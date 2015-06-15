From: Alberto Murillo <alberto.murillo.silva@intel.com>
Subject: [PATCH] Correct the location of checkarch.sh in Makefile
Date: Mon, 15 Jun 2015 14:24:22 -0500
Message-ID: <1434396262-2425-1-git-send-email-alberto.murillo.silva@intel.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Cc: Alberto Murillo <alberto.murillo.silva@intel.com>

Fix the commit d2a186088d1b4a6fa2f05cccf5a40f9720a09bf1

Signed-off-by: Alberto Murillo <alberto.murillo.silva@intel.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 4c4f0fb..fe2eab3 100644
--- a/Makefile
+++ b/Makefile
@@ -82,7 +82,7 @@ clean-pkg:
 clean: clean-programs clean-doc clean-conf clean-scripts clean-pkg
 
 .PHONY:check
-check: ARCH=$(shell sh script/checkarch.sh)
+check: ARCH=$(shell sh scripts/checkarch.sh)
 check:
 	CC=$(CHECK_CC_FLAGS) $(MAKE) all
 
-- 
2.3.2 (Apple Git-55)
