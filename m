From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] use NR_SCSI_OPCODES definition
Date: Mon, 25 Nov 2013 08:16:40 +0900
Message-ID: <20131125074847U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 usr/spc.c  |    2 +-
 usr/tgtd.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/spc.c b/usr/spc.c
index 9faa705..29f39a9 100644
--- a/usr/spc.c
+++ b/usr/spc.c
@@ -735,7 +735,7 @@ static int report_opcodes_all(struct scsi_cmd *cmd, int rctd,
 	data = &buf[4];
 
 	ops = cmd->dev->dev_type_template.ops;
-	for (i = 0; i < 256; i++) {
+	for (i = 0; i < NR_SCSI_OPCODES; i++) {
 		if (ops[i].cmd_perform == spc_illegal_op)
 			continue;
 
diff --git a/usr/tgtd.h b/usr/tgtd.h
index 850a110..8a25521 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -153,7 +153,7 @@ struct device_type_template {
 	tgtadm_err (*lu_offline)(struct scsi_lu *lu);
 	int (*cmd_passthrough)(int, struct scsi_cmd *);
 
-	struct device_type_operations ops[256];
+	struct device_type_operations ops[NR_SCSI_OPCODES];
 
 	struct list_head device_type_siblings;
 };
-- 
1.7.2.5
