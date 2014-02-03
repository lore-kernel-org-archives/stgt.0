From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] iser: Fix discovery over iser on non default port
Date: Mon,  3 Feb 2014 17:57:37 +0200
Message-ID: <1391443057-21148-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

Build the target list with the socket port instead of
using ISCSI_LISTEN_PORT.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/iscsi/iser_text.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/usr/iscsi/iser_text.c b/usr/iscsi/iser_text.c
index 08cdfe5..16520cb 100644
--- a/usr/iscsi/iser_text.c
+++ b/usr/iscsi/iser_text.c
@@ -832,6 +832,7 @@ static void iser_text_scan(struct iscsi_connection *iscsi_conn,
 			struct sockaddr_storage ss;
 			socklen_t slen, blen;
 			char *p, buf[NI_MAXHOST + 128];
+			int port;
 
 			if (value[0] == 0)
 				continue;
@@ -857,7 +858,14 @@ static void iser_text_scan(struct iscsi_connection *iscsi_conn,
 			if (ss.ss_family == AF_INET6)
 				 *p++ = ']';
 
-			sprintf(p, ":%d,1", ISCSI_LISTEN_PORT);
+			if (ss.ss_family == AF_INET6)
+				port = ntohs(((struct sockaddr_in6 *)
+						&ss)->sin6_port);
+			else
+				port = ntohs(((struct sockaddr_in *)
+						&ss)->sin_port);
+
+			sprintf(p, ":%d,1", port);
 			iser_target_list_build(iscsi_conn, tx_pdu, buf,
 					  strcmp(value, "All") ? value : NULL);
 		} else
-- 
1.7.8.2
