From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: fix pthread rwlock leak in sd_io()
Date: Thu, 31 Oct 2013 10:31:27 +0900
Message-ID: <1383183087-3789-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, sheepdog@lists.wpkg.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

The current sd_io function exits without unlocking pthread rwlock in
the error path.  This fixes the leak bug.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index cfe1046..8bb5c80 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -845,7 +845,7 @@ retry:
 
 		if (ret) {
 			eprintf("%lu %d\n", idx, ret);
-			return -1;
+			goto out;
 		}
 
 done:
@@ -856,6 +856,7 @@ done:
 	if (need_update_inode)
 		ret = update_inode(ai);
 
+out:
 	pthread_rwlock_unlock(&ai->inode_lock);
 
 	return ret;
-- 
1.7.9.3
