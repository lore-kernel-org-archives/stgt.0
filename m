From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] bs_rdwr.c: add missing MMC opcodes to the backing store defs
Date: Tue, 19 Aug 2014 20:00:09 -0700
Message-ID: <1408503609-11688-2-git-send-email-ronniesahlberg@gmail.com>
References: <1408503609-11688-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QR/VnD3AV9f7kEcRG1CKSfYNyj2Unmg5ryNabZa9OHM=;
        b=OIP8Ktj2W03dYxMPbd59hI1anD2uC9uBlPtIDT0p2aOSTzMaDoH3IPyCgSIWLmMsez
         3BJXcYxCkFFQooybkDtjGbqf1oCyUAeXvF5OvDDqNgf4c0n7t9C1bUlXzYoJQ4rYOfwb
         dcaPng7brQhfpp+hj5tL5nGTc5/ip8GPMnCWNqZNFv9BiL5CNRUykfJkUXy0LfEfw7/F
         ToOPwhSrnrHBKRGrDY592XYhvD4ON0IlUdX5iJHjpyblv4ILDDdwD1LwbDwK1Xw0wLUL
         NTA3JTn2Gq8UOcL1wvjySAN12QKV0UcfCfltiJGGvQO1fp8i5tBKuaUUJJu2LGHFfjzK
         TumA==
In-Reply-To: <1408503609-11688-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

MMC devices also use the rdwr backend so we need to specify its specific
opcodes in the supported opcode map.
Otherwise we will be returning "INVALID_OPCODE" for initiators that try
to connect.

This fixes the MMC emulation so that initiators will be able to connect
and access the media again.

This has been broken for a while, which probably means few people use
the funky MMC emulation in tgtd :-(

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/bs_rdwr.c |   10 ++++++++++
 usr/scsi.h    |    9 +++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/usr/bs_rdwr.c b/usr/bs_rdwr.c
index a6301a7..e2e32ed 100644
--- a/usr/bs_rdwr.c
+++ b/usr/bs_rdwr.c
@@ -427,8 +427,11 @@ __attribute__((constructor)) static void bs_rdwr_constructor(void)
 {
 	unsigned char opcodes[] = {
 		ALLOW_MEDIUM_REMOVAL,
+		CLOSE_TRACK,
 		COMPARE_AND_WRITE,
 		FORMAT_UNIT,
+		GET_CONFIGURATION,
+		GET_PERFORMACE,
 		INQUIRY,
 		MAINT_PROTOCOL_IN,
 		MODE_SELECT,
@@ -444,13 +447,20 @@ __attribute__((constructor)) static void bs_rdwr_constructor(void)
 		READ_12,
 		READ_16,
 		READ_6,
+		READ_BUFFER_CAP,
 		READ_CAPACITY,
+		READ_DISK_INFO,
+		READ_DVD_STRUCTURE,
+		READ_TOC,
+		READ_TRACK_INFO,
 		RELEASE,
 		REPORT_LUNS,
 		REQUEST_SENSE,
 		RESERVE,
 		SEND_DIAGNOSTIC,
 		SERVICE_ACTION_IN,
+		SET_CD_SPEED,
+		SET_STREAMING,
 		START_STOP,
 		SYNCHRONIZE_CACHE,
 		SYNCHRONIZE_CACHE_16,
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
