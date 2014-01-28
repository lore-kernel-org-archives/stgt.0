From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH] iser: Add Discovery support
Date: Tue, 28 Jan 2014 11:17:59 +0200
Message-ID: <1390900679-30187-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, roid@mellanox.com, oren@mellanox.com, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <nezhinsky@gmail.com>

Add support to handle TEXT PDU, such as SendTargets which are used i
for running iscsi discovery over iser. 

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Alexander Nezhinsky <nezhinsky@gmail.com>
---
 usr/iscsi/iser.c      |    4 ++++
 usr/iscsi/iser_text.c |   40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index 0f4a893..7a0d20c 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -2597,7 +2597,9 @@ static int iser_task_delivery(struct iser_task *task)
 		break;
 	case ISCSI_OP_TEXT:
 		err = iser_text_exec(&conn->h, &task->pdu, &conn->text_tx_task->pdu);
+		schedule_resp_tx(conn->text_tx_task, conn);
 		break;
+
 	default:
 		eprintf("Internal error: Unexpected op:0x%x\n", task->opcode);
 		err = -EINVAL;
@@ -2829,6 +2831,8 @@ static void iser_rx_handler(struct iser_work_req *rxd)
 			break;
 		case ISCSI_OP_TEXT:
 			dprintf("text rx\n");
+			err = iser_task_delivery(task);
+			queue_task = 0;
 			break;
 		case ISCSI_OP_SNACK:
 			eprintf("Cannot handle SNACK yet\n");
diff --git a/usr/iscsi/iser_text.c b/usr/iscsi/iser_text.c
index 6617a34..08cdfe5 100644
--- a/usr/iscsi/iser_text.c
+++ b/usr/iscsi/iser_text.c
@@ -588,6 +588,12 @@ static void iser_login_finish(struct iscsi_connection *iscsi_conn,
 		iscsi_conn->tsih = iscsi_conn->session->tsih;
 		break;
 	case SESSION_DISCOVERY:
+		err = iser_login_complete(iscsi_conn);
+		if (err) {
+			class = ISCSI_STATUS_CLS_TARGET_ERR;
+			detail = ISCSI_LOGIN_STATUS_NO_RESOURCES;
+			goto fail;
+		}
 		/* set a dummy tsih value */
 		iscsi_conn->tsih = 1;
 		break;
@@ -785,6 +791,32 @@ auth_err:
 	return;
 }
 
+
+void iser_target_list_build(struct iscsi_connection *conn, struct iser_pdu *tx_pdu, char *addr, char *name)
+{
+	struct iscsi_target *target;
+
+	list_for_each_entry(target, &iscsi_targets_list, tlist) {
+		if (name && strcmp(tgt_targetname(target->tid), name))
+			continue;
+
+		if (!target->rdma)
+			continue;
+
+		if (ip_acl(target->tid, conn))
+			continue;
+
+		if (iqn_acl(target->tid, conn))
+			continue;
+
+		if (isns_scn_access(target->tid, conn->initiator))
+			continue;
+
+		iser_text_key_add(conn, tx_pdu, "TargetName", tgt_targetname(target->tid));
+		iser_text_key_add(conn, tx_pdu, "TargetAddress", addr);
+	}
+}
+
 static void iser_text_scan(struct iscsi_connection *iscsi_conn,
 			   struct iser_pdu *rx_pdu,
 			   struct iser_pdu *tx_pdu)
@@ -826,7 +858,7 @@ static void iser_text_scan(struct iscsi_connection *iscsi_conn,
 				 *p++ = ']';
 
 			sprintf(p, ":%d,1", ISCSI_LISTEN_PORT);
-			target_list_build(iscsi_conn, buf,
+			iser_target_list_build(iscsi_conn, tx_pdu, buf,
 					  strcmp(value, "All") ? value : NULL);
 		} else
 			iser_text_key_add(iscsi_conn, tx_pdu, key, "NotUnderstood");
@@ -856,6 +888,12 @@ int iser_text_exec(struct iscsi_connection *iscsi_conn,
 	dprintf("Text request: %d\n", iscsi_conn->state);
 	iser_text_scan(iscsi_conn, rx_pdu, tx_pdu);
 
+	if (tx_pdu->membuf.size > MAX_KEY_VALUE_PAIRS) {
+		eprintf("Text pdu size %d too big, can't send at once\n",
+			tx_pdu->membuf.size);
+		tx_pdu->membuf.size = 0;
+	}
+
 	if (req->flags & ISCSI_FLAG_CMD_FINAL)
 		rsp->flags = ISCSI_FLAG_CMD_FINAL;
 
-- 
1.7.1
