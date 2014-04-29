From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 2/3] Remove startup_lock
Date: Mon, 28 Apr 2014 18:51:21 -0700
Message-ID: <1398736282-1193-2-git-send-email-agrover@redhat.com>
References: <1398736282-1193-1-git-send-email-agrover@redhat.com>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1398736282-1193-1-git-send-email-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

The purpose of the startup lock was to hold threads at the startup_lock
so if a thread creation fails, it's still possible to have them
end themselves by looking at info->stop. Since we are back to using
pthread_cancel instead of info->stop, we don't need this any more.
The only wrinkle is we need to only send pthread_cancels to
successfully-created threads, so now check this in the destroy_threads
reverse-loop.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 usr/bs.c        | 17 +++++------------
 usr/bs_thread.h |  2 --
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/usr/bs.c b/usr/bs.c
index d81aaee..d6b8015 100644
--- a/usr/bs.c
+++ b/usr/bs.c
@@ -228,9 +228,6 @@ static void *bs_thread_worker_fn(void *arg)
 	sigfillset(&set);
 	sigprocmask(SIG_BLOCK, &set, NULL);
 
-	pthread_mutex_lock(&info->startup_lock);
-	dprintf("started this thread\n");
-	pthread_mutex_unlock(&info->startup_lock);
 
 	while (1) {
 		pthread_mutex_lock(&info->pending_lock);
@@ -420,9 +417,7 @@ tgtadm_err bs_thread_open(struct bs_thread_info *info, request_func_t *rfn,
 
 	pthread_cond_init(&info->pending_cond, NULL);
 	pthread_mutex_init(&info->pending_lock, NULL);
-	pthread_mutex_init(&info->startup_lock, NULL);
 
-	pthread_mutex_lock(&info->startup_lock);
 	for (i = 0; i < nr_threads; i++) {
 		ret = pthread_create(&info->worker_thread[i], NULL,
 				     bs_thread_worker_fn, info);
@@ -434,22 +429,21 @@ tgtadm_err bs_thread_open(struct bs_thread_info *info, request_func_t *rfn,
 				goto destroy_threads;
 		}
 	}
-	pthread_mutex_unlock(&info->startup_lock);
 	info->nr_worker_threads = nr_threads;
 
 	return TGTADM_SUCCESS;
 destroy_threads:
 
-	pthread_mutex_unlock(&info->startup_lock);
 	for (; i > 0; i--) {
-		pthread_cancel(info->worker_thread[i - 1]);
-		pthread_join(info->worker_thread[i - 1], NULL);
-		eprintf("stopped the worker thread %d\n", i - 1);
+		if (info->worker_thread[i - 1]) {
+			pthread_cancel(info->worker_thread[i - 1]);
+			pthread_join(info->worker_thread[i - 1], NULL);
+			eprintf("stopped the worker thread %d\n", i - 1);
+		}
 	}
 
 	pthread_cond_destroy(&info->pending_cond);
 	pthread_mutex_destroy(&info->pending_lock);
-	pthread_mutex_destroy(&info->startup_lock);
 	free(info->worker_thread);
 
 	return TGTADM_NOMEM;
@@ -468,7 +462,6 @@ void bs_thread_close(struct bs_thread_info *info)
 
 	pthread_cond_destroy(&info->pending_cond);
 	pthread_mutex_destroy(&info->pending_lock);
-	pthread_mutex_destroy(&info->startup_lock);
 	free(info->worker_thread);
 }
 
diff --git a/usr/bs_thread.h b/usr/bs_thread.h
index a3ac551..260f73f 100644
--- a/usr/bs_thread.h
+++ b/usr/bs_thread.h
@@ -11,8 +11,6 @@ struct bs_thread_info {
 	/* protected by pending_lock */
 	struct list_head pending_list;
 
-	pthread_mutex_t startup_lock;
-
 	request_func_t *request_fn;
 };
 
-- 
1.9.0
