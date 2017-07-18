From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 2/2] Remove incorrect size specifier in spc_lu_init
Date: Tue, 18 Jul 2017 13:52:58 -0700
Message-ID: <20170718205258.6246-3-agrover@redhat.com>
References: <20170718205258.6246-1-agrover@redhat.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com BA0D880477
In-Reply-To: <20170718205258.6246-1-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

The vendor_id field is only 9 bytes, so GCC 7 complains when a size
specifier of 16 is given.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 usr/spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/spc.c b/usr/spc.c
index cdb8a2a..82a6ec9 100644
--- a/usr/spc.c
+++ b/usr/spc.c
@@ -2069,7 +2069,7 @@ int spc_lu_init(struct scsi_lu *lu)
 	lu->attrs.sense_format = 0;
 
 	snprintf(lu->attrs.vendor_id, sizeof(lu->attrs.vendor_id),
-		 "%-16s", VENDOR_ID);
+		 "%-s", VENDOR_ID);
 	snprintf(lu->attrs.product_rev, sizeof(lu->attrs.product_rev),
 		 "%s", "0001");
 	snprintf(lu->attrs.scsi_id, sizeof(lu->attrs.scsi_id),
-- 
2.9.4
