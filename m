From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] sbc.c: report DPO/FUA support in modesense datain
Date: Fri,  5 Dec 2014 06:51:59 -0800
Message-ID: <1417791119-30801-2-git-send-email-ronniesahlberg@gmail.com>
References: <1417791119-30801-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EVCw+Yo4u+r2gUWml464QwE7+xAbjTRk0+Rw8QI//kE=;
        b=T6+BXfN/T9xPJqAM8ZsAC7Pf03ZRyhmN0snSNK1QGIyNqUuJ8HGNu7V2ALGnbxNbKu
         fuOYQWr+9GnQyQLOz4ztIN5sAkO8rJcrUvCRYmCrG7Roj5PH46lLVTI+N0h+9Hd9RgSz
         zZwwxiC8KRsxfV03QkWJRvzzP69q+gYp4SeNJCR097nCsbLjNjCxI+LlaSTgBXrtRGDZ
         t9LwHzGHDSzMvNgPUbAkO5ZBs0Wv+W4DJjkOuPxxpiy3Icucn4WSTBhS05VMeN3c2apL
         mqeW9U7QFs2yCD8NVCU1u5EtWepl8nCAH1sHCBURJFabYq9dajydPdFMzaPg7G+7uxr0
         VBvQ==
In-Reply-To: <1417791119-30801-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

We already do support DPO in the bs_rdwr backend and we pass DPO==1 as a
hint to the kernel using POSIX_FADV_NOREUSE for WRITE_10/12/16.
The idea here is that IF DPO==1 then this is a hint from the initiator that
we should not cache the data. TGTD itself does not do any caching but the
pagecache on the host might, hence the POSIX_FADV_NOREUSE hint.

So we already do support some basic DPO functionality in bs_rdwr.c. For the
other backends we do not yet, but all those backends ignore the DPO bit
anyway (i.e. they will not fail the command with INVALID_FIELD_IN_CDB).

This patch sets the 0x10 flag in the device specific parameters for block
device mode pages so that we tell the initiator that we support DPO (and FUA).

With this patch the linux kernel initiator now recognizes that it may use
DPO/FUA. As will hopefully other initiators as well.
[160973.210942] sd 18:0:0:2: Attached scsi generic sg15 type 0
[160973.211761] sd 18:0:0:1: [sdk] Write Protect is off
[160973.211765] sd 18:0:0:1: [sdk] Mode Sense: 69 00 10 08
[160973.211868] sd 18:0:0:1: [sdk] Write cache: enabled, read cache: enabled,
supports DPO and FUA

Supporting DPO can have a positive performance impact since it can allow
more efficient use of the target cache. I.e. an initiator can hint to the
target which writes should not pollute the cache.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/sbc.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/usr/sbc.c b/usr/sbc.c
index c4f012c..8dbcd78 100644
--- a/usr/sbc.c
+++ b/usr/sbc.c
@@ -120,27 +120,28 @@ static int sbc_mode_select(int host_no, struct scsi_cmd *cmd)
 static int sbc_mode_sense(int host_no, struct scsi_cmd *cmd)
 {
 	int ret;
+	uint8_t device_specific = 0x10; /* DPOFUA */
+	uint8_t mode6, *data;
 
 	ret = spc_mode_sense(host_no, cmd);
+	if (ret != SAM_STAT_GOOD)
+		return ret;
 
 	/*
-	 * If this is a read-only lun, we must modify the data and set the
-	 * write protect bit
+	 * If this is a read-only lun, we must set the write protect bit
 	 */
-	if ((cmd->dev->attrs.readonly || cmd->dev->attrs.swp)
-	&& ret == SAM_STAT_GOOD) {
-		uint8_t *data, mode6;
+	if (cmd->dev->attrs.readonly || cmd->dev->attrs.swp)
+		device_specific |= 0x80;
 
-		mode6 = (cmd->scb[0] == 0x1a);
-		data = scsi_get_in_buffer(cmd);
+	data = scsi_get_in_buffer(cmd);
 
-		if (mode6)
-			data[2] |= 0x80;
-		else
-			data[3] |= 0x80;
-	}
+	mode6 = (cmd->scb[0] == 0x1a);
+	if (mode6)
+		data[2] = device_specific;
+	else
+		data[3] = device_specific;
 
-	return ret;
+	return SAM_STAT_GOOD;
 }
 
 static int sbc_format_unit(int host_no, struct scsi_cmd *cmd)
-- 
2.1.0
