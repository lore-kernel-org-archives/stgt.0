From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] tgt-setup-lun: fix error when blocksize not given
Date: Tue, 26 Jul 2016 13:49:25 +0300
Message-ID: <1469530165-16220-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

A prev commit added option for blocksize but intorudced a bug
when user didn't provide a value.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 scripts/tgt-setup-lun | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/tgt-setup-lun b/scripts/tgt-setup-lun
index f875b40..8983f10 100755
--- a/scripts/tgt-setup-lun
+++ b/scripts/tgt-setup-lun
@@ -281,7 +281,10 @@ if [ $bs_type ]; then
 	echo "Setting backing store type: $bs_type"
 	bs_opt="-E $bs_type"
 fi
-$TGTADM --lld $lld_name --op new --mode logicalunit --tid $tid --lun $lun --blocksize $block_size -b $dev $bs_opt
+if [ $block_size ]; then
+	blksize_opt="--blocksize $block_size"
+fi
+$TGTADM --lld $lld_name --op new --mode logicalunit --tid $tid --lun $lun -b $dev $bs_opt $blksize_opt
 res=$?
 
 if [ $res -ne 0 ]; then
-- 
1.8.4.3
