From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 1/3] sheepdog: refresh invalidated inode in update_inode() path
Date: Fri, 26 Sep 2014 15:44:24 +0900
Message-ID: <1411713866-12355-2-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1411713866-12355-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zhVWT6aqUmGYxB1KbHVlIDAmeN9FIWjROdrkpBROMxM=;
        b=AnjbpiarNIeHx/Nx+U+RFuF26LlnEA2MPYG1uZrd5NJBcp4SmPiqyOJt8JQb7gmHVA
         XKEUZG8biO3af9DzfsNstBrL9XAPDKkDyGu4JgGpMYCZWtLBmIxK0pSFdPhJFTZUZpeD
         vjCrlPhsltMXXA2sL+cqyvoHhP9hzYGfD2uw/KzfYpGieobTXOqYSdrjM2LG/be/oadI
         Ix+KCUbohAL+xu7EhnTT3rDZ68VOA9knvmjl6aLfPZEJLNOCD7zQDRwat2lE7HRJT9py
         InoU+9lSDDCfmAfHmGBpOojZ7NJdUd5JnYi5U0VMsjRNmxg9Zz+axkUdt4tAK1SlqMmj
         QMtg==
In-Reply-To: <1411713866-12355-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

This patch also adds a string representation of new error code
SD_RES_INODE_INVALIDATED.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index bbbd392..09ba470 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -346,6 +346,7 @@ static const char *sd_strerror(int err)
 		{SD_RES_JOIN_FAILED, "Target node had failed to join sheepdog"},
 		{SD_RES_HALT, "Sheepdog is stopped serving IO request"},
 		{SD_RES_READONLY, "Object is read-only"},
+		{SD_RES_INODE_INVALIDATED, "Inode object is invalidated"},
 	};
 
 	for (i = 0; i < ARRAY_SIZE(errors); ++i) {
@@ -766,7 +767,7 @@ static int sd_sync(struct sheepdog_access_info *ai)
 
 static int update_inode(struct sheepdog_access_info *ai)
 {
-	int ret = 0;
+	int ret = 0, need_reload_inode = 0;
 	uint64_t oid = vid_to_vdi_oid(ai->inode.vdi_id);
 	uint32_t min, max, offset, data_len;
 
@@ -776,16 +777,29 @@ static int update_inode(struct sheepdog_access_info *ai)
 	if (max < min)
 		goto end;
 
+	goto update;
+
+reload:
+	reload_inode(ai);
+	need_reload_inode = 0;
+
+update:
 	offset = sizeof(ai->inode) - sizeof(ai->inode.data_vdi_id) +
 		min * sizeof(ai->inode.data_vdi_id[0]);
 	data_len = (max - min + 1) * sizeof(ai->inode.data_vdi_id[0]);
 
 	ret = write_object(ai, (char *)&ai->inode + offset, oid,
 			   ai->inode.nr_copies, data_len, offset,
-			   0, 0, 0, NULL);
+			   0, 0, 0, &need_reload_inode);
 	if (ret < 0)
 		eprintf("sync inode failed\n");
 
+	if (need_reload_inode) {
+		dprintf("reloading inode is required in the path"
+			" of update_inode()\n");
+		goto reload;
+	}
+
 end:
 	ai->min_dirty_data_idx = UINT32_MAX;
 	ai->max_dirty_data_idx = 0;
-- 
1.8.3.2
