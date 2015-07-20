From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 2/4] sheepdog: serialize overwrapping request
Date: Mon, 20 Jul 2015 15:59:13 +0900
Message-ID: <1437375555-11698-2-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1437375555-11698-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nIHErk2qnpNLXINvGRXS4rF12CtT6lcHsd0RyViiR+8=;
        b=SUmPSkIadUwhGWfUCEkqLKWOH4iD0Eeo1MM6lTxOKKzvq9wS+CiSqlg5rfB/7b9jvz
         tRNOJstDPDdyKi1Fu2WEx38MHDpzTIVsnIfqUtsLEVxcqeB419vYfkjMQwo1vVmfVSf9
         CVmDGbVL3MIckGJn7wbowfQQ8IKCoZ6ehbfEqbjkP+d/LoR7rJgh564twXWccO4Ty8n6
         P+6BqZsLcymfkhNX7Ohq7THyge3vqxd3hkzXX1AfXmJUtuzdDkW7HW9VbVGBtCVZ5pt4
         fvmb2pEDPKT5r0IkUekjhi7Zcf51wnVEcR6bSmAVyQtNpCGx9QcuO5CKEabGBsY9uLkt
         YGRA==
In-Reply-To: <1437375555-11698-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>

iSCSI initiators can issue read and write requests that target
overlapping areas. In such a case, current sheepdog driver cannot
serialize these requests so the semantics of virtual drive will be
corrupt. This patch implements a mechanism for serializing such
requests.

Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 21d7dac..be6d321 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -294,6 +294,10 @@ struct sheepdog_access_info {
 
 	pthread_mutex_t inode_version_mutex;
 	uint64_t inode_version;
+
+	struct list_head inflight_list_head;
+	pthread_mutex_t inflight_list_mutex;
+	pthread_cond_t inflight_list_cond;
 };
 
 static inline int is_data_obj_writeable(struct sheepdog_inode *inode,
@@ -1252,6 +1256,11 @@ trans_to_expect_nothing:
 		goto out;
 
 	ret = 0;
+
+	INIT_LIST_HEAD(&ai->inflight_list_head);
+	pthread_mutex_init(&ai->inflight_list_mutex, NULL);
+	pthread_cond_init(&ai->inflight_list_cond, NULL);
+
 out:
 	strcpy(filename, orig_filename);
 	free(orig_filename);
@@ -1349,6 +1358,41 @@ out:
 	return ret;
 }
 
+struct inflight_thread {
+	unsigned long min_idx, max_idx;
+	struct list_head list;
+};
+
+static void inflight_block(struct sheepdog_access_info *ai,
+			   struct inflight_thread *myself)
+{
+	struct inflight_thread *inflight;
+
+	pthread_mutex_lock(&ai->inflight_list_mutex);
+
+retry:
+	list_for_each_entry(inflight, &ai->inflight_list_head, list) {
+		if (!(myself->max_idx < inflight->min_idx ||
+		      inflight->max_idx < myself->min_idx)) {
+			pthread_cond_wait(&ai->inflight_list_cond,
+					  &ai->inflight_list_mutex);
+			goto retry;
+		}
+	}
+
+	list_add_tail(&myself->list, &ai->inflight_list_head);
+	pthread_mutex_unlock(&ai->inflight_list_mutex);
+}
+ void inflight_release(struct sheepdog_access_info *ai,
+			     struct inflight_thread *myself)
+{
+	pthread_mutex_lock(&ai->inflight_list_mutex);
+	list_del(&myself->list);
+	pthread_mutex_unlock(&ai->inflight_list_mutex);
+
+	pthread_cond_signal(&ai->inflight_list_cond);
+}
+
 static void bs_sheepdog_request(struct scsi_cmd *cmd)
 {
 	int ret = 0;
@@ -1360,6 +1404,13 @@ static void bs_sheepdog_request(struct scsi_cmd *cmd)
 	struct sheepdog_access_info *ai =
 		(struct sheepdog_access_info *)(info + 1);
 
+	uint32_t object_size = (UINT32_C(1) << ai->inode.block_size_shift);
+	struct inflight_thread myself;
+	int inflight = 0;
+
+	memset(&myself, 0, sizeof(myself));
+	INIT_LIST_HEAD(&myself.list);
+
 	switch (cmd->scb[0]) {
 	case SYNCHRONIZE_CACHE:
 	case SYNCHRONIZE_CACHE_16:
@@ -1383,6 +1434,13 @@ static void bs_sheepdog_request(struct scsi_cmd *cmd)
 		}
 
 		length = scsi_get_out_length(cmd);
+
+		myself.min_idx = cmd->offset / object_size;
+		myself.max_idx = (cmd->offset + length + (object_size - 1))
+			/ object_size;
+		inflight_block(ai, &myself);
+		inflight = 1;
+
 		ret = sd_io(ai, 1, scsi_get_out_buffer(cmd),
 			    length, cmd->offset);
 
@@ -1394,6 +1452,13 @@ static void bs_sheepdog_request(struct scsi_cmd *cmd)
 	case READ_12:
 	case READ_16:
 		length = scsi_get_in_length(cmd);
+
+		myself.min_idx = cmd->offset / object_size;
+		myself.max_idx = (cmd->offset + length + (object_size - 1))
+			/ object_size;
+		inflight_block(ai, &myself);
+		inflight = 1;
+
 		ret = sd_io(ai, 0, scsi_get_in_buffer(cmd),
 			    length, cmd->offset);
 		if (ret)
@@ -1413,6 +1478,9 @@ static void bs_sheepdog_request(struct scsi_cmd *cmd)
 			cmd, cmd->scb[0], ret, length, cmd->offset);
 		sense_data_build(cmd, key, asc);
 	}
+
+	if (inflight)
+		inflight_release(ai, &myself);
 }
 
 static int bs_sheepdog_open(struct scsi_lu *lu, char *path,
-- 
1.9.1
