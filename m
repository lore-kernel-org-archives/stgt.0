From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: spc: Support NAA IEEE Registered Extended field in VPD page 0x83
Date: Tue, 25 Feb 2014 14:54:13 +0200
Message-ID: <1393332853-12965-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Dennis Cullison <Dennis.Cullison@Teradata.com>, Or Gerlitz <ogerlitz@mellanox.com>

From: Dennis Cullison <Dennis.Cullison@Teradata.com>

Enables support for the NAA IEEE Registered Extended field in the
inquiry VPD page 0x83. This field is used by multi-pathing
software for device persistency.

Signed-off-by: Dennis Cullison <Dennis.Cullison@Teradata.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
---

Hi Tomo, 

This fix is from Dennis Cullison who asked me to assist in submission

Or.

 usr/spc.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/usr/spc.c b/usr/spc.c
index 29f39a9..0dd590f 100644
--- a/usr/spc.c
+++ b/usr/spc.c
@@ -145,6 +145,12 @@ static void update_vpd_83(struct scsi_lu *lu, void *id)
 	struct vpd *vpd_pg = lu->attrs.lu_vpd[PCODE_OFFSET(0x83)];
 	uint8_t	*data = vpd_pg->data;
 
+	char *id_str = id;
+	char subs[] = "0";
+	unsigned long a = 0;
+	unsigned long b = 0;
+	unsigned long c;
+
 	data[0] = INQ_CODE_ASCII;
 	data[1] = DESG_T10;
 	data[3] = SCSI_ID_LEN;
@@ -160,6 +166,24 @@ static void update_vpd_83(struct scsi_lu *lu, void *id)
 
 	put_unaligned_be64(lu->attrs.numeric_id, data);
 	data[0] |= NAA_LOCAL << 4;
+
+	data += NAA_DESG_LEN;
+	data[0] = INQ_CODE_BIN;
+	data[1] = DESG_NAA;
+	data[3] = NAA_DESG_LEN_EXTD;
+	data += DESG_HDR_LEN;
+	while (*id_str) {
+		subs[0] = *id_str++;
+		c = a >> 60;
+		a <<= 4;
+		b <<= 4;
+		b |= c;
+		a |= strtoul(subs, NULL, 16);
+	}
+	put_unaligned_be64(b, data);
+	put_unaligned_be64(a, data + 8);
+	data[0] &= 0x0F;
+	data[0] |= NAA_IEEE_REGD_EXTD << 4;
 }
 
 static void update_vpd_b2(struct scsi_lu *lu, void *id)
@@ -2060,7 +2084,7 @@ int spc_lu_init(struct scsi_lu *lu)
 
 	/* VPD page 0x83 */
 	pg = PCODE_OFFSET(0x83);
-	lu_vpd[pg] = alloc_vpd(2*DESG_HDR_LEN + NAA_DESG_LEN + SCSI_ID_LEN);
+	lu_vpd[pg] = alloc_vpd(3*DESG_HDR_LEN + NAA_DESG_LEN + SCSI_ID_LEN + NAA_DESG_LEN_EXTD);
 	if (!lu_vpd[pg])
 		return -ENOMEM;
 	lu_vpd[pg]->vpd_update = update_vpd_83;
-- 
1.7.1
