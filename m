From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] tgtd: fix memory leaks at it_nexus_create()
Date: Mon,  9 Dec 2013 03:32:19 +0900
Message-ID: <1386527539-30494-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

The it_nexus_create function exits without freeing it_nexus_lu_info
struct nor it_nexus struct at error paths.

This fixes the leak bugs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/target.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/usr/target.c b/usr/target.c
index 6968e76..f4c5b4e 100644
--- a/usr/target.c
+++ b/usr/target.c
@@ -321,8 +321,10 @@ int it_nexus_create(int tid, uint64_t itn_id, int host_no, char *info)
 		INIT_LIST_HEAD(&itn_lu->pending_ua_sense_list);
 
 		ret = ua_sense_add(itn_lu, ASC_POWERON_RESET);
-		if (ret)
+		if (ret) {
+			free(itn_lu);
 			goto out;
+		}
 
 		list_add_tail(&itn_lu->lu_itl_info_siblings,
 			      &lu->lu_itl_info_list);
@@ -338,6 +340,7 @@ int it_nexus_create(int tid, uint64_t itn_id, int host_no, char *info)
 	return 0;
 out:
 	it_nexus_del_lu_info(itn);
+	free(itn);
 	return -ENOMEM;
 }
 
-- 
1.7.9.3
