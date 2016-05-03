From: Feng Li <li.feng@oracle.com>
Subject: [PATCH] fix timerfd support
Date: Tue,  3 May 2016 16:45:38 +0800
Message-ID: <1462265138-39308-1-git-send-email-li.feng@oracle.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org, lifeng1519@gmail.com

From: vonnyfly <lifeng1519@gmail.com>

There are some exceptions when checking features in Makefile.
In my debian, timerfd.h path is not '/usr/include/sys/timerfd.h'.

 $ find /usr/include -name "timerfd.h" | head -n1
 /usr/include/x86_64-linux-gnu/sys/timerfd.h

In my raspberrypi, the path is also not here.

So, it will not enable timerfd, even though it supports actually.
When I enable it after fix.  I have seen error logs.
"Failed to write to pipe".

From the code, we could know in add_work, it calls work_timer_schedule_evt.
work_timer_schedule_evt will call write(timer_fd[1], ...), then it will print error log,
because timer_fd[1] == -1.

When enable timerfd support, makefile check incorrectly.
work_timer_schedule_evt should check support of timerfd.

Signed-off-by: vonnyfly <lifeng1519@gmail.com>
---
 usr/Makefile | 2 +-
 usr/work.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/Makefile b/usr/Makefile
index 1fae7e7..d4e3eaf 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -5,7 +5,7 @@ ifneq ($(shell test -e /usr/include/linux/signalfd.h && echo 1),)
 CFLAGS += -DUSE_SIGNALFD
 endif
 
-ifneq ($(shell test -e /usr/include/sys/timerfd.h && echo 1),)
+ifneq ($(shell test -n $(shell find /usr/include -name "timerfd.h" | head -n1) && echo 1),)
 CFLAGS += -DUSE_TIMERFD
 endif
 
diff --git a/usr/work.c b/usr/work.c
index 6b9ec12..d760c22 100644
--- a/usr/work.c
+++ b/usr/work.c
@@ -59,7 +59,7 @@ static void work_timer_schedule_evt(void)
 	unsigned int n = 0;
 	int err;
 
-	if (timer_pending)
+	if (timer_pending || timer_fd[1] < 0)
 		return;
 
 	timer_pending = 1;
-- 
2.8.1
