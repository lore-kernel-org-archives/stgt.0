From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: fix error handling issue in bs_sheepdog_request()
Date: Thu, 31 Oct 2013 22:36:04 +0900
Message-ID: <1383226564-21505-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, sheepdog@lists.wpkg.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

bs_sheepdog_request function, the request handler of sheepdog driver,
doesn't set scsi status code if the driver failed to create writable
VDI from snapshot.

In that case, CHECK_CONDITION result code should be set to cmd->result
through scsi_set_result() macro.  This fix corrects the error
handling issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 7341708..1dda915 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -1184,7 +1184,7 @@ static void bs_sheepdog_request(struct scsi_cmd *cmd)
 					" snapshot failed\n");
 				set_medium_error(&result, &key, &asc);
 
-				return;
+				break;
 			}
 			ai->is_snapshot = 0;
 		}
-- 
1.7.9.3
