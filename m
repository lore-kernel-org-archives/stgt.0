From: Feng Li <li.feng@oracle.com>
Subject: [PATCH] convert scsi_cmnd.h macro to normal functions
Date: Tue, 24 May 2016 11:14:28 +0800
Message-ID: <1464059668-3149-1-git-send-email-li.feng@oracle.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Feng Li <lifeng1519@gmail.com>

From: Feng Li <lifeng1519@gmail.com>

When I read this code, I found it's hard to understand about these macros.
I hardly find where are the definitions of some functions.
Therefore, I expand them to normal functions for convience.

Signed-off-by: Feng Li <lifeng1519@gmail.com>
---
 usr/scsi_cmnd.h | 298 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 170 insertions(+), 128 deletions(-)

diff --git a/usr/scsi_cmnd.h b/usr/scsi_cmnd.h
index 8bdcb19..696e588 100644
--- a/usr/scsi_cmnd.h
+++ b/usr/scsi_cmnd.h
@@ -1,145 +1,187 @@
 struct target;
 struct mgmt_req;
 
-/* needs to move somewhere else */
-#define SCSI_SENSE_BUFFERSIZE	252
+/*  needs to move somewhere else */
+#define SCSI_SENSE_BUFFERSIZE 252
 
 enum data_direction {
-	DATA_NONE = 0,
-	DATA_WRITE = 1,
-	DATA_READ = 2,
-	DATA_BIDIRECTIONAL = 3,
+    DATA_NONE = 0,
+    DATA_WRITE = 1,
+    DATA_READ = 2,
+    DATA_BIDIRECTIONAL = 3,
 };
 
 struct scsi_data_buffer {
-	uint64_t buffer;
-	uint32_t length;
-	uint32_t transfer_len;
-	int32_t resid;
+    uint64_t buffer;
+    uint32_t length;
+    uint32_t transfer_len;
+    int32_t resid;
 };
 
 struct scsi_cmd {
-	struct target *c_target;
-	/* linked it_nexus->cmd_hash_list */
-	struct list_head c_hlist;
-	struct list_head qlist;
-
-	uint64_t dev_id;
-
-	struct scsi_lu *dev;
-	unsigned long state;
-
-	enum data_direction data_dir;
-	struct scsi_data_buffer in_sdb;
-	struct scsi_data_buffer out_sdb;
-
-	uint64_t cmd_itn_id;
-	uint64_t offset;
-	uint32_t tl;
-	uint8_t *scb;
-	int scb_len;
-	uint8_t lun[8];
-	int attribute;
-	uint64_t tag;
-	int result;
-	struct mgmt_req *mreq;
-
-	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
-	int sense_len;
-
-	struct list_head bs_list;
-
-	struct it_nexus *it_nexus;
-	struct it_nexus_lu_info *itn_lu_info;
+    struct target* c_target;
+    /*  linked it_nexus->cmd_hash_list */
+    struct list_head c_hlist;
+    struct list_head qlist;
+
+    uint64_t dev_id;
+
+    struct scsi_lu* dev;
+    unsigned long state;
+
+    enum data_direction data_dir;
+    struct scsi_data_buffer in_sdb;
+    struct scsi_data_buffer out_sdb;
+
+    uint64_t cmd_itn_id;
+    uint64_t offset;
+    uint32_t tl;
+    uint8_t* scb;
+    int scb_len;
+    uint8_t lun[8];
+    int attribute;
+    uint64_t tag;
+    int result;
+    struct mgmt_req* mreq;
+
+    unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
+    int sense_len;
+
+    struct list_head bs_list;
+
+    struct it_nexus* it_nexus;
+    struct it_nexus_lu_info* itn_lu_info;
+};
+static inline void scsi_set_result(struct scsi_cmd* scmd, int val) {
+    scmd->result = val;
+}
+static inline int scsi_get_result(struct scsi_cmd* scmd) {
+    return scmd->result;
+};
+static inline void scsi_set_data_dir(struct scsi_cmd* scmd, enum data_direction val) {
+    scmd->data_dir = val;
+}
+static inline enum data_direction scsi_get_data_dir(struct scsi_cmd* scmd) {
+    return scmd->data_dir;
+};
+static inline void scsi_set_in_length(struct scsi_cmd* scmd, uint32_t val) {
+    scmd->in_sdb.length = (val);
+}
+static inline uint32_t scsi_get_in_length(struct scsi_cmd* scmd) {
+    return (scmd->in_sdb.length);
+}
+static inline void scsi_set_out_length(struct scsi_cmd* scmd, uint32_t val) {
+    scmd->out_sdb.length = (val);
+}
+static inline uint32_t scsi_get_out_length(struct scsi_cmd* scmd) {
+    return (scmd->out_sdb.length);
+};
+static inline void scsi_set_in_transfer_len(struct scsi_cmd* scmd, uint32_t val) {
+    scmd->in_sdb.transfer_len = (val);
+}
+static inline uint32_t scsi_get_in_transfer_len(struct scsi_cmd* scmd) {
+    return (scmd->in_sdb.transfer_len);
+}
+static inline void scsi_set_out_transfer_len(struct scsi_cmd* scmd, uint32_t val) {
+    scmd->out_sdb.transfer_len = (val);
+}
+static inline uint32_t scsi_get_out_transfer_len(struct scsi_cmd* scmd) {
+    return (scmd->out_sdb.transfer_len);
+};
+static inline void scsi_set_in_resid(struct scsi_cmd* scmd, int32_t val) {
+    scmd->in_sdb.resid = (val);
+}
+static inline int32_t scsi_get_in_resid(struct scsi_cmd* scmd) {
+    return (scmd->in_sdb.resid);
+}
+static inline void scsi_set_out_resid(struct scsi_cmd* scmd, int32_t val) {
+    scmd->out_sdb.resid = (val);
+}
+static inline int32_t scsi_get_out_resid(struct scsi_cmd* scmd) {
+    return (scmd->out_sdb.resid);
+};
+static inline void scsi_set_in_buffer(struct scsi_cmd* scmd, void* val) {
+    scmd->in_sdb.buffer = (unsigned long)(val);
+}
+static inline void* scsi_get_in_buffer(struct scsi_cmd* scmd) {
+    return (void*)(unsigned long)(scmd->in_sdb.buffer);
+}
+static inline void scsi_set_out_buffer(struct scsi_cmd* scmd, void* val) {
+    scmd->out_sdb.buffer = (unsigned long)(val);
+}
+static inline void* scsi_get_out_buffer(struct scsi_cmd* scmd) {
+    return (void*)(unsigned long)(scmd->out_sdb.buffer);
 };
 
