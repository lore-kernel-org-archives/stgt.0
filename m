From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 3/6] sheepdog: pass a correct flag to reload_inode()
Date: Tue,  6 Sep 2016 16:37:26 +0900
Message-ID: <1473147449-29377-4-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q04niVhG07nS8JzSPtIkkkPoDwCPRi6Y1QUTTZqu9HM=;
        b=wI1yUM9e/tYBjaW68c/MkvEybgCRdN6bke9PsxRKW+wYa3ZeUUsbNM3GQBzfm3nm2R
         o3P+F0ShzCBX0QLx/NAIPPWN84WvZdtmJWB0uPc5oFLStBQGjF6mebG9yVGsvm+Gbmac
         7oyKZPPwO6TbKBw/PHoibD85IqOFv9tt+nobT4yDjaVND+rXd7JiVaYUtj4IsVnhf7Vp
         NuGubfNhJJxk05Zedouw98ZWr5oAn7XPa5Ov1Ct3DJ7KGT/qAj46A9OsgZDS47EAGMIo
         5/DsEBVMGSFaBbcGioSOlE9SmcpNdATeaaUvPr51WzQBXO1ssaYo2ogNd9Ux/LZrXGUP
         9/eA==
In-Reply-To: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>, Takashi Menjo <menjo.takashi@lab.ntt.co.jp>

Current usage of reload_inode() is invalid because it is called with
is_snapshot == 0 even for a case of readonly. This patch fixes the
problem.

Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Cc: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
Tested-by: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index be6d321..ecb5033 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
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
2.7.4
