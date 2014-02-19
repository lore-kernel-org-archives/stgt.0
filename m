From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v2] tgtd: refresh ready fds of event loop after event deletion
Date: Wed, 19 Feb 2014 13:21:59 +0900
Message-ID: <1392783719-8868-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
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
also lets tgt_event_del() to turn on the flag in its tail.

For example, we can produce segfault of tgtd under heavy load. Below
is a backtrace obtained from the core file:
(gdb) bt

To be honest, I still don't find an event handler which calls
tgt_event_del() for other fds. But with this modification, the above
segfault is avoided. The change seems to be effective.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/tgtd.c |    9 +++++++++
 usr/tgtd.h |    2 ++
 2 files changed, 11 insertions(+)

v2: use the existing label "retry" instead of adding a new label

diff --git a/usr/tgtd.c b/usr/tgtd.c
index 50e1c83..04b31dc 100644
--- a/usr/tgtd.c
+++ b/usr/tgtd.c
@@ -212,6 +212,8 @@ static struct event_data *tgt_event_lookup(int fd)
 	return NULL;
 }
 
+int event_need_refresh;
+
 void tgt_event_del(int fd)
 {
 	struct event_data *tev;
@@ -229,6 +231,8 @@ void tgt_event_del(int fd)
 
 	list_del(&tev->e_list);
 	free(tev);
+
+	event_need_refresh = 1;
 }
 
 int tgt_event_modify(int fd, int events)
@@ -426,6 +430,11 @@ retry:
 		for (i = 0; i < nevent; i++) {
 			tev = (struct event_data *) events[i].data.ptr;
 			tev->handler(tev->fd, events[i].events, tev->data);
+
+			if (event_need_refresh) {
+				event_need_refresh = 0;
+				goto retry;
+			}
 		}
 	}
 
diff --git a/usr/tgtd.h b/usr/tgtd.h
index 8a25521..46b02af 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -405,4 +405,6 @@ struct service_action *
 find_service_action(struct service_action *service_action,
 		    uint32_t action);
 
+extern int event_need_refresh;
+
 #endif
-- 
1.7.10.4
