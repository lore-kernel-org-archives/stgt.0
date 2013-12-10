From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] iscsi/conn.c: fix a typo s/sesson/session/
Date: Tue, 10 Dec 2013 23:27:17 +0900
Message-ID: <1386685637-24388-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This fixes a typo "sesson" in an error message of conn_close function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/iscsi/conn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/iscsi/conn.c b/usr/iscsi/conn.c
index 17aa3e3..bb18ac0 100644
--- a/usr/iscsi/conn.c
+++ b/usr/iscsi/conn.c
@@ -106,7 +106,7 @@ void conn_close(struct iscsi_connection *conn)
 	if (!conn->session)
 		goto done;
 
-	eprintf("sesson %p %d\n", conn->session, conn->session->refcount);
+	eprintf("session %p %d\n", conn->session, conn->session->refcount);
 
 	/*
 	 * We just closed the ep so we are not going to send/recv anything.
-- 
1.7.9.3
