From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: add missing initialization of request header
Date: Thu, 19 Dec 2013 20:16:17 +0900
Message-ID: <1387451777-25196-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

The create_branch function of the sheepdog driver sends a partially
uninitialized request to sheepdog.  This fixes the defect.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index f11b693..59b2d25 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -1116,6 +1116,7 @@ static int create_branch(struct sheepdog_access_info *ai)
 	unsigned int wlen = 0, rlen;
 	int ret;
 
+	memset(&hdr, 0, sizeof(hdr));
 	hdr.opcode = SD_OP_DEL_VDI;
 	hdr.vdi_id = ai->inode.vdi_id;
 	hdr.flags = SD_FLAG_CMD_WRITE;
-- 
1.7.9.3
