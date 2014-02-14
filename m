From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v4 RFC 4/5] tgtd: implement a deferred event modification mechanism
Date: Fri, 14 Feb 2014 20:21:32 +0900
Message-ID: <1392376893-26106-5-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
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

In the next commit, worker threads for sending/receiving iSCSI PDUs
will be implemented. When the feature is used, the worker threads read
and write fds created by accept(2). For avoiding conflicts between the
main event loop thread and the worker threads, no event should be
notified to the main event via epoll_wait(2) when the worker threads
are running.

For this purpose, this patch implements a deferred event modification
mechanism. Two new members are added to iscsi_tcp_connection:
used_in_worker_threads and restore_events. The first one is used for
indicating that the connection is used by worker threads. The second
one is used for storing an event mask which should be set to the
fd. When control of the fd is passed back to the main event, the
stored event mask is set via tgt_event_modify().

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/iscsi/iscsi_tcp.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/usr/iscsi/iscsi_tcp.c b/usr/iscsi/iscsi_tcp.c
index d00265e..bb553a8 100644
--- a/usr/iscsi/iscsi_tcp.c
+++ b/usr/iscsi/iscsi_tcp.c
@@ -61,6 +61,9 @@ struct iscsi_tcp_connection {
 	long ttt;
 
 	struct iscsi_connection iscsi_conn;
+
+	int used_in_worker_thread;
+	int restore_events;
 };
 
 static inline struct iscsi_tcp_connection *TCP_CONN(struct iscsi_connection *conn)
@@ -588,9 +591,13 @@ static void iscsi_event_modify(struct iscsi_connection *conn, int events)
 	struct iscsi_tcp_connection *tcp_conn = TCP_CONN(conn);
 	int ret;
 
-	ret = tgt_event_modify(tcp_conn->fd, events);
-	if (ret)
-		eprintf("tgt_event_modify failed\n");
+	if (tcp_conn->used_in_worker_thread)
+		tcp_conn->restore_events = events;
+	else {
+		ret = tgt_event_modify(tcp_conn->fd, events);
+		if (ret)
+			eprintf("tgt_event_modify failed\n");
+	}
 }
 
 static struct iscsi_task *iscsi_tcp_alloc_task(struct iscsi_connection *conn,
-- 
1.7.10.4
