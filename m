From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] tgtd: oom_adjust don't fail on EACCES error
Date: Mon, 01 Feb 2016 21:41:20 +0900 (JST)
Message-ID: <20160201.214120.2110776701550322638.tomof@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Applied the following

==
From ef7972ec782a5ee46608bdbfb821a35ad970d5e3 Mon Sep 17 00:00:00 2001
From: Ryan Harper <ryan.harper@canonical.com>
Date: Mon, 1 Feb 2016 02:02:17 -0600
Subject: [PATCH] tgtd: oom_adjust don't fail on EACCES error

When running root-under-userns, don't error out when
attempting to modify oom_score_adj.

Signed-off-by: Ryan Harper <ryan.harper@canonical.com>
---
 usr/tgtd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/tgtd.c b/usr/tgtd.c
index 65bc888..19c703d 100644
--- a/usr/tgtd.c
+++ b/usr/tgtd.c
@@ -604,7 +604,7 @@ int main(int argc, char **argv)
 	}
 
 	err = oom_adjust();
-	if (err && getuid() == 0)
+	if (err && (errno != EACCES) && getuid() == 0)
 		exit(1);
 
 	err = nr_file_adjust();
-- 
2.1.4
