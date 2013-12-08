From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] tgtd: fix segmentation fault in tgt_device_destroy()
Date: Mon,  9 Dec 2013 02:54:44 +0900
Message-ID: <1386525284-27517-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

The tgt_device_destroy function arises segmentation fault if we delete
a target with a force option while an iscsi session exists:

 kernel: tgtd[10094]: segfault at 7fe2511b1b4f ip 0000000000414080
  sp 00007fff9f2df0e0 error 4 in tgtd[400000+33000]
 tgtd: tgtd logger exits abnormally, pid:10095

This fault is reproducible with the following steps:

 server# dog vdi create <vdiname> 10G
 server# tgtadm --lld iscsi --mode target --op new --tid 1 -T <target>
 server# tgtadm --lld iscsi --mode logicalunit --op new --tid 1 --lun 1
  --backing-store unix:/sheepdog/sock:<vdiname> --bstype sheepdog
 server# tgtadm --lld iscsi --mode account --op new --user <user>
  --password <password>
 server# tgtadm --lld iscsi --mode account --op bind --tid 1 --user <user>
 server# tgtadm --lld iscsi --mode target --op bind --tid 1 -I ALL

 client# iscsiadm -m discovery -t sendtargets -p <server ip>
 client# iscsiadm -m node -T <target> --op update --name
  node.session.auth.authmethod --value CHAP
 client# iscsiadm -m node -T <target> --op update --name
  node.session.auth.username --value <user>
 client# iscsiadm -m node -T <target> --op update --name
  node.session.auth.password --value <password>
 client# iscsiadm -m node -T <target> --login

 server# tgtadm --lld iscsi --mode target --op delete --force --tid 1

The backtrace of the fault is as follows:

 # gdb tgtd /core.10094
 Program terminated with signal 11, Segmentation fault.
 #0  0x0000000000414080 in ua_sense_add (itn_lu=0x1288a30, asc=16142)
     at target.c:108
 108    if (itn_lu->lu->attrs.sense_format) {
 (gdb) bt
 #0  0x0000000000414080 in ua_sense_add (itn_lu=0x1288a30, asc=16142)
     at target.c:108
 #1  0x00000000004143d5 in tgt_device_destroy (tid=<value optimized out>,
     lun=<value optimized out>, force=<value optimized out>) at target.c:731
 #2  0x0000000000414554 in tgt_target_destroy (lld_no=0, tid=1, force=1)
     at target.c:2000
 #3  0x0000000000412161 in target_mgmt (mtask=0x1288a70) at mgmt.c:87
 #4  tgt_mgmt (mtask=0x1288a70) at mgmt.c:412
 #5  0x0000000000412777 in mtask_handler (fd=13, events=<value optimized out>,
     data=0x1288a70) at mgmt.c:492
 #6  0x00000000004106a9 in event_loop () at tgtd.c:411
 #7  0x0000000000410d65 in main (argc=<value optimized out>,
     argv=<value optimized out>) at tgtd.c:583

The fault happened because the current tgt_device_destroy function
does not remove nor free it_nexus_lu_info structures associated to the
lun that we are deleting.

Due to the leak, ua_sense_add function accesses to the lun info
(itn_lu->lun) that is already freed.

I here used a sheepdog backing store, but the same issue can happen
for other types of backing store.

This patch fixes the issue by adding missing cleanup code of
it_nexus_lu_info struct to tgt_device_destroy function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/target.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/usr/target.c b/usr/target.c
index 257135d..6968e76 100644
--- a/usr/target.c
+++ b/usr/target.c
@@ -740,6 +740,10 @@ tgtadm_err tgt_device_destroy(int tid, uint64_t lun, int force)
 					 itn_itl_info_siblings) {
 			if (itn_lu->lu == lu) {
 				ua_sense_pending_del(itn_lu);
+
+				list_del(&itn_lu->itn_itl_info_siblings);
+				list_del(&itn_lu->lu_itl_info_siblings);
+				free(itn_lu);
 				break;
 			}
 		}
-- 
1.7.9.3
