From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v4 RFC 2/5] tgtd: decompose iscsi_[rt]x_handler()
Date: Fri, 14 Feb 2014 20:21:30 +0900
Message-ID: <1392376893-26106-3-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
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

Basic strategy of parallelizing sending/receiving iSCSI PDUs is like
this: offload do_recv(), do_send() and crc checking to worker threads
and do other part in the main event loop thread.

To follow the above strategy, this patch decomposes iscsi_rx_handler()
and iscsi_tx_handler() into some parts. Some of them can be called in
worker threads and others are not. In the future commit,
multi-threaded TCP event handler will be implemented based on
them. This patch re-implements single threaded TCP event handler
(past iscsi_tcp_event_handler(), renamed iscsi_tcp_st_event_handler())
based on these decomposed parts. iscsi_tcp_st_event_handler() is
also required because under some workload the multi-threaded version
degrades performance because of frequent communication between
threads.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/iscsi/iscsi_tcp.c |   47 +++++++++++++++++++++++-----
 usr/iscsi/iscsid.c    |   81 +++++++++++++++++++++++++++++--------------------
 usr/iscsi/iscsid.h    |    7 ++++-
 3 files changed, 94 insertions(+), 41 deletions(-)

diff --git a/usr/iscsi/iscsi_tcp.c b/usr/iscsi/iscsi_tcp.c
index 4a9532a..9a41466 100644
--- a/usr/iscsi/iscsi_tcp.c
+++ b/usr/iscsi/iscsi_tcp.c
@@ -37,7 +37,7 @@
 #include "util.h"
 #include "work.h"
 
-static void iscsi_tcp_event_handler(int fd, int events, void *data);
+static void iscsi_tcp_st_event_handler(int fd, int events, void *data);
 static void iscsi_tcp_release(struct iscsi_connection *conn);
 static struct iscsi_task *iscsi_tcp_alloc_task(struct iscsi_connection *conn,
 						size_t ext_len);
@@ -255,7 +255,7 @@ static void accept_connection(int afd, int events, void *data)
 	conn_read_pdu(conn);
 	set_non_blocking(fd);
 
-	ret = tgt_event_add(fd, EPOLLIN, iscsi_tcp_event_handler, conn);
+	ret = tgt_event_add(fd, EPOLLIN, iscsi_tcp_st_event_handler, conn);
 	if (ret) {
 		conn_exit(conn);
 		free(tcp_conn);
@@ -270,19 +270,52 @@ out:
 	return;
 }
 
