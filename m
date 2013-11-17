From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Add an array that describes which opcodes are
 supported by the RDWR and SHEEPDOG backends.
Date: Sun, 17 Nov 2013 22:23:58 +0900
Message-ID: <20131117215706K.fujita.tomonori@lab.ntt.co.jp>
References: <1384651106-18407-1-git-send-email-ronniesahlberg@gmail.com>
	<1384651106-18407-2-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1384651106-18407-2-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sat, 16 Nov 2013 17:18:26 -0800
Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:

> While RDWR supports all SBC opcodes that TGTD implement SHEEPDOG
> only supports a subset and lacks the following opcodes:
>             WRITE_VERIFY10/12/16 VERIFY10/12/16 PREFETCH10/16
>             WRITE_SAME10/16 UNMAP and ORWRITE
> 
> This allows backends to specify which opcodes it is prepared to process
> and which commands should fail with invalid op code
> and allows SHEEPDOG backed LUNs to respond with INVALID_OP_CODE
> correctly.
> 
> This is most useful for block devices where we have several different backends
> and where some backends only support a subset of the commands
> 
> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> ---
>  usr/bs.c          |    8 ++++++++
>  usr/bs_rdwr.c     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  usr/bs_sheepdog.c |   38 ++++++++++++++++++++++++++++++++++++++
>  usr/scsi.c        |    6 ++++++
>  usr/tgtd.h        |    1 +
>  5 files changed, 104 insertions(+), 0 deletions(-)
> 
> diff --git a/usr/bs.c b/usr/bs.c
> index 636f53b..a6a5852 100644
> --- a/usr/bs.c
> +++ b/usr/bs.c
> @@ -463,3 +463,11 @@ int bs_thread_cmd_submit(struct scsi_cmd *cmd)
>  
>  	return 0;
>  }
> +
> +void bs_create_opcode_map(unsigned char *map, unsigned char *opcodes, int num)
> +{
> +	int i;
> +
> +	for (i = 0; i < num; i++)
> +		map[opcodes[i] >> 3] |= 1 << (opcodes[i] % 8);
> +}
> diff --git a/usr/bs_rdwr.c b/usr/bs_rdwr.c
> index ff009eb..01a710e 100644
> --- a/usr/bs_rdwr.c
> +++ b/usr/bs_rdwr.c
> @@ -412,6 +412,8 @@ static void bs_rdwr_exit(struct scsi_lu *lu)
>  	bs_thread_close(info);
>  }
>  
> +static char bs_ops_supported[32];

I prefer to put this array to backingstore_template rather than let
each backing store because all backing stores should to have this
array.


