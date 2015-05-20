From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 1/2] iser: Clear tasks free list when closing the connection
Date: Wed, 20 May 2015 11:45:55 +0300
Message-ID: <1432111556-20535-2-git-send-email-sagig@mellanox.com>
References: <1432111556-20535-1-git-send-email-sagig@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1432111556-20535-1-git-send-email-sagig@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

In discovery sessions, iser has posted the RX descriptors
and cancelled the event that enabled it to consume the flushes.

So, just clear the tasks free list at conn_close too (safe).

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/iscsi/iser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index 9519862..3925de3 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -1279,6 +1279,7 @@ void iser_conn_close(struct iser_conn *conn)
 	if (err)
 		eprintf("conn:%p rdma_disconnect failed, %m\n", &conn->h);
 
+	iser_ib_clear_tx_list(conn);
 	list_del(&conn->conn_list);
 
 	tgt_remove_sched_event(&conn->sched_buf_alloc);
-- 
1.8.4.3
