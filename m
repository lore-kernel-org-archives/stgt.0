From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 1/2] Validate the DataOut length in WRITE_SAME_1*
Date: Sun,  2 Oct 2016 09:04:01 -0700
Message-ID: <1475424242-18168-2-git-send-email-ronniesahlberg@gmail.com>
References: <1475424242-18168-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OGBdUD8v67A2N1eZoUYB2cYl9NsztgfeU0mLJbAIjlc=;
        b=SiKRh7TTPoR4EJenPEqRgi7Y6S9Q+LAbaMfGLoa4CK+uynub2M5WeXa/eqBjID2B1P
         PGE6IPRyhhCbceE/LE+mcuujoF6o1lTtO/DiRUk/Us5JHk5cpgM6GAguGSp5hgQVLTdh
         QojPJnF69OE9wBs2Kc1X43S9xjOG7v4NtmYJevVlhNCmb4PVEMEwCtNNrrpf3pd8kObh
         4xbznCN+qIfupmAhavMmm1UyRF4q6mft+pnvThGx0BdzJR1QqT1TtJyKYObr+W5bnqXV
         sBPSGGt164nB+ek+y0cWYDi/8DJU58uJ74LjuLr9MgBMccqxohTKYIHpx9SxeC4CKtoz
         3tcQ==
In-Reply-To: <1475424242-18168-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: tomof@acm.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>

WRITE_SAME_1* takes either no data at all or exactly one block of data
as DataOut. Check for this and fail the cdb if the DataOut size differs.

(Some initiators use DataOut size == 0 (primarily together with unmap)
to mean "use a block all filled with 0" so that is why I think we
should be liberal and allow size==0 too here.)

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/sbc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/usr/sbc.c b/usr/sbc.c
index 8dbcd78..e58a233 100644
--- a/usr/sbc.c
+++ b/usr/sbc.c
@@ -245,6 +245,7 @@ static int sbc_rw(int host_no, struct scsi_cmd *cmd)
 	int ret;
 	uint64_t lba;
 	uint32_t tl;
+	size_t blocksize = 1 << cmd->dev->blk_shift;
 	unsigned char key = ILLEGAL_REQUEST;
 	uint16_t asc = ASC_LUN_NOT_SUPPORTED;
 	struct scsi_lu *lu = cmd->dev;
@@ -306,6 +307,13 @@ static int sbc_rw(int host_no, struct scsi_cmd *cmd)
 			asc = ASC_INVALID_FIELD_IN_CDB;
 			goto sense;
 		}
+		/* Fail of DataOut is neither ==0 or ==blocksize */
+		if (scsi_get_out_length(cmd) &&
+		    blocksize != scsi_get_out_length(cmd)) {
+			key = ILLEGAL_REQUEST;
+			asc = ASC_PARAMETER_LIST_LENGTH_ERR;
+			goto sense;
+		}
 		break;
 	}
 
-- 
2.5.0
