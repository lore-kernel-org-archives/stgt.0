From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] iser: fix segfault when not passing options to iser param
Date: Mon, 25 Jul 2016 17:00:38 +0300
Message-ID: <1469455238-26716-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/iscsi/iser.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index 7befd06..67d5c83 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -3583,6 +3583,9 @@ static int iser_param_parser(char *p)
 	int err = 0;
 	char *q;
 
+	if (!p)
+	    return 0;
+
 	while (*p) {
 		if (!strncmp(p, lld_param_port, strlen(lld_param_port))) {
 			short int port_val;
-- 
1.8.4.3
