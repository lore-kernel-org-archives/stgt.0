From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] Fix accepting invalid block size
Date: Tue, 26 Jul 2016 14:06:32 +0300
Message-ID: <1469531192-30570-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

bshift can be negative so its type should not be unsigned or the
comparison of its negative never succeeds.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/target.c b/usr/target.c
index 6dce46b..f109f17 100644
--- a/usr/target.c
+++ b/usr/target.c
@@ -611,7 +611,7 @@ tgtadm_err tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
 	lu->blk_shift = 0;
 	if (blocksize) {
 		unsigned int bsize;
-		unsigned int bshift;
+		int bshift;
 
 		dprintf("blocksize=%s\n", blocksize);
 		bsize = strtoul(blocksize, NULL, 0);
-- 
1.8.4.3
