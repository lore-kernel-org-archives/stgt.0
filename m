From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 3/4] sheepdog: pass a correct flag to find_vdi_name()
Date: Mon, 20 Jul 2015 15:59:14 +0900
Message-ID: <1437375555-11698-3-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1437375555-11698-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6999+QLnh5QPisQvhA/p8dA9igjrvLJ5BjN/ZBifcyA=;
        b=c+m//O+67B+6NxVjJuQOgpB0TqaOiiExb7q/Mzf7FAZN5gozs4J61/uqHjePE48M+b
         lJYiVIEHXGZvmNRTZbDEHhG6XCBVRqMVk6dzlueT2uz1jEiIELt6pYR9UmdmjAFxdn6B
         CEaYbyZWOnQ0RRkdo3dDjBNvjfwLOJinb5niEHPUjVUYklzLzNeK8chy1odFqGtwNovA
         qspsvVwJQlcjsjzAf9IsXCliBYgsipVaFTTn9VUZ6C+xavrhHrBeD84LF2ERIQ+cOT8X
         eR5+sQeDCjGL6KEmfkBURcVIrfpBGtmDPBu4OvBMDpVQfllOWVG2YXMClWAFLq4S4Qp4
         jzPg==
In-Reply-To: <1437375555-11698-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>

Current usage of find_vdi_name() is invalid because it is called with
for_snapshot == 0 even for a case of readonly. This patch fixes the
problem.

Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index be6d321..56630ac 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -681,7 +681,7 @@ static int reload_inode(struct sheepdog_access_info *ai, int is_snapshot)
 		memset(tag, 0, sizeof(tag));
 
 		ret = find_vdi_name(ai, ai->inode.name, CURRENT_VDI_ID, tag,
-				    &vid, 0);
+				    &vid, 1);
 		if (ret) {
 			ret = -1;
 			goto ret;
@@ -905,6 +905,7 @@ static int sd_io(struct sheepdog_access_info *ai, int write, char *buf, int len,
 	int need_update_inode = 0, need_reload_inode;
 	int nr_copies = ai->inode.nr_copies;
 	int need_write_lock, check_idx;
+	int read_reload_snap = 0;
 
 	goto do_req;
 
@@ -912,7 +913,7 @@ reload_in_read_path:
 	pthread_rwlock_unlock(&ai->inode_lock); /* unlock current read lock */
 
 	pthread_rwlock_wrlock(&ai->inode_lock);
-	ret = reload_inode(ai, 0);
+	ret = reload_inode(ai, read_reload_snap);
 	if (ret) {
 		eprintf("failed to reload in read path\n");
 		goto out;
@@ -1008,6 +1009,8 @@ retry:
 					dprintf("reload in read path for not"\
 						" written area\n");
 					size = orig_size;
+					read_reload_snap =
+						need_reload_inode == 1;
 					goto reload_in_read_path;
 				}
 			}
@@ -1019,6 +1022,7 @@ retry:
 			if (need_reload_inode) {
 				dprintf("reload in ordinal read path\n");
 				size = orig_size;
+				read_reload_snap = need_reload_inode == 1;
 				goto reload_in_read_path;
 			}
 		}
-- 
1.9.1
