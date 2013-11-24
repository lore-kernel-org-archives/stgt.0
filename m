From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] REPORT SUPPORTED OPCODES: Only return opcodes supported by the backend.
Date: Sun, 24 Nov 2013 15:02:33 -0800
Message-ID: <1385334153-12171-2-git-send-email-ronniesahlberg@gmail.com>
References: <1385334153-12171-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OGH+8cziN+Xj3VWMxQxZVFvINITRqzQvKSRRYcZQ0t8=;
        b=RbNHo3rji2xtZrKNwC33uRGolh5Zj83scwr3aOy4i0iKzbqMs5pN7+Hskb0d1p9iVr
         PwdQ+9gnwgqlKPjE9St86bP2FMmRCLoycxddAz/BbutBFjh6cztVDiGGvVOBzQqpOvWq
         +45nDkDa+NE4l9Ai67Hhr9T1ylz1t/AQcthAV+mpRgEEXZCIz71sS+yA+h7FZQ6dI6ny
         cGwi+XpSkOv6RchGxNK8E88sDq4RTAoeCFxBXiy8Q3+7VwGsElO0Y9ruly5a4rpPm5XP
         qBgvLSZS5ioz5BEoa+rPILq/1xy6I0c3EtjqqQkszr5vkyOcv/+AUEexMwr+6FMdC+h7
         nxdw==
In-Reply-To: <1385334153-12171-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/spc.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/usr/spc.c b/usr/spc.c
index 88fdf7d..9faa705 100644
--- a/usr/spc.c
+++ b/usr/spc.c
@@ -739,6 +739,9 @@ static int report_opcodes_all(struct scsi_cmd *cmd, int rctd,
 		if (ops[i].cmd_perform == spc_illegal_op)
 			continue;
 
+		if (!is_bs_support_opcode(cmd->dev->bst, i))
+			continue;
+
 		/* this command does not take a service action, so just
 		   report the opcode
 		*/
@@ -826,6 +829,9 @@ static int report_opcode_one(struct scsi_cmd *cmd, int rctd, uint8_t opcode,
 
 	ops = cmd->dev->dev_type_template.ops;
 
+	if (!is_bs_support_opcode(cmd->dev->bst, opcode))
+		return SAM_STAT_CHECK_CONDITION;
+
 	if ((is_service_action && !ops[opcode].service_actions)
 	||  (!is_service_action && ops[opcode].service_actions)) {
 		return SAM_STAT_CHECK_CONDITION;
-- 
1.7.3.1
