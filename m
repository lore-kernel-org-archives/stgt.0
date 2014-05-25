From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH 1/2] iser: make membuf size configurable
Date: Sun, 25 May 2014 14:10:25 +0300
Message-ID: <1401016226-3404-2-git-send-email-roid@mellanox.com>
References: <1401016226-3404-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1401016226-3404-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

membuf size is the max size of one rdma buffer used.
The default is still 512 as was but a user can now change it
to 1024 for example to be able to use bigger block sizes.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/iscsi/iser.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index d748184..35c6faa 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -76,7 +76,7 @@ char *iser_portal_addr;
  */
 #define MAX_WQE 1800
 
-#define RDMA_TRANSFER_SIZE  (512 * 1024)
+#define DEFAULT_RDMA_TRANSFER_SIZE  (512 * 1024)
 
 #define MAX_POLL_WC 32
 
@@ -97,7 +97,7 @@ static size_t buf_pool_sz_mb = DEFAULT_POOL_SIZE_MB;
 static int cq_vector = -1;
 
 static int membuf_num;
-static size_t membuf_size = RDMA_TRANSFER_SIZE;
+static size_t membuf_size = DEFAULT_RDMA_TRANSFER_SIZE;
 
 static int iser_conn_get(struct iser_conn *conn);
 static int iser_conn_getn(struct iser_conn *conn, int n);
@@ -1166,8 +1166,7 @@ int iser_login_complete(struct iscsi_connection *iscsi_conn)
 
 	/* How much data to grab in an RDMA operation, read or write */
 	/* ToDo: fix iscsi login code, broken handling of MAX_XMIT_DL */
-	iscsi_conn->session_param[ISCSI_PARAM_MAX_XMIT_DLENGTH].val =
-		RDMA_TRANSFER_SIZE;
+	iscsi_conn->session_param[ISCSI_PARAM_MAX_XMIT_DLENGTH].val = membuf_size;
 out:
 	return err;
 }
@@ -3492,6 +3491,7 @@ static const char *lld_param_nop = "nop";
 static const char *lld_param_on = "on";
 static const char *lld_param_off = "off";
 static const char *lld_param_pool_sz_mb = "pool_sz_mb";
+static const char *lld_param_buf_sz_kb = "buf_sz_kb";
 static const char *lld_param_cq_vector = "cq_vector";
 
 static int iser_param_parser(char *p)
@@ -3531,6 +3531,13 @@ static int iser_param_parser(char *p)
 			buf_pool_sz_mb = atoi(q);
 			if (buf_pool_sz_mb < 128)
 				buf_pool_sz_mb = 128;
+		} else if (!strncmp(p, lld_param_buf_sz_kb,
+				    strlen(lld_param_buf_sz_kb))) {
+			q = p + strlen(lld_param_buf_sz_kb) + 1;
+			membuf_size = atoi(q);
+			if (membuf_size < 1)
+				membuf_size = 1;
+			membuf_size = membuf_size * 1024;
 		} else if (!strncmp(p, lld_param_cq_vector,
 				    strlen(lld_param_cq_vector))) {
 			q = p + strlen(lld_param_cq_vector) + 1;
-- 
1.7.1
