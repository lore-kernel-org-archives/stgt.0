From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: fix gcc warning at sd_open()
Date: Fri, 29 Nov 2013 00:28:06 +0900
Message-ID: <1385652486-7498-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This fixes the following warning at sd_open function, which happens
because gcc isn't always perfect with determining whether a variable
is used uninitialized:

cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2
-fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC DTGT_VERSION=\"\"
--DBSDIR=\"/lib/tgt/backing-store\" bs_sheepdog.c o bs_sheepdog.o
bs_sheepdog.c: In function 'sd_open':
bs_sheepdog.c:920: warning: 'saveptr' may be used uninitialized in
this function

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index d3572db..9848e9f 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -917,7 +917,7 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 	uint32_t snapid = -1;
 	char tag[SD_MAX_VDI_TAG_LEN + 1];
 	char vdi_name[SD_MAX_VDI_LEN + 1];
-	char *saveptr, *result;
+	char *saveptr = NULL, *result;
 	enum {
 		EXPECT_PROTO,
 		EXPECT_PATH,
-- 
1.7.9.3
