From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Add an array that describes which opcodes are
 supported by the RDWR and SHEEPDOG backends.
Date: Mon, 25 Nov 2013 06:06:23 +0900
Message-ID: <20131125053843U.fujita.tomonori@lab.ntt.co.jp>
References: <1384651106-18407-2-git-send-email-ronniesahlberg@gmail.com>
	<20131117215706K.fujita.tomonori@lab.ntt.co.jp>
	<CAN05THR59d2Bx-sg43n4kbwQgtVYO8xoGYhm_NU2f-=3Qa8ewQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAN05THR59d2Bx-sg43n4kbwQgtVYO8xoGYhm_NU2f-=3Qa8ewQ@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org

On Sun, 24 Nov 2013 08:39:05 -0800
ronnie sahlberg <ronniesahlberg@gmail.com> wrote:

> This looks like it is working in my tests.

Applied the following, thanks!

=
From b747c18406b1adb688cac6e92611b82ca9baa980 Mon Sep 17 00:00:00 2001
From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Date: Mon, 25 Nov 2013 05:36:52 +0900
Subject: [PATCH] Add an array that describes which opcodes are supported

While RDWR supports all SBC opcodes that TGTD implement SHEEPDOG
only supports a subset and lacks the following opcodes:
            WRITE_VERIFY10/12/16 VERIFY10/12/16 PREFETCH10/16
            WRITE_SAME10/16 UNMAP and ORWRITE

This allows backends to specify which opcodes it is prepared to
process and which commands should fail with invalid op code and allows
SHEEPDOG backed LUNs to respond with INVALID_OP_CODE correctly.

This is most useful for block devices where we have several different
backends and where some backends only support a subset of the commands

Changed by FUJITA Tomonori:

- use ARRAY_SIZE()
- use Linux bitmap functions
- put the supported ops array into struct backingstore_template

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 usr/bs.c          |   24 ++++++++++++++++++++++++
 usr/bs_rdwr.c     |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 usr/bs_sheepdog.c |   34 ++++++++++++++++++++++++++++++++++
 usr/scsi.c        |    5 +++++
 usr/tgtd.h        |    6 ++++++
 usr/util.h        |   22 +++++++++++++++++++++-
 6 files changed, 137 insertions(+), 1 deletions(-)

diff --git a/usr/bs.c b/usr/bs.c
index 636f53b..b0ee66f 100644
--- a/usr/bs.c
+++ b/usr/bs.c
@@ -45,6 +45,7 @@
 #include "tgtadm_error.h"
 #include "util.h"
 #include "bs_thread.h"
+#include "scsi.h"
 
 LIST_HEAD(bst_list);
 
@@ -63,6 +64,28 @@ static pthread_t ack_thread;
 static LIST_HEAD(ack_list);
 static pthread_cond_t finished_cond;
 
+
+void bs_create_opcode_map(struct backingstore_template *bst,
+			  unsigned char *opcodes, int num)
+{
+	int i;
+
+	for (i = 0; i < num; i++)
+		set_bit(opcodes[i], bst->bs_supported_ops);
+}
+
+int is_bs_support_opcode(struct backingstore_template *bst, int op)
+{
+	/*
+	 * assumes that this bs doesn't support supported_ops yet so
+	 * returns success for the compatibility.
+	 */
+	if (!test_bit(TEST_UNIT_READY, bst->bs_supported_ops))
+		return 1;
+
+	return test_bit(op, bst->bs_supported_ops);
+}
+
 int register_backingstore_template(struct backingstore_template *bst)
 {
 	list_add(&bst->backingstore_siblings, &bst_list);
@@ -463,3 +486,4 @@ int bs_thread_cmd_submit(struct scsi_cmd *cmd)
 
 	return 0;
 }
