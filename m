From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: [PATCH 2/2] tgtadm: display unsupported operation name explicitly
Date: Sat, 18 Jan 2014 13:28:38 +0800
Message-ID: <52DA1106.5050008@gmail.com>
References: <52DA10B3.7010309@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=gh/tfhOae9yJQk08P70r0xT0hPDmoJU9UpET5F2IUMg=;
        b=LcaOXBRid/zQBDoj4Ipxw0IBS2T0qaHXup+C5O7K4q8uVrnx2eD9O7puyVCCRWg6L+
         bnezwmgCD+NHruyw1qUKr4XtoGUU3SDDkXCbMztAzdp+YDhxYSnlzi2hwb8EJv/LraI0
         WvdXTjhxuO9psxzY8xr7fyK1tAglePpYl0TrK/Z+ZYAihrR2pk8vsKjTRm3p0vYMhi77
         txLntCC4musEvH0rqYpypDstiYzhuCgcFalHtjQTF+JCB51pLKSndmZCs5ZZA3Z907a/
         s7O7UhBcd8X31zuDLrtegt79wre6SMH8wIYPnTItcqnvyT9NPrX0smdrTDc5WbWTNmPx
         OY8A==
In-Reply-To: <52DA10B3.7010309@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

When we specify an unsupported operation type for some mode,
tgtadm will display the error message which contains the
unsupported operation type value. The patch changes to
display the operation name which is more explicit. Also
change the word 'option' to 'operation'.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 usr/tgtadm.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/usr/tgtadm.c b/usr/tgtadm.c
index d708a65..cc63fbf 100644
--- a/usr/tgtadm.c
+++ b/usr/tgtadm.c
@@ -493,6 +493,7 @@ int main(int argc, char **argv)
 	char *user, *password;
 	struct tgtadm_req adm_req = {0}, *req = &adm_req;
 	struct concat_buf b;
+	char *op_name;
 
 	op = tid = mode = -1;
 	cid = hostno = sid = 0;
@@ -503,7 +504,7 @@ int main(int argc, char **argv)
 	ac_dir = ACCOUNT_TYPE_INCOMING;
 	name = value = path = targetname = address = iqnname = NULL;
 	targetOps = portalOps = bstype = bsopts = NULL;
-	bsoflags = blocksize = user = password = NULL;
+	bsoflags = blocksize = user = password = op_name = NULL;
 	force = 0;
 
 	optind = 1;
@@ -516,6 +517,7 @@ int main(int argc, char **argv)
 			break;
 		case 'o':
 			op = str_to_op(optarg);
+			op_name = optarg;
 			break;
 		case 'm':
 			mode = str_to_mode(optarg);
@@ -653,7 +655,8 @@ int main(int argc, char **argv)
 		case OP_STATS:
 			break;
 		default:
-			eprintf("option %d not supported in system mode\n", op);
+			eprintf("operation %s not supported in system mode\n",
+				op_name);
 			exit(EINVAL);
 			break;
 		}
@@ -709,8 +712,8 @@ int main(int argc, char **argv)
 			}
 			if (!address && !iqnname && !hostno) {
 				eprintf("%s operation requires"
-					" initiator-address, initiator-name or bus\n",
-					op == OP_BIND ? "bind" : "unbind");
+					" initiator-address, initiator-name"
+					"or bus\n", op_name);
 				exit(EINVAL);
 			}
 			break;
@@ -728,7 +731,8 @@ int main(int argc, char **argv)
 			}
 			break;
 		default:
-			eprintf("option %d not supported in target mode\n", op);
+			eprintf("operation %s not supported in target mode\n",
+				op_name);
 			exit(EINVAL);
 			break;
 		}
@@ -794,8 +798,8 @@ int main(int argc, char **argv)
 				tid = GLOBAL_TID;
 			break;
 		default:
-			eprintf("option %d not supported in account mode\n",
-				op);
+			eprintf("operation %s not supported in account mode\n",
+				op_name);
 			exit(EINVAL);
 			break;
 		}
@@ -847,8 +851,8 @@ int main(int argc, char **argv)
 			}
 			break;
 		default:
-			eprintf("option %d not supported in "
-				"logicalunit mode\n", op);
+			eprintf("operation %s not supported in "
+				"logicalunit mode\n", op_name);
 			exit(EINVAL);
 			break;
 		}
@@ -891,8 +895,8 @@ int main(int argc, char **argv)
 			}
 			break;
 		default:
-			eprintf("option %d not supported in "
-					"portal mode\n", op);
+			eprintf("operation %s not supported in portal mode\n",
+				op_name);
 			exit(EINVAL);
 			break;
 		}
-- 
1.7.1
