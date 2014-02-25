From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: iscsi: Move two messages to be logged as debug and not as errors
Date: Tue, 25 Feb 2014 14:53:58 +0200
Message-ID: <1393332838-12900-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Dennis Cullison <Dennis.Cullison@Teradata.com>

Move two messages which are printed when connections are close from error
to debug level.

Without this change, a message currently gets logged every time an automatic
discovery process runs on the initiator node when using the discovery database.
When using multiple Control Ports, there are a lot of messages getting logged.
These essentially flood the /var/log/messages file on the initiator.

Signed-off-by: Dennis Cullison <Dennis.Cullison@Teradata.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
---
 usr/iscsi/conn.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/iscsi/conn.c b/usr/iscsi/conn.c
index bb18ac0..4cef6fd 100644
--- a/usr/iscsi/conn.c
+++ b/usr/iscsi/conn.c
@@ -100,13 +100,13 @@ void conn_close(struct iscsi_connection *conn)
 		eprintf("failed to close a connection, %p %u %s\n",
 			conn, conn->refcount, strerror(errno));
 	else
-		eprintf("connection closed, %p %u\n", conn, conn->refcount);
+		dprintf("connection closed, %p %u\n", conn, conn->refcount);
 
 	/* may not have been in FFP yet */
 	if (!conn->session)
 		goto done;
 
-	eprintf("session %p %d\n", conn->session, conn->session->refcount);
+	dprintf("session %p %d\n", conn->session, conn->session->refcount);
 
 	/*
 	 * We just closed the ep so we are not going to send/recv anything.
-- 
1.7.1