+
diff --git a/usr/bs_rdwr.c b/usr/bs_rdwr.c
index ff009eb..a6301a7 100644
--- a/usr/bs_rdwr.c
+++ b/usr/bs_rdwr.c
@@ -425,5 +425,52 @@ static struct backingstore_template rdwr_bst = {
 
 __attribute__((constructor)) static void bs_rdwr_constructor(void)
 {
+	unsigned char opcodes[] = {
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
+	bs_create_opcode_map(&rdwr_bst, opcodes, ARRAY_SIZE(opcodes));
+
 	register_backingstore_template(&rdwr_bst);
 }
diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 16547d0..d3572db 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -1296,5 +1296,39 @@ static struct backingstore_template sheepdog_bst = {
 
 __attribute__((constructor)) static void __constructor(void)
 {
+	unsigned char opcodes[] = {
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
+	bs_create_opcode_map(&sheepdog_bst, opcodes, ARRAY_SIZE(opcodes));
+
 	register_backingstore_template(&sheepdog_bst);
 }
diff --git a/usr/scsi.c b/usr/scsi.c
index 2636a5c..d7c0095 100644
--- a/usr/scsi.c
+++ b/usr/scsi.c
@@ -492,6 +492,11 @@ int scsi_cmd_perform(int host_no, struct scsi_cmd *cmd)
 	if (spc_access_check(cmd))
 		return SAM_STAT_RESERVATION_CONFLICT;
 
+	if (!is_bs_support_opcode(cmd->dev->bst, op)) {
+		sense_data_build(cmd, ILLEGAL_REQUEST, ASC_INVALID_OP_CODE);
+		return SAM_STAT_CHECK_CONDITION;
+	}
+
 	return cmd->dev->dev_type_template.ops[op].cmd_perform(host_no, cmd);
 }
 
diff --git a/usr/tgtd.h b/usr/tgtd.h
index b0528b4..850a110 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -7,6 +7,8 @@
 
 struct concat_buf;
 
+#define NR_SCSI_OPCODES		256
+
 #define SCSI_ID_LEN		36
 #define SCSI_SN_LEN		36
 
@@ -165,6 +167,7 @@ struct backingstore_template {
 	void (*bs_exit)(struct scsi_lu *dev);
 	int (*bs_cmd_submit)(struct scsi_cmd *cmd);
 	int bs_oflags_supported;
+	unsigned long bs_supported_ops[NR_SCSI_OPCODES / __WORDSIZE];
 
 	struct list_head backingstore_siblings;
 };
@@ -369,6 +372,9 @@ extern tgtadm_err dtd_check_removable(int tid, uint64_t lun);
 
 extern int register_backingstore_template(struct backingstore_template *bst);
 extern struct backingstore_template *get_backingstore_template(const char *name);
+extern void bs_create_opcode_map(struct backingstore_template *bst,
+				 unsigned char *opcodes, int num);
+extern int is_bs_support_opcode(struct backingstore_template *bst, int op);
 
 extern int lld_init_one(int lld_index);
 
diff --git a/usr/util.h b/usr/util.h
index d01d58b..08a6dd3 100644
--- a/usr/util.h
+++ b/usr/util.h
@@ -19,6 +19,7 @@
 #include "be_byteshift.h"
 
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+#define DIV_ROUND_UP(x, y) (((x) + (y) - 1) / (y))
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #define ALIGN(x,a) (((x)+(a)-1)&~((a)-1))
 
@@ -214,10 +215,29 @@ static inline int unmap_file_region(int fd, off_t offset, off_t length)
 #ifdef FALLOC_FL_PUNCH_HOLE
 	if (fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			offset, length) == 0)
-		return 0; 
+		return 0;
 #endif
 	return -1;
 }
 
+#define BITS_PER_LONG __WORDSIZE
+#define BITS_PER_BYTE           8
+#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+
+static inline void set_bit(int nr, unsigned long *addr)
+{
+	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
+}
+
+static inline void clear_bit(int nr, unsigned long *addr)
+{
+	addr[nr / BITS_PER_LONG] &= ~(1UL << (nr % BITS_PER_LONG));
+}
+
+static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
+{
+	return ((1UL << (nr % BITS_PER_LONG)) &
+		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
+}
 
 #endif
-- 
1.7.2.5
