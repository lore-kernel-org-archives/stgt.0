From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Add support for WRITE_ATOMIC_16
Date: Wed,  9 Sep 2015 11:43:55 -0700
Message-ID: <1441824235-7724-2-git-send-email-ronniesahlberg@gmail.com>
References: <1441824235-7724-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zYZp8PCwfLVxARUjUb9zi4le71lVTeFxFkqGuFlUUUc=;
        b=KNZMl3j6PolTzEx61wpY39RUXy/N8Dq+jm7jZ3ppUyp+dczKAtUuCHQNDCgepBOzVO
         eBX0SleeZXAo9wjy1O9lW0tTRnw5+o31RToD4T5Amc+N+hfEX1wl5Ry6RVZ/2DSiUgky
         2DJRrkNbkD6ppChFLC8Ntc4aqXV05ZMu2Chquvcg0ywU/g8dr6RW96G/HrgIWBVaPWNa
         rDLd4YxWWe/FhQ7taC7d7qsS0jrSyFGZWlj9EyadHuf2/Qt3HVBxJcDFA+1sh0pRafM9
         jAhVtLaVcsmCSTJCOvLpP+cZl/OPO3nTsTe+IdlaOhpgRyDjwGmE8327SmNjcPZlrKkL
         7QTA==
In-Reply-To: <1441824235-7724-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

We treat these the same as WRITE_16 so it is not technically a true
WRITE_ATOMIC_16 but it is close enough.
And it makes tgtd better to use for WRITE_ATOMIC_16 testing
using capable initiators.

We only support this opcode for the bs_rdwr backend so far and the way we
try to implement as atomic as possible is to:
* mmap populate and lock the file region for the backing store
* mlock the write buffer
* memcpy the data from write buffer to mmapped region. This should not
not fail prematurely nor should it block waiting for paging to happen.
So it should be running at full memory speed.
* unmap and unlock everything

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/bs_rdwr.c    | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 usr/iscsi/iser.c |  1 +
 usr/sbc.c        | 34 ++++++++++++++++++++++++++--------
 usr/scsi.c       | 12 ++++++++++++
 usr/scsi.h       |  1 +
 usr/spc.c        | 10 ++++++++++
 usr/spc.h        |  2 ++
 usr/tgtd.h       |  3 +++
 8 files changed, 108 insertions(+), 8 deletions(-)

diff --git a/usr/bs_rdwr.c b/usr/bs_rdwr.c
index 56d086d..d0ddbf8 100644
--- a/usr/bs_rdwr.c
+++ b/usr/bs_rdwr.c
@@ -27,6 +27,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <unistd.h>
@@ -217,6 +218,47 @@ write:
 		if (do_verify)
 			goto verify;
 		break;
+	case WRITE_ATOMIC_16:
+		length = scsi_get_out_length(cmd);
+		write_buf = scsi_get_out_buffer(cmd);
+
+		ptr = mmap(NULL, length, PROT_WRITE,
+			   MAP_SHARED|MAP_LOCKED|MAP_POPULATE,
+			   fd, offset);
+		if (ptr == MAP_FAILED) {
+			eprintf("Failed to mmap the image file during " \
+				"ATOMIC_WRITE_16\n");
+
+			result = SAM_STAT_CHECK_CONDITION;
+			key = HARDWARE_ERROR;
+			asc = ASC_INTERNAL_TGT_FAILURE;
+			break;
+		}
+
+		if (mlock(write_buf, length) == -1) {
+			munlock(ptr, length);
+			munmap(ptr, length);
+			eprintf("Failed to mlock write buffer during " \
+				"ATOMIC_WRITE_16\n");
+
+			result = SAM_STAT_CHECK_CONDITION;
+			key = HARDWARE_ERROR;
+			asc = ASC_INTERNAL_TGT_FAILURE;
+			break;
+		}
+
+		/* Since both the write buffer as well as the file region we
+		   are writing to are populated and locked in memory at this
+		   point we should be pretty much guaranteed that memcpy will
+		   not fail to copy everything as quickly as possible.
+		   This is probably as atomic we can make it for now.
+		 */
+		memcpy(ptr, write_buf, length);
+
+		munlock(write_buf, length);
+		munlock(ptr, length);
+		munmap(ptr, length);
+		break;
 	case WRITE_SAME:
 	case WRITE_SAME_16:
 		/* WRITE_SAME used to punch hole in file */
@@ -390,6 +432,16 @@ static int bs_rdwr_open(struct scsi_lu *lu, char *path, int *fd, uint64_t *size)
 	if (!lu->attrs.no_auto_lbppbe)
 		update_lbppbe(lu, blksize);
 
+	lu->attrs.wa_xfer_max = 1024 * 1024 * 16 / (1U << lu->blk_shift);
+	if (blksize > 1U << lu->blk_shift) {
+		lu->attrs.wa_align = blksize / (1U << lu->blk_shift);
+		lu->attrs.wa_gran = blksize / (1U << lu->blk_shift);
+	} else {
+		lu->attrs.wa_align = 1;
+		lu->attrs.wa_gran = 1;
+	}
+	update_write_atomic_vpd(lu);
+
 	return 0;
 }
 
