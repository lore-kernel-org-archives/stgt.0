From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] MMC: add a dedicated backend for MMC so that supported-opcode map works
Date: Wed, 20 Aug 2014 16:45:38 -0700
Message-ID: <1408578338-9262-2-git-send-email-ronniesahlberg@gmail.com>
References: <1408578338-9262-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a8p6mZKgK83UGdWpzhif0/HJtdCxbvZ+r9k5hgr7sQo=;
        b=s8Gwq6oMQc+cScUsEf/dpLkdM1bOLssqoBIX5fRiC8YLM0ahZcsez1Mk8Uze095wec
         Neea6Yi17i0tcaIAzBM0wgHx2p/qsNGleLC1gcfGtMGy20cIERkCPIpIX9g4yebvp6qS
         XJY6ny+L8FE7JVtKnJS4363Cr27FtrjYFRV1wIWehHP9u9guYJlBFJRMlcm/Dyxakka+
         hkXEKodBTc9sMR6jeQEtXrc9hFwUN8O7YS2yVDxap6m0dBoUi0RafQ8DgHcrFDfNuvmr
         9p+8+/3gKxh9aoJum2HyTHlbb1gVd3Q3tVPPDzx60o7m2lyimt8seWBmf2oRZ4mHwF8+
         bomg==
In-Reply-To: <1408578338-9262-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

MMC has been broken for a while since some of the vital opcodes
(GET_CONFIGURATION) and friends are not in the supported opcode
whitelist in bs_rdwr.c.
The real problem is that we have a bs_rdwr.c backend for SBC and we
piggyback on this SBC backend also for the MMC emulation.

Add defines for the missing MMC opcodes and create a new backend
dedicated for MMC that has the proper whitelist for MMC opcodes.
This new backend is actually part of bs_rdwr.c and shares all the
code with the SBC based backend.
However the new MMC backend will have a different name "mmc" to indicate
it is for the MMC emulation and it comes with a supported opcode
whitelist that is appropriate for MMC devices.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/bs_rdwr.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 usr/mmc.c     |    6 +++---
 usr/scsi.h    |    9 +++++++++
 3 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/usr/bs_rdwr.c b/usr/bs_rdwr.c
index a6301a7..2769a0d 100644
--- a/usr/bs_rdwr.c
+++ b/usr/bs_rdwr.c
@@ -423,9 +423,20 @@ static struct backingstore_template rdwr_bst = {
 	.bs_oflags_supported    = O_SYNC | O_DIRECT,
 };
 
+static struct backingstore_template mmc_bst = {
+	.bs_name		= "mmc",
+	.bs_datasize		= sizeof(struct bs_thread_info),
+	.bs_open		= bs_rdwr_open,
+	.bs_close		= bs_rdwr_close,
+	.bs_init		= bs_rdwr_init,
+	.bs_exit		= bs_rdwr_exit,
+	.bs_cmd_submit		= bs_thread_cmd_submit,
+	.bs_oflags_supported    = O_SYNC | O_DIRECT,
+};
+
 __attribute__((constructor)) static void bs_rdwr_constructor(void)
 {
-	unsigned char opcodes[] = {
+	unsigned char sbc_opcodes[] = {
 		ALLOW_MEDIUM_REMOVAL,
 		COMPARE_AND_WRITE,
 		FORMAT_UNIT,
@@ -469,8 +480,43 @@ __attribute__((constructor)) static void bs_rdwr_constructor(void)
 		WRITE_VERIFY_12,
 		WRITE_VERIFY_16
 	};
-
-	bs_create_opcode_map(&rdwr_bst, opcodes, ARRAY_SIZE(opcodes));
-
+	bs_create_opcode_map(&rdwr_bst, sbc_opcodes, ARRAY_SIZE(sbc_opcodes));
 	register_backingstore_template(&rdwr_bst);
+
+	unsigned char mmc_opcodes[] = {
+		ALLOW_MEDIUM_REMOVAL,
+		CLOSE_TRACK,
+		GET_CONFIGURATION,
+		GET_PERFORMACE,
+		INQUIRY,
+		MODE_SELECT,
+		MODE_SELECT_10,
+		MODE_SENSE,
+		MODE_SENSE_10,
+		PERSISTENT_RESERVE_IN,
+		PERSISTENT_RESERVE_OUT,
+		READ_10,
+		READ_12,
+		READ_BUFFER_CAP,
+		READ_CAPACITY,
+		READ_DISK_INFO,
+		READ_DVD_STRUCTURE,
+		READ_TOC,
+		READ_TRACK_INFO,
+		RELEASE,
+		REPORT_LUNS,
+		REQUEST_SENSE,
+		RESERVE,
+		SET_CD_SPEED,
+		SET_STREAMING,
+		START_STOP,
+		SYNCHRONIZE_CACHE,
+		TEST_UNIT_READY,
+		VERIFY_10,
+		WRITE_10,
+		WRITE_12,
+		WRITE_VERIFY,
+	};
+	bs_create_opcode_map(&mmc_bst, mmc_opcodes, ARRAY_SIZE(mmc_opcodes));
+	register_backingstore_template(&mmc_bst);
 }
diff --git a/usr/mmc.c b/usr/mmc.c
index 768fe91..edfea61 100644
--- a/usr/mmc.c
+++ b/usr/mmc.c
@@ -2207,10 +2207,10 @@ static tgtadm_err mmc_lu_init(struct scsi_lu *lu)
 	if (spc_lu_init(lu))
 		return TGTADM_NOMEM;
 
-	/* MMC devices always use rdwr backingstore */
-	bst = get_backingstore_template("rdwr");
+	/* MMC devices always use mmc backingstore */
+	bst = get_backingstore_template("mmc");
 	if (!bst) {
-		eprintf("failed to find bstype, rdwr\n");
+		eprintf("failed to find bstype, mmc\n");
 		return TGTADM_INVALID_REQUEST;
 	}
 	lu->bst = bst;
diff --git a/usr/scsi.h b/usr/scsi.h
index 1edcfd7..3569fd0 100644
--- a/usr/scsi.h
+++ b/usr/scsi.h
@@ -62,12 +62,17 @@
 #define WRITE_SAME            0x41
 #define UNMAP		      0x42
 #define READ_TOC              0x43
+#define GET_CONFIGURATION     0x46
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d
+#define READ_DISK_INFO        0x51
+#define READ_TRACK_INFO       0x52
 #define MODE_SELECT_10        0x55
 #define RESERVE_10            0x56
 #define RELEASE_10            0x57
 #define MODE_SENSE_10         0x5a
+#define CLOSE_TRACK           0x5b
+#define READ_BUFFER_CAP       0x5c
 #define PERSISTENT_RESERVE_IN 0x5e
 #define PERSISTENT_RESERVE_OUT 0x5f
 #define VARLEN_CDB            0x7f
@@ -89,6 +94,8 @@
 #define EXCHANGE_MEDIUM       0xa6
 #define READ_12               0xa8
 #define WRITE_12              0xaa
+#define GET_PERFORMACE        0xac
+#define READ_DVD_STRUCTURE    0xad
 #define WRITE_VERIFY_12       0xae
 #define VERIFY_12	      0xaf
 #define SEARCH_HIGH_12        0xb0
@@ -96,6 +103,8 @@
 #define SEARCH_LOW_12         0xb2
 #define READ_ELEMENT_STATUS   0xb8
 #define SEND_VOLUME_TAG       0xb6
+#define SET_STREAMING         0xb6
+#define SET_CD_SPEED          0xbb
 #define WRITE_LONG_2          0xea
 
 /* Service actions for opcode 0xa3 */
-- 
1.7.3.1
