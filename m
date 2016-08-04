From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] Fix compile warnings
Date: Thu,  4 Aug 2016 15:26:29 +0300
Message-ID: <1470313589-15347-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

Because of unused return values.
Also set gcc Werror flag to consider warnings as errors.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/Makefile       |  2 +-
 usr/bs_rdwr.c      |  2 --
 usr/bs_ssc.c       |  2 --
 usr/iscsi/iscsid.c |  6 ++----
 usr/iscsi/iser.c   | 11 ++++-------
 usr/parser.c       |  9 ++++-----
 6 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/usr/Makefile b/usr/Makefile
index d4e3eaf..decf13c 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -45,7 +45,7 @@ CFLAGS += -g -O0 -ggdb -rdynamic
 else
 CFLAGS += -g -O2 -fno-strict-aliasing
 endif
-CFLAGS += -Wall -Wstrict-prototypes -fPIC
+CFLAGS += -Wall -Wstrict-prototypes -Werror -fPIC
 CFLAGS += -DTGT_VERSION=\"$(VERSION)$(EXTRAVERSION)\"
 CFLAGS += -DBSDIR=\"$(DESTDIR)$(libdir)/backing-store\"
 
diff --git a/usr/bs_rdwr.c b/usr/bs_rdwr.c
index 56d086d..09f6bb8 100644
--- a/usr/bs_rdwr.c
+++ b/usr/bs_rdwr.c
@@ -65,7 +65,6 @@ static void bs_rdwr_request(struct scsi_cmd *cmd)
 	int result = SAM_STAT_GOOD;
 	uint8_t key;
 	uint16_t asc;
-	uint32_t info = 0;
 	char *tmpbuf;
 	size_t blocksize;
 	uint64_t offset = cmd->offset;
@@ -149,7 +148,6 @@ static void bs_rdwr_request(struct scsi_cmd *cmd)
 			for (pos = 0; pos < length && *spos++ == *dpos++;
 			     pos++)
 				;
-			info = pos;
 			result = SAM_STAT_CHECK_CONDITION;
 			key = MISCOMPARE;
 			asc = ASC_MISCOMPARE_DURING_VERIFY_OPERATION;
diff --git a/usr/bs_ssc.c b/usr/bs_ssc.c
index fe1ff18..5119163 100644
--- a/usr/bs_ssc.c
+++ b/usr/bs_ssc.c
@@ -684,8 +684,6 @@ static void bs_ssc_exit(struct scsi_lu *lu)
 
 static void bs_ssc_close(struct scsi_lu *lu)
 {
-	struct ssc_info *ssc;
-	ssc = dtype_priv(lu);
 	dprintf("##### Close #####\n");
 	close(lu->fd);
 }
diff --git a/usr/iscsi/iscsid.c b/usr/iscsi/iscsid.c
index 106ec65..2918615 100644
--- a/usr/iscsi/iscsid.c
+++ b/usr/iscsi/iscsid.c
@@ -1597,7 +1597,6 @@ static int iscsi_task_queue(struct iscsi_task *task)
 	struct iscsi_hdr *req = (struct iscsi_hdr *) &task->req;
 	uint32_t cmd_sn;
 	struct iscsi_task *ent;
-	int err;
 
 	dprintf("%x %x %x\n", be32_to_cpu(req->statsn), session->exp_cmd_sn,
 		req->opcode);
@@ -1611,7 +1610,7 @@ static int iscsi_task_queue(struct iscsi_task *task)
 		session->exp_cmd_sn = ++cmd_sn;
 
 		/* Should we close the connection... */
-		err = iscsi_task_execute(task);
+		iscsi_task_execute(task);
 
 		if (list_empty(&session->pending_cmd_list))
 			return 0;
