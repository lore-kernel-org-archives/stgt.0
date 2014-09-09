From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] SMC: add a smc backend template with an opcode whitelist
Date: Mon,  8 Sep 2014 19:53:09 -0700
Message-ID: <1410231190-28735-2-git-send-email-ronniesahlberg@gmail.com>
References: <1410231190-28735-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ksgJmYVGsOCeTUSvofkVK9RT9z/oObrpS588Njz1EJY=;
        b=I1IKMzP98pC7DsaDL/NbsPm5BnwaETBcdvaMNPdcXpIJyShBFvclXJTaBRJDjpDyW4
         stiO4E3vT+Mlo/NfJNWGMDguuOXJzCfwn2zx4HHdxgJg/VCj0tWHtp6VZAwcsmP18wDr
         EIPkdW9ISWFyC2vx0ZQcYImmv7Ad0rr29AKWoVT3LA877yJpimfhDUAjLXxoRlu/OxLN
         t35RYSpjF7rJaR2hzZFoKFDuRXPnOy6ycUhyrv0sQOHQ0xTLJSQDOF5bhefpth0KbeKm
         M1nt6ZnP3+AzVST8j2zTs+Ev19Er1mMNi1baDRJ49uLmK3mocyyeBLx9GrvY6l89XOhv
         NPJg==
In-Reply-To: <1410231190-28735-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>

SMC is not working properly since we do not yet initialize a proper
SMC backend to tell it which opcodes are valid and which are not.
With this change SMC works again and we can create a jukebox that
mtx can communicate with correctly.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/bs_rdwr.c |   33 +++++++++++++++++++++++++++++++++
 usr/scsi.h    |    1 +
 usr/smc.c     |    9 +++++++++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/usr/bs_rdwr.c b/usr/bs_rdwr.c
index 2769a0d..56d086d 100644
--- a/usr/bs_rdwr.c
+++ b/usr/bs_rdwr.c
@@ -434,6 +434,17 @@ static struct backingstore_template mmc_bst = {
 	.bs_oflags_supported    = O_SYNC | O_DIRECT,
 };
 
+static struct backingstore_template smc_bst = {
+	.bs_name		= "smc",
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
 	unsigned char sbc_opcodes[] = {
@@ -519,4 +530,26 @@ __attribute__((constructor)) static void bs_rdwr_constructor(void)
 	};
 	bs_create_opcode_map(&mmc_bst, mmc_opcodes, ARRAY_SIZE(mmc_opcodes));
 	register_backingstore_template(&mmc_bst);
+
+	unsigned char smc_opcodes[] = {
+		INITIALIZE_ELEMENT_STATUS,
+		INITIALIZE_ELEMENT_STATUS_WITH_RANGE,
+		INQUIRY,
+		MAINT_PROTOCOL_IN,
+		MODE_SELECT,
+		MODE_SELECT_10,
+		MODE_SENSE,
+		MODE_SENSE_10,
+		MOVE_MEDIUM,
+		PERSISTENT_RESERVE_IN,
+		PERSISTENT_RESERVE_OUT,
+		REQUEST_SENSE,
+		TEST_UNIT_READY,
+		READ_ELEMENT_STATUS,
+		RELEASE,
+		REPORT_LUNS,
+		RESERVE,
+	};
+	bs_create_opcode_map(&smc_bst, smc_opcodes, ARRAY_SIZE(smc_opcodes));
+	register_backingstore_template(&smc_bst);
 }
diff --git a/usr/scsi.h b/usr/scsi.h
index 3569fd0..6d0a2a5 100644
--- a/usr/scsi.h
+++ b/usr/scsi.h
@@ -50,6 +50,7 @@
 #define SYNCHRONIZE_CACHE     0x35
 #define LOCK_UNLOCK_CACHE     0x36
 #define READ_DEFECT_DATA      0x37
+#define INITIALIZE_ELEMENT_STATUS_WITH_RANGE 0x37
 #define MEDIUM_SCAN           0x38
 #define COMPARE               0x39
 #define COPY_VERIFY           0x3a
diff --git a/usr/smc.c b/usr/smc.c
index 910b532..9a40bdb 100644
--- a/usr/smc.c
+++ b/usr/smc.c
@@ -493,6 +493,7 @@ sense:
 
 static tgtadm_err smc_lu_init(struct scsi_lu *lu)
 {
+	struct backingstore_template *bst;
 	struct smc_info *smc;
 	tgtadm_err adm_err;
 
@@ -505,6 +506,14 @@ static tgtadm_err smc_lu_init(struct scsi_lu *lu)
 	if (spc_lu_init(lu))
 		return TGTADM_NOMEM;
 
+	/* SMC devices always use smc backingstore */
+	bst = get_backingstore_template("smc");
+	if (!bst) {
+		eprintf("failed to find bstype, smc\n");
+		return TGTADM_INVALID_REQUEST;
+	}
+	lu->bst = bst;
+
 	strncpy(lu->attrs.product_id, "VIRTUAL-CHANGER",
 						sizeof(lu->attrs.product_id));
 	lu->attrs.version_desc[0] = 0x0480; /* SMC-3 no version claimed */
-- 
1.7.3.1
