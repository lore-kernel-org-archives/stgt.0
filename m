From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH V1] spc: Support NAA IEEE Registered Extended field in VPD page 0x83
Date: Thu, 13 Mar 2014 11:40:37 +0200
Message-ID: <1394703637-13010-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, oren@mellanox.com, Dennis Cullison <Dennis.Cullison@Teradata.com>, Or Gerlitz <ogerlitz@mellanox.com>

From: Dennis Cullison <Dennis.Cullison@Teradata.com>

Enables support for the NAA IEEE Registered Extended field in the
inquiry VPD page 0x83. This field is used by multi-pathing
software for device persistency.

Signed-off-by: Dennis Cullison <Dennis.Cullison@Teradata.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
---

changes from V0:
 - fixed the patch to work when a long is 32 bits by using uint64_t type
 - added some comments within the code as asked by Tomo

 usr/spc.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/usr/spc.c b/usr/spc.c
index 29f39a9..cdb8a2a 100644
--- a/usr/spc.c
+++ b/usr/spc.c
@@ -145,6 +145,12 @@ static void update_vpd_83(struct scsi_lu *lu, void *id)
 	struct vpd *vpd_pg = lu->attrs.lu_vpd[PCODE_OFFSET(0x83)];
 	uint8_t	*data = vpd_pg->data;
 
+	char *id_str = id;
+	char substring[] = "0";
+	uint64_t a = 0;
+	uint64_t b = 0;
+	uint64_t c;
+
 	data[0] = INQ_CODE_ASCII;
 	data[1] = DESG_T10;
 	data[3] = SCSI_ID_LEN;
@@ -160,6 +166,30 @@ static void update_vpd_83(struct scsi_lu *lu, void *id)
 
 	put_unaligned_be64(lu->attrs.numeric_id, data);
 	data[0] |= NAA_LOCAL << 4;
+
+	data += NAA_DESG_LEN;
+	data[0] = INQ_CODE_BIN;
+	data[1] = DESG_NAA;
+	data[3] = NAA_DESG_LEN_EXTD;
+	data += DESG_HDR_LEN;
+	/*
+	 * The NAA_DESG_LEN_EXTD field is a 128 bit field
+	 * which contains a numeric value. This loop converts
+	 * the string pointed to by 'id_str' into a right
+	 * adjusted numeric value.
+	 */
+	while (*id_str) {
+		substring[0] = *id_str++;
+		c = a >> 60;
+		a <<= 4;
+		b <<= 4;
+		b |= c;
+		a |= strtoul(substring, NULL, 16);
+	}
+	put_unaligned_be64(b, data);
+	put_unaligned_be64(a, data + 8);
+	data[0] &= 0x0F;
+	data[0] |= NAA_IEEE_REGD_EXTD << 4;
 }
 
 static void update_vpd_b2(struct scsi_lu *lu, void *id)
@@ -2060,7 +2090,7 @@ int spc_lu_init(struct scsi_lu *lu)
 
 	/* VPD page 0x83 */
 	pg = PCODE_OFFSET(0x83);
-	lu_vpd[pg] = alloc_vpd(2*DESG_HDR_LEN + NAA_DESG_LEN + SCSI_ID_LEN);
+	lu_vpd[pg] = alloc_vpd(3*DESG_HDR_LEN + NAA_DESG_LEN + SCSI_ID_LEN + NAA_DESG_LEN_EXTD);
 	if (!lu_vpd[pg])
 		return -ENOMEM;
 	lu_vpd[pg]->vpd_update = update_vpd_83;
-- 
1.7.1