@@ -1960,13 +1959,12 @@ static int iscsi_scsi_cmd_tx_done(struct iscsi_connection *conn)
 static int iscsi_task_tx_done(struct iscsi_connection *conn)
 {
 	struct iscsi_task *task = conn->tx_task;
-	int err;
 	uint8_t op;
 
 	op = task->req.opcode & ISCSI_OPCODE_MASK;
 	switch (op) {
 	case ISCSI_OP_SCSI_CMD:
-		err = iscsi_scsi_cmd_tx_done(conn);
+		iscsi_scsi_cmd_tx_done(conn);
 		break;
 	case ISCSI_OP_NOOP_IN:
 		/* NOOP_IN req is allocated within iscsi_tcp
diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index 67d5c83..c7c43b2 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -2196,7 +2196,6 @@ static void iser_sched_rdma_rd(struct event_data *evt)
 	struct iser_task *prev_task = NULL;
 	struct iser_task *task = NULL;
 	int num_reqs = 0;
-	int err;
 
 	if (unlikely(conn->h.state != STATE_FULL)) {
 		dprintf("conn:%p closing, ignoring rdma_rd\n", conn);
@@ -2220,7 +2219,7 @@ static void iser_sched_rdma_rd(struct event_data *evt)
 	if (prev_task) {
 		prev_task->rdmad.send_wr.next = NULL;
 		/* submit the chain of rdma-rd requests, start from the first */
-		err = iser_post_send(conn, first_wr, num_reqs);
+		iser_post_send(conn, first_wr, num_reqs);
 
 		/* ToDo: error handling */
 	}
@@ -2234,7 +2233,6 @@ static void iser_sched_tx(struct event_data *evt)
 	struct iser_task *task;
 	struct iser_work_req *cur_send_wr;
 	int num_reqs = 0;
-	int err;
 
 	if (unlikely(conn->h.state == STATE_CLOSE)) {
 		dprintf("conn:%p closing, ignoring tx\n", conn);
@@ -2267,7 +2265,7 @@ static void iser_sched_tx(struct event_data *evt)
 	if (prev_task) {
 		prev_task->txd.send_wr.next = NULL;
 		/* submit the chain of rdma-wr & tx reqs, start from the first */
-		err = iser_post_send(conn, first_wr, num_reqs);
+		iser_post_send(conn, first_wr, num_reqs);
 
 		/* ToDo: error handling */
 	}
@@ -2280,7 +2278,6 @@ static void iser_sched_post_recv(struct event_data *evt)
 	struct iser_task *prev_task = NULL;
 	struct iser_task *task;
 	int num_recv_bufs = 0;
-	int err;
 
 	if (unlikely(conn->h.state != STATE_FULL)) {
 		dprintf("conn:%p closing, ignoring post recv\n", conn);
@@ -2304,7 +2301,7 @@ static void iser_sched_post_recv(struct event_data *evt)
 	if (prev_task) {
 		prev_task->rxd.recv_wr.next = NULL;
 		/* post the chain of recv buffers, start from the first */
-		err = iser_post_recv(conn, first_task, num_recv_bufs);
+		iser_post_recv(conn, first_task, num_recv_bufs);
 
 		/* ToDo: error handling */
 	}
@@ -2802,7 +2799,7 @@ static int iser_rx_handler_non_ff(struct iser_task *task)
 			conn, conn->h.state);
 		break;
 	}
-	return 0;
+	return err;
 }
 
 static void iser_rx_handler(struct iser_work_req *rxd)
diff --git a/usr/parser.c b/usr/parser.c
index 0b244e4..7b892a5 100644
--- a/usr/parser.c
+++ b/usr/parser.c
@@ -30,7 +30,6 @@ static int match_one(char *s, char *p, substring_t args[])
 {
 	char *meta;
 	int argc = 0;
-	unsigned long long ret;
 
 	if (!p)
 		return 1;
@@ -69,16 +68,16 @@ static int match_one(char *s, char *p, substring_t args[])
 			args[argc].to = s + len;
 			break;
 		case 'd':
-			ret = strtol(s, &args[argc].to, 0);
+			strtol(s, &args[argc].to, 0);
 			goto num;
 		case 'u':
-			ret = strtoul(s, &args[argc].to, 0);
+			strtoul(s, &args[argc].to, 0);
 			goto num;
 		case 'o':
-			ret = strtoul(s, &args[argc].to, 8);
+			strtoul(s, &args[argc].to, 8);
 			goto num;
 		case 'x':
-			ret = strtoul(s, &args[argc].to, 16);
+			strtoul(s, &args[argc].to, 16);
 		num:
 			if (args[argc].to == args[argc].from)
 				return 0;
-- 
1.8.4.3
