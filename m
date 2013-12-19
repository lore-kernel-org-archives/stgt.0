From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: add missing initialization of read data length
Date: Thu, 19 Dec 2013 14:46:58 +0900
Message-ID: <1387432018-746-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

In the sheepdog driver, the read data length argument of do_req
function is not initialized by some caller functions such as
sd_sync(), sd_close(), and create_branch().

This patch adds those missing initializations to prevent uncertain
behavior in do_req() and fixes the following warning of valgrind:

 ==1885== Conditional jump or move depends on uninitialised value(s)
 ==1885==    at 0x425994: do_req (bs_sheepdog.c:598)
 ==1885==    by 0x426A06: bs_sheepdog_close (bs_sheepdog.c:1100)
 ==1885==    by 0x4142B4: tgt_device_destroy (target.c:705)
 ==1885==    by 0x412335: tgt_mgmt (mgmt.c:222)
 ==1885==    by 0x412776: mtask_handler (mgmt.c:494)
 ==1885==    by 0x4106A8: event_loop (tgtd.c:411)
 ==1885==    by 0x410D64: main (tgtd.c:583)

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 07ad0de..f11b693 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -708,7 +708,7 @@ static int sd_sync(struct sheepdog_access_info *ai)
 	int ret;
 	struct sheepdog_obj_req hdr;
 	struct sheepdog_obj_rsp *rsp = (struct sheepdog_obj_rsp *)&hdr;
-	unsigned int wlen = 0, rlen;
+	unsigned int wlen = 0, rlen = 0;
 
 	memset(&hdr, 0, sizeof(hdr));
 
@@ -1087,7 +1087,7 @@ static void sd_close(struct sheepdog_access_info *ai)
 {
 	struct sheepdog_vdi_req hdr;
 	struct sheepdog_vdi_rsp *rsp = (struct sheepdog_vdi_rsp *)&hdr;
-	unsigned int wlen = 0, rlen;
+	unsigned int wlen = 0, rlen = 0;
 	int ret;
 
 	memset(&hdr, 0, sizeof(hdr));
@@ -1120,6 +1120,7 @@ static int create_branch(struct sheepdog_access_info *ai)
 	hdr.vdi_id = ai->inode.vdi_id;
 	hdr.flags = SD_FLAG_CMD_WRITE;
 	wlen = SD_MAX_VDI_LEN;
+	rlen = 0;
 	hdr.data_length = wlen;
 
 	ret = do_req(ai, (struct sheepdog_req *)&hdr, ai->inode.name,
@@ -1135,6 +1136,7 @@ static int create_branch(struct sheepdog_access_info *ai)
 
 	hdr.flags = SD_FLAG_CMD_WRITE;
 	wlen = SD_MAX_VDI_LEN;
+	rlen = 0;
 	hdr.data_length = wlen;
 	hdr.vdi_size = ai->inode.vdi_size;
 	ret = do_req(ai, (struct sheepdog_req *)&hdr, ai->inode.name,
-- 
1.7.9.3
