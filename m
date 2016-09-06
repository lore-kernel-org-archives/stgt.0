From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 4/6] sheepdog: handle a case of snapshot -> failover
Date: Tue,  6 Sep 2016 16:37:27 +0900
Message-ID: <1473147449-29377-5-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g/iNaw8l3yhjb+2Hs8cwWS1r+BO2DIoviJXGX/ngyNM=;
        b=yM6YJp/oZw1+1/fvk4iq+A91FneYR90u/Fo/FeQxSzvoOsAjC/znhy9DlI/AUBeLtE
         L4h2latheNhCWwN+tBuAfVe9ekPTyKZJ4b1PTdn6FqJSObv2924mM3XLVgeZ/nSMamWt
         hupY5P6VK88aWYqg0OIrYJ0MNPNOQC+2+T0hU4v+PFYb+GNV9cHuZNkJz8E3Ef8fi3Cu
         cX6jSlYLVhxbtHrNGWFY6nzyvsp2uCxpjpkjEiPt3HdM2rqHyxAyL9Q+qqi0WPQEDVQm
         ugqGnCRVNS/3A61k7F1L4K3RNNLLdBPqDo7H3QjoTMLdC1xq7ABfBxqnyHCR2LFWflHz
         RmxQ==
In-Reply-To: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>, Takashi Menjo <menjo.takashi@lab.ntt.co.jp>

If refreshed inode is snapshot, we can reload entire inode and switch
to working VDI immediately.

Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Cc: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
Tested-by: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index ecb5033..8f228b5 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -704,6 +704,34 @@ static int reload_inode(struct sheepdog_access_info *ai, int is_snapshot)
 			ret = -1;
 			goto ret;
 		}
+
+		if (!!ai->inode.snap_ctime) {
+			/*
+			 * This is a case like below:
+			 * take snapshot -> write something -> failover
+			 *
+			 * Because invalidated inode is readonly and latest
+			 * working VDI can have COWed objects, we need to
+			 * resolve VID and reload its entire inode object.
+			 */
+			memset(tag, 0, sizeof(tag));
+
+			ret = find_vdi_name(ai, ai->inode.name, CURRENT_VDI_ID,
+					    tag, &vid, 0);
+			if (ret) {
+				ret = -1;
+				goto ret;
+			}
+
+			ret = read_object(ai, (char *)&ai->inode,
+					  vid_to_vdi_oid(vid),
+					  ai->inode.nr_copies, SD_INODE_SIZE, 0,
+					  &need_reload);
+			if (ret) {
+				ret = -1;
+				goto ret;
+			}
+		}
 	}
 
 	ai->min_dirty_data_idx = UINT32_MAX;
-- 
2.7.4
