From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] iser: fix local conn params being reset to default
Date: Tue, 28 Oct 2014 17:41:06 +0200
Message-ID: <1414510866-14770-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

Instead of reseting the params to default if they pass it
we should reset to max if they pass it.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/iscsi/iser_text.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/iscsi/iser_text.c b/usr/iscsi/iser_text.c
index 8180dbc..b8c5136 100644
--- a/usr/iscsi/iser_text.c
+++ b/usr/iscsi/iser_text.c
@@ -342,8 +342,8 @@ static int iser_login_check_params(struct iscsi_connection *iscsi_conn,
 		if (p[i].state == KEY_STATE_START && p[i].val != session_keys[i].def) {
 			if (iscsi_conn->state == STATE_LOGIN) {
 				if (i >= ISCSI_PARAM_FIRST_LOCAL) {
-					if (p[i].val > session_keys[i].def)
-						p[i].val = session_keys[i].def;
+					if (p[i].val > session_keys[i].max)
+						p[i].val = session_keys[i].max;
 					p[i].state = KEY_STATE_DONE;
 					continue;
 				}
-- 
1.8.4.3
