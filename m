From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH] tgtd: let conn_close() transfer state of a connection
Date: Mon, 17 Feb 2014 17:12:29 +0900
Message-ID: <1392624749-18940-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Current tgtd seems to have a possibility that it has a connection
whose state isn't STATE_CLOSE even after the connection is passed to
conn_close(). Such a connection is confusing because
iscsi_scsi_cmd_done() cannot detect the closing of the connection.

This patch lets conn_close() transfer state of a connection to
STATE_CLOSE for avoiding this purpose.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/iscsi/conn.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/usr/iscsi/conn.c b/usr/iscsi/conn.c
index bb18ac0..cfd6b3e 100644
--- a/usr/iscsi/conn.c
+++ b/usr/iscsi/conn.c
@@ -88,6 +88,8 @@ void conn_close(struct iscsi_connection *conn)
 	struct iscsi_task *task, *tmp;
 	int ret;
 
+	conn->state = STATE_CLOSE;
+
 	if (conn->closed) {
 		eprintf("already closed %p %u\n", conn, conn->refcount);
 		return;
-- 
1.7.10.4
