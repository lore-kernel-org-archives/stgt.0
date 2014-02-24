From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] tgtd: fix internal error of __inaccount_bind()
Date: Mon, 24 Feb 2014 15:43:26 +0900
Message-ID: <1393224206-21585-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

When trying to bind 32 accounts to the same target, tgtadm outputs
"unknown error" and exits returing status code 22 (EINVAL).

This is because __inaccount_bind() function of tgtd does not increment
target->account.nr_inaccount when it doubles maximum number of
accounts for the target, and therefore it tries to allocate an aid
slot on target->account.in_aids[] array even though no free aid slot
is available there.

This fixes the bug.

Reported-by: Satoshi Yoshida <yoshida.satoshi@po.ntts.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/target.c b/usr/target.c
index f4c5b4e..b6f324c 100644
--- a/usr/target.c
+++ b/usr/target.c
@@ -1581,7 +1581,6 @@ static tgtadm_err __inaccount_bind(struct target *target, int aid)
 		}
 
 		target->account.in_aids[i] = aid;
-		target->account.nr_inaccount++;
 	} else {
 		int new_max = target->account.max_inaccount << 1;
 		int *buf;
@@ -1597,6 +1596,7 @@ static tgtadm_err __inaccount_bind(struct target *target, int aid)
 		target->account.in_aids[target->account.max_inaccount] = aid;
 		target->account.max_inaccount = new_max;
 	}
+	target->account.nr_inaccount++;
 
 	return TGTADM_SUCCESS;
 }
-- 
1.7.9.3
