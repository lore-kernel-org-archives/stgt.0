From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: fix io errors during writing to a snapshot
Date: Tue,  7 Jan 2014 21:59:31 +0900
Message-ID: <1389099571-10567-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

The sheepdog driver fails with io errors when write access is
requested for a snapshot vdi.  The failure happens in create_branch
function:

 tgtd: read_write_object(684) No object found (oid: 8000000
 000000000, old_oid: 0)
 tgtd: create_branch(1160) reloading new inode object failed
 tgtd: bs_sheepdog_request(1197) creating writable VDI from
 snapshot failed

 sd 12:0:0:1: [sdb] Unhandled sense code
 sd 12:0:0:1: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
 sd 12:0:0:1: [sdb] Sense Key : Medium Error [current]
 sd 12:0:0:1: [sdb] Add. Sense: Unrecovered read error
 sd 12:0:0:1: [sdb] CDB: Write(10): 2a 00 00 00 20 a8 00 00 08 00
 Buffer I/O error on device sdb1, logical block 1041
 lost page write due to I/O error on sdb1

This turned out to be caused by a race condition among multiple write
requests.  When bs_sheepdog_request() receives a write request for the
snapshot vdi, it tries to change the snapshot to a writable vdi with
the create_branch function.  However, the current implementation of
create_branch() cannot handle concurrent requests exclusively nor
protected from regular io routine (sd_io).

This fixes the above io-error issue by serializing create_branch()
with a pthread reader/writer lock, and also fixes the race condition
between create_branch() and sd_io() with the lock.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 59b2d25..6d60bd6 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -1116,6 +1116,16 @@ static int create_branch(struct sheepdog_access_info *ai)
 	unsigned int wlen = 0, rlen;
 	int ret;
 
+	ret = pthread_rwlock_wrlock(&ai->inode_lock);
+	if (ret) {
+		eprintf("failed to get inode lock %s\n", strerror(ret));
+		return -1;
+	}
+
+	if (!ai->is_snapshot)
+		/* check again the snapshot flag to avoid race condition */
+		goto out;
+
 	memset(&hdr, 0, sizeof(hdr));
 	hdr.opcode = SD_OP_DEL_VDI;
 	hdr.vdi_id = ai->inode.vdi_id;
@@ -1128,7 +1138,7 @@ static int create_branch(struct sheepdog_access_info *ai)
 		     &wlen, &rlen);
 	if (ret) {
 		eprintf("deleting snapshot VDI for creating branch failed\n");
-		return -1;
+		goto out;
 	}
 
 	memset(&hdr, 0, sizeof(hdr));
@@ -1144,19 +1154,22 @@ static int create_branch(struct sheepdog_access_info *ai)
 		     &wlen, &rlen);
 	if (ret) {
 		eprintf("creating new VDI for creating branch failed\n");
-		return -1;
+		goto out;
 	}
 
 	ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(rsp->vdi_id),
 			  ai->inode.nr_copies, SD_INODE_SIZE, 0);
 	if (ret) {
 		eprintf("reloading new inode object failed");
-		return -1;
+		goto out;
 	}
 
+	ai->is_snapshot = 0;
 	dprintf("creating branch from snapshot, new VDI ID: %x\n", rsp->vdi_id);
+out:
+	pthread_rwlock_unlock(&ai->inode_lock);
 
-	return 0;
+	return ret;
 }
 
 static void bs_sheepdog_request(struct scsi_cmd *cmd)
@@ -1190,7 +1203,6 @@ static void bs_sheepdog_request(struct scsi_cmd *cmd)
 
 				break;
 			}
-			ai->is_snapshot = 0;
 		}
 
 		length = scsi_get_out_length(cmd);
-- 
1.7.9.3
