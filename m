From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 2/2] iser: Fix wrong access to the session discovery mode
Date: Wed, 20 May 2015 11:45:56 +0300
Message-ID: <1432111556-20535-3-git-send-email-sagig@mellanox.com>
References: <1432111556-20535-1-git-send-email-sagig@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1432111556-20535-1-git-send-email-sagig@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

In discovery sessions we don't create a real session (but
set a dummy tsih). When getting a logout request in a discovery
session, we attempted to access the iscsi session (which is NULL
obviously).

Fix this by not accessing the session in iser_logout_exec at all.

Reported-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/iscsi/iser.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index 3925de3..7befd06 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -1747,7 +1747,6 @@ static void iser_handle_rdmacm(int fd __attribute__ ((unused)),
 static int iser_logout_exec(struct iser_task *task)
 {
 	struct iser_conn *conn = task->conn;
-	struct iscsi_session *session = conn->h.session;
 	struct iscsi_logout_rsp *rsp_bhs =
 		(struct iscsi_logout_rsp *) task->pdu.bhs;
 
@@ -1757,10 +1756,8 @@ static int iser_logout_exec(struct iser_task *task)
 	rsp_bhs->response = ISCSI_LOGOUT_SUCCESS;
 	rsp_bhs->itt = task->tag;
 	rsp_bhs->statsn = cpu_to_be32(conn->h.stat_sn++);
-
-	if (session->exp_cmd_sn == task->cmd_sn && !task->is_immediate)
-		session->exp_cmd_sn++;
-	iser_set_rsp_stat_sn(session, task->pdu.bhs);
+	rsp_bhs->exp_cmdsn = cpu_to_be32(conn->h.exp_cmd_sn);
+	rsp_bhs->max_cmdsn = cpu_to_be32(conn->h.max_cmd_sn);
 
 	task->pdu.ahssize = 0;
 	task->pdu.membuf.size = 0;
-- 
1.8.4.3
