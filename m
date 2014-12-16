From: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Subject: [PATCH] sheepdog: support for variable object size
Date: Tue, 16 Dec 2014 20:01:39 +0900
Message-ID: <1418727699-23585-1-git-send-email-ishizaki.teruaki@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@lab.ntt.co.jp, Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>

Previously, Sheepdog VDI's object size was fixed to 4MB.
This patch enables to handle variable object size of Sheepdog VDI.

Signed-off-by: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 7c155fe..0838009 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -194,7 +194,7 @@ struct sheepdog_vdi_req {
 	uint8_t copies;
 	uint8_t copy_policy;
 	uint8_t ec_index;
-	uint8_t reserved;
+	uint8_t block_size_shift;
 	uint32_t snapid;
 	uint32_t type;
 	uint32_t pad[2];
@@ -212,7 +212,8 @@ struct sheepdog_vdi_rsp {
 	uint32_t vdi_id;
 	uint32_t attr_id;
 	uint8_t copies;
-	uint8_t reserved[3];
+	uint8_t block_size_shift;
+	uint8_t reserved[2];
 	uint32_t pad[3];
 };
 
@@ -864,10 +865,11 @@ static int sd_io(struct sheepdog_access_info *ai, int write, char *buf, int len,
 		 uint64_t offset)
 {
 	uint32_t vid;
-	unsigned long idx = offset / SD_DATA_OBJ_SIZE;
+	uint32_t object_size = (UINT32_C(1) << ai->inode.block_size_shift);
+	unsigned long idx = offset / object_size;
 	unsigned long max =
-		(offset + len + (SD_DATA_OBJ_SIZE - 1)) / SD_DATA_OBJ_SIZE;
-	unsigned obj_offset = offset % SD_DATA_OBJ_SIZE;
+		(offset + len + (object_size - 1)) / object_size;
+	unsigned obj_offset = offset % object_size;
 	size_t orig_size, size, rest = len;
 	int ret = 0, create;
 	uint64_t oid, old_oid;
@@ -896,7 +898,7 @@ do_req:
 
 	for (; idx < max; idx++) {
 		orig_size = size;
-		size = SD_DATA_OBJ_SIZE - obj_offset;
+		size = object_size - obj_offset;
 		size = min_t(size_t, size, rest);
 
 retry:
-- 
1.7.1
