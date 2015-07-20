From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 4/4] sheepdog: handle a case of snapshot -> failover
Date: Mon, 20 Jul 2015 15:59:15 +0900
Message-ID: <1437375555-11698-4-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1437375555-11698-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8LHfgM3iuw5KNKBI2pngF88ZTHOG9aAg3FHdtaB9pho=;
        b=fkniMJ3p4IERaC9HQ0Z4+6v3rO6d72pkDRwnQxGzsc7kar+RKPA/QxbJi7jN25Jt5+
         DMYFIIV2bsASkgcfLXi4G7/Ix/WP29DPr8w5TY6z0eByrAuro/W5HJwQbjgnH6hmJLfo
         naGUrvnxNqmqURMW3bngITKcTti/AynuINNW6CWL+UAX/4ANAxwniyDe+RqngX2uM+T1
         mpkDtlCYWXlPy1rsAAgEPeQDwLuWWEcfLfnCSCZVkVY0tteEWVSZKVsFjdJPW3ww65yx
         jNAScyPaYmgvtl9uDBRj+hAptM4Dw1lkxXUeqb3LRoE198yNKQi78OBdmODpx/SGQK4I
         oeJg==
In-Reply-To: <1437375555-11698-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>

If refreshed inode is snapshot, we can reload entire inode and switch
to working VDI immediately. It is required by the new refreshing
condition introduced in the commit 8f781f02ab of sheepdog.

Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 56630ac..99519ef 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -704,6 +704,34 @@ static int reload_inode(struct sheepdog_access_info *ai, int is_snapshot)
 			ret = -1;
 			goto ret;
 		}
+
+		if (!!ai->inode.snap_ctime) {
+			/*
+			 * This is a case like below:
+			 * take snapshot -> write something -> failover
+			 *
+			 * Because invalidated inode is readonly and latest
+			 * working VDI can have COWed objects, we need to
+			 * resolve VID and reload its entire inode object.
+			 */
+			memset(tag, 0, sizeof(tag));
+
+			ret = find_vdi_name(ai, ai->inode.name, CURRENT_VDI_ID,
+					    tag, &vid, 1);
+			if (ret) {
+				ret = -1;
+				goto ret;
+			}
+
+			ret = read_object(ai, (char *)&ai->inode,
+					  vid_to_vdi_oid(vid),
+					  ai->inode.nr_copies, SD_INODE_SIZE, 0,
+					  &need_reload);
+			if (ret) {
+				ret = -1;
+				goto ret;
+			}
+		}
 	}
 
 	ai->min_dirty_data_idx = UINT32_MAX;
-- 
1.9.1
