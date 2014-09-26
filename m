From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 2/3] sheepdog: set flag for indicating requests are from tgt
Date: Fri, 26 Sep 2014 15:44:25 +0900
Message-ID: <1411713866-12355-3-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1411713866-12355-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aCIOSkIqfMBoww4Xa9N4z1W2tu+C2vu2lmEjigwvF7M=;
        b=PR+/9rw6K0XLA9DT3it3yzJwnhQXHh6ivgDGjNueJvS5vWGWd1nFIcoVLty/XF17KC
         nto9i5EWVDj1PFpgCqA9NrT0KZCMewlNOODwTUrCIsVca0WbUWMmbaG7DngiS5Cx/Xad
         0TSXhCGlPjuAcPqC31FGHpNnZg06JaHMNNk3lQHBvLJZz8T7VEa9ru0LH/HVBYUt7LkQ
         IeCrMguotGzwF11iBgO/Vqkl6XwX4V642s4KTa0HKjpphKuiJbJDbO8g5xGTTcynftMI
         dmVMF4H3wizRr3DqphSuBXn1nQp5BKkWhO9k1GoD3wzvXo9TnfWIvDUwboVr2G4yJwhl
         5UqA==
In-Reply-To: <1411713866-12355-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

It is required for iSCSI multipath with sheepdog.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 09ba470..06f2995 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -66,6 +66,9 @@
 #define SD_FLAG_CMD_COW      0x02
 #define SD_FLAG_CMD_CACHE    0x04 /* Writeback mode for cache */
 #define SD_FLAG_CMD_DIRECT   0x08 /* Don't use cache */
+/* return something back while sending something to sheep */
+#define SD_FLAG_CMD_PIGGYBACK   0x10
+#define SD_FLAG_CMD_TGT   0x20
 
 #define SD_RES_SUCCESS       0x00 /* Success */
 #define SD_RES_UNKNOWN       0x01 /* Unknown error */
@@ -693,6 +696,7 @@ static int read_write_object(struct sheepdog_access_info *ai, char *buf,
 	hdr.data_length = datalen;
 	hdr.offset = offset;
 	hdr.copies = copies;
+	hdr.flags |= SD_FLAG_CMD_TGT;
 
 	ret = do_req(ai, (struct sheepdog_req *)&hdr, buf, &wlen, &rlen);
 	if (ret) {
@@ -1171,6 +1175,7 @@ trans_to_expect_nothing:
 	ai->min_dirty_data_idx = UINT32_MAX;
 	ai->max_dirty_data_idx = 0;
 
+retry:
 	ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(vid),
 			  0, SD_INODE_SIZE, 0, &need_reload);
 	if (ret)
-- 
1.8.3.2
