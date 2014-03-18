From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] iscsi: fix segfault at iscsi_scsi_cmd_done()
Date: Tue, 18 Mar 2014 12:27:24 +0900
Message-ID: <1395113244-20488-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

When enabling ping-nop of iscsi by setting valid values to
nop_interval and nop_count parameters, tgtd crashed with the following
segmentation fault at iscsi_scsi_cmd_done() function:

 Program terminated with signal 11, Segmentation fault.
 #0  __list_add (nid=<value optimized out>, result=<value optimized out>,
     scmd=0x980f20) at ./list.h:67
 67              prev->next = new;
 (gdb) bt
 #0  __list_add (nid=<value optimized out>, result=<value optimized out>,
     scmd=0x980f20) at ./list.h:67
 #1  list_add_tail (nid=<value optimized out>, result=<value optimized out>,
     scmd=0x980f20) at ./list.h:77
 #2  iscsi_scsi_cmd_done (nid=<value optimized out>,
     result=<value optimized out>, scmd=0x980f20) at iscsi/iscsid.c:1270
 #3  0x000000000042b69d in bs_sig_request_done (fd=<value optimized out>,
     events=<value optimized out>, data=<value optimized out>) at bs.c:212
 #4  0x0000000000414231 in event_loop () at tgtd.c:432
 #5  0x000000000041490a in main (argc=<value optimized out>,
     argv=<value optimized out>) at tgtd.c:620

This segfault is caused by forcible destruction of tcp connection
using iscsi_tcp_release() within iscsi_tcp_nop_work_handler().

This patch fixes it by closing connection cleanly there with
conn_close() function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/iscsi/iscsi_tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/iscsi/iscsi_tcp.c b/usr/iscsi/iscsi_tcp.c
index 4a9532a..4cc2cf4 100644
--- a/usr/iscsi/iscsi_tcp.c
+++ b/usr/iscsi/iscsi_tcp.c
@@ -108,7 +108,7 @@ static void iscsi_tcp_nop_work_handler(void *data)
 		if (tcp_conn->nop_inflight_count > tcp_conn->nop_count) {
 			eprintf("tcp connection timed out after %d failed " \
 				"NOP-OUT\n", tcp_conn->nop_count);
-			iscsi_tcp_release(&tcp_conn->iscsi_conn);
+			conn_close(&tcp_conn->iscsi_conn);
 			/* cant/shouldnt delete tcp_conn from within the loop */
 			break;
 		}
-- 
1.7.9.3
