From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v4 RFC 1/5] tgtd: add helper functions for checking iostate of iscsi connections
Date: Fri, 14 Feb 2014 20:21:29 +0900
Message-ID: <1392376893-26106-2-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1392376893-26106-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1392376893-26106-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

This patch adds helper functions for checking iostate of iscsi
connections from outside of iscsid.c. These functions will be used in
iscsi_tcp.c in the future commits.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/iscsi/iscsid.c |   20 ++++++++++++++++++++
 usr/iscsi/iscsid.h |    4 ++++
 2 files changed, 24 insertions(+)

diff --git a/usr/iscsi/iscsid.c b/usr/iscsi/iscsid.c
index 30bd13f..c472608 100644
--- a/usr/iscsi/iscsid.c
+++ b/usr/iscsi/iscsid.c
@@ -76,6 +76,26 @@ enum {
 	IOSTATE_TX_END,
 };
 
+int is_conn_rx_bhs(struct iscsi_connection *conn)
+{
+	return conn->rx_iostate == IOSTATE_RX_BHS;
+}
+
+int is_conn_rx_init_ahs(struct iscsi_connection *conn)
+{
+	return conn->rx_iostate == IOSTATE_RX_INIT_AHS;
+}
+
+int is_conn_rx_end(struct iscsi_connection *conn)
+{
+	return conn->rx_iostate == IOSTATE_RX_END;
+}
+
+int is_conn_tx_end(struct iscsi_connection *conn)
+{
+	return conn->tx_iostate == IOSTATE_TX_END;
+}
+
 void conn_read_pdu(struct iscsi_connection *conn)
 {
 	conn->rx_iostate = IOSTATE_RX_BHS;
diff --git a/usr/iscsi/iscsid.h b/usr/iscsi/iscsid.h
index c7f6801..01d0002 100644
--- a/usr/iscsi/iscsid.h
+++ b/usr/iscsi/iscsid.h
@@ -336,6 +336,10 @@ extern int iscsi_param_parse_portals(char *p, int do_add, int do_delete);
 extern void iscsi_update_conn_stats_rx(struct iscsi_connection *conn, int size, int opcode);
 extern void iscsi_update_conn_stats_tx(struct iscsi_connection *conn, int size, int opcode);
 extern void iscsi_rsp_set_residual(struct iscsi_cmd_rsp *rsp, struct scsi_cmd *scmd);
+extern int is_conn_rx_bhs(struct iscsi_connection *conn);
+extern int is_conn_rx_init_ahs(struct iscsi_connection *conn);
+extern int is_conn_rx_end(struct iscsi_connection *conn);
+extern int is_conn_tx_end(struct iscsi_connection *conn);
 
 /* iscsid.c iscsi_task */
 extern void iscsi_free_task(struct iscsi_task *task);
-- 
1.7.10.4
