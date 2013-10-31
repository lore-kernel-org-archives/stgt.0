From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: fix memory leak issues in sd_open()
Date: Thu, 31 Oct 2013 17:36:34 +0900
Message-ID: <1383208594-639-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, sheepdog@lists.wpkg.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This fixes memory leak issues in sd_open function which were brought
by the patch titled "bs_sheepdog.c: support various VDI options in
--backing-store option" (commit:
f282f83c036e298f316ef64d1e51aff3f57b9eaf).

The current sd_open function doesn't free locally allocated string
"orig_filename" nor restores "filename" argument temporarily broken
for parsing VDI options when unknown protocol was specified or tcp
port number was malformed.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 8bb5c80..7341708 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -962,7 +962,8 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 			} else {
 				eprintf("unknown protocol of sheepdog vdi:"\
 					" %s\n", result);
-				return -1;
+				ret = -1;
+				goto out;
 			}
 			break;
 		case EXPECT_PATH:
@@ -979,7 +980,8 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 				if (!isdigit(result[i])) {
 					eprintf("invalid tcp port number:"\
 						" %s\n", result);
-					return -1;
+					ret = -1;
+					goto out;
 				}
 			}
 
-- 
1.7.9.3