@@ -485,6 +537,7 @@ __attribute__((constructor)) static void bs_rdwr_constructor(void)
 		WRITE_12,
 		WRITE_16,
 		WRITE_6,
+		WRITE_ATOMIC_16,
 		WRITE_SAME,
 		WRITE_SAME_16,
 		WRITE_VERIFY,
diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index 7befd06..c8b9c91 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -2162,6 +2162,7 @@ static inline int task_can_batch(struct iser_task *task)
 	case WRITE_10:
 	case WRITE_12:
 	case WRITE_16:
+	case WRITE_ATOMIC_16:
 	case READ_6:
 	case READ_10:
 	case READ_12:
diff --git a/usr/sbc.c b/usr/sbc.c
index 8dbcd78..494c9b6 100644
--- a/usr/sbc.c
+++ b/usr/sbc.c
@@ -260,13 +260,14 @@ static int sbc_rw(int host_no, struct scsi_cmd *cmd)
 	}
 
 	switch (cmd->scb[0]) {
+	case ORWRITE_16:
 	case READ_10:
 	case READ_12:
 	case READ_16:
 	case WRITE_10:
 	case WRITE_12:
 	case WRITE_16:
-	case ORWRITE_16:
+	case WRITE_ATOMIC_16:
 	case WRITE_VERIFY:
 	case WRITE_VERIFY_12:
 	case WRITE_VERIFY_16:
@@ -311,19 +312,20 @@ static int sbc_rw(int host_no, struct scsi_cmd *cmd)
 
 	if (lu->attrs.readonly || cmd->dev->attrs.swp) {
 		switch (cmd->scb[0]) {
+		case COMPARE_AND_WRITE:
+		case ORWRITE_16:
+		case PRE_FETCH_10:
+		case PRE_FETCH_16:
 		case WRITE_6:
 		case WRITE_10:
 		case WRITE_12:
 		case WRITE_16:
-		case ORWRITE_16:
+		case WRITE_ATOMIC_16:
+		case WRITE_SAME:
+		case WRITE_SAME_16:
 		case WRITE_VERIFY:
 		case WRITE_VERIFY_12:
 		case WRITE_VERIFY_16:
-		case WRITE_SAME:
-		case WRITE_SAME_16:
-		case PRE_FETCH_10:
-		case PRE_FETCH_16:
-		case COMPARE_AND_WRITE:
 			key = DATA_PROTECT;
 			asc = ASC_WRITE_PROTECT;
 			goto sense;
@@ -334,6 +336,21 @@ static int sbc_rw(int host_no, struct scsi_cmd *cmd)
 	lba = scsi_rw_offset(cmd->scb);
 	tl  = scsi_rw_count(cmd->scb);
 
+	if (cmd->scb[0] == WRITE_ATOMIC_16) {
+		/* Atomic writes must be aligned properly */
+		if ((lu->attrs.wa_align > 1) && (lba % lu->attrs.wa_align)) {
+			key = ILLEGAL_REQUEST;
+			asc = ASC_INVALID_FIELD_IN_CDB;
+			goto sense;
+		}
+		/* Atomic writes must have right granularity */
+		if ((lu->attrs.wa_gran > 1) && (tl % lu->attrs.wa_gran)) {
+			key = ILLEGAL_REQUEST;
+			asc = ASC_INVALID_FIELD_IN_CDB;
+			goto sense;
+		}
+	}
+
 	/* Verify that we are not doing i/o beyond
 	   the end-of-lun */
 	if (tl) {
@@ -367,6 +384,7 @@ static int sbc_rw(int host_no, struct scsi_cmd *cmd)
 	case WRITE_10:
 	case WRITE_12:
 	case WRITE_16:
+	case WRITE_ATOMIC_16:
 	case WRITE_VERIFY:
 	case WRITE_VERIFY_12:
 	case WRITE_VERIFY_16:
@@ -929,7 +947,7 @@ static struct device_type_template sbc_template = {
 		{spc_illegal_op,},
 		{spc_illegal_op,},
 		{spc_illegal_op,},
-		{spc_illegal_op,},
+		{sbc_rw,},		/* WRITE_ATOMIC_16 */
 		{spc_illegal_op,},
 		{sbc_service_action, sbc_service_actions,},
 		{spc_illegal_op,},
diff --git a/usr/scsi.c b/usr/scsi.c
index 4eccf13..46c36f1 100644
--- a/usr/scsi.c
+++ b/usr/scsi.c
@@ -155,6 +155,9 @@ const unsigned char *get_scsi_cdb_usage_data(unsigned char op, unsigned char sa)
 	static unsigned char orwrite_16[] = {
 	       0xff, 0xfa, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x07};
+	static unsigned char write_atomic_16[] = {
+	       0xff, 0xf8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	       0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x1f, 0x07};
 	static unsigned char compare_and_write[] = {
 	       0xff, 0xfa, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x07};
@@ -263,6 +266,9 @@ const unsigned char *get_scsi_cdb_usage_data(unsigned char op, unsigned char sa)
 	case ORWRITE_16:
 		buf = orwrite_16;
 		break;
+	case WRITE_ATOMIC_16:
+		buf = write_atomic_16;
+		break;
 	case WRITE_VERIFY_16:
 	case VERIFY_16:
 		buf = verify_16;
@@ -393,6 +399,7 @@ uint64_t scsi_rw_offset(uint8_t *scb)
 	case READ_16:
 	case PRE_FETCH_16:
 	case WRITE_16:
+	case WRITE_ATOMIC_16:
 	case ORWRITE_16:
 	case VERIFY_16:
 	case WRITE_VERIFY_16:
@@ -450,6 +457,9 @@ uint32_t scsi_rw_count(uint8_t *scb)
 		cnt = (uint32_t)scb[10] << 24 | (uint32_t)scb[11] << 16 |
 			(uint32_t)scb[12] << 8 | (uint32_t)scb[13];
 		break;
+	case WRITE_ATOMIC_16:
+		cnt = (uint32_t)scb[12] << 8 | (uint32_t)scb[13];
+		break;
 	case COMPARE_AND_WRITE:
 		cnt = (uint32_t)scb[13];
 		break;
@@ -560,6 +570,7 @@ int scsi_is_io_opcode(unsigned char op)
 	case WRITE_16:
 	case ORWRITE_16:
 	case VERIFY_16:
+	case WRITE_ATOMIC_16:
 	case WRITE_VERIFY_16:
 	case COMPARE_AND_WRITE:
 		ret = 1;
@@ -581,6 +592,7 @@ enum data_direction scsi_data_dir_opcode(unsigned char op)
 	case WRITE_10:
 	case WRITE_12:
 	case WRITE_16:
+	case WRITE_ATOMIC_16:
 	case ORWRITE_16:
 	case WRITE_VERIFY:
 	case WRITE_VERIFY_12:
diff --git a/usr/scsi.h b/usr/scsi.h
index 6d0a2a5..b139735 100644
--- a/usr/scsi.h
+++ b/usr/scsi.h
@@ -86,6 +86,7 @@
 #define PRE_FETCH_16          0x90
 #define SYNCHRONIZE_CACHE_16  0x91
 #define WRITE_SAME_16         0x93
+#define WRITE_ATOMIC_16       0x9c
 #define SERVICE_ACTION_IN     0x9e
 #define	SAI_READ_CAPACITY_16  0x10
 #define	SAI_GET_LBA_STATUS    0x12
diff --git a/usr/spc.c b/usr/spc.c
index cdb8a2a..b71323e 100644
--- a/usr/spc.c
+++ b/usr/spc.c
@@ -210,6 +210,16 @@ static void update_vpd_b2(struct scsi_lu *lu, void *id)
 	}
 }
 
+
+void update_write_atomic_vpd(struct scsi_lu *lu)
+{
+	struct vpd *vpd_pg = lu->attrs.lu_vpd[PCODE_OFFSET(0xb0)];
+
+	put_unaligned_be32(lu->attrs.wa_xfer_max, vpd_pg->data + 40);
+	put_unaligned_be32(lu->attrs.wa_align, vpd_pg->data + 44);
+	put_unaligned_be32(lu->attrs.wa_gran, vpd_pg->data + 48);
+}
+
 static void update_vpd_b0(struct scsi_lu *lu, void *id)
 {
 	struct vpd *vpd_pg = lu->attrs.lu_vpd[PCODE_OFFSET(0xb0)];
diff --git a/usr/spc.h b/usr/spc.h
index 0c537e1..7ac62f6 100644
--- a/usr/spc.h
+++ b/usr/spc.h
@@ -33,4 +33,6 @@ extern tgtadm_err spc_lu_online(struct scsi_lu *lu);
 extern tgtadm_err spc_lu_offline(struct scsi_lu *lu);
 
 extern int spc_access_check(struct scsi_cmd *cmd);
+extern void update_write_atomic_vpd(struct scsi_lu *lu);
+
 #endif
diff --git a/usr/tgtd.h b/usr/tgtd.h
index d8b2ac1..4dad800 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -89,6 +89,9 @@ struct lu_phy_attr {
 	char no_auto_lbppbe;    /* Do not update it automatically when the
 				   backing file changes */
 	uint16_t la_lba;	/* Lowest aligned LBA */
+	uint16_t wa_xfer_max;	/* Max Atomix Write Transfer (in blocks)*/
+	uint16_t wa_align;	/* Atomix Write Alignment (in blocks)*/
+	uint16_t wa_gran;	/* Atomix Write Granularity (in blocks)*/
 
 	/* VPD pages 0x80 -> 0xff masked with 0x80*/
 	struct vpd *lu_vpd[1 << PCODE_SHIFT];
-- 
2.1.0
