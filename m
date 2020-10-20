From: Apollon Oikonomopoulos <apoikos@debian.org>
Subject: [PATCH] Replace __packed with __attribute__(...)
Date: Tue, 20 Oct 2020 14:55:40 +0300
Message-ID: <20201020115541.184675-2-apoikos@debian.org>
References: <20201020115541.184675-1-apoikos@debian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20201020115541.184675-1-apoikos@debian.org>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org
Cc: Apollon Oikonomopoulos <apoikos@debian.org>

GCC 10 changed the default from -fcommon to -fno-common. This makes the
tgt build fail because of multiple definitions of __packed. Change all
instances of __packed to __attribute__((__packed__)), which is the
canonical attribute form.

Signed-off-by: Apollon Oikonomopoulos <apoikos@debian.org>
---
 usr/iscsi/iscsid.c | 2 +-
 usr/iscsi/iser.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/iscsi/iscsid.c b/usr/iscsi/iscsid.c
index a54a46e..476a760 100644
--- a/usr/iscsi/iscsid.c
+++ b/usr/iscsi/iscsid.c
@@ -1074,7 +1074,7 @@ void iscsi_rsp_set_residual(struct iscsi_cmd_rsp *rsp, struct scsi_cmd *scmd)
 struct iscsi_sense_data {
 	uint16_t length;
 	uint8_t  data[0];
-} __packed;
+} __attribute__((__packed__));
 
 static int iscsi_cmd_rsp_build(struct iscsi_task *task)
 {
diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index c7c43b2..2abb872 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -92,7 +92,7 @@ char *iser_portal_addr;
 struct iscsi_sense_data {
 	uint16_t length;
 	uint8_t data[0];
-} __packed;
+} __attribute__((__packed__));
 
 static size_t buf_pool_sz_mb = DEFAULT_POOL_SIZE_MB;
 static int cq_vector = -1;
-- 
2.28.0