>  static struct backingstore_template rdwr_bst = {
>  	.bs_name		= "rdwr",
>  	.bs_datasize		= sizeof(struct bs_thread_info),
> @@ -421,9 +423,58 @@ static struct backingstore_template rdwr_bst = {
>  	.bs_exit		= bs_rdwr_exit,
>  	.bs_cmd_submit		= bs_thread_cmd_submit,
>  	.bs_oflags_supported    = O_SYNC | O_DIRECT,
> +	.bs_ops_supported	= bs_ops_supported,
>  };
>  
>  __attribute__((constructor)) static void bs_rdwr_constructor(void)
>  {
> +	static char opcodes[] = {
> +		ALLOW_MEDIUM_REMOVAL,
> +		COMPARE_AND_WRITE,
> +		FORMAT_UNIT,
> +		INQUIRY,
> +		MAINT_PROTOCOL_IN,
> +		MODE_SELECT,
> +		MODE_SELECT_10,
> +		MODE_SENSE,
> +		MODE_SENSE_10,
> +		ORWRITE_16,
> +		PERSISTENT_RESERVE_IN,
> +		PERSISTENT_RESERVE_OUT,
> +		PRE_FETCH_10,
> +		PRE_FETCH_16,
> +		READ_10,
> +		READ_12,
> +		READ_16,
> +		READ_6,
> +		READ_CAPACITY,
> +		RELEASE,
> +		REPORT_LUNS,
> +		REQUEST_SENSE,
> +		RESERVE,
> +		SEND_DIAGNOSTIC,
> +		SERVICE_ACTION_IN,
> +		START_STOP,
> +		SYNCHRONIZE_CACHE,
> +		SYNCHRONIZE_CACHE_16,
> +		TEST_UNIT_READY,
> +		UNMAP,
> +		VERIFY_10,
> +		VERIFY_12,
> +		VERIFY_16,
> +		WRITE_10,
> +		WRITE_12,
> +		WRITE_16,
> +		WRITE_6,
> +		WRITE_SAME,
> +		WRITE_SAME_16,
> +		WRITE_VERIFY,
> +		WRITE_VERIFY_12,
> +		WRITE_VERIFY_16
> +	};
> +
> +	bs_create_opcode_map(bs_ops_supported, &opcodes[0],
> +		sizeof(opcodes) / sizeof(opcodes[0]));

ARRAY_SIZE macro?

>  	register_backingstore_template(&rdwr_bst);
>  }
> diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
> index 1dda915..2d2b8a1 100644
> --- a/usr/bs_sheepdog.c
> +++ b/usr/bs_sheepdog.c
> @@ -1283,6 +1283,8 @@ static void bs_sheepdog_exit(struct scsi_lu *lu)
>  	dprintf("cleaned logical unit %p safely\n", lu);
>  }
>  
> +static char bs_ops_supported[32];
> +
>  static struct backingstore_template sheepdog_bst = {
>  	.bs_name		= "sheepdog",
>  	.bs_datasize		=
> @@ -1292,9 +1294,45 @@ static struct backingstore_template sheepdog_bst = {
>  	.bs_init		= bs_sheepdog_init,
>  	.bs_exit		= bs_sheepdog_exit,
>  	.bs_cmd_submit		= bs_thread_cmd_submit,
> +	.bs_ops_supported	= bs_ops_supported,
>  };
>  
>  __attribute__((constructor)) static void __constructor(void)
>  {
> +	static char opcodes[] = {
> +		ALLOW_MEDIUM_REMOVAL,
> +		FORMAT_UNIT,
> +		INQUIRY,
> +		MAINT_PROTOCOL_IN,
> +		MODE_SELECT,
> +		MODE_SELECT_10,
> +		MODE_SENSE,
> +		MODE_SENSE_10,
> +		PERSISTENT_RESERVE_IN,
> +		PERSISTENT_RESERVE_OUT,
> +		READ_10,
> +		READ_12,
> +		READ_16,
> +		READ_6,
> +		READ_CAPACITY,
> +		RELEASE,
> +		REPORT_LUNS,
> +		REQUEST_SENSE,
> +		RESERVE,
> +		SEND_DIAGNOSTIC,
> +		SERVICE_ACTION_IN,
> +		START_STOP,
> +		SYNCHRONIZE_CACHE,
> +		SYNCHRONIZE_CACHE_16,
> +		TEST_UNIT_READY,
> +		WRITE_10,
> +		WRITE_12,
> +		WRITE_16,
> +		WRITE_6
> +	};
> +
> +	bs_create_opcode_map(bs_ops_supported, &opcodes[0],
> +		sizeof(opcodes) / sizeof(opcodes[0]));
> +
>  	register_backingstore_template(&sheepdog_bst);
>  }
> diff --git a/usr/scsi.c b/usr/scsi.c
> index 2636a5c..14c7c33 100644
> --- a/usr/scsi.c
> +++ b/usr/scsi.c
> @@ -492,6 +492,12 @@ int scsi_cmd_perform(int host_no, struct scsi_cmd *cmd)
>  	if (spc_access_check(cmd))
>  		return SAM_STAT_RESERVATION_CONFLICT;
>  
> +	if (cmd->dev->bst->bs_ops_supported
> +	&& !(cmd->dev->bst->bs_ops_supported[op >> 3] & (1 << (op % 8)))) {
> +		sense_data_build(cmd, ILLEGAL_REQUEST, ASC_INVALID_OP_CODE);
> +		return SAM_STAT_CHECK_CONDITION;
> +	}

I think that the details of the array had better to exist in the same
file including bs_create_opcode_map().

Here's the modified version. Not tested.

diff --git a/usr/bs.c b/usr/bs.c
index 636f53b..2c353af 100644
--- a/usr/bs.c
+++ b/usr/bs.c
@@ -45,6 +45,7 @@
 #include "tgtadm_error.h"
 #include "util.h"
 #include "bs_thread.h"
+#include "scsi.h"
 
 LIST_HEAD(bst_list);
 
@@ -63,6 +64,27 @@ static pthread_t ack_thread;
 static LIST_HEAD(ack_list);
 static pthread_cond_t finished_cond;
 
+
+void bs_create_opcode_map(struct backingstore_template *bst, unsigned char *opcodes, int num)
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
@@ -463,3 +485,4 @@ int bs_thread_cmd_submit(struct scsi_cmd *cmd)
 
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
index 1dda915..30af8ed 100644
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
index b0528b4..510b025 100644
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
@@ -369,6 +372,8 @@ extern tgtadm_err dtd_check_removable(int tid, uint64_t lun);
 
 extern int register_backingstore_template(struct backingstore_template *bst);
 extern struct backingstore_template *get_backingstore_template(const char *name);
+extern void bs_create_opcode_map(struct backingstore_template *bst, unsigned char *opcodes, int num);
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
