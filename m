From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 2/2] bs_sheepdog.c: fix segmentation fault caused by deleting logical unit
Date: Wed, 16 Oct 2013 11:49:42 +0900
Message-ID: <1381891782-13078-3-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1381891782-13078-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1381891782-13078-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

This patch removes a bug in bs_exit() of bs_sheepdog.c which caused
segmentation fault.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 11ddce6..de66d59 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -1233,15 +1233,20 @@ static void bs_sheepdog_exit(struct scsi_lu *lu)
 	struct sheepdog_access_info *ai =
 		(struct sheepdog_access_info *)(info + 1);
 
-	struct sheepdog_fd_list *p;
+	struct sheepdog_fd_list *p, *next;
 
 	bs_thread_close(info);
 
-	list_for_each_entry(p, &ai->fd_list_head, list) {
+	list_for_each_entry_safe(p, next, &ai->fd_list_head, list) {
 		close(p->fd);
 		list_del(&p->list);
 		free(p);
 	}
+
+	pthread_rwlock_destroy(&ai->fd_list_lock);
+	pthread_rwlock_destroy(&ai->inode_lock);
+
+	dprintf("cleaned logical unit %p safely\n", lu);
 }
 
 static struct backingstore_template sheepdog_bst = {
-- 
1.7.10.4

