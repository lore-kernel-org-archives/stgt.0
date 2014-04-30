From: Andy Grover <agrover@redhat.com>
Subject: [PATCH] Remove unneeded pthread_cond_broadcast
Date: Wed, 30 Apr 2014 10:00:21 -0700
Message-ID: <1398877221-26278-1-git-send-email-agrover@redhat.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Previous patchset neglected to remove a now unneeded call.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 usr/bs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/usr/bs.c b/usr/bs.c
index 1ab86f7..a6b0b57 100644
--- a/usr/bs.c
+++ b/usr/bs.c
@@ -448,8 +448,6 @@ void bs_thread_close(struct bs_thread_info *info)
 {
 	int i;
 
-	pthread_cond_broadcast(&info->pending_cond);
-
 	for (i = 0; i < info->nr_worker_threads && info->worker_thread[i]; i++) {
 		pthread_cancel(info->worker_thread[i]);
 		pthread_join(info->worker_thread[i], NULL);
-- 
1.9.0
