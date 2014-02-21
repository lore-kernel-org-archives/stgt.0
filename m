From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] iscsi: fix leak of session->initiator_alias
Date: Fri, 21 Feb 2014 22:15:02 +0900
Message-ID: <1392988502-8734-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

session->initiator_alias is not freed in error paths of
session_create() and even in the normal path of session_destroy().

This fixes these leak bugs.

Note that we don't have to do a null check for
session->initiator_alias before calling free(session->initiator_alias)
because free() function simply ignores NULL pointer.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/iscsi/session.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/usr/iscsi/session.c b/usr/iscsi/session.c
index 98c0949..22638e7 100644
--- a/usr/iscsi/session.c
+++ b/usr/iscsi/session.c
@@ -106,8 +106,7 @@ int session_create(struct iscsi_connection *conn)
 	session->info = zalloc(1024);
 	if (!session->info) {
 		free(session->initiator);
-		if (session->initiator_alias)
-			free(session->initiator_alias);
+		free(session->initiator_alias);
 		free(session);
 		return -ENOMEM;
 	}
@@ -124,6 +123,7 @@ int session_create(struct iscsi_connection *conn)
 	err = it_nexus_create(target->tid, tsih, 0, session->info);
 	if (err) {
 		free(session->initiator);
+		free(session->initiator_alias);
 		free(session->info);
 		free(session);
 		return err;
@@ -174,6 +174,7 @@ static void session_destroy(struct iscsi_session *session)
 	list_del(&session->hlist);
 
 	free(session->initiator);
+	free(session->initiator_alias);
 	free(session->info);
 	free(session);
 }
-- 
1.7.9.3
