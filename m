From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] util.h: correct range check of str_to_int_gt() and str_to_int_lt()
Date: Tue, 10 Dec 2013 13:49:47 +0900
Message-ID: <1386650987-15110-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

The range checks of str_to_int_gt() and str_to_int_lt() are not
implemented literally.  The current definitions fail to reject a
marginal value.

Due to this difference, tgtd accepts option "-t 0" without an error,
which overrides nr_iothreads to 0 and causes clients to hang.

This corrects str_to_int_gt()/str_to_int_lt() and prevents the issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/util.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/util.h b/usr/util.h
index 08a6dd3..0e34c35 100644
--- a/usr/util.h
+++ b/usr/util.h
@@ -159,7 +159,7 @@ struct signalfd_siginfo {
 #define str_to_int_gt(str, val, minv)   		\
 ({      						\
 	int ret = str_to_int(str, val); 		\
-	if (!ret && (val < minv))       		\
+	if (!ret && (val <= minv))       		\
 		ret = ERANGE;   			\
 	ret;						\
 })
@@ -177,7 +177,7 @@ struct signalfd_siginfo {
 #define str_to_int_lt(str, val, maxv)   		\
 ({      						\
 	int ret = str_to_int(str, val); 		\
-	if (!ret && (val > maxv))       		\
+	if (!ret && (val >= maxv))       		\
 		ret = ERANGE;				\
 	ret;						\
 })
-- 
1.7.9.3
