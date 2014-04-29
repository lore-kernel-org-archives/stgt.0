From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 3/3] Replace if()/goto with while()
Date: Mon, 28 Apr 2014 18:51:22 -0700
Message-ID: <1398736282-1193-3-git-send-email-agrover@redhat.com>
References: <1398736282-1193-1-git-send-email-agrover@redhat.com>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1398736282-1193-1-git-send-email-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Is equivalent and nicer-looking.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 usr/bs.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/usr/bs.c b/usr/bs.c
index d6b8015..1ab86f7 100644
--- a/usr/bs.c
+++ b/usr/bs.c
@@ -122,11 +122,9 @@ retry:
 	}
 
 	pthread_mutex_lock(&finished_lock);
-retest:
-	if (list_empty(&finished_list)) {
+
+	while (list_empty(&finished_list))
 		pthread_cond_wait(&finished_cond, &finished_lock);
-		goto retest;
-	}
 
 	while (!list_empty(&finished_list)) {
 		cmd = list_first_entry(&finished_list,
@@ -228,16 +226,13 @@ static void *bs_thread_worker_fn(void *arg)
 	sigfillset(&set);
 	sigprocmask(SIG_BLOCK, &set, NULL);
 
-
 	while (1) {
 		pthread_mutex_lock(&info->pending_lock);
 		pthread_cleanup_push(mutex_cleanup, &info->pending_lock);
 
-	retest:
-		if (list_empty(&info->pending_list)) {
-			pthread_cond_wait(&info->pending_cond, &info->pending_lock);
-			goto retest;
-		}
+		while (list_empty(&info->pending_list))
+			pthread_cond_wait(&info->pending_cond,
+					  &info->pending_lock);
 
 		cmd = list_first_entry(&info->pending_list,
 				       struct scsi_cmd, bs_list);
-- 
1.9.0
