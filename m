From: Feng Li <li.feng@oracle.com>
Subject: [PATCH 1/2] fix memory leak in session.c
Date: Thu,  2 Jun 2016 15:17:10 +0800
Message-ID: <1464851831-105676-1-git-send-email-li.feng@oracle.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Feng Li <lifeng1519@gmail.com>

From: Feng Li <lifeng1519@gmail.com>

Memory leaks when memory allocation fails.

Signed-off-by: Feng Li <lifeng1519@gmail.com>
---
 usr/iscsi/session.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/usr/iscsi/session.c b/usr/iscsi/session.c
index 22638e7..09d4442 100644
--- a/usr/iscsi/session.c
+++ b/usr/iscsi/session.c
@@ -98,6 +98,7 @@ int session_create(struct iscsi_connection *conn)
 	if (conn->initiator_alias) {
 		session->initiator_alias = strdup(conn->initiator_alias);
 		if (!session->initiator_alias) {
+			free(session->initiator);
 			free(session);
 			return -ENOMEM;
 		}
-- 
2.8.1
