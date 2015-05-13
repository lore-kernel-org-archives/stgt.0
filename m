From: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Subject: [PATCH] sheepdog: fix to update data_vdi_id after writing data  object
Date: Wed, 13 May 2015 10:06:32 +0900
Message-ID: <1431479192-3181-1-git-send-email-ishizaki.teruaki@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org, mitake.hitoshi@lab.ntt.co.jp
Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>

Previously data_vdi_id was updated although data object was not
written successfully.
That broke inode data and volume data.

This patch changes to update data_vdi_id after writing data
object successfully.

Signed-off-by: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 9b5b259..cfaf48b 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -937,14 +937,6 @@ retry:
 
 				oid = vid_to_data_oid(ai->inode.vdi_id, idx);
 
-				ai->min_dirty_data_idx =
-					min_t(uint32_t,
-					      idx, ai->min_dirty_data_idx);
-				ai->max_dirty_data_idx =
-					max_t(uint32_t,
-					      idx, ai->max_dirty_data_idx);
-
-				ai->inode.data_vdi_id[idx] = vid;
 			}
 
 			need_reload_inode = 0;
@@ -966,6 +958,14 @@ retry:
 				}
 
 				if (create) {
+					ai->min_dirty_data_idx =
+						min_t(uint32_t, idx,
+						      ai->min_dirty_data_idx);
+					ai->max_dirty_data_idx =
+						max_t(uint32_t, idx,
+						      ai->max_dirty_data_idx);
+					ai->inode.data_vdi_id[idx] = vid;
+
 					need_update_inode = 1;
 					create = 0;
 				}
-- 
1.8.3.1
