From: YAMADA Hideki <yamada.hideki@lab.ntt.co.jp>
Subject: [PATCH] sheepdog: fix to clear create flag when reloading inode
Date: Wed,  5 Nov 2014 14:31:20 +0900
Message-ID: <1415165480-15541-1-git-send-email-yamada.hideki@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: YAMADA Hideki <yamada.hideki@lab.ntt.co.jp>

This bug causes duplicated CREATE_AND_WRITE requests
in case of iSCSI multipath failover.

Signed-off-by: YAMADA Hideki <yamada.hideki@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index ba5b099..2941803 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -858,7 +858,7 @@ static int sd_io(struct sheepdog_access_info *ai, int write, char *buf, int len,
 		(offset + len + (SD_DATA_OBJ_SIZE - 1)) / SD_DATA_OBJ_SIZE;
 	unsigned obj_offset = offset % SD_DATA_OBJ_SIZE;
 	size_t orig_size, size, rest = len;
-	int ret = 0, create = 0;
+	int ret = 0, create;
 	uint64_t oid, old_oid;
 	uint16_t flags = 0;
 	int need_update_inode = 0, need_reload_inode;
@@ -899,6 +899,7 @@ retry:
 			 * always turn on cache of sheep layer
 			 */
 			flags = SD_FLAG_CMD_CACHE;
+			create = 0;
 
 			if (ai->inode.data_vdi_id[idx] != vid) {
 				create = 1;
-- 
1.7.1
