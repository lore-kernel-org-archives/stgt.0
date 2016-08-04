From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] Reject target names with invalid characters
Date: Thu,  4 Aug 2016 13:19:12 +0300
Message-ID: <1470305952-16492-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

Reject target names that do not consist on chars described in
RFC 7143 section 4.2.7 iSCSI Name Encoding.

A user could create target names with invalid characters which could
break initiators. e.g. creating target with chars that are not allowed
in a file name and using Linux open-iscsi initiator which create folders
based the target names.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/target.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/usr/target.c b/usr/target.c
index f109f17..8432438 100644
--- a/usr/target.c
+++ b/usr/target.c
@@ -29,6 +29,7 @@
 #include <unistd.h>
 #include <sys/socket.h>
 #include <sys/time.h>
+#include <ctype.h>
 
 #include "list.h"
 #include "util.h"
@@ -2138,6 +2139,13 @@ tgtadm_err tgt_target_create(int lld, int tid, char *args)
 		}
 	};
 
+	for (p = targetname; *p != '\0'; p++) {
+	    if (isalnum(*p) || *p == ':' || *p == '.' || *p == '-')
+		continue;
+	    eprintf("Target name %s has invalid characters\n", targetname);
+	    return TGTADM_INVALID_REQUEST;
+	}
+
 	if (!targetname)
 		return TGTADM_INVALID_REQUEST;
 
-- 
1.8.4.3
