From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: [PATCH 2/3] sheepdog: update layout of inode object header
Date: Sun,  6 Jul 2014 23:30:31 +0900
Message-ID: <1404657032-17629-3-git-send-email-mitake.hitoshi@gmail.com>
References: <1404657032-17629-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jiwBmfIdkJmZh6QjRzxNuU6O8cdHLQisXCWXbEwOppA=;
        b=wbTJlVCIW36xBKjSI2lRu22/+KqneenBMHm/6TYhXvUmK0wuo3ktyaticeAKZMcN2+
         sFLhsLHK3q7bORInRiAz5ITF/feCBe7E0etWVPuqYkcbzlRwAG4zNKpmzXejOKRxuL2E
         tWQkrQioMvAJUonmtRVASFb8ngmbiJwS8sTMXmBGzjujR71IJAUFxJRrJ+Uki1srFHaw
         2CCC1iNqVDFGfLTE8A/gIeRy4zCldpkzbzcxoTXzF9FZowtyJs7fPxC+eK6i0rXg/joe
         ZpqYkCUyApkZN77Fj9FI86PGbJtbAFQAr2W2AYuDXR/jYLXUW5KES+z9/2IXdzlP/S4o
         06tw==
In-Reply-To: <1404657032-17629-1-git-send-email-mitake.hitoshi@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@gmail.com>, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

This change doesn't affect behavior of sheepdog driver. Just for
documentation purpose.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index a333675..15f44d8 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -193,6 +193,19 @@ struct sheepdog_vdi_rsp {
 	uint32_t pad[5];
 };
 
+/*
+ * Historical notes: previous version of sheepdog (< v0.9.0) has a limit of
+ * maximum number of children which can be created from single VDI. So the inode
+ * object has an array for storing the IDs of the child VDIs. The constant
+ * OLD_MAX_CHILDREN represents it. Current sheepdog doesn't have the limitation,
+ * so we are recycling the area (4 * OLD_MAX_CHILDREN = 4KB) for storing new
+ * metadata.
+ *
+ * users of the released area:
+ * - uint32_t btree_counter
+ */
+#define OLD_MAX_CHILDREN 1024U
+
 struct sheepdog_inode {
 	char name[SD_MAX_VDI_LEN];
 	char tag[SD_MAX_VDI_TAG_LEN];
@@ -201,13 +214,17 @@ struct sheepdog_inode {
 	uint64_t vm_clock_nsec;
 	uint64_t vdi_size;
 	uint64_t vm_state_size;
-	uint16_t copy_policy;
+	uint8_t  copy_policy;
+	uint8_t  store_policy;
 	uint8_t nr_copies;
 	uint8_t block_size_shift;
 	uint32_t snap_id;
 	uint32_t vdi_id;
 	uint32_t parent_vdi_id;
-	uint32_t child_vdi_id[MAX_CHILDREN];
+
+	uint32_t btree_counter;
+	uint32_t __unused[OLD_MAX_CHILDREN - 1];
+
 	uint32_t data_vdi_id[MAX_DATA_OBJS];
 };
 
-- 
1.9.1