-#define scsi_cmnd_accessor(field, type)						\
-static inline void scsi_set_##field(struct scsi_cmd *scmd, type val)		\
-{										\
-	scmd->field = val;							\
-}										\
-static inline type scsi_get_##field(struct scsi_cmd *scmd)			\
-{										\
-	return scmd->field;							\
-}
-
-scsi_cmnd_accessor(result, int);
-scsi_cmnd_accessor(data_dir, enum data_direction);
-
-
-#define scsi_data_buffer_accessor(field, type, set_cast, get_cast)		\
-	scsi_data_buffer_function(in, field, type, set_cast, get_cast)		\
-	scsi_data_buffer_function(out, field, type, set_cast, get_cast)
-
-#define scsi_data_buffer_function(dir, field, type, set_cast, get_cast)		\
-static inline void scsi_set_##dir##_##field(struct scsi_cmd *scmd, type val)	\
-{										\
-	scmd->dir##_sdb.field = set_cast (val);					\
-}										\
-static inline type scsi_get_##dir##_##field(struct scsi_cmd *scmd)		\
-{										\
-	return get_cast (scmd->dir##_sdb.field);				\
-}
-
-scsi_data_buffer_accessor(length, uint32_t, ,);
-scsi_data_buffer_accessor(transfer_len, uint32_t, ,);
-scsi_data_buffer_accessor(resid, int32_t, ,);
-scsi_data_buffer_accessor(buffer, void *, (unsigned long), (void *)(unsigned long));
-
-static inline void scsi_set_in_resid_by_actual(struct scsi_cmd *scmd,
-					       uint32_t transfer_len)
-{
-	uint32_t expected_len = scsi_get_in_length(scmd);
-	int32_t resid;
-
-	if (transfer_len <= expected_len)
-		resid = expected_len - transfer_len;
-	else {
-		resid = -(int32_t)(transfer_len - expected_len);
-		transfer_len = expected_len;
-	}
-	scsi_set_in_transfer_len(scmd, transfer_len);
-	scsi_set_in_resid(scmd, resid);
-}
-
-static inline void scsi_set_out_resid_by_actual(struct scsi_cmd *scmd,
-						uint32_t transfer_len)
-{
-	uint32_t expected_len = scsi_get_out_length(scmd);
-	int32_t resid;
-
-	if (transfer_len <= expected_len)
-		resid = expected_len - transfer_len;
-	else {
-		resid = -(int32_t)(transfer_len - expected_len);
-		transfer_len = expected_len;
-	}
-	scsi_set_out_transfer_len(scmd, transfer_len);
-	scsi_set_out_resid(scmd, resid);
+static inline void scsi_set_in_resid_by_actual(struct scsi_cmd* scmd,
+                                               uint32_t transfer_len) {
+    uint32_t expected_len = scsi_get_in_length(scmd);
+    int32_t resid;
+
+    if (transfer_len <= expected_len)
+        resid = expected_len - transfer_len;
+    else {
+        resid = -(int32_t)(transfer_len - expected_len);
+        transfer_len = expected_len;
+    }
+    scsi_set_in_transfer_len(scmd, transfer_len);
+    scsi_set_in_resid(scmd, resid);
+}
+
+static inline void scsi_set_out_resid_by_actual(struct scsi_cmd* scmd,
+                                                uint32_t transfer_len) {
+    uint32_t expected_len = scsi_get_out_length(scmd);
+    int32_t resid;
+
+    if (transfer_len <= expected_len)
+        resid = expected_len - transfer_len;
+    else {
+        resid = -(int32_t)(transfer_len - expected_len);
+        transfer_len = expected_len;
+    }
+    scsi_set_out_transfer_len(scmd, transfer_len);
+    scsi_set_out_resid(scmd, resid);
 }
 
 enum {
-	TGT_CMD_QUEUED,
-	TGT_CMD_PROCESSED,
-	TGT_CMD_ASYNC,
-	TGT_CMD_NOT_LAST,
+    TGT_CMD_QUEUED,
+    TGT_CMD_PROCESSED,
+    TGT_CMD_ASYNC,
+    TGT_CMD_NOT_LAST,
 };
-
-#define CMD_FNS(bit, name)						\
-static inline void set_cmd_##name(struct scsi_cmd *c)			\
-{									\
-	(c)->state |= (1UL << TGT_CMD_##bit);				\
-}									\
-static inline void clear_cmd_##name(struct scsi_cmd *c)			\
-{									\
-	(c)->state &= ~(1UL << TGT_CMD_##bit);				\
-}									\
-static inline int cmd_##name(const struct scsi_cmd *c)			\
-{									\
-	return ((c)->state & (1UL << TGT_CMD_##bit));			\
-}
-
-CMD_FNS(QUEUED, queued)
-CMD_FNS(PROCESSED, processed)
-CMD_FNS(ASYNC, async)
-CMD_FNS(NOT_LAST, not_last)
+static inline void set_cmd_queued(struct scsi_cmd* c) {
+    (c)->state |= (1UL << TGT_CMD_QUEUED);
+}
+static inline void clear_cmd_queued(struct scsi_cmd* c) {
+    (c)->state &= ~(1UL << TGT_CMD_QUEUED);
+}
+static inline int cmd_queued(const struct scsi_cmd* c) {
+    return ((c)->state & (1UL << TGT_CMD_QUEUED));
+}
+static inline void set_cmd_processed(struct scsi_cmd* c) {
+    (c)->state |= (1UL << TGT_CMD_PROCESSED);
+}
+static inline void clear_cmd_processed(struct scsi_cmd* c) {
+    (c)->state &= ~(1UL << TGT_CMD_PROCESSED);
+}
+static inline int cmd_processed(const struct scsi_cmd* c) {
+    return ((c)->state & (1UL << TGT_CMD_PROCESSED));
+}
+static inline void set_cmd_async(struct scsi_cmd* c) {
+    (c)->state |= (1UL << TGT_CMD_ASYNC);
+}
+static inline void clear_cmd_async(struct scsi_cmd* c) {
+    (c)->state &= ~(1UL << TGT_CMD_ASYNC);
+}
+static inline int cmd_async(const struct scsi_cmd* c) {
+    return ((c)->state & (1UL << TGT_CMD_ASYNC));
+}
+static inline void set_cmd_not_last(struct scsi_cmd* c) {
+    (c)->state |= (1UL << TGT_CMD_NOT_LAST);
+}
+static inline void clear_cmd_not_last(struct scsi_cmd* c) {
+    (c)->state &= ~(1UL << TGT_CMD_NOT_LAST);
+}
+static inline int cmd_not_last(const struct scsi_cmd* c) {
+    return ((c)->state & (1UL << TGT_CMD_NOT_LAST));
+}
-- 
2.8.1