-static void iscsi_tcp_event_handler(int fd, int events, void *data)
+static void iscsi_tcp_st_event_handler(int fd, int events, void *data)
 {
+	int ret;
+
 	struct iscsi_connection *conn = (struct iscsi_connection *) data;
 
-	if (events & EPOLLIN)
-		iscsi_rx_handler(conn);
+	if (events & EPOLLIN) {
+		if (is_conn_rx_bhs(conn)) {
+			ret = iscsi_rx_bhs_handler(conn);
+			if (!is_conn_rx_init_ahs(conn)
+			    || ret < 0 || conn->state == STATE_CLOSE)
+				goto epollin_end;
+		}
+
+		if (conn->state != STATE_CLOSE && is_conn_rx_init_ahs(conn)) {
+			iscsi_pre_iostate_rx_init_ahs(conn);
+
+			if (conn->state == STATE_CLOSE)
+				goto epollin_end;
+		}
+
+		if (conn->state != STATE_CLOSE)
+			iscsi_rx_handler(conn);
 
+		if (conn->state != STATE_CLOSE && is_conn_rx_end(conn))
+			iscsi_rx_done(conn);
+	}
+
+epollin_end:
 	if (conn->state == STATE_CLOSE)
 		dprintf("connection closed\n");
 
-	if (conn->state != STATE_CLOSE && events & EPOLLOUT)
-		iscsi_tx_handler(conn);
+	if (conn->state != STATE_CLOSE && events & EPOLLOUT) {
+		if (conn->state == STATE_SCSI && !conn->tx_task) {
+			if (iscsi_task_tx_start(conn))
+				goto epollout_end;
+		}
+
+		if (conn->state != STATE_CLOSE)
+			iscsi_tx_handler(conn);
+
+		if (conn->state != STATE_CLOSE && is_conn_tx_end(conn))
+			iscsi_tx_done(conn);
+	}
 
+epollout_end:
 	if (conn->state == STATE_CLOSE) {
 		dprintf("connection closed %p\n", conn);
 		conn_close(conn);
diff --git a/usr/iscsi/iscsid.c b/usr/iscsi/iscsid.c
index c472608..c696d30 100644
--- a/usr/iscsi/iscsid.c
+++ b/usr/iscsi/iscsid.c
@@ -1991,7 +1991,7 @@ static int iscsi_task_tx_done(struct iscsi_connection *conn)
 	return 0;
 }
 
-static int iscsi_task_tx_start(struct iscsi_connection *conn)
+int iscsi_task_tx_start(struct iscsi_connection *conn)
 {
 	struct iscsi_task *task;
 	int is_rsp, err = 0;
@@ -2048,7 +2048,7 @@ static int do_recv(struct iscsi_connection *conn, int next_state)
 		return 0;
 	} else if (ret < 0) {
 		if (errno == EINTR || errno == EAGAIN)
-			return 0;
+			return -errno;
 		else
 			return -EIO;
 	}
@@ -2066,7 +2066,30 @@ static int do_recv(struct iscsi_connection *conn, int next_state)
 	return ret;
 }
 
