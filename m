From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] tgtd: fix leak of task_in_scsi flag
Date: Mon, 17 Mar 2014 12:39:01 +0900
Message-ID: <1395027541-11479-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

When target_mgmt_request() function receives unknown or unsupported
task management function code or task was already completed for
ABORT_TASK request, iscsi_tm_execute() and iser_tm_exec() functions
exit without clearing task_in_scsi flag even though scsi command is
not in processing.

This is because the current implementation of target_mgmt_request()
function returns -EINVAL or -EEXIST for the above cases and
iscsi_tm_execute() and iser_tm_exec() do not handle these return
codes.

This fixes the issue by changing the return value of
target_mgmt_request() to MGMT_REQ_FAILED for such cases.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/target.c b/usr/target.c
index b6f324c..0f3066b 100644
--- a/usr/target.c
+++ b/usr/target.c
@@ -1454,7 +1454,7 @@ enum mgmt_req_result target_mgmt_request(int tid, uint64_t itn_id,
 	}
 
 	if (err)
-		return err;
+		return MGMT_REQ_FAILED;
 	else if (send)
 		return MGMT_REQ_DONE;
 
-- 
1.7.9.3
