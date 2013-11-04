From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: [PATCH RFC] tgtd: send/recv iSCSI PDUs in worker threads
Date: Mon,  4 Nov 2013 14:13:16 +0900
Message-ID: <1383541996-7946-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=zQuHsZwkn2kOwvWOc8LqVHHmAxEXBcFFLmSPTMoZXEA=;
        b=iWvW2igW9LrP+609Hmfr1y/eVWLx2Hpk7DfYmfv8IxPaZmPpUIg1cT9/msmjYx8uDW
         mxW1+RF5MSxvkiTJnE9exMASBTV/skUL0YbQHO3iVwKHJ/8vacUhD9HDxivNvtZlwIaz
         0KO0p2T5g93M2bonFdR9KsJthnF/hp+HdKmNd0uizkqFWsFmchXL2r+obCZq4cIoTyBM
         /1TzqNRONn09a8BLEtOUTYtbrblc0jV3ZKo8Yevlqq4onVe1bW5Gayhsli7f8U+XqQLU
         FQaEMdHjh1i6z7p2q4wCNrnEDWNqvQktaeFhI1AkeDq3PPWR/5kvwPzcaQCmJe7+mtMI
         Y3oA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Current tgtd sends and receives iSCSI PDUs in its main event
loop. This design can cause bottleneck when many iSCSI clients connect
to single tgtd process. For example, we need multiple tgtd processes
for utilizing fast network like 10 GbE because typical single
processor core isn't fast enough for processing bunch of requests.

This patch lets tgtd send/receive iSCSI PDUs and check digests in its
worker threads. After applying this patch, the bottleneck in the main
event loop is removed and the performance is improved.

The improvement can be seen even if tgtd and iSCSI initiator are
running on a single host. Below is a snippet of fio result on my
laptop. The workload is 128MB random RW. Backingstore is sheepdog.

original tgtd:
  read : io=65392KB, bw=4445.2KB/s, iops=1111, runt= 14711msec
  write: io=65680KB, bw=4464.8KB/s, iops=1116, runt= 14711msec

tgtd with this patch:
  read : io=65392KB, bw=5098.9KB/s, iops=1274, runt= 12825msec
  write: io=65680KB, bw=5121.3KB/s, iops=1280, runt= 12825msec

This change will be more effective when a number of iSCSI clients
increases. I'd like to hear your comments on this change.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/iscsi/iscsi_tcp.c | 291 +++++++++++++++++++++++++++++++++++++++++++++++---
 usr/iscsi/iscsid.c    |  61 +++++++----
 usr/iscsi/iscsid.h    |   4 +
 3 files changed, 322 insertions(+), 34 deletions(-)

diff --git a/usr/iscsi/iscsi_tcp.c b/usr/iscsi/iscsi_tcp.c
index 4a9532a..062f299 100644
--- a/usr/iscsi/iscsi_tcp.c
+++ b/usr/iscsi/iscsi_tcp.c
@@ -31,6 +31,7 @@
 #include <netinet/tcp.h>
 #include <sys/epoll.h>
 #include <sys/socket.h>
+#include <pthread.h>
 
 #include "iscsid.h"
 #include "tgtd.h"
@@ -48,6 +49,20 @@ static long nop_ttt;
 static int listen_fds[8];
 static struct iscsi_transport iscsi_tcp;
 
