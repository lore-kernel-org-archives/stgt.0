From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] iser: fix tasks leak with all its resources
Date: Wed,  7 Jan 2015 18:42:14 +0200
Message-ID: <1420648934-10219-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

On timewait_exit cm event we expect to put the last refcount on conn and
release it. Since we already after the connection was closed we
could have tasks in tx_list that won't be processed.
We need to clean them or refcount won't reach 0.
Not cleaning the tasks will also leak any rdma_bufs associated with those
tasks.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/iscsi/iser.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index ace8da3..f262ed6 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -1644,7 +1644,27 @@ static void iser_cm_timewait_exit(struct rdma_cm_event *ev)
 	struct rdma_cm_id *cm_id = ev->id;
 	struct iser_conn *conn = cm_id->context;
 
-	eprintf("conn:%p cm_id:%p\n", &conn->h, cm_id);
+	eprintf("conn:%p refcnt:%d cm_id:%p\n",
+		&conn->h, conn->h.refcount, cm_id);
+
+	if (conn->h.state == STATE_CLOSE) {
+		/*
+		 * Tasks sitting in the conn->tx_list are stuck there after we
+		 * close the conn and since each holds a reference on the conn
+		 * we need to clean them up explicitly now.  Otherwise they will
+		 * prevent the conn from being cleaned up (since the refcount
+		 * won't reach zero).  If the conn doesn't get cleaned up, then
+		 * along with leaking the conn itself (and all its resources),
+		 * we'll also leak any rdma_buf's associated with the tasks.
+		 * Since the rdma_buf pool is associated with the iser_device
+		 * and so gets reused when a new iser_conn connection is
+		 * established, leaking too many of those bufs will eventually
+		 * clear the pool.
+		 */
+		iser_ib_clear_tx_list(conn);
+		eprintf("conn:%p refcnt:%d cm_id:%p (after cleanup)\n",
+			&conn->h, conn->h.refcount, cm_id);
+	}
 
 	/* Refcount was incremented just before accepting the connection,
 	   typically this is the last decrement and the connection will be
-- 
1.8.4.3
