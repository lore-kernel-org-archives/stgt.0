From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH] sheepdog: fine grained locking in write path
Date: Tue, 21 Apr 2015 18:33:53 +0900
Message-ID: <1429608833-11636-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Yv/lek2n6zF3JL4EzHkFPX3s7iPuqJKOGilpXG6iAP0=;
        b=d7AuiEg7ReU+tY09qIRpqEXyO0c2dlrxAwsEXnK+6VaSUnIM4QAa9MJt5KmCZ0x4D6
         989x1O0z9zTEI4t/8gTDk+Ha4fl0Pm3RWI9yfzDkwhic9e0zzBuTakt+vM0JudkAj2F7
         c18zG/NSRhVMV1UwEm07xh4AWUmwcULvPJSBksK9fSoaNZme2bAYGM3vTvgXhuD/Mxsc
         JIw9t34kS4DGY31lMDXb7Jfizgnrc8oBFVM0JqpxuUNXpDYwi+9hVrzohg7/0IpnmY2q
         dJKQeGcw4AHZV0JCzn1IIT4dLbNst5Tcxhq0ozlqNhvC4UX+vrhaTCd4tSvuDnFzRMPG
         P2fA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Current sheepdog driver has a big write lock section. It harms write
performance significantly. This patch removes a needless big write
lock section with checking submitted requests can cause COW or
not. The write performance can be improved significantly.

In a case of 4k rand write by fio:
 - before: 1144 IOPS
 - after:  19074 IOPS

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 0838009..9b5b259 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -876,6 +876,7 @@ static int sd_io(struct sheepdog_access_info *ai, int write, char *buf, int len,
 	uint16_t flags = 0;
 	int need_update_inode = 0, need_reload_inode;
 	int nr_copies = ai->inode.nr_copies;
+	int need_write_lock, check_idx;
 
 	goto do_req;
 
@@ -891,7 +892,18 @@ reload_in_read_path:
 	pthread_rwlock_unlock(&ai->inode_lock);
 
 do_req:
-	if (write)
+	need_write_lock = 0;
+	vid = ai->inode.vdi_id;
+
+	for (check_idx = idx; check_idx < max; check_idx++) {
+		if (ai->inode.data_vdi_id[check_idx] == vid)
+			continue;
+
+		need_write_lock = 1;
+		break;
+	}
+
+	if (need_write_lock)
 		pthread_rwlock_wrlock(&ai->inode_lock);
 	else
 		pthread_rwlock_rdlock(&ai->inode_lock);
-- 
1.9.1
