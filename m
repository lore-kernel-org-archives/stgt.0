From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] iscsi: fix leak of task for delayed management request
Date: Tue, 18 Mar 2014 11:19:58 +0900
Message-ID: <1395109198-15307-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Fix the following crash of tgtd which occured when removing a target
with --force option:

  conn_close(90) already closed 0x2058598 1
  iscsi_target_destroy(416) bug still have sessions 91

This crash happens if a task remains after the following calls of
conn_close() function for every connection on the target.

  list_for_each_entry_safe(session, stmp, &target->sessions_list, slist) {
          list_for_each_entry_safe(conn, ctmp, &session->conn_list, clist) {
                  conn_close(conn);
          }
  }

The leaked task turned out to be a task for handling ABORT_TASK
management request which was delayed due to a flying io.  The delayed
management request is attached to cmd->mreq of the io command and is
completed by iscsi_tm_done() function.  However, this function fails
with the following error and leaks the task if associated connection
(task->conn) is already closed:

 tgt_event_modify(245) Cannot find event 25
 iscsi_event_modify(560) tgt_event_modify failed

This fixes the issue by freeing task in iscsi_tm_done() if state of
the connection is STATE_CLOSE.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/iscsi/iscsid.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/usr/iscsi/iscsid.c b/usr/iscsi/iscsid.c
index 30bd13f..f0abe39 100644
--- a/usr/iscsi/iscsid.c
+++ b/usr/iscsi/iscsid.c
@@ -1428,6 +1428,11 @@ static int iscsi_tm_done(struct mgmt_req *mreq)
 		task->result = ISCSI_TMF_RSP_REJECTED;
 		break;
 	}
+
+	if (task->conn->state == STATE_CLOSE) {
+		iscsi_free_task(task);
+		return 0;
+	}
 	list_add_tail(&task->c_list, &task->conn->tx_clist);
 	task->conn->tp->ep_event_modify(task->conn, EPOLLIN | EPOLLOUT);
 	return 0;
-- 
1.7.9.3
