From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] The first byte in CDB USAGE DATA should be the opcode number and not 0xFF
Date: Mon, 24 Feb 2014 19:15:09 -0800
Message-ID: <1393298109-16052-2-git-send-email-ronniesahlberg@gmail.com>
References: <1393298109-16052-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oezXCXhDmJNE7iTeKQt1qn20GSB6SKYeOaPyS2K1Ndk=;
        b=MybTce4CRALdQtyvPbxaniyN9dXgVgWF9Vs3u/CoWEKghAzJu+2IOh1AauMjXHWimR
         BOuefBzSNIJHJlSVn66ZPcjE4DdWtM8mr6tHqIwqyyLM4hdMHhPZTBD9kjIrr4yhB0ml
         yeDrgV/aCED4z7DFuY1cLkMbzuKgAwyoE6tiJq2mIvEzz+zDvRgEMBObXV2PjblXUSmg
         pYbafZpX9WSciHKh3y1HuW/px5lKWAIjbluqWSb8FPaB9WDtAR7P/2xCAGA3CACEi8Gl
         wQlAFBEbiCw3IP2/3im2sqLFNEzwouVflgcr/V8f7ZK+3O8ANM3wYG+zTF4ydkTVHFvW
         izqw==
In-Reply-To: <1393298109-16052-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

When we build the CDB USAGE DATA field for a REPORT SUPPORTED OPCODES reply
we must set the first byte of the field to the opcode itself, and not
to 0xFF as we currently do.

SPC4:
...
The CDB USAGE DATA field contains information about the CDB for the command being queried.
The first byte of the CDB USAGE FIELD field shall contain the operation code for the command being queried.
...

A test for this is available in the libiscsi test utility :

./bin/iscsi-test-cu iscsi://127.0.0.1/iqn.ronnie.test/1 --test=SCSI.ReportSupportedOpcodes.OneCommand

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/scsi.c |  195 ++++++++++++++++++++++++++++++++++++------------------------
 1 files changed, 118 insertions(+), 77 deletions(-)

