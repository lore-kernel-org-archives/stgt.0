From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] smc: fix snprintf warnings with gcc7
Date: Fri, 28 Jul 2017 11:34:15 +0900 (JST)
Message-ID: <20170728.113415.1898388363586159156.tomof@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 usr/smc.c  | 11 ++++++++---
 usr/util.h | 14 ++++++++++++++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/usr/smc.c b/usr/smc.c
index fb0143d..b80aba2 100644
--- a/usr/smc.c
+++ b/usr/smc.c
@@ -161,9 +161,9 @@ static int add_element_descriptor(uint8_t *data, struct slot *s,
 	i = 12;
 	if (voltag) {
 		if (s->volume_tag[0] != ' ' && s->volume_tag[0] != '\0')
-			snprintf((char *)&data[i], 32, "%-32s", s->volume_tag);
+			scsi_sprintf((char *)&data[i], 32, "%-32s", s->volume_tag);
 		else if (s->barcode[0] != ' ' && s->barcode[0] != '\0')
-			snprintf((char *)&data[i], 32, "%-32s", s->barcode);
+			scsi_sprintf((char *)&data[i], 32, "%-32s", s->barcode);
 		else
 			memset(&data[i], 0x20, 32);
 
@@ -181,7 +181,12 @@ static int add_element_descriptor(uint8_t *data, struct slot *s,
 		data[i + 3] = 34;	/* Length */
 		snprintf((char *)&data[i + 4], 9, "%-8s", attr->vendor_id);
 		snprintf((char *)&data[i + 12], 17, "%-16s", attr->product_id);
-		snprintf((char *)&data[i + 28], 11, "%-10s", attr->scsi_sn);
+		{
+			char buf[sizeof(attr->scsi_sn) + 1];
+			memset(buf, 0, sizeof(buf));
+			snprintf(buf, sizeof(buf), "%-s", attr->scsi_sn);
+			memcpy((char *)&data[i + 28], buf, 10);
+		}
 	}
 
 	return determine_element_sz(dvcid, voltag);
diff --git a/usr/util.h b/usr/util.h
index 256bdb8..fe82554 100644
--- a/usr/util.h
+++ b/usr/util.h
@@ -240,4 +240,18 @@ static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
 }
 
+static inline int scsi_sprintf(char *str, size_t size, const char *format, ...)
+{
+	va_list args;
+	char buf[size + 1];
+	int n;
+
+	memset(buf, 0, sizeof(buf));
+	va_start(args, format);
+	n = snprintf(buf, sizeof(buf), format, args);
+	va_end(args);
+	memcpy(str, buf, size);
+	return n;
+}
+
 #endif
-- 
2.1.4
