From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/3] Fix race on thread shutdown causing deadlock
Date: Mon, 28 Apr 2014 18:51:20 -0700
Message-ID: <1398736282-1193-1-git-send-email-agrover@redhat.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

This patch and the next are somewhat a revert of 318e9f2, but the previous
fix didn't quite close the race. This only happens when we create threads
for a backstore that turns out to be invalid, which we then tear down.

See https://bugzilla.redhat.com/show_bug.cgi?id=848585 .

This is occurring because there's still a window where a thread misses
seeing info->stop == 1 but is not yet in cond_wait so it misses the
broadcast:

thread_close:              thread_worker_fn:
                           info->stop is seen as 0
info->stop = 1
pthread_cond_broadcast     -- misses broadcast
                           pthread_cond_wait
pthread_join (hangs)

I believe the solution is to go back to using pthread_cancel. We can call
it before pthread_cond_wait is called (or after) and it will do the right
thing: pop out and exit. The only tricky bit is we need to use the
pthread_cleanup_push mechanism to properly release info->pending_lock.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 usr/bs.c        | 25 ++++++++++++++-----------
 usr/bs_thread.h |  2 --
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/usr/bs.c b/usr/bs.c
index 13d3b4e..d81aaee 100644
--- a/usr/bs.c
+++ b/usr/bs.c
@@ -213,6 +213,12 @@ static void bs_sig_request_done(int fd, int events, void *data)
 	}
 }
 
+/* Unlock mutex even if thread is cancelled */
+static void mutex_cleanup(void *mutex)
+{
+	pthread_mutex_unlock(mutex);
+}
+
 static void *bs_thread_worker_fn(void *arg)
 {
 	struct bs_thread_info *info = arg;
@@ -226,15 +232,13 @@ static void *bs_thread_worker_fn(void *arg)
 	dprintf("started this thread\n");
 	pthread_mutex_unlock(&info->startup_lock);
 
-	while (!info->stop) {
+	while (1) {
 		pthread_mutex_lock(&info->pending_lock);
+		pthread_cleanup_push(mutex_cleanup, &info->pending_lock);
+
 	retest:
 		if (list_empty(&info->pending_list)) {
 			pthread_cond_wait(&info->pending_cond, &info->pending_lock);
-			if (info->stop) {
-				pthread_mutex_unlock(&info->pending_lock);
-				pthread_exit(NULL);
-			}
 			goto retest;
 		}
 
@@ -242,7 +246,7 @@ static void *bs_thread_worker_fn(void *arg)
 				       struct scsi_cmd, bs_list);
 
 		list_del(&cmd->bs_list);
-		pthread_mutex_unlock(&info->pending_lock);
+		pthread_cleanup_pop(1); /* Unlock pending_lock mutex */
 
 		info->request_fn(cmd);
 
@@ -435,10 +439,10 @@ tgtadm_err bs_thread_open(struct bs_thread_info *info, request_func_t *rfn,
 
 	return TGTADM_SUCCESS;
 destroy_threads:
-	info->stop = 1;
 
 	pthread_mutex_unlock(&info->startup_lock);
 	for (; i > 0; i--) {
+		pthread_cancel(info->worker_thread[i - 1]);
 		pthread_join(info->worker_thread[i - 1], NULL);
 		eprintf("stopped the worker thread %d\n", i - 1);
 	}
@@ -455,18 +459,17 @@ void bs_thread_close(struct bs_thread_info *info)
 {
 	int i;
 
-	info->stop = 1;
 	pthread_cond_broadcast(&info->pending_cond);
 
-	for (i = 0; i < info->nr_worker_threads && info->worker_thread[i]; i++)
+	for (i = 0; i < info->nr_worker_threads && info->worker_thread[i]; i++) {
+		pthread_cancel(info->worker_thread[i]);
 		pthread_join(info->worker_thread[i], NULL);
+	}
 
 	pthread_cond_destroy(&info->pending_cond);
 	pthread_mutex_destroy(&info->pending_lock);
 	pthread_mutex_destroy(&info->startup_lock);
 	free(info->worker_thread);
-
-	info->stop = 0;
 }
 
 int bs_thread_cmd_submit(struct scsi_cmd *cmd)
diff --git a/usr/bs_thread.h b/usr/bs_thread.h
index a7e4063..a3ac551 100644
--- a/usr/bs_thread.h
+++ b/usr/bs_thread.h
@@ -13,8 +13,6 @@ struct bs_thread_info {
 
 	pthread_mutex_t startup_lock;
 
-	int stop;
-
 	request_func_t *request_fn;
 };
 
-- 
1.9.0