diff --git a/usr/scsi.c b/usr/scsi.c
index d7c0095..4eccf13 100644
--- a/usr/scsi.c
+++ b/usr/scsi.c
@@ -59,164 +59,184 @@ int get_scsi_cdb_size(struct scsi_cmd *cmd)
 const unsigned char *get_scsi_cdb_usage_data(unsigned char op, unsigned char sa)
 {
 	static const unsigned char usage[16];
+	unsigned char *buf = NULL;
 
-	static const unsigned char allow_medium_removal[] = {
+	static unsigned char allow_medium_removal[] = {
 	       0xff, 0x00, 0x00, 0x00, 0x03, 0x07};
-	static const unsigned char send_diagnostics[] = {
+	static unsigned char send_diagnostics[] = {
 	       0xff, 0xff, 0x00, 0xff, 0xff, 0x07};
-	static const unsigned char start_stop[] = {
+	static unsigned char start_stop[] = {
 	       0xff, 0x01, 0x00, 0x0f, 0xf7, 0x07};
-	static const unsigned char mode_sense[] = {
+	static unsigned char mode_sense[] = {
 	       0xff, 0x08, 0xff, 0xff, 0xff, 0x07};
-	static const unsigned char mode_select[] = {
+	static unsigned char mode_select[] = {
 	       0xff, 0x11, 0x00, 0x00, 0xff, 0x07};
-	static const unsigned char reserve_release[] = {
+	static unsigned char reserve_release[] = {
 	       0xff, 0x00, 0x00, 0x00, 0x00, 0x07};
-	static const unsigned char inquiry[] = {
+	static unsigned char inquiry[] = {
 	       0xff, 0x01, 0xff, 0xff, 0xff, 0x07};
-	static const unsigned char read_write_6[] = {
+	static unsigned char read_write_6[] = {
 	       0xff, 0x1f, 0xff, 0xff, 0xff, 0x07};
-	static const unsigned char format_unit[] = {
+	static unsigned char format_unit[] = {
 	       0xff, 0xff, 0x00, 0x00, 0x00, 0x07};
-	static const unsigned char request_sense[] = {
+	static unsigned char request_sense[] = {
 	       0xff, 0x01, 0x00, 0x00, 0xff, 0x07};
-	static const unsigned char test_unit_ready[] = {
+	static unsigned char test_unit_ready[] = {
 	       0xff, 0x00, 0x00, 0x00, 0x00, 0x07};
-
-	static const unsigned char persistent_reserve_in[] = {
+	static unsigned char persistent_reserve_in[] = {
 	       0xff, 0x1f, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff,
 	       0xff, 0x07};
-	static const unsigned char persistent_reserve_out[] = {
+	static unsigned char persistent_reserve_out[] = {
 	       0xff, 0x1f, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff,
 	       0xff, 0x07};
-	static const unsigned char mode_sense_10[] = {
+	static unsigned char mode_sense_10[] = {
 	       0xff, 0x18, 0xff, 0xff, 0x00, 0x00, 0x00, 0xff,
 	       0xff, 0x07};
-	static const unsigned char mode_select_10[] = {
+	static unsigned char mode_select_10[] = {
 	       0xff, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff,
 	       0xff, 0x07};
-	static const unsigned char unmap[] = {
+	static unsigned char unmap[] = {
 	       0xff, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff,
 	       0xff, 0x07};
-	static const unsigned char write_same_10[] = {
+	static unsigned char write_same_10[] = {
 	       0xff, 0xf8, 0xff, 0xff, 0xff, 0xff, 0x00, 0xff,
 	       0xff, 0x07};
-	static const unsigned char pre_fetch_10[] = {
+	static unsigned char pre_fetch_10[] = {
 	       0xff, 0x02, 0xff, 0xff, 0xff, 0xff, 0x00, 0xff,
 	       0xff, 0x07};
-	static const unsigned char synchronize_cache_10[] = {
+	static unsigned char synchronize_cache_10[] = {
 	       0xff, 0x06, 0xff, 0xff, 0xff, 0xff, 0x00, 0xff,
 	       0xff, 0x07};
-	static const unsigned char verify_10[] = {
+	static unsigned char verify_10[] = {
 	       0xff, 0xf2, 0xff, 0xff, 0xff, 0xff, 0x00, 0xff,
 	       0xff, 0x07};
-	static const unsigned char write_10[] = {
+	static unsigned char write_10[] = {
 	       0xff, 0xfa, 0xff, 0xff, 0xff, 0xff, 0x00, 0xff,
 	       0xff, 0x07};
-	static const unsigned char read_10[] = {
+	static unsigned char read_10[] = {
 	       0xff, 0xfe, 0xff, 0xff, 0xff, 0xff, 0x00, 0xff,
 	       0xff, 0x07};
-	static const unsigned char read_capacity[] = {
+	static unsigned char read_capacity[] = {
 	       0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	       0x00, 0x07};
-
-	static const unsigned char verify_12[] = {
+	static unsigned char verify_12[] = {
 	       0xff, 0xf2, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0x00, 0x07};
-	static const unsigned char write_12[] = {
+	static unsigned char write_12[] = {
 	       0xff, 0xfa, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0x00, 0x07};
-	static const unsigned char read_12[] = {
+	static unsigned char read_12[] = {
 	       0xff, 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0x00, 0x07};
-	static const unsigned char rep_sup_opcodes[] = {
+	static unsigned char rep_sup_opcodes[] = {
 	       0xff, 0x1f, 0x87, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0x00, 0x07};
-	static const unsigned char report_luns[] = {
+	static unsigned char report_luns[] = {
 	       0xff, 0x00, 0xff, 0x00, 0x00, 0x00, 0xff, 0xff,
 	       0xff, 0xff, 0x00, 0x07};
-
-	static const unsigned char get_lba_status[] = {
+	static unsigned char get_lba_status[] = {
 	       0xff, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x07};
-	static const unsigned char read_capacity_16[] = {
+	static unsigned char read_capacity_16[] = {
 	       0xff, 0x1f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	       0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0x00, 0x07};
-	static const unsigned char write_same_16[] = {
+	static unsigned char write_same_16[] = {
 	       0xff, 0xf8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x07};
-	static const unsigned char synchronize_cache_16[] = {
+	static unsigned char synchronize_cache_16[] = {
 	       0xff, 0x06, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x07};
-	static const unsigned char pre_fetch_16[] = {
+	static unsigned char pre_fetch_16[] = {
 	       0xff, 0x02, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x07};
-	static const unsigned char verify_16[] = {
+	static unsigned char verify_16[] = {
 	       0xff, 0xf2, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x07};
-	static const unsigned char orwrite_16[] = {
+	static unsigned char orwrite_16[] = {
 	       0xff, 0xfa, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x07};
-	static const unsigned char compare_and_write[] = {
+	static unsigned char compare_and_write[] = {
 	       0xff, 0xfa, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x07};
-	static const unsigned char read_16[] = {
+	static unsigned char read_16[] = {
 	       0xff, 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x07};
 
 	switch (op) {
 	case TEST_UNIT_READY:
-		return test_unit_ready;
+		buf = test_unit_ready;
+		break;
 	case REQUEST_SENSE:
-		return request_sense;
+		buf = request_sense;
+		break;
 	case FORMAT_UNIT:
-		return format_unit;
+		buf = format_unit;
+		break;
 	case READ_6:
 	case WRITE_6:
-		return read_write_6;
+		buf = read_write_6;
+		break;
 	case INQUIRY:
-		return inquiry;
+		buf = inquiry;
+		break;
 	case MODE_SELECT:
-		return mode_select;
+		buf = mode_select;
+		break;
 	case RELEASE:
 	case RESERVE:
-		return reserve_release;
+		buf = reserve_release;
+		break;
 	case MODE_SENSE:
-		return mode_sense;
+		buf = mode_sense;
+		break;
 	case START_STOP:
-		return start_stop;
+		buf = start_stop;
+		break;
 	case SEND_DIAGNOSTIC:
-		return send_diagnostics;
+		buf = send_diagnostics;
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
-		return allow_medium_removal;
+		buf = allow_medium_removal;
+		break;
 	case READ_CAPACITY:
-		return read_capacity;
+		buf = read_capacity;
+		break;
 	case READ_10:
-		return read_10;
+		buf = read_10;
+		break;
 	case WRITE_10:
-		return write_10;
+		buf = write_10;
+		break;
 	case WRITE_VERIFY:
 	case VERIFY_10:
-		return verify_10;
+		buf = verify_10;
+		break;
 	case PRE_FETCH_10:
-		return pre_fetch_10;
+		buf = pre_fetch_10;
+		break;
 	case SYNCHRONIZE_CACHE:
-		return synchronize_cache_10;
+		buf = synchronize_cache_10;
+		break;
 	case WRITE_SAME:
-		return write_same_10;
+		buf = write_same_10;
+		break;
 	case UNMAP:
-		return unmap;
+		buf = unmap;
+		break;
 	case MODE_SELECT_10:
-		return mode_select_10;
+		buf = mode_select_10;
+		break;
 	case MODE_SENSE_10:
-		return mode_sense_10;
+		buf = mode_sense_10;
+		break;
 	case PERSISTENT_RESERVE_IN:
 		switch (sa) {
 		case PR_IN_READ_KEYS:
 		case PR_IN_READ_RESERVATION:
 		case PR_IN_REPORT_CAPABILITIES:
 		case PR_IN_READ_FULL_STATUS:
-			return persistent_reserve_in;
+			buf = persistent_reserve_in;
+			break;
 		}
 		break;
 	case PERSISTENT_RESERVE_OUT:
@@ -229,49 +249,70 @@ const unsigned char *get_scsi_cdb_usage_data(unsigned char op, unsigned char sa)
 		case PR_OUT_PREEMPT_AND_ABORT:
 		case PR_OUT_REGISTER_AND_IGNORE_EXISTING_KEY:
 		case PR_OUT_REGISTER_AND_MOVE:
-			return persistent_reserve_out;
+			buf = persistent_reserve_out;
+			break;
 		}
 		break;
 	case READ_16:
-		return read_16;
+		buf = read_16;
+		break;
 	case COMPARE_AND_WRITE:
-		return compare_and_write;
+		buf = compare_and_write;
+		break;
 	case WRITE_16:
 	case ORWRITE_16:
-		return orwrite_16;
+		buf = orwrite_16;
+		break;
 	case WRITE_VERIFY_16:
 	case VERIFY_16:
-		return verify_16;
+		buf = verify_16;
+		break;
 	case PRE_FETCH_16:
-		return pre_fetch_16;
+		buf = pre_fetch_16;
+		break;
 	case SYNCHRONIZE_CACHE_16:
-		return synchronize_cache_16;
+		buf = synchronize_cache_16;
+		break;
 	case WRITE_SAME_16:
-		return write_same_16;
+		buf = write_same_16;
+		break;
 	case SERVICE_ACTION_IN:
 		switch (sa) {
 		case SAI_READ_CAPACITY_16:
-			return read_capacity_16;
+			buf = read_capacity_16;
+			break;
 		case SAI_GET_LBA_STATUS:
-			return get_lba_status;
+			buf = get_lba_status;
+			break;
 		}
 		break;
 	case REPORT_LUNS:
-		return report_luns;
+		buf = report_luns;
+		break;
 	case MAINT_PROTOCOL_IN:
 		switch (sa) {
 		case MPI_REPORT_SUPPORTED_OPCODES:
-			return rep_sup_opcodes;
+			buf = rep_sup_opcodes;
+			break;
 		}
 		break;
 	case READ_12:
-		return read_12;
+		buf = read_12;
+		break;
 	case VERIFY_12:
 	case WRITE_VERIFY_12:
-		return verify_12;
+		buf = verify_12;
+		break;
 	case WRITE_12:
-		return write_12;
+		buf = write_12;
+		break;
 	}
+
+	if (buf) {
+		buf[0] = op;
+		return buf;
+	}
+
 	return usage;
 }
 
-- 
1.7.3.1
