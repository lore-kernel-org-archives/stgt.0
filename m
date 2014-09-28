From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH] sheepdog: optimize reloading of inode
Date: Sun, 28 Sep 2014 21:48:05 +0900
Message-ID: <1411908485-28924-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=IWJmjzzS23ZWo/6zGAfjy2JgnuFxdg3jz2gvobrmkFo=;
        b=IqFdfPVUpOCXMgL+cTFOTaInMogvoTLtGD8TvzaRVFg/sDZIegD6XQxrJTvP4ETK4F
         Noz5q1mDLFG3Za1bM5rkjod0HX/oLobN2zXWdymkCAYwOZ9sIwevI192iv8N1PVG8nlI
         BofNQJnMokCSUL2rv+NF3bQFvkLFP45HqbqcAqrNfOTc00QPW9CRxaA8X8oJvdrG5MgG
         PH8gnCFK7HysUrD9lUKS8xtF8YFhZcyhN5hkVQGW93eOXjXxMkUXPvnjitJEB8mLZ6iV
         /mqKVHm6lUP/xdE1+0SlsJ9sR+Aar0cj4BPam10iOH9pYtbGtYWB1ZrkeuTFakckivgn
         XPBg==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Current sheepdog driver reloads inode when in both cases of snapshot
and invalidateion with iSCSI multipath. In the first case, reloading
whole inode isn't required. This patch reduces the overhead produced
by whole reloading in the case of snapshot.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 47 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index b9b7067..9376946 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -642,22 +642,37 @@ static int read_object(struct sheepdog_access_info *ai, char *buf, uint64_t oid,
 		       int copies, unsigned int datalen, uint64_t offset,
 		       int *need_reload);
 
-static int reload_inode(struct sheepdog_access_info *ai)
+static int reload_inode(struct sheepdog_access_info *ai, int is_snapshot)
 {
 	int ret, need_reload = 0;
 	char tag[SD_MAX_VDI_TAG_LEN];
 	uint32_t vid;
 
-	memset(tag, 0, sizeof(tag));
+	if (is_snapshot) {
+		memset(tag, 0, sizeof(tag));
 
-	ret = find_vdi_name(ai, ai->inode.name, CURRENT_VDI_ID, tag, &vid, 0);
-	if (ret)
-		return -1;
+		ret = find_vdi_name(ai, ai->inode.name, CURRENT_VDI_ID, tag,
+				    &vid, 0);
+		if (ret)
+			return -1;
 
-	ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(vid),
-			  ai->inode.nr_copies, SD_INODE_SIZE, 0, &need_reload);
-	if (ret)
-		return -1;
+		ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(vid),
+				  ai->inode.nr_copies,
+				  offsetof(struct sheepdog_inode, data_vdi_id),
+				  0, &need_reload);
+		if (ret)
+			return -1;
+	} else {
+		ret = read_object(ai, (char *)&ai->inode,
+				  vid_to_vdi_oid(ai->inode.vdi_id),
+				  ai->inode.nr_copies, SD_INODE_SIZE, 0,
+				  &need_reload);
+		if (ret)
+			return -1;
+	}
+
+	ai->min_dirty_data_idx = UINT32_MAX;
+	ai->max_dirty_data_idx = 0;
 
 	return 0;
 }
@@ -709,6 +724,8 @@ static int read_write_object(struct sheepdog_access_info *ai, char *buf,
 		return 0;
 	case SD_RES_INODE_INVALIDATED:
 		dprintf("inode object is invalidated\n");
+		*need_reload = 2;
+		return 0;
 	case SD_RES_READONLY:
 		*need_reload = 1;
 		return 0;
@@ -784,7 +801,7 @@ static int update_inode(struct sheepdog_access_info *ai)
 	goto update;
 
 reload:
-	reload_inode(ai);
+	reload_inode(ai, 0);
 	need_reload_inode = 0;
 
 update:
@@ -853,7 +870,7 @@ reload_in_read_path:
 	pthread_rwlock_unlock(&ai->inode_lock); /* unlock current read lock */
 
 	pthread_rwlock_wrlock(&ai->inode_lock);
-	ret = reload_inode(ai);
+	ret = reload_inode(ai, 0);
 	if (ret) {
 		eprintf("failed to reload in read path\n");
 		goto out;
@@ -911,7 +928,13 @@ retry:
 					   old_oid, flags, &need_reload_inode);
 			if (!ret) {
 				if (need_reload_inode) {
-					ret = reload_inode(ai);
+					/* If need_reload_inode is 1,
+					 * snapshot was created.
+					 * If it is 2, inode object is
+					 * invalidated
+					 */
+					ret = reload_inode(ai,
+						   need_reload_inode == 1);
 					if (!ret)
 						goto retry;
 				}
-- 
1.9.1
