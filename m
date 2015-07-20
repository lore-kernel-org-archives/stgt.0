From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 1/4] sheepdog: prevent double locking during inode reload
Date: Mon, 20 Jul 2015 15:59:12 +0900
Message-ID: <1437375555-11698-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=OX9II+IoudHX1C627uR2aZlYEuOjlOZzfHZz5tMYR44=;
        b=RtsJgx0j4HV6eG14vgV3ZuppzKpA8wFn6SnPS8dJi1SHRu9bpcBwfe0s/M2C55cfys
         GhLarp/1AEcQqecTfwqj1n5DOXgVMAhjgzcFByk9nsksqlWLtGaR4Q9rBGULQJKOWakT
         HL269KvD5deVLJzrcUncEAZJ9vwNrSWyVKjCFxPg4dIUiCxqa6/KqH6cDVF93+AcgJWT
         8FOmQR4dmeG3TJPb5JgU03n8yH2Sh9v3KIAKj6cwYF79CWH8f9GG0JcHzPa5KeRqr91f
         Lh7QYnprvbX93VCXSlRxiV/ifEmqLZFFT1OiL9UNaWfJAe2qS4YsRORYVuIIJ/Do3v1K
         X+5g==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>

The commit 0c531dfe18f9b2af made the lock protecting on memory inode
object finer grain and improved performacne, but it also introduced a
possibility of double locking single VDI.

The problem can arise in this sequence:
1. both of thread A and B issues write request to a VDI
2. user make a snapshot of the VDI
3. the VDI is now readonly snapshot, sheep returns SD_RES_READONLY
4. both of A and B calls find_vdi_name() for obtaining a new ID of
   working VDI, it results double locking

This patch resolves the problem. Each thread has a version number of
inode object in its TLS. Acess info struct also has the number. When
the thread needs to reload the inode object, it check the number with
the one of the access info first. If they differ, it means no other
threads reloaded the object. If not, it means other thread already
reloaded, so the thread doesn't call find_vdi_name() and double
locking can be avoided.

Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index cfaf48b..21d7dac 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -291,6 +291,9 @@ struct sheepdog_access_info {
 
 	struct sheepdog_inode inode;
 	pthread_rwlock_t inode_lock;
+
+	pthread_mutex_t inode_version_mutex;
+	uint64_t inode_version;
 };
 
 static inline int is_data_obj_writeable(struct sheepdog_inode *inode,
@@ -656,37 +659,58 @@ static int read_object(struct sheepdog_access_info *ai, char *buf, uint64_t oid,
 
 static int reload_inode(struct sheepdog_access_info *ai, int is_snapshot)
 {
-	int ret, need_reload = 0;
+	int ret = 0, need_reload = 0;
 	char tag[SD_MAX_VDI_TAG_LEN];
 	uint32_t vid;
 
+	static __thread uint64_t inode_version;
+
+	pthread_mutex_lock(&ai->inode_version_mutex);
+
+	if (inode_version != ai->inode_version) {
+		/* some other threads reloaded inode */
+		inode_version = ai->inode_version;
+		goto ret;
+	}
+
 	if (is_snapshot) {
 		memset(tag, 0, sizeof(tag));
 
 		ret = find_vdi_name(ai, ai->inode.name, CURRENT_VDI_ID, tag,
 				    &vid, 0);
-		if (ret)
-			return -1;
+		if (ret) {
+			ret = -1;
+			goto ret;
+		}
 
 		ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(vid),
 				  ai->inode.nr_copies,
 				  offsetof(struct sheepdog_inode, data_vdi_id),
 				  0, &need_reload);
-		if (ret)
-			return -1;
+		if (ret) {
+			ret = -1;
+			goto ret;
+		}
 	} else {
 		ret = read_object(ai, (char *)&ai->inode,
 				  vid_to_vdi_oid(ai->inode.vdi_id),
 				  ai->inode.nr_copies, SD_INODE_SIZE, 0,
 				  &need_reload);
-		if (ret)
-			return -1;
+		if (ret) {
+			ret = -1;
+			goto ret;
+		}
 	}
 
 	ai->min_dirty_data_idx = UINT32_MAX;
 	ai->max_dirty_data_idx = 0;
 
-	return 0;
+	inode_version++;
+	ai->inode_version = inode_version;
+
+ret:
+	pthread_mutex_unlock(&ai->inode_version_mutex);
+	return ret;
 }
 
 static int read_write_object(struct sheepdog_access_info *ai, char *buf,
@@ -1426,6 +1450,7 @@ static tgtadm_err bs_sheepdog_init(struct scsi_lu *lu, char *bsopts)
 	INIT_LIST_HEAD(&ai->fd_list_head);
 	pthread_rwlock_init(&ai->fd_list_lock, NULL);
 	pthread_rwlock_init(&ai->inode_lock, NULL);
+	pthread_mutex_init(&ai->inode_version_mutex, NULL);
 
 	return bs_thread_open(info, bs_sheepdog_request, nr_iothreads);
 }
-- 
1.9.1
