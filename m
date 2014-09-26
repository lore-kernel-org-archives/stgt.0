From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 3/3] sheepdog: change a method for detecting invalidation of inode
Date: Fri, 26 Sep 2014 15:44:26 +0900
Message-ID: <1411713866-12355-4-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1411713866-12355-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z5DH4KgO6XAaC70Cj78BGgGT1SdH/9m1QfcH+gsO74g=;
        b=CTS5D/j8LoDunzdEfB6FEpyoftj4Hmx9r2onK1baBFEgL+uIxUCSV7gFVmRkr+nTB0
         UvE9hLMy4wPQPoC0JnJJ9Y+v5toW2xGPa5hqoK0QaelsMuAAuN45/67gFdwiyAySie2L
         McWscGwpfjNE7z47ZuEDvaYaKpG4CoQDPCevCj2htH+cYdcG2mSSSVn1TyhmjVJ5vFas
         45YbsQE84QLSs1AvgNAiNlN7JJNw0jEZjdM7UYKmWxwqk/99L6j/ytMGW0vqglM8pExG
         OhHd6wdO2RTDtxEg5pSchQUYP+ELhD26etAA8PtV1QS2+PofzgKoPoRtC/gNktlYDJFh
         kFEQ==
In-Reply-To: <1411713866-12355-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Current method of detecting invalidation of inode can produce bunch of
error messages if a first object of VDI doesn't exist. This patch
updates the method: reading first one byte of inode object. It can
reduce needless and confusing error messages.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 06f2995..b9b7067 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -817,18 +817,16 @@ static int is_refresh_required(struct sheepdog_access_info *ai)
  * 1: refresh is required
  */
 {
-	uint64_t first_oid = vid_to_data_oid(ai->inode.vdi_id, 0);
+	uint64_t inode_oid = vid_to_vdi_oid(ai->inode.vdi_id);
 	char dummy;
 	int need_reload_inode = 0;
 
 	/*
 	 * Check inode of this tgtd is invaldiated or not.
-	 * Reading which object isn't a problem. If the inode object is
-	 * invalidated, sheep returns SD_RES_INODE_INVALIDATED even if the
-	 * object doesn't exist. So we read the first one.
+	 * The inode object is the only one object which always exists.
 	 */
 
-	read_object(ai, &dummy, first_oid, ai->inode.nr_copies, sizeof(dummy),
+	read_object(ai, &dummy, inode_oid, ai->inode.nr_copies, sizeof(dummy),
 		    0, &need_reload_inode);
 
 	return need_reload_inode;
-- 
1.8.3.2
