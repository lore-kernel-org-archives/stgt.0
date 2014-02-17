From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH] tgtd: refresh ready fds of event loop after event deletion
Date: Mon, 17 Feb 2014 17:12:18 +0900
Message-ID: <1392624738-18896-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Current main event loop (event_loop()) of tgtd has a possibility of
segmentation fault. The problem is caused by the below sequence:

1. Event A, B are ready so epoll_wait(2) returns.
2. The handler of the event A is called. In the event handler, the
   event B is deleted with tgt_event_del()
3. event_loop() tries to call the handler of the event B. It causes
   segfault because the event struct is already removed and freed.

For avoid this problem, this patch adds a new global variable
event_need_refresh. If the value of this variable is 1, event_loop()
calls epoll_wait(2) again for refreshing ready fd list. This patch
also lets tgt_event_del() to turn on the flag in its tail. With this
modification, the above segfault is avoided.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/tgtd.c |   10 ++++++++++
 usr/tgtd.h |    2 ++
 2 files changed, 12 insertions(+)

diff --git a/usr/tgtd.c b/usr/tgtd.c
index 09c1442..c758458 100644
--- a/usr/tgtd.c
+++ b/usr/tgtd.c
@@ -215,6 +215,8 @@ static struct event_data *tgt_event_lookup(int fd)
 	return NULL;
 }
 
+int event_need_refresh;
+
 void tgt_event_del(int fd)
 {
 	struct event_data *tev;
@@ -232,6 +234,8 @@ void tgt_event_del(int fd)
 
 	list_del(&tev->e_list);
 	free(tev);
+
+	event_need_refresh = 1;
 }
 
 int tgt_event_modify(int fd, int events)
@@ -419,6 +423,7 @@ retry:
 	sched_remains = tgt_exec_scheduled();
 	timeout = sched_remains ? 0 : -1;
 
+refresh:
 	nevent = epoll_wait(ep_fd, events, ARRAY_SIZE(events), timeout);
 	if (nevent < 0) {
 		if (errno != EINTR) {
@@ -429,6 +434,11 @@ retry:
 		for (i = 0; i < nevent; i++) {
 			tev = (struct event_data *) events[i].data.ptr;
 			tev->handler(tev->fd, events[i].events, tev->data);
+
+			if (event_need_refresh) {
+				event_need_refresh = 0;
+				goto refresh;
+			}
 		}
 	}
 
diff --git a/usr/tgtd.h b/usr/tgtd.h
index a708f13..91dd7b4 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -406,4 +406,6 @@ struct service_action *
 find_service_action(struct service_action *service_action,
 		    uint32_t action);
 
+extern int event_need_refresh;
+
 #endif
-- 
1.7.10.4
