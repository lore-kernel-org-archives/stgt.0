From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: fix a compiler warning due to an unused label
Date: Sat, 11 Oct 2014 13:13:22 +0900
Message-ID: <1413000802-11886-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=y3fIcWJNBYUJD8T6BzQT/DVEzIMPLxEGCAcovQX9sRQ=;
        b=Wn66WZqZXhDlVhluuH6KLWDDWb/KYQM6AeerCWoY9vEO6quzGfqDKtllmwhruokcV0
         0X6nZUN5K1UfNPxyIWAgLNmlgTUCw7It1Q8FRa6SbSURFm1Tju43dEWaC+yyfgffjzBN
         9ojVjCK84u4nalL/WOvzITjaLkWI+F2Tzep0qDhjEkMIudoM9CJ9ChrnELFeGfc9319b
         iE1qua0FDbT3bGjiHYHcJYJuH+UN/X/otMu3JSIS+NuA6GRu4+RSetlvvUhNeJTJSBU1
         roQx7JCyYu/GGBLq0hQJSEhgJEnJIGlB9mNt1eQJ1UHWus70vP7KtJ1FKNSTXV1P35Id
         H/PA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This gets rid of the following gcc warning in sd_open function by
removing the unused label 'retry':

 bs_sheepdog.c: In function 'sd_open':
 bs_sheepdog.c:1199:1: warning: label 'retry' defined but not used [-Wunused-label]
  retry:
  ^

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 9376946..ba5b099 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -1196,7 +1196,6 @@ trans_to_expect_nothing:
 	ai->min_dirty_data_idx = UINT32_MAX;
 	ai->max_dirty_data_idx = 0;
 
-retry:
 	ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(vid),
 			  0, SD_INODE_SIZE, 0, &need_reload);
 	if (ret)
-- 
1.8.3.1