+enum iscsi_tcp_work_state {
+	ISCSI_TCP_WORK_INIT,
+	ISCSI_TCP_WORK_RX,
+	ISCSI_TCP_WORK_TX,
+	ISCSI_TCP_WORK_TX_EAGAIN,
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
 
@@ -59,13 +74,198 @@ struct iscsi_tcp_connection {
 	long ttt;
 
 	struct iscsi_connection iscsi_conn;
+	struct iscsi_tcp_work work;
+
+	int used_in_worker_thread;
 };
 
+static LIST_HEAD(iscsi_tcp_work_list);
+static pthread_mutex_t iscsi_tcp_work_mutex = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t iscsi_tcp_work_cond = PTHREAD_COND_INITIALIZER;
+
+static LIST_HEAD(iscsi_tcp_work_finished_list);
+static pthread_mutex_t iscsi_tcp_work_finished_mutex =
+	PTHREAD_MUTEX_INITIALIZER;
+
+static int iscsi_tcp_work_done_fds[2];
+
+static pthread_mutex_t iscsi_tcp_worker_startup_mutex =
+	PTHREAD_MUTEX_INITIALIZER;
+
+static int iscsi_tcp_worker_stop;
+
+static pthread_t *iscsi_tcp_worker_threads;
+
+static void iscsi_tcp_work_done_handler(int fd, int events, void *data)
+{
+	LIST_HEAD(list);
+	struct iscsi_tcp_work *work;
+	struct iscsi_connection *conn;
+	struct iscsi_tcp_connection *tcp_conn;
+	int ret;
+	char dummy = 0;
+
+	ret = read(fd, &dummy, sizeof(dummy));
+	if (ret != sizeof(dummy)) {
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
+		ret = tgt_event_add(tcp_conn->fd,
+				    work->state == ISCSI_TCP_WORK_TX ?
+				    EPOLLOUT : EPOLLIN,
+				    iscsi_tcp_event_handler, conn);
+		if (ret) {
+			eprintf("failed to add event: %m\n");
+			exit(1);
+		}
+
+		switch (work->state) {
+		case ISCSI_TCP_WORK_RX:
+			if (conn->state != STATE_CLOSE)
+				iscsi_tcp_work_rx_done_fn(conn);
+			break;
+		case ISCSI_TCP_WORK_TX:
+			iscsi_tcp_work_tx_done_fn(conn);
+			break;
+		case ISCSI_TCP_WORK_TX_EAGAIN:
+			/* do nothing */
+			break;
+		default:
+			eprintf("invalid state of iscsi work tcp: %d\n",
+				work->state);
+			exit(1);
+		}
+
+		if (conn->state == STATE_CLOSE) {
+			dprintf("connection closed %p\n", conn);
+			conn_close(conn);
+		} else
+			work->state = ISCSI_TCP_WORK_INIT;
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
+	char dummy = 0;
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
+		case ISCSI_TCP_WORK_RX:
+			do {
+				iscsi_rx_handler(conn);
+			} while (!is_conn_rx_end(conn)
+				 && conn->state != STATE_CLOSE);
+
+			break;
+		case ISCSI_TCP_WORK_TX:
+			do {
+				ret = iscsi_tx_handler(conn);
+				if (ret == -EAGAIN) {
+					/* no data to send */
+					work->state = ISCSI_TCP_WORK_TX_EAGAIN;
+					break;
+				}
+			} while (!is_conn_tx_end(conn)
+				 && conn->state != STATE_CLOSE);
+
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
+		ret = write(iscsi_tcp_work_done_fds[1], &dummy,
+			    sizeof(dummy));
+		if (ret != sizeof(dummy)) {
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
 
+static void queue_iscsi_tcp_work(struct iscsi_connection *conn)
+{
+	struct iscsi_tcp_connection *tcp_conn = TCP_CONN(conn);
+	struct iscsi_tcp_work *work = &tcp_conn->work;
+
+	/*
+	 * Delete from main event loop temporaly, because the fd is used by
+	 * worker threads.
+	 */
+	tcp_conn->used_in_worker_thread = 1;
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
@@ -102,6 +302,9 @@ static void iscsi_tcp_nop_work_handler(void *data)
 		if (tcp_conn->nop_tick > 0)
 			continue;
 
+		if (tcp_conn->used_in_worker_thread)
+			continue;
+
 		tcp_conn->nop_tick = tcp_conn->nop_interval;
 
 		tcp_conn->nop_inflight_count++;
@@ -241,6 +444,9 @@ static void accept_connection(int afd, int events, void *data)
 	if (!tcp_conn)
 		goto out;
 
+	INIT_LIST_HEAD(&tcp_conn->work.list);
+	tcp_conn->work.state = ISCSI_TCP_WORK_INIT;
+
 	conn = &tcp_conn->iscsi_conn;
 
 	ret = conn_init(conn);
@@ -273,20 +479,20 @@ out:
 static void iscsi_tcp_event_handler(int fd, int events, void *data)
 {
 	struct iscsi_connection *conn = (struct iscsi_connection *) data;
+	struct iscsi_tcp_connection *tcp_conn = TCP_CONN(conn);
+	struct iscsi_tcp_work *work = &tcp_conn->work;
 
-	if (events & EPOLLIN)
-		iscsi_rx_handler(conn);
-
-	if (conn->state == STATE_CLOSE)
-		dprintf("connection closed\n");
+	if (work->state != ISCSI_TCP_WORK_INIT) {
+		eprintf("invalid state of work: %d\n", work->state);
+		exit(1);
+	}
 
-	if (conn->state != STATE_CLOSE && events & EPOLLOUT)
-		iscsi_tx_handler(conn);
+	if (events & EPOLLIN)
+		work->state = ISCSI_TCP_WORK_RX;
+	else if (events & EPOLLOUT)
+		work->state = ISCSI_TCP_WORK_TX;
 
-	if (conn->state == STATE_CLOSE) {
-		dprintf("connection closed %p\n", conn);
-		conn_close(conn);
-	}
+	queue_iscsi_tcp_work(conn);
 }
 
 int iscsi_tcp_init_portal(char *addr, int port, int tpgt)
@@ -423,6 +629,8 @@ int iscsi_delete_portal(char *addr, int port)
 
 static int iscsi_tcp_init(void)
 {
+	int ret = 0, i;
+
 	/* If we were passed any portals on the command line */
 	if (portal_arguments)
 		iscsi_param_parse_portals(portal_arguments, 1, 0);
@@ -440,17 +648,76 @@ static int iscsi_tcp_init(void)
 	nop_work.data = &nop_work;
 	add_work(&nop_work, 1);
 
-	return 0;
+	ret = pipe(iscsi_tcp_work_done_fds);
+	if (ret < 0) {
+		eprintf("failed to create pipe for tcp work: %m\n");
+		return -1;
+	}
+
+	ret = tgt_event_add(iscsi_tcp_work_done_fds[0], EPOLLIN,
+			    iscsi_tcp_work_done_handler, NULL);
+	if (ret < 0) {
+		eprintf("failed to register iscsi_tcp_work_done_handler():"\
+			" %m\n");
+		ret = -1;
+		goto close_done_fds;
+	}
+
+	iscsi_tcp_worker_threads = calloc(nr_iothreads, sizeof(pthread_t));
+	if (!iscsi_tcp_worker_threads) {
+		eprintf("failed to allocate memory for pthread identifier:"\
+			" %m\n");
+		ret = -1;
+
+		goto close_done_fds;
+	}
+
+	pthread_mutex_lock(&iscsi_tcp_worker_startup_mutex);
+	for (i = 0; i < nr_iothreads; i++) {
+		ret = pthread_create(&iscsi_tcp_worker_threads[i], NULL,
+				     iscsi_tcp_worker_fn, NULL);
+		if (ret) {
+			eprintf("creating worker thread failed: %m\n");
+			ret = -1;
+
+			goto terminate_workers;
+		}
+	}
+
+	pthread_mutex_unlock(&iscsi_tcp_worker_startup_mutex);
+	goto out;
+
+terminate_workers:
+	iscsi_tcp_worker_stop = 1;
+	pthread_mutex_unlock(&iscsi_tcp_worker_startup_mutex);
+
+	for (; i <= 0; i--)
+		pthread_join(iscsi_tcp_worker_threads[i], NULL);
+
+close_done_fds:
+	close(iscsi_tcp_work_done_fds[0]);
+	close(iscsi_tcp_work_done_fds[1]);
+
+out:
+	return ret;
 }
 
 static void iscsi_tcp_exit(void)
 {
+	int i;
+
 	struct iscsi_portal *portal, *ptmp;
 
 	list_for_each_entry_safe(portal, ptmp, &iscsi_portals_list,
 			    iscsi_portal_siblings) {
 		iscsi_delete_portal(portal->addr, portal->port);
 	}
+
+	iscsi_tcp_worker_stop = 1;
+	for (i = 0; i < nr_iothreads; i++) {
+		pthread_cond_signal(&iscsi_tcp_work_cond);
+		pthread_join(iscsi_tcp_worker_threads[i], NULL);
+	}
 }
 
 static int iscsi_tcp_conn_login_complete(struct iscsi_connection *conn)
diff --git a/usr/iscsi/iscsid.c b/usr/iscsi/iscsid.c
index 30bd13f..dfa49ac 100644
--- a/usr/iscsi/iscsid.c
+++ b/usr/iscsi/iscsid.c
@@ -76,6 +76,16 @@ enum {
 	IOSTATE_TX_END,
 };
 
+int is_conn_rx_end(struct iscsi_connection *conn)
+{
+	return conn->rx_iostate == IOSTATE_RX_END;
+}
+
+int is_conn_tx_end(struct iscsi_connection *conn)
+{
+	return conn->tx_iostate == IOSTATE_TX_END;
+}
+
 void conn_read_pdu(struct iscsi_connection *conn)
 {
 	conn->rx_iostate = IOSTATE_RX_BHS;
@@ -2014,7 +2024,6 @@ static int iscsi_task_tx_start(struct iscsi_connection *conn)
 
 nodata:
 	dprintf("no more data\n");
-	conn->tp->ep_event_modify(conn, EPOLLIN);
 	return -EAGAIN;
 }
 
@@ -2051,7 +2060,6 @@ void iscsi_rx_handler(struct iscsi_connection *conn)
 	int ret = 0, hdigest, ddigest;
 	uint32_t crc;
 
-
 	if (conn->state == STATE_SCSI) {
 		struct param *p = conn->session_param;
 		hdigest = p[ISCSI_PARAM_HDRDGST_EN].val & DIGEST_CRC32C;
@@ -2182,9 +2190,8 @@ again:
 		exit(1);
 	}
 
-	if (ret < 0 ||
-	    conn->rx_iostate != IOSTATE_RX_END ||
-	    conn->state == STATE_CLOSE)
+	if (ret < 0 || conn->rx_iostate != IOSTATE_RX_END
+	    || conn->state == STATE_CLOSE)
 		return;
 
 	if (conn->rx_size) {
@@ -2192,20 +2199,6 @@ again:
 			conn->rx_size);
 		exit(1);
 	}
-
-	if (conn->state == STATE_SCSI) {
-		ret = iscsi_task_rx_done(conn);
-		if (ret)
-			conn->state = STATE_CLOSE;
-		else
-			conn_read_pdu(conn);
-	} else {
-		conn_write_pdu(conn);
-		conn->tp->ep_event_modify(conn, EPOLLOUT);
-		ret = cmnd_execute(conn);
-		if (ret)
-			conn->state = STATE_CLOSE;
-	}
 }
 
 static int do_send(struct iscsi_connection *conn, int next_state)
@@ -2373,6 +2366,33 @@ again:
 finish:
 	cmnd_finish(conn);
 
+out:
+	return ret;
+}
+
+void iscsi_tcp_work_rx_done_fn(struct iscsi_connection *conn)
+{
+	int ret;
+
+	if (conn->state == STATE_SCSI) {
+		ret = iscsi_task_rx_done(conn);
+		if (ret)
+			conn->state = STATE_CLOSE;
+		else
+			conn_read_pdu(conn);
+	} else {
+		conn_write_pdu(conn);
+		conn->tp->ep_event_modify(conn, EPOLLOUT);
+		ret = cmnd_execute(conn);
+		if (ret)
+			conn->state = STATE_CLOSE;
+	}
+}
+
+void iscsi_tcp_work_tx_done_fn(struct iscsi_connection *conn)
+{
+	int ret;
+
 	switch (conn->state) {
 	case STATE_KERNEL:
 		ret = conn_take_fd(conn);
@@ -2395,9 +2415,6 @@ finish:
 		conn->tp->ep_event_modify(conn, EPOLLIN);
 		break;
 	}
-
-out:
-	return ret;
 }
 
 int iscsi_transportid(int tid, uint64_t itn_id, char *buf, int size)
diff --git a/usr/iscsi/iscsid.h b/usr/iscsi/iscsid.h
index c7f6801..e716154 100644
--- a/usr/iscsi/iscsid.h
+++ b/usr/iscsi/iscsid.h
@@ -336,6 +336,10 @@ extern int iscsi_param_parse_portals(char *p, int do_add, int do_delete);
 extern void iscsi_update_conn_stats_rx(struct iscsi_connection *conn, int size, int opcode);
 extern void iscsi_update_conn_stats_tx(struct iscsi_connection *conn, int size, int opcode);
 extern void iscsi_rsp_set_residual(struct iscsi_cmd_rsp *rsp, struct scsi_cmd *scmd);
+extern void iscsi_tcp_work_rx_done_fn(struct iscsi_connection *conn);
+extern void iscsi_tcp_work_tx_done_fn(struct iscsi_connection *conn);
+extern int is_conn_rx_end(struct iscsi_connection *conn);
+extern int is_conn_tx_end(struct iscsi_connection *conn);
 
 /* iscsid.c iscsi_task */
 extern void iscsi_free_task(struct iscsi_task *task);
-- 
1.8.1.2