-void iscsi_rx_handler(struct iscsi_connection *conn)
+int iscsi_rx_bhs_handler(struct iscsi_connection *conn)
+{
+	if (conn->rx_iostate != IOSTATE_RX_BHS) {
+		eprintf("invalid rx_iostate: %d\n", conn->rx_iostate);
+		exit(1);
+	}
+
+	return do_recv(conn, IOSTATE_RX_INIT_AHS);
+}
+
+void iscsi_pre_iostate_rx_init_ahs(struct iscsi_connection *conn)
+{
+	if (conn->state == STATE_SCSI) {
+		if (iscsi_task_rx_start(conn))
+			conn->state = STATE_CLOSE;
+	} else {
+		conn->rx_buffer = conn->req_buffer;
+		conn->req.ahs = conn->rx_buffer;
+		conn->req.data = conn->rx_buffer
+			+ conn->req.bhs.hlength * 4;
+	}
+}
+
+int iscsi_rx_handler(struct iscsi_connection *conn)
 {
 	int ret = 0, hdigest, ddigest;
 	uint32_t crc;
@@ -2080,23 +2103,7 @@ void iscsi_rx_handler(struct iscsi_connection *conn)
 		hdigest = ddigest = 0;
 again:
 	switch (conn->rx_iostate) {
-	case IOSTATE_RX_BHS:
-		ret = do_recv(conn, IOSTATE_RX_INIT_AHS);
-		if (ret <= 0 || conn->rx_iostate != IOSTATE_RX_INIT_AHS)
-			break;
 	case IOSTATE_RX_INIT_AHS:
-		if (conn->state == STATE_SCSI) {
-			ret = iscsi_task_rx_start(conn);
-			if (ret) {
-				conn->state = STATE_CLOSE;
-				break;
-			}
-		} else {
-			conn->rx_buffer = conn->req_buffer;
-			conn->req.ahs = conn->rx_buffer;
-			conn->req.data = conn->rx_buffer
-				+ conn->req.bhs.hlength * 4;
-		}
 		conn->req.ahssize = conn->req.bhs.hlength * 4;
 		conn->req.datasize = ntoh24(conn->req.bhs.dlength);
 		conn->rx_size = conn->req.ahssize;
@@ -2104,7 +2111,7 @@ again:
 		if (conn->state != STATE_SCSI &&
 		    conn->req.ahssize > INCOMING_BUFSIZE) {
 			conn->state = STATE_CLOSE;
-			return;
+			return -1;
 		}
 
 		if (conn->rx_size) {
@@ -2164,7 +2171,7 @@ again:
 				if (conn->req.ahssize + conn->rx_size >
 				    INCOMING_BUFSIZE) {
 					conn->state = STATE_CLOSE;
-					return;
+					return -1;
 				}
 			}
 		} else {
@@ -2202,10 +2209,11 @@ again:
 		exit(1);
 	}
 
-	if (ret < 0 ||
-	    conn->rx_iostate != IOSTATE_RX_END ||
-	    conn->state == STATE_CLOSE)
-		return;
+	if (ret < 0)
+		return ret;
+
+	if (conn->rx_iostate != IOSTATE_RX_END || conn->state == STATE_CLOSE)
+		return 0;
 
 	if (conn->rx_size) {
 		eprintf("error %d %d %d\n", conn->state, conn->rx_iostate,
@@ -2213,6 +2221,13 @@ again:
 		exit(1);
 	}
 
+	return 0;
+}
+
+void iscsi_rx_done(struct iscsi_connection *conn)
+{
+	int ret;
+
 	if (conn->state == STATE_SCSI) {
 		ret = iscsi_task_rx_done(conn);
 		if (ret)
@@ -2268,12 +2283,6 @@ int iscsi_tx_handler(struct iscsi_connection *conn)
 	} else
 		hdigest = ddigest = 0;
 
-	if (conn->state == STATE_SCSI && !conn->tx_task) {
-		ret = iscsi_task_tx_start(conn);
-		if (ret)
-			goto out;
-	}
-
 	/*
 	 * For rdma, grab the data-in or r2t packet and covert to
 	 * an RDMA operation.
@@ -2393,6 +2402,14 @@ again:
 finish:
 	cmnd_finish(conn);
 
+out:
+	return ret;
+}
+
+void iscsi_tx_done(struct iscsi_connection *conn)
+{
+	int ret;
+
 	switch (conn->state) {
 	case STATE_KERNEL:
 		ret = conn_take_fd(conn);
@@ -2416,8 +2433,6 @@ finish:
 		break;
 	}
 
-out:
-	return ret;
 }
 
 int iscsi_transportid(int tid, uint64_t itn_id, char *buf, int size)
diff --git a/usr/iscsi/iscsid.h b/usr/iscsi/iscsid.h
index 01d0002..b795828 100644
--- a/usr/iscsi/iscsid.h
+++ b/usr/iscsi/iscsid.h
@@ -321,8 +321,13 @@ extern tgtadm_err conn_close_admin(uint32_t tid, uint64_t sid, uint32_t cid);
 extern char *text_key_find(struct iscsi_connection *conn, char *searchKey);
 extern void text_key_add(struct iscsi_connection *conn, char *key, char *value);
 extern void conn_read_pdu(struct iscsi_connection *conn);
+extern int iscsi_task_tx_start(struct iscsi_connection *conn);
 extern int iscsi_tx_handler(struct iscsi_connection *conn);
-extern void iscsi_rx_handler(struct iscsi_connection *conn);
+extern void iscsi_tx_done(struct iscsi_connection *conn);
+extern int iscsi_rx_bhs_handler(struct iscsi_connection *conn);
+extern void iscsi_pre_iostate_rx_init_ahs(struct iscsi_connection *conn);
+extern int iscsi_rx_handler(struct iscsi_connection *conn);
+extern void iscsi_rx_done(struct iscsi_connection *conn);
 extern int iscsi_scsi_cmd_execute(struct iscsi_task *task);
 extern int iscsi_transportid(int tid, uint64_t itn_id, char *buf, int size);
 extern int iscsi_add_portal(char *addr, int port, int tpgt);
-- 
1.7.10.4
