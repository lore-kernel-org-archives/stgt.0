From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v4 RFC 5/5] tgtd: offload iSCSI PDU send/recv to worker threads
Date: Fri, 14 Feb 2014 20:21:33 +0900
Message-ID: <1392376893-26106-6-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1392376893-26106-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1392376893-26106-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Current tgtd sends and receives iSCSI PDUs in its main event
loop. This design can cause bottleneck when many iSCSI clients connect
to single tgtd process. For example, we need multiple tgtd processes
for utilizing fast network like 10 GbE because typical single
processor core isn't fast enough for processing a bunch of requests.

This patch lets tgtd offload send/recv iSCSI PDUs and check digests to
worker threads when a parameter of "-T" option is larger than 1. The
offloading is done by a newly added event handler,
iscsi_tcp_mt_event_handler(). When "-T" isn't passed or value 1 is
passed, single threaded version (iscsi_tcp_st_event_handler()) is
used. The single threaded version is provided because in some cases
the multi-threaded version degrades performance (e.g. a number of
initiators are not so large).

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/iscsi/iscsi_tcp.c |  345 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 344 insertions(+), 1 deletion(-)

diff --git a/usr/iscsi/iscsi_tcp.c b/usr/iscsi/iscsi_tcp.c
index bb553a8..a78ddbb 100644
--- a/usr/iscsi/iscsi_tcp.c
+++ b/usr/iscsi/iscsi_tcp.c
@@ -31,6 +31,8 @@
 #include <netinet/tcp.h>
 #include <sys/epoll.h>
 #include <sys/socket.h>
+#include <pthread.h>
+#include <sys/eventfd.h>
 
 #include "iscsid.h"
 #include "tgtd.h"
@@ -40,6 +42,7 @@
 int nr_tcp_iothreads = 1;
 
 static void iscsi_tcp_st_event_handler(int fd, int events, void *data);
+static void iscsi_tcp_mt_event_handler(int fd, int events, void *data);
 static void iscsi_tcp_release(struct iscsi_connection *conn);
 static struct iscsi_task *iscsi_tcp_alloc_task(struct iscsi_connection *conn,
 						size_t ext_len);
@@ -50,6 +53,23 @@ static long nop_ttt;
 static int listen_fds[8];
 static struct iscsi_transport iscsi_tcp;
 
