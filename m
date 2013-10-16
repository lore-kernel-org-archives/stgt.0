From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v2 3/3] bs_sheepdog.c: test connection when new logical unit is created
Date: Wed, 16 Oct 2013 17:42:08 +0900
Message-ID: <1381912928-7462-4-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1381912928-7462-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1381912928-7462-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

This patch adds creation of a test connection in the process of making
logical unit. This is required for validating --backing-store option
and avoid forever trying of reconnection.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index de66d59..a0dc896 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -909,7 +909,7 @@ out:
 
 static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 {
-	int ret = 0, i, len;
+	int ret = 0, i, len, fd;
 	uint32_t vid = 0;
 	char *orig_filename;
 
@@ -973,6 +973,15 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 			parse_state = EXPECT_PORT;
 			break;
 		case EXPECT_PORT:
+			len = strlen(result);
+			for (i = 0; i < len; i++) {
+				if (!isdigit(result[i])) {
+					eprintf("invalid tcp port number:"\
+						" %s\n", result);
+					return -1;
+				}
+			}
+
 			ai->port = atoi(result);
 			parse_state = EXPECT_VDI;
 			break;
@@ -1020,6 +1029,25 @@ trans_to_expect_nothing:
 	else
 		dprintf("hostname: %s, port: %d\n", ai->hostname, ai->port);
 
+	/*
+	 * test connection for validating command line option
+	 *
+	 * if this step is skipped, the main thread of tgtd will try to
+	 * reconnect to sheep process forever
+	 */
+	fd = ai->is_unix ?
+		connect_to_sdog_unix(ai->uds_path) :
+		connect_to_sdog_tcp(ai->hostname, ai->port);
+
+	if (fd < 0) {
+		eprintf("connecting to sheep process failed, "\
+			"please verify the --backing-store option: %s",
+			orig_filename);
+		return -1;
+	}
+
+	close(fd);		/* we don't need this connection */
+
 	if (snapid == -1)
 		dprintf("tag: %s\n", tag);
 	else
-- 
1.7.10.4

