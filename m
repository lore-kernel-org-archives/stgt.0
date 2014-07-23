From: Ruoyu <liangry@ucweb.com>
Subject: [PATCH] bs_ssc: remove unused variables
Date: Wed, 23 Jul 2014 10:44:10 +0800
Message-ID: <1406083450-29957-1-git-send-email-liangry@ucweb.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ruoyu <liangry@ucweb.com>

The variables, transfer_length and residue are never used in the
function tape_rdwr_request()

Signed-off-by: Ruoyu <liangry@ucweb.com>
---
 usr/bs_ssc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/usr/bs_ssc.c b/usr/bs_ssc.c
index a7e062d..fe1ff18 100644
--- a/usr/bs_ssc.c
+++ b/usr/bs_ssc.c
@@ -435,7 +435,7 @@ static void tape_rdwr_request(struct scsi_cmd *cmd)
 	struct ssc_info *ssc = dtype_priv(cmd->dev);
 	struct blk_header_info *h = &ssc->c_blk;
 	int ret, code;
-	uint32_t length, i, transfer_length, residue;
+	uint32_t length, i;
 	int result = SAM_STAT_GOOD;
 	uint8_t *buf;
 	int32_t count;
@@ -446,8 +446,6 @@ static void tape_rdwr_request(struct scsi_cmd *cmd)
 	ret = 0;
 	length = 0;
 	i = 0;
-	transfer_length = 0;
-	residue = 0;
 	code = 0;
 	ssc = dtype_priv(cmd->dev);
 
-- 
1.8.3.2

