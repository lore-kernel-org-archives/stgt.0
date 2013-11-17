From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Add an array that describes which opcodes are supported by the RDWR and SHEEPDOG backends.
Date: Sat, 16 Nov 2013 17:18:26 -0800
Message-ID: <1384651106-18407-2-git-send-email-ronniesahlberg@gmail.com>
References: <1384651106-18407-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N9BmD8n/Tg6KSOnMwp/kONrsQBLRsTqsFwOk4vi8sQQ=;
        b=vUXIZOlZmuJjTPD7+cZ7UhCIrSokxFuF4CP63USw1fHKM0kIH+aY5ClUB12uJRyBko
         FAXyY2ybGJm2LR06NvDs9EYaDHKzavaNxV6vyJuAWEvOT/mEWzfY/yfmFMp4aixkwhN/
         9ZgxfL/e/0snQtRHbTuJx3w4+OIFYRwEQcqcJWRyw0/uL6IY3zWulYJAudVUAh6FWFOn
         mrbkMI5Fx7v8J88A+sGvuQxGWCghdlGTf73LU+nUBKasldE7flMOsMci/SHxri2a2poH
         Gi1uy2j9gUTkbNc3uFL02I7LHa+xVzOc6HxzlAT3Kc2+6NZ/jbQKtG/2PSEyD10YMrKq
         1viQ==
In-Reply-To: <1384651106-18407-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

While RDWR supports all SBC opcodes that TGTD implement SHEEPDOG
only supports a subset and lacks the following opcodes:
            WRITE_VERIFY10/12/16 VERIFY10/12/16 PREFETCH10/16
            WRITE_SAME10/16 UNMAP and ORWRITE

This allows backends to specify which opcodes it is prepared to process
and which commands should fail with invalid op code
and allows SHEEPDOG backed LUNs to respond with INVALID_OP_CODE
correctly.

This is most useful for block devices where we have several different backends
and where some backends only support a subset of the commands

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/bs.c          |    8 ++++++++
 usr/bs_rdwr.c     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 usr/bs_sheepdog.c |   38 ++++++++++++++++++++++++++++++++++++++
 usr/scsi.c        |    6 ++++++
 usr/tgtd.h        |    1 +
 5 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/usr/bs.c b/usr/bs.c
index 636f53b..a6a5852 100644
--- a/usr/bs.c
+++ b/usr/bs.c
@@ -463,3 +463,11 @@ int bs_thread_cmd_submit(struct scsi_cmd *cmd)
 
 	return 0;
 }
+
+void bs_create_opcode_map(unsigned char *map, unsigned char *opcodes, int num)
+{
+	int i;
+
+	for (i = 0; i < num; i++)
+		map[opcodes[i] >> 3] |= 1 << (opcodes[i] % 8);
+}
diff --git a/usr/bs_rdwr.c b/usr/bs_rdwr.c
index ff009eb..01a710e 100644
--- a/usr/bs_rdwr.c
+++ b/usr/bs_rdwr.c
@@ -412,6 +412,8 @@ static void bs_rdwr_exit(struct scsi_lu *lu)
 	bs_thread_close(info);
 }
 
+static char bs_ops_supported[32];
+
 static struct backingstore_template rdwr_bst = {
 	.bs_name		= "rdwr",
 	.bs_datasize		= sizeof(struct bs_thread_info),
@@ -421,9 +423,58 @@ static struct backingstore_template rdwr_bst = {
 	.bs_exit		= bs_rdwr_exit,
 	.bs_cmd_submit		= bs_thread_cmd_submit,
 	.bs_oflags_supported    = O_SYNC | O_DIRECT,
+	.bs_ops_supported	= bs_ops_supported,
 };
 
 __attribute__((constructor)) static void bs_rdwr_constructor(void)
 {
+	static char opcodes[] = {
+		ALLOW_MEDIUM_REMOVAL,
+		COMPARE_AND_WRITE,
+		FORMAT_UNIT,
+		INQUIRY,
+		MAINT_PROTOCOL_IN,
+		MODE_SELECT,
+		MODE_SELECT_10,
+		MODE_SENSE,
+		MODE_SENSE_10,
+		ORWRITE_16,
+		PERSISTENT_RESERVE_IN,
+		PERSISTENT_RESERVE_OUT,
+		PRE_FETCH_10,
+		PRE_FETCH_16,
+		READ_10,
+		READ_12,
+		READ_16,
+		READ_6,
+		READ_CAPACITY,
+		RELEASE,
+		REPORT_LUNS,
+		REQUEST_SENSE,
+		RESERVE,
+		SEND_DIAGNOSTIC,
+		SERVICE_ACTION_IN,
+		START_STOP,
+		SYNCHRONIZE_CACHE,
+		SYNCHRONIZE_CACHE_16,
+		TEST_UNIT_READY,
+		UNMAP,
+		VERIFY_10,
+		VERIFY_12,
+		VERIFY_16,
+		WRITE_10,
+		WRITE_12,
+		WRITE_16,
+		WRITE_6,
+		WRITE_SAME,
+		WRITE_SAME_16,
+		WRITE_VERIFY,
+		WRITE_VERIFY_12,
+		WRITE_VERIFY_16
+	};
+
+	bs_create_opcode_map(bs_ops_supported, &opcodes[0],
+		sizeof(opcodes) / sizeof(opcodes[0]));
+
 	register_backingstore_template(&rdwr_bst);
 }
diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 1dda915..2d2b8a1 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -1283,6 +1283,8 @@ static void bs_sheepdog_exit(struct scsi_lu *lu)
 	dprintf("cleaned logical unit %p safely\n", lu);
 }
 
