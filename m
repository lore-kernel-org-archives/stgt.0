From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH] sheepdog: support iSCSI multipath
Date: Thu,  7 Aug 2014 10:25:49 +0900
Message-ID: <1407374749-13610-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=CFJbh3wxG+SnGWAZ4GQBpoiOHhE2wUzr6NNF+r+fxOE=;
        b=rMT0E0XLbAtXZE4RJsyqSYo69heHFq83D8r2MgrNoMwfYqjl4/gstZToBMauRP9wDC
         thkyNSlC7xdNEn4Q3Dbg43MGTJ9JYbJxlwESyMIUMxoS0m0IV77LNH+IMrpSp88Q86Xr
         fSob5958q6Nh8lLrJp/j2NYiEOMklKdnF3XkoQZPhXBG7SyDcTR/wu5NhsSo0k52CrsY
         hNrb820271ySE4dNcvxL2ceNCBL18tEF3vvHpGXa7ytYANoGRgmOcMXEjq23EoDyT7be
         vN9rQeety6OQdjlL+km/s51cSc5wNom1emQy5qWFlTXEpNqW6qE2F5emzyXAFH+cvVA+
         rzEQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

This patch implements iSCSI multipath support in sheepdog backing
store driver. Below is a brief description of the feature:

The main problem of enabling iSCSI multipath for sheepdog's VDI is
keeping coherence of tgtd's internal inode data structure. Assume tgt
A and B have logical units which point same sheepdog VDI. After
initialization of the logical units, A and B have copies of inode
object in their address space (let's X denote this object). When an
initiator sends write request to A and the request causes COW, A
creates a new object and updates the inode object X (let's X' denote
the updated one).

After the update by A, A can die with hardware faults. In such a case,
the initiator detects a connection error and switch its target to B if
iSCSI multipath is configured correctly. But the problem can arise at
this point. Because B doesn't know the update caused by A and its
internal inode object is still X, not X'. B creates requests based on
X, so it can read obsolete data which is already hidden by X' or
update X' in wrong manner.

For solving the above problem, sheepdog implements inode object
coherence protocol which mocks MSI protocol of shared memory multicore
processors. With this mechanism sheepdog can prevent requests which
are based on obsolete inode objects. This patch let sheepdog driver of
tgtd adopt the coherence protocol.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 81 insertions(+), 16 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 15f44d8..ffc2519 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -94,6 +94,11 @@
 #define SD_RES_JOIN_FAILED   0x18 /* Target node had failed to join sheepdog */
 #define SD_RES_HALT          0x19 /* Sheepdog is stopped serving IO request */
 #define SD_RES_READONLY      0x1A /* Object is read-only */
+#define SD_RES_INCOMPLETE    0x1B /* Object (in kv) is incomplete uploading */
+/* sheep is collecting cluster wide status, not ready for operation */
+#define SD_RES_COLLECTING_CINFO 0x1C
+ /* inode object in client is invalidated, refreshing is required */
+#define SD_RES_INODE_INVALIDATED 0x1D
 
 /*
  * Object ID rules
@@ -166,6 +171,9 @@ struct sheepdog_obj_rsp {
 	uint32_t pad[6];
 };
 
+#define LOCK_TYPE_NORMAL 1
+#define LOCK_TYPE_SHARED 2      /* for iSCSI multipath */
+
 struct sheepdog_vdi_req {
 	uint8_t proto_ver;
 	uint8_t opcode;
@@ -177,7 +185,8 @@ struct sheepdog_vdi_req {
 	uint32_t vdi_id;
 	uint32_t copies;
 	uint32_t snapid;
-	uint32_t pad[3];
+	uint32_t type;
+	uint32_t pad[2];
 };
 
 struct sheepdog_vdi_rsp {
@@ -626,11 +635,12 @@ static int find_vdi_name(struct sheepdog_access_info *ai, char *filename,
 			 uint32_t snapid, char *tag, uint32_t *vid,
 			 int for_snapshot);
 static int read_object(struct sheepdog_access_info *ai, char *buf, uint64_t oid,
-		       int copies, unsigned int datalen, uint64_t offset);
+		       int copies, unsigned int datalen, uint64_t offset,
+		       int *need_reload);
 
 static int reload_inode(struct sheepdog_access_info *ai)
 {
-	int ret;
+	int ret, need_reload = 0;
 	char tag[SD_MAX_VDI_TAG_LEN];
 	uint32_t vid;
 
@@ -641,7 +651,7 @@ static int reload_inode(struct sheepdog_access_info *ai)
 		return -1;
 
 	ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(vid),
-			  ai->inode.nr_copies, SD_INODE_SIZE, 0);
+			  ai->inode.nr_copies, SD_INODE_SIZE, 0, &need_reload);
 	if (ret)
 		return -1;
 
@@ -692,9 +702,10 @@ static int read_write_object(struct sheepdog_access_info *ai, char *buf,
 	switch (rsp->result) {
 	case SD_RES_SUCCESS:
 		return 0;
+	case SD_RES_INODE_INVALIDATED:
+		dprintf("inode object is invalidated\n");
 	case SD_RES_READONLY:
-		if (need_reload)
-			*need_reload = 1;
+		*need_reload = 1;
 		return 0;
 	default:
 		eprintf("%s (oid: %" PRIx64 ", old_oid: %" PRIx64 ")\n",
@@ -705,10 +716,10 @@ static int read_write_object(struct sheepdog_access_info *ai, char *buf,
 
 static int read_object(struct sheepdog_access_info *ai, char *buf,
 		       uint64_t oid, int copies,
-		       unsigned int datalen, uint64_t offset)
+		       unsigned int datalen, uint64_t offset, int *need_reload)
 {
 	return read_write_object(ai, buf, oid, copies, datalen, offset,
-				 0, 0, 0, 0, NULL);
+				 0, 0, 0, 0, need_reload);
 }
 
 static int write_object(struct sheepdog_access_info *ai, char *buf,
@@ -782,6 +793,29 @@ end:
 	return ret;
 }
 
+static int is_refresh_required(struct sheepdog_access_info *ai)
+/*
+ * 0: refresh isn't required
+ * 1: refresh is required
+ */
+{
+	uint64_t first_oid = vid_to_data_oid(ai->inode.vdi_id, 0);
+	char dummy;
+	int need_reload_inode = 0;
+
+	/*
+	 * Check inode of this tgtd is invaldiated or not.
+	 * Reading which object isn't a problem. If the inode object is
+	 * invalidated, sheep returns SD_RES_INODE_INVALIDATED even if the
+	 * object doesn't exist. So we read the first one.
+	 */
+
+	read_object(ai, &dummy, first_oid, ai->inode.nr_copies, sizeof(dummy),
+		    0, &need_reload_inode);
+
+	return need_reload_inode;
+}
+
 static int sd_io(struct sheepdog_access_info *ai, int write, char *buf, int len,
 		 uint64_t offset)
 {
@@ -790,19 +824,34 @@ static int sd_io(struct sheepdog_access_info *ai, int write, char *buf, int len,
 	unsigned long max =
 		(offset + len + (SD_DATA_OBJ_SIZE - 1)) / SD_DATA_OBJ_SIZE;
 	unsigned obj_offset = offset % SD_DATA_OBJ_SIZE;
-	size_t size, rest = len;
+	size_t orig_size, size, rest = len;
 	int ret = 0, create = 0;
 	uint64_t oid, old_oid;
 	uint16_t flags = 0;
 	int need_update_inode = 0, need_reload_inode;
 	int nr_copies = ai->inode.nr_copies;
 
+	goto do_req;
+
+reload_in_read_path:
+	pthread_rwlock_unlock(&ai->inode_lock); /* unlock current read lock */
+
+	pthread_rwlock_wrlock(&ai->inode_lock);
+	ret = reload_inode(ai);
+	if (ret) {
+		eprintf("failed to reload in read path\n");
+		goto out;
+	}
+	pthread_rwlock_unlock(&ai->inode_lock);
+
+do_req:
 	if (write)
 		pthread_rwlock_wrlock(&ai->inode_lock);
 	else
 		pthread_rwlock_rdlock(&ai->inode_lock);
 
 	for (; idx < max; idx++) {
+		orig_size = size;
 		size = SD_DATA_OBJ_SIZE - obj_offset;
 		size = min_t(size_t, size, rest);
 
@@ -858,13 +907,27 @@ retry:
 			}
 		} else {
 			if (!ai->inode.data_vdi_id[idx]) {
-				memset(buf, 0, size);
-				goto done;
+				int check = is_refresh_required(ai);
+				if (!check) {
+					memset(buf, 0, size);
+					goto done;
+				} else {
+					dprintf("reload in read path for not"\
+						" written area\n");
+					size = orig_size;
+					goto reload_in_read_path;
+				}
 			}
 
+			need_reload_inode = 0;
 			ret = read_object(ai, buf + (len - rest),
 					  oid, nr_copies, size,
-					  obj_offset);
+					  obj_offset, &need_reload_inode);
+			if (need_reload_inode) {
+				dprintf("reload in ordinal read path\n");
+				size = orig_size;
+				goto reload_in_read_path;
+			}
 		}
 
 		if (ret) {
@@ -905,6 +968,7 @@ static int find_vdi_name(struct sheepdog_access_info *ai, char *filename,
 		hdr.opcode = SD_OP_GET_VDI_INFO;
 	else
 		hdr.opcode = SD_OP_LOCK_VDI;
+	hdr.type = LOCK_TYPE_SHARED;
 
 	wlen = SD_MAX_VDI_LEN + SD_MAX_VDI_TAG_LEN;
 	hdr.proto_ver = SD_PROTO_VER;
@@ -934,7 +998,7 @@ out:
 
 static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 {
-	int ret = 0, i, len, fd;
+	int ret = 0, i, len, fd, need_reload = 0;
 	uint32_t vid = 0;
 	char *orig_filename;
 
@@ -1094,7 +1158,7 @@ trans_to_expect_nothing:
 	ai->max_dirty_data_idx = 0;
 
 	ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(vid),
-			  0, SD_INODE_SIZE, 0);
+			  0, SD_INODE_SIZE, 0, &need_reload);
 	if (ret)
 		goto out;
 
@@ -1116,6 +1180,7 @@ static void sd_close(struct sheepdog_access_info *ai)
 	memset(&hdr, 0, sizeof(hdr));
 
 	hdr.opcode = SD_OP_RELEASE_VDI;
+	hdr.type = LOCK_TYPE_SHARED;
 	hdr.vdi_id = ai->inode.vdi_id;
 
 	ret = do_req(ai, (struct sheepdog_req *)&hdr, NULL, &wlen, &rlen);
@@ -1137,7 +1202,7 @@ static int create_branch(struct sheepdog_access_info *ai)
 	struct sheepdog_vdi_req hdr;
 	struct sheepdog_vdi_rsp *rsp = (struct sheepdog_vdi_rsp *)&hdr;
 	unsigned int wlen = 0, rlen;
-	int ret;
+	int ret, need_reload = 0;
 
 	ret = pthread_rwlock_wrlock(&ai->inode_lock);
 	if (ret) {
@@ -1181,7 +1246,7 @@ static int create_branch(struct sheepdog_access_info *ai)
 	}
 
 	ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(rsp->vdi_id),
-			  ai->inode.nr_copies, SD_INODE_SIZE, 0);
+			  ai->inode.nr_copies, SD_INODE_SIZE, 0, &need_reload);
 	if (ret) {
 		eprintf("reloading new inode object failed");
 		goto out;
-- 
1.8.3.2