+enum iscsi_tcp_work_state {
+	ISCSI_TCP_WORK_INIT,
+	ISCSI_TCP_WORK_RX,
+	ISCSI_TCP_WORK_RX_BHS,
+	ISCSI_TCP_WORK_RX_EAGAIN,
+	ISCSI_TCP_WORK_RX_FAILED,
+	ISCSI_TCP_WORK_TX,
+	ISCSI_TCP_WORK_TX_FAILED,
+};
+
+struct iscsi_tcp_work {
+	/* list: connected to iscsi_tcp_work_list or iscsi_tcp_finished_list */
+	struct list_head list;
+
+	enum iscsi_tcp_work_state state;
+};
+
 struct iscsi_tcp_connection {
 	int fd;
 
@@ -64,13 +84,229 @@ struct iscsi_tcp_connection {
 
 	int used_in_worker_thread;
 	int restore_events;
+
+	struct iscsi_tcp_work work;
 };
 
+static LIST_HEAD(iscsi_tcp_work_list);
+static pthread_mutex_t iscsi_tcp_work_mutex = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t iscsi_tcp_work_cond = PTHREAD_COND_INITIALIZER;
+
+static LIST_HEAD(iscsi_tcp_work_finished_list);
+static pthread_mutex_t iscsi_tcp_work_finished_mutex =
+	PTHREAD_MUTEX_INITIALIZER;
+
+static int iscsi_tcp_work_done_fd;
+
+static pthread_mutex_t iscsi_tcp_worker_startup_mutex =
+	PTHREAD_MUTEX_INITIALIZER;
+
+static int iscsi_tcp_worker_stop;
+
+static pthread_t *iscsi_tcp_worker_threads;
+
+static void queue_iscsi_tcp_work(struct iscsi_connection *conn, int events);
+
+static void iscsi_tcp_work_done_handler(int fd, int events, void *data)
+{
+	LIST_HEAD(list);
+	struct iscsi_tcp_work *work;
+	struct iscsi_connection *conn;
+	struct iscsi_tcp_connection *tcp_conn;
+	int ret, failed;
+	eventfd_t dummy;
+
+	ret = eventfd_read(fd, &dummy);
+	if (ret < 0) {
+		eprintf("iscsi tcp work error: %m\n");
+		exit(1);
+	}
+
+	pthread_mutex_lock(&iscsi_tcp_work_finished_mutex);
+	list_splice_init(&iscsi_tcp_work_finished_list, &list);
+	pthread_mutex_unlock(&iscsi_tcp_work_finished_mutex);
+
+	while (!list_empty(&list)) {
+		work = list_first_entry(&list, struct iscsi_tcp_work, list);
+		list_del(&work->list);
+
+		tcp_conn =
+			container_of(work, struct iscsi_tcp_connection, work);
+		conn = &tcp_conn->iscsi_conn;
+
+		tcp_conn->used_in_worker_thread = 0;
+
+		ret = tgt_event_add(tcp_conn->fd, tcp_conn->restore_events,
+				    iscsi_tcp_mt_event_handler, conn);
+		if (ret < 0) {
+			/* fd is broken by worker threads */
+			failed = 1;
+			goto end;
+		}
+
+		failed = 0;
+
+		if (conn->state == STATE_CLOSE)
+			goto end;
+
+		switch (work->state) {
+		case ISCSI_TCP_WORK_RX_FAILED:
+		case ISCSI_TCP_WORK_TX_FAILED:
+			failed = 1;
+			goto end;
+		case ISCSI_TCP_WORK_RX:
+			if (is_conn_rx_end(conn))
+				iscsi_rx_done(conn);
+			break;
+		case ISCSI_TCP_WORK_RX_BHS:
+			if (is_conn_rx_bhs(conn))
+				/* EAGAIN or EINTR */
+				break;
+
+			iscsi_pre_iostate_rx_init_ahs(conn);
+			if (conn->state == STATE_CLOSE)
+				break;
+
+			/* bypass the main event loop */
+			work->state = ISCSI_TCP_WORK_RX;
+			queue_iscsi_tcp_work(conn, tcp_conn->restore_events);
+			continue;
+		case ISCSI_TCP_WORK_TX:
+			if (is_conn_tx_end(conn))
+				iscsi_tx_done(conn);
+			break;
+		default:
+			eprintf("invalid state of iscsi work tcp: %d\n",
+				work->state);
+			exit(1);
+		}
+
+		tcp_conn->restore_events = 0;
+
+end:
+		work->state = ISCSI_TCP_WORK_INIT;
+		if (failed || conn->state == STATE_CLOSE) {
+			dprintf("connection closed %p\n", conn);
+			conn_close(conn);
+		}
+	}
+}
+
+static void *iscsi_tcp_worker_fn(void *arg)
+{
+	sigset_t set;
+	struct iscsi_tcp_work *work;
+	struct iscsi_connection *conn;
+	struct iscsi_tcp_connection *tcp_conn;
+	int ret;
+
+	sigfillset(&set);
+	sigprocmask(SIG_BLOCK, &set, NULL);
+
+	pthread_mutex_lock(&iscsi_tcp_worker_startup_mutex);
+	pthread_mutex_unlock(&iscsi_tcp_worker_startup_mutex);
+
+	dprintf("starting iscsi tcp worker thread: %lu\n", pthread_self());
+
+	while (!iscsi_tcp_worker_stop) {
+		pthread_mutex_lock(&iscsi_tcp_work_mutex);
+retest:
+		if (list_empty(&iscsi_tcp_work_list)) {
+			pthread_cond_wait(&iscsi_tcp_work_cond,
+					  &iscsi_tcp_work_mutex);
+
+			if (iscsi_tcp_worker_stop) {
+				pthread_mutex_unlock(&iscsi_tcp_work_mutex);
+				pthread_exit(NULL);
+			}
+
+			goto retest;
+		}
+
+		work = list_first_entry(&iscsi_tcp_work_list,
+				       struct iscsi_tcp_work, list);
+
+		list_del(&work->list);
+		pthread_mutex_unlock(&iscsi_tcp_work_mutex);
+
+		tcp_conn =
+			container_of(work, struct iscsi_tcp_connection, work);
+		conn = &tcp_conn->iscsi_conn;
+
+		switch (work->state) {
+		case ISCSI_TCP_WORK_RX_BHS:
+			ret = iscsi_rx_bhs_handler(conn);
+			if (ret < 0)
+				work->state = ISCSI_TCP_WORK_RX_FAILED;
+			break;
+		case ISCSI_TCP_WORK_RX:
+			do {
+				ret = iscsi_rx_handler(conn);
+				if (ret == -EAGAIN)
+					break;
+				if (ret == -EINTR)
+					continue;
+
+				if (ret < 0) {
+					work->state = ISCSI_TCP_WORK_RX_FAILED;
+					break;
+				}
+			} while (conn->state != STATE_CLOSE &&
+				 !is_conn_rx_end(conn));
+			break;
+		case ISCSI_TCP_WORK_TX:
+			do {
+				ret = iscsi_tx_handler(conn);
+				if (ret < 0) {
+					work->state = ISCSI_TCP_WORK_TX_FAILED;
+					break;
+				}
+			} while (conn->state != STATE_CLOSE &&
+				 !is_conn_tx_end(conn));
+			break;
+		default:
+			eprintf("invalid state of iscsi tcp work: %d\n",
+				work->state);
+			exit(1);
+		}
+
+		pthread_mutex_lock(&iscsi_tcp_work_finished_mutex);
+		list_add_tail(&work->list, &iscsi_tcp_work_finished_list);
+		pthread_mutex_unlock(&iscsi_tcp_work_finished_mutex);
+
+		ret = eventfd_write(iscsi_tcp_work_done_fd, 1);
+		if (ret < 0) {
+			eprintf("iscsi tcp work error: %m\n");
+			exit(1);
+		}
+	}
+
+	pthread_exit(NULL);
+}
+
 static inline struct iscsi_tcp_connection *TCP_CONN(struct iscsi_connection *conn)
 {
 	return container_of(conn, struct iscsi_tcp_connection, iscsi_conn);
 }
 
+static void queue_iscsi_tcp_work(struct iscsi_connection *conn, int events)
+{
+	struct iscsi_tcp_connection *tcp_conn = TCP_CONN(conn);
+	struct iscsi_tcp_work *work = &tcp_conn->work;
+
+	tcp_conn->used_in_worker_thread = 1;
+
+	tcp_conn->restore_events = events;
+
+	tgt_event_del(tcp_conn->fd);
+
+	pthread_mutex_lock(&iscsi_tcp_work_mutex);
+	list_add_tail(&work->list, &iscsi_tcp_work_list);
+	pthread_mutex_unlock(&iscsi_tcp_work_mutex);
+
+	pthread_cond_signal(&iscsi_tcp_work_cond);
+}
+
 static struct tgt_work nop_work;
 
 /* all iscsi connections */
@@ -100,6 +336,9 @@ static void iscsi_tcp_nop_work_handler(void *data)
 	struct iscsi_tcp_connection *tcp_conn;
 
 	list_for_each_entry(tcp_conn, &iscsi_tcp_conn_list, tcp_conn_siblings) {
+		if (tcp_conn->used_in_worker_thread)
+			continue;
+
 		if (tcp_conn->nop_interval == 0)
 			continue;
 
@@ -246,6 +485,9 @@ static void accept_connection(int afd, int events, void *data)
 	if (!tcp_conn)
 		goto out;
 
+	INIT_LIST_HEAD(&tcp_conn->work.list);
+	tcp_conn->work.state = ISCSI_TCP_WORK_INIT;
+
 	conn = &tcp_conn->iscsi_conn;
 
 	ret = conn_init(conn);
@@ -260,7 +502,11 @@ static void accept_connection(int afd, int events, void *data)
 	conn_read_pdu(conn);
 	set_non_blocking(fd);
 
-	ret = tgt_event_add(fd, EPOLLIN, iscsi_tcp_st_event_handler, conn);
+	ret = tgt_event_add(fd, EPOLLIN,
+			    nr_tcp_iothreads == 1 ?
+			    iscsi_tcp_st_event_handler :
+			    iscsi_tcp_mt_event_handler,
+			    conn);
 	if (ret) {
 		conn_exit(conn);
 		free(tcp_conn);
@@ -327,6 +573,39 @@ epollout_end:
 	}
 }
 
+static void iscsi_tcp_mt_event_handler(int fd, int events, void *data)
+{
+	struct iscsi_connection *conn = (struct iscsi_connection *) data;
+	struct iscsi_tcp_connection *tcp_conn = TCP_CONN(conn);
+	struct iscsi_tcp_work *work = &tcp_conn->work;
+
+	if (work->state != ISCSI_TCP_WORK_INIT) {
+		eprintf("invalid state of iscsi tcp work: %d\n", work->state);
+		exit(1);
+	}
+
+	if (conn->state == STATE_CLOSE) {
+		conn_close(conn);
+		return;
+	}
+
+	if (events & EPOLLIN) {
+		if (is_conn_rx_bhs(conn))
+			work->state = ISCSI_TCP_WORK_RX_BHS;
+		else
+			work->state = ISCSI_TCP_WORK_RX;
+	} else if (events & EPOLLOUT) {
+		if (conn->state == STATE_SCSI && !conn->tx_task) {
+			if (iscsi_task_tx_start(conn))
+				return;
+		}
+
+		work->state = ISCSI_TCP_WORK_TX;
+	}
+
+	queue_iscsi_tcp_work(conn, events);
+}
+
 int iscsi_tcp_init_portal(char *addr, int port, int tpgt)
 {
 	struct addrinfo hints, *res, *res0;
@@ -461,6 +740,8 @@ int iscsi_delete_portal(char *addr, int port)
 
 static int iscsi_tcp_init(void)
 {
+	int i, ret = 0;
+
 	/* If we were passed any portals on the command line */
 	if (portal_arguments)
 		iscsi_param_parse_portals(portal_arguments, 1, 0);
@@ -478,17 +759,79 @@ static int iscsi_tcp_init(void)
 	nop_work.data = &nop_work;
 	add_work(&nop_work, 1);
 
+	if (1 < nr_tcp_iothreads) {
+		iscsi_tcp_work_done_fd = eventfd(0, EFD_NONBLOCK);
+		if (iscsi_tcp_work_done_fd < 0) {
+			eprintf("failed to create eventfd for tcp work: %m\n");
+			return -1;
+		}
+
+		ret = tgt_event_add(iscsi_tcp_work_done_fd, EPOLLIN,
+				    iscsi_tcp_work_done_handler, NULL);
+		if (ret < 0) {
+			eprintf("failed to register"\
+				"iscsi_tcp_work_done_handler(): %m\n");
+			ret = -1;
+			goto close_done_fd;
+		}
+
+		iscsi_tcp_worker_threads = calloc(nr_tcp_iothreads,
+						  sizeof(pthread_t));
+		if (!iscsi_tcp_worker_threads) {
+			eprintf("failed to allocate memory for pthread"\
+				" identifier: %m\n");
+			ret = -1;
+
+			goto close_done_fd;
+		}
+
+		pthread_mutex_lock(&iscsi_tcp_worker_startup_mutex);
+		for (i = 0; i < nr_tcp_iothreads; i++) {
+			ret = pthread_create(&iscsi_tcp_worker_threads[i], NULL,
+					     iscsi_tcp_worker_fn, NULL);
+			if (ret) {
+				eprintf("creating worker thread failed: %m\n");
+				ret = -1;
+
+				goto terminate_workers;
+			}
+		}
+
+		pthread_mutex_unlock(&iscsi_tcp_worker_startup_mutex);
+		goto out;
+
+terminate_workers:
+		iscsi_tcp_worker_stop = 1;
+		pthread_mutex_unlock(&iscsi_tcp_worker_startup_mutex);
+
+		for (; 0 <= i; i--)
+			pthread_join(iscsi_tcp_worker_threads[i], NULL);
+
+		free(iscsi_tcp_worker_threads);
+
+close_done_fd:
+		close(iscsi_tcp_work_done_fd);
+	}
+
+out:
 	return 0;
 }
 
 static void iscsi_tcp_exit(void)
 {
+	int i;
 	struct iscsi_portal *portal, *ptmp;
 
 	list_for_each_entry_safe(portal, ptmp, &iscsi_portals_list,
 			    iscsi_portal_siblings) {
 		iscsi_delete_portal(portal->addr, portal->port);
 	}
+
+	iscsi_tcp_worker_stop = 1;
+	for (i = 0; i < nr_tcp_iothreads; i++) {
+		pthread_cond_signal(&iscsi_tcp_work_cond);
+		pthread_join(iscsi_tcp_worker_threads[i], NULL);
+	}
 }
 
 static int iscsi_tcp_conn_login_complete(struct iscsi_connection *conn)
-- 
1.7.10.4
