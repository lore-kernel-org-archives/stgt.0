From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v2 1/3] bs_sheepdog.c: mock the behavior of QEMU's sheepdog driver in a correct manner
Date: Wed, 16 Oct 2013 17:42:06 +0900
Message-ID: <1381912928-7462-2-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1381912928-7462-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1381912928-7462-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Current bs_sheepdog.c doesn't mock the behavior of QEMU's sheepdog
driver in a correct manner when it opens snapshot VDIs. It treats the
snapshot VDIs as read-only disks, but this behavior is different from
the QEMU's driver. This patch lets bs_sheepdog.c mock the original
behavior (delete an original VDI of the snapshot -> create a new non
snapshot VDI based on the snapshot and open it). This patch also
removes confusing notations of --backing-store option of
bs_sheepdog.c.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |  109 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 76 insertions(+), 33 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 4f7cde0..11ddce6 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -622,8 +622,11 @@ static int reload_inode(struct sheepdog_access_info *ai)
 	if (ret)
 		return -1;
 
-	read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(vid),
-		    ai->inode.nr_copies, SD_INODE_SIZE, 0);
+	ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(vid),
+			  ai->inode.nr_copies, SD_INODE_SIZE, 0);
+	if (ret)
+		return -1;
+
 	return 0;
 }
 
@@ -917,9 +920,9 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 	enum {
 		EXPECT_PROTO,
 		EXPECT_PATH,
-		EXPECT_VDI,
-		EXPECT_HOST_OR_PORT,
+		EXPECT_HOST,
 		EXPECT_PORT,
+		EXPECT_VDI,
 		EXPECT_TAG_OR_SNAP,
 		EXPECT_NOTHING,
 	} parse_state = EXPECT_PROTO;
@@ -942,9 +945,6 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 	 * tcp:<host>:<port>:<vdi>
 	 * tcp:<host>:<port>:<vdi>:<tag>
 	 * tcp:<host>:<port>:<vdi>:<snapid>
-	 * tcp:<port>:<vdi>
-	 * tcp:<port>:<vdi>:<tag>
-	 * tcp:<port>:<vdi>:<snapid>
 	 */
 
 	result = strtok_r(filename, ":", &saveptr);
@@ -957,7 +957,7 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 				parse_state = EXPECT_PATH;
 			} else if (!strcmp("tcp", result)) {
 				ai->is_unix = 0;
-				parse_state = EXPECT_HOST_OR_PORT;
+				parse_state = EXPECT_HOST;
 			} else {
 				eprintf("unknown protocol of sheepdog vdi:"\
 					" %s\n", result);
@@ -968,26 +968,14 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 			strncpy(ai->uds_path, result, UNIX_PATH_MAX);
 			parse_state = EXPECT_VDI;
 			break;
-		case EXPECT_HOST_OR_PORT:
-			len = strlen(result);
-			for (i = 0; i < len; i++) {
-				if (!isdigit(result[i])) {
-					/* result is a hostname */
-					strncpy(ai->hostname, result,
-						HOST_NAME_MAX);
-					parse_state = EXPECT_PORT;
-					goto next_token;
-				}
-			}
-
-			/* result is a port, use localhost as hostname */
-			strncpy(ai->hostname, "localhost", strlen("localhost"));
-set_port:
+		case EXPECT_HOST:
+			strncpy(ai->hostname, result, HOST_NAME_MAX);
+			parse_state = EXPECT_PORT;
+			break;
+		case EXPECT_PORT:
 			ai->port = atoi(result);
 			parse_state = EXPECT_VDI;
 			break;
-		case EXPECT_PORT:
-			goto set_port;
 		case EXPECT_VDI:
 			strncpy(vdi_name, result, SD_MAX_VDI_LEN);
 			parse_state = EXPECT_TAG_OR_SNAP;
@@ -1017,8 +1005,6 @@ trans_to_expect_nothing:
 				parse_state);
 			exit(1);
 		}
-
-next_token:;
 	} while ((result = strtok_r(NULL, ":", &saveptr)) != NULL);
 
 	if (parse_state != EXPECT_NOTHING &&
@@ -1039,7 +1025,8 @@ next_token:;
 	else
 		dprintf("snapid: %d\n", snapid);
 
-	ai->is_snapshot = !(snapid == -1) && strlen(tag);
+	dprintf("VDI name: %s\n", vdi_name);
+	ai->is_snapshot = !(snapid == -1) || strlen(tag);
 	ret = find_vdi_name(ai, vdi_name, snapid == -1 ? 0 : snapid, tag, &vid,
 			    ai->is_snapshot);
 	if (ret)
@@ -1087,6 +1074,53 @@ static void set_medium_error(int *result, uint8_t *key, uint16_t *asc)
 	*asc = ASC_READ_ERROR;
 }
 
+static int create_branch(struct sheepdog_access_info *ai)
+{
+	struct sheepdog_vdi_req hdr;
+	struct sheepdog_vdi_rsp *rsp = (struct sheepdog_vdi_rsp *)&hdr;
+	unsigned int wlen = 0, rlen;
+	int ret;
+
+	hdr.opcode = SD_OP_DEL_VDI;
+	hdr.vdi_id = ai->inode.vdi_id;
+	hdr.flags = SD_FLAG_CMD_WRITE;
+	wlen = SD_MAX_VDI_LEN;
+	hdr.data_length = wlen;
+
+	ret = do_req(ai, (struct sheepdog_req *)&hdr, ai->inode.name,
+		     &wlen, &rlen);
+	if (ret) {
+		eprintf("deleting snapshot VDI for creating branch failed\n");
+		return -1;
+	}
+
+	memset(&hdr, 0, sizeof(hdr));
+	hdr.opcode = SD_OP_NEW_VDI;
+	hdr.vdi_id = ai->inode.vdi_id;
+
+	hdr.flags = SD_FLAG_CMD_WRITE;
+	wlen = SD_MAX_VDI_LEN;
+	hdr.data_length = wlen;
+	hdr.vdi_size = ai->inode.vdi_size;
+	ret = do_req(ai, (struct sheepdog_req *)&hdr, ai->inode.name,
+		     &wlen, &rlen);
+	if (ret) {
+		eprintf("creating new VDI for creating branch failed\n");
+		return -1;
+	}
+
+	ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(rsp->vdi_id),
+			  ai->inode.nr_copies, SD_INODE_SIZE, 0);
+	if (ret) {
+		eprintf("reloading new inode object failed");
+		return -1;
+	}
+
+	dprintf("creating branch from snapshot, new VDI ID: %x\n", rsp->vdi_id);
+
+	return 0;
+}
+
 static void bs_sheepdog_request(struct scsi_cmd *cmd)
 {
 	int ret = 0;
@@ -1110,11 +1144,20 @@ static void bs_sheepdog_request(struct scsi_cmd *cmd)
 	case WRITE_12:
 	case WRITE_16:
 		if (ai->is_snapshot) {
-			length = scsi_get_out_length(cmd);
-			ret = sd_io(ai, 1, scsi_get_out_buffer(cmd),
-				    length, cmd->offset);
-		} else
-			ret = -1;
+			ret = create_branch(ai);
+			if (ret) {
+				eprintf("creating writable VDI from"\
+					" snapshot failed\n");
+				set_medium_error(&result, &key, &asc);
+
+				return;
+			}
+			ai->is_snapshot = 0;
+		}
+
+		length = scsi_get_out_length(cmd);
+		ret = sd_io(ai, 1, scsi_get_out_buffer(cmd),
+			    length, cmd->offset);
 
 		if (ret)
 			set_medium_error(&result, &key, &asc);
-- 
1.7.10.4

