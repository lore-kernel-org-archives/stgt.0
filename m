From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: [PATCH 1/2] tgtadm: Correct mode names in the option error message
Date: Sat, 18 Jan 2014 13:27:15 +0800
Message-ID: <52DA10B3.7010309@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        bh=nNU0KH0gKfo+03B56r0Mo5O/rRl6IYwdVp1fo0R+aQA=;
        b=dXFdNRsnEBUFfl8bOCwdtGFG6u1mRohX6lgHh7E43yrXMA3KF2MK264+yJ3H4bFMN0
         Q2hM9ekGie/p+eOJRIfo1hkH/0r+9AfzbBFvtwr86MT27Ej2pi+o+LJVfJwKcLhFIov9
         YD+aH7hqosTv3jynlGyAdvYbJfKXX8wmZgZBT3HJIDeRhs1ls/H3gOG9Qg8XAJEn01Ny
         lNjVJPP42QAN+6kbJk8gm+P0k79pMKNFE8R4aA6VL7NDURVontjDJo5O4wTSK6thN3Ec
         OI+Y0zs/rSLNLG+w4jOHglEgDAcQWrQFXdhS3R3kczklUbzzkw8j1oXC3aWjCGirq6EK
         Uhxw==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

When an error option is specified for some mode and operation,
tgtadm outputs an error message which contains the mode name.
But some of the mode names are obviously wrong so the patch fixes
them.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 usr/tgtadm.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/usr/tgtadm.c b/usr/tgtadm.c
index 7771119..d708a65 100644
--- a/usr/tgtadm.c
+++ b/usr/tgtadm.c
@@ -739,7 +739,7 @@ int main(int argc, char **argv)
 		case OP_NEW:
 			rc = verify_mode_params(argc, argv, "LmoupfC");
 			if (rc) {
-				eprintf("logicalunit mode: option '-%c' is "
+				eprintf("account mode: option '-%c' is "
 					"not allowed/supported\n", rc);
 				exit(EINVAL);
 			}
@@ -752,7 +752,7 @@ int main(int argc, char **argv)
 		case OP_SHOW:
 			rc = verify_mode_params(argc, argv, "LmoC");
 			if (rc) {
-				eprintf("target mode: option '-%c' is not "
+				eprintf("account mode: option '-%c' is not "
 					"allowed/supported\n", rc);
 				exit(EINVAL);
 			}
@@ -760,7 +760,7 @@ int main(int argc, char **argv)
 		case OP_DELETE:
 			rc = verify_mode_params(argc, argv, "LmouC");
 			if (rc) {
-				eprintf("target mode: option '-%c' is not "
+				eprintf("account mode: option '-%c' is not "
 					"allowed/supported\n", rc);
 				exit(EINVAL);
 			}
@@ -768,7 +768,7 @@ int main(int argc, char **argv)
 		case OP_BIND:
 			rc = verify_mode_params(argc, argv, "LmotuOC");
 			if (rc) {
-				eprintf("target mode: option '-%c' is not "
+				eprintf("account mode: option '-%c' is not "
 					"allowed/supported\n", rc);
 				exit(EINVAL);
 			}
@@ -782,7 +782,7 @@ int main(int argc, char **argv)
 		case OP_UNBIND:
 			rc = verify_mode_params(argc, argv, "LmotuOC");
 			if (rc) {
-				eprintf("target mode: option '-%c' is not "
+				eprintf("account mode: option '-%c' is not "
 					"allowed/supported\n", rc);
 				exit(EINVAL);
 			}
@@ -817,7 +817,7 @@ int main(int argc, char **argv)
 		case OP_NEW:
 			rc = verify_mode_params(argc, argv, "LmofytlbEYCS");
 			if (rc) {
-				eprintf("target mode: option '-%c' is not "
+				eprintf("logicalunit mode: option '-%c' is not "
 					  "allowed/supported\n", rc);
 				exit(EINVAL);
 			}
@@ -833,7 +833,7 @@ int main(int argc, char **argv)
 		case OP_STATS:
 			rc = verify_mode_params(argc, argv, "LmotlC");
 			if (rc) {
-				eprintf("target mode: option '-%c' is not "
+				eprintf("logicalunit mode: option '-%c' is not "
 					  "allowed/supported\n", rc);
 				exit(EINVAL);
 			}
@@ -905,7 +905,7 @@ int main(int argc, char **argv)
 		case OP_SHOW:
 			rc = verify_mode_params(argc, argv, "LmoC");
 			if (rc) {
-				eprintf("system mode: option '-%c' is not "
+				eprintf("lld mode: option '-%c' is not "
 					"allowed/supported\n", rc);
 				exit(EINVAL);
 			}
-- 
1.7.1
