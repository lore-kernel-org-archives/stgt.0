From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 5/6] sheepdog: don't let ai have min and max dirty data indexes
Date: Tue,  6 Sep 2016 16:37:28 +0900
Message-ID: <1473147449-29377-6-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8/l3EAkTP1ctKRr/nrFAY0unKut8Bpd8NaFV7wJ+Cew=;
        b=zqd6Fs+/c7xlgTn2NDt5WTE8BnCJ8mbhqQcf3tfSYCYGuFWcwYA2M1pAANwyJ9G5o6
         21my64Cz+uSwonqcRhgq2qdof3FMW6vEtVr2vyhRGn2QYGLaCkhSXablYKc9rSBUxbJd
         cSepyuvHyByDOxRoVXPpxwSj/lTQ41JvJ2saOiaxpj3TdlRafBJv1jT1GOpldm51HRJA
         E4W0L+lW68kMvRZT5XJcXPTni5s7mU8T+1IPNZTewTAbPL0Bs0wyObzySNb7gPfOlO4j
         zGScc7fMHgEe+L1U/RYj47+IXUs3eh48GqBVz7O/APP2OxpmY6CqZ/wZmnTbopkPXsGZ
         A+9Q==
In-Reply-To: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>, Takashi Menjo <menjo.takashi@lab.ntt.co.jp>

Like the qemu driver [1], this patch decouples min and dirty data
indexes from access info for avoiding overwriting by parallel
requests.

[1] https://github.com/codyprime/qemu-kvm-jtc/commit/498f21405a286f718a0767c791b7d2db19f4e5bd

Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Cc: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
Tested-by: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 8f228b5..12bcfd9 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -286,9 +286,6 @@ struct sheepdog_access_info {
 	struct list_head fd_list_head;
 	pthread_rwlock_t fd_list_lock;
 
-	uint32_t min_dirty_data_idx;
-	uint32_t max_dirty_data_idx;
-
 	struct sheepdog_inode inode;
 	pthread_rwlock_t inode_lock;
 
@@ -734,9 +731,6 @@ static int reload_inode(struct sheepdog_access_info *ai, int is_snapshot)
 		}
 	}
 
-	ai->min_dirty_data_idx = UINT32_MAX;
-	ai->max_dirty_data_idx = 0;
-
 	inode_version++;
 	ai->inode_version = inode_version;
 
@@ -854,14 +848,11 @@ static int sd_sync(struct sheepdog_access_info *ai)
 	}
 }
 
-static int update_inode(struct sheepdog_access_info *ai)
+static int update_inode(struct sheepdog_access_info *ai, uint32_t min, uint32_t max)
 {
 	int ret = 0, need_reload_inode = 0;
 	uint64_t oid = vid_to_vdi_oid(ai->inode.vdi_id);
-	uint32_t min, max, offset, data_len;
-
-	min = ai->min_dirty_data_idx;
-	max = ai->max_dirty_data_idx;
+	uint32_t offset, data_len;
 
 	if (max < min)
 		goto end;
@@ -890,8 +881,6 @@ update:
 	}
 
 end:
-	ai->min_dirty_data_idx = UINT32_MAX;
-	ai->max_dirty_data_idx = 0;
 
 	return ret;
 }
@@ -934,6 +923,7 @@ static int sd_io(struct sheepdog_access_info *ai, int write, char *buf, int len,
 	int nr_copies = ai->inode.nr_copies;
 	int need_write_lock, check_idx;
 	int read_reload_snap = 0;
+	uint32_t min_dirty_data_idx = UINT32_MAX, max_dirty_data_idx = 0;
 
 	goto do_req;
 
@@ -1015,12 +1005,12 @@ retry:
 				}
 
 				if (create) {
-					ai->min_dirty_data_idx =
+					min_dirty_data_idx =
 						min_t(uint32_t, idx,
-						      ai->min_dirty_data_idx);
-					ai->max_dirty_data_idx =
+						      min_dirty_data_idx);
+					max_dirty_data_idx =
 						max_t(uint32_t, idx,
-						      ai->max_dirty_data_idx);
+						      max_dirty_data_idx);
 					ai->inode.data_vdi_id[idx] = vid;
 
 					need_update_inode = 1;
@@ -1066,7 +1056,7 @@ done:
 	}
 
 	if (need_update_inode)
-		ret = update_inode(ai);
+		ret = update_inode(ai, min_dirty_data_idx, max_dirty_data_idx);
 
 out:
 	pthread_rwlock_unlock(&ai->inode_lock);
@@ -1279,9 +1269,6 @@ trans_to_expect_nothing:
 	if (ret)
 		goto out;
 
-	ai->min_dirty_data_idx = UINT32_MAX;
-	ai->max_dirty_data_idx = 0;
-
 	ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(vid),
 			  0, SD_INODE_SIZE, 0, &need_reload);
 	if (ret)
-- 
2.7.4