+static char bs_ops_supported[32];
+
 static struct backingstore_template sheepdog_bst = {
 	.bs_name		= "sheepdog",
 	.bs_datasize		=
@@ -1292,9 +1294,45 @@ static struct backingstore_template sheepdog_bst = {
 	.bs_init		= bs_sheepdog_init,
 	.bs_exit		= bs_sheepdog_exit,
 	.bs_cmd_submit		= bs_thread_cmd_submit,
+	.bs_ops_supported	= bs_ops_supported,
 };
 
 __attribute__((constructor)) static void __constructor(void)
 {
+	static char opcodes[] = {
+		ALLOW_MEDIUM_REMOVAL,
+		FORMAT_UNIT,
+		INQUIRY,
+		MAINT_PROTOCOL_IN,
+		MODE_SELECT,
+		MODE_SELECT_10,
+		MODE_SENSE,
+		MODE_SENSE_10,
+		PERSISTENT_RESERVE_IN,
+		PERSISTENT_RESERVE_OUT,
+		READ_10,
+		READ_12,
+		READ_16,
+		READ_6,
+		READ_CAPACITY,
+		RELEASE,
+		REPORT_LUNS,
+		REQUEST_SENSE,
+		RESERVE,
+		SEND_DIAGNOSTIC,
+		SERVICE_ACTION_IN,
+		START_STOP,
+		SYNCHRONIZE_CACHE,
+		SYNCHRONIZE_CACHE_16,
+		TEST_UNIT_READY,
+		WRITE_10,
+		WRITE_12,
+		WRITE_16,
+		WRITE_6
+	};
+
+	bs_create_opcode_map(bs_ops_supported, &opcodes[0],
+		sizeof(opcodes) / sizeof(opcodes[0]));
+
 	register_backingstore_template(&sheepdog_bst);
 }
diff --git a/usr/scsi.c b/usr/scsi.c
index 2636a5c..14c7c33 100644
--- a/usr/scsi.c
+++ b/usr/scsi.c
@@ -492,6 +492,12 @@ int scsi_cmd_perform(int host_no, struct scsi_cmd *cmd)
 	if (spc_access_check(cmd))
 		return SAM_STAT_RESERVATION_CONFLICT;
 
+	if (cmd->dev->bst->bs_ops_supported
+	&& !(cmd->dev->bst->bs_ops_supported[op >> 3] & (1 << (op % 8)))) {
+		sense_data_build(cmd, ILLEGAL_REQUEST, ASC_INVALID_OP_CODE);
+		return SAM_STAT_CHECK_CONDITION;
+	}
+
 	return cmd->dev->dev_type_template.ops[op].cmd_perform(host_no, cmd);
 }
 
diff --git a/usr/tgtd.h b/usr/tgtd.h
index b0528b4..568da01 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -165,6 +165,7 @@ struct backingstore_template {
 	void (*bs_exit)(struct scsi_lu *dev);
 	int (*bs_cmd_submit)(struct scsi_cmd *cmd);
 	int bs_oflags_supported;
+	const char *bs_ops_supported;
 
 	struct list_head backingstore_siblings;
 };
-- 
1.7.3.1
