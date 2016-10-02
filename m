From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 2/2] WRITE_SAME_* TL==0 means all blocks from LBA until the end of device.
Date: Sun,  2 Oct 2016 09:04:02 -0700
Message-ID: <1475424242-18168-3-git-send-email-ronniesahlberg@gmail.com>
References: <1475424242-18168-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=93HPbk0iEx6XlrYAFA+9wHFKOT31fpsteoLnVmCtqIs=;
        b=1FEqSG/iXyGs3fsxaI4wWkUdawjbC71nut906xoNMR1/N6X6jLmngQrlLyByZjgJud
         b1KXI9wfX7fVTilXkslg4DeRKxxU1oYf2vntHD1kkbSv3wzMHOelm4RIcjv4mBEMFMqa
         G3gPL/EKHRFLvOulLGMa55K2jQvsN3dn6SD/1Qhbuno4DdyysM/DVGqIrpt4gjYtBTJ5
         2yNR/E/lvbMf1gnApRm6cn+LcpCsqGU5lAQdmvH0dmcTuT2gl5lfrwNhgF7NyBr7bvpW
         jIDgvM48EScG3KvE25LSBkr1h6GOR7CR/4tu2kuEVV2N58yJBZXkb02rqHJpsn/A/ED3
         Atcw==
In-Reply-To: <1475424242-18168-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: tomof@acm.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/sbc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/usr/sbc.c b/usr/sbc.c
index e58a233..779dacd 100644
--- a/usr/sbc.c
+++ b/usr/sbc.c
@@ -260,6 +260,9 @@ static int sbc_rw(int host_no, struct scsi_cmd *cmd)
 		goto sense;
 	}
 
+	lba = scsi_rw_offset(cmd->scb);
+	tl  = scsi_rw_count(cmd->scb);
+
 	switch (cmd->scb[0]) {
 	case READ_10:
 	case READ_12:
@@ -314,6 +317,10 @@ static int sbc_rw(int host_no, struct scsi_cmd *cmd)
 			asc = ASC_PARAMETER_LIST_LENGTH_ERR;
 			goto sense;
 		}
+		/* TL == 0 means all LBAs until end of device */
+		if (tl == 0)
+			tl = (lu->size >> cmd->dev->blk_shift) - lba;
+
 		break;
 	}
 
@@ -339,9 +346,6 @@ static int sbc_rw(int host_no, struct scsi_cmd *cmd)
 		}
 	}
 
-	lba = scsi_rw_offset(cmd->scb);
-	tl  = scsi_rw_count(cmd->scb);
-
 	/* Verify that we are not doing i/o beyond
 	   the end-of-lun */
 	if (tl) {
-- 
2.5.0
