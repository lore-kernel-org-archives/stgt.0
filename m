From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v3 3/3] bs_sheepdog.c: test connection when new logical unit is created
Date: Thu, 17 Oct 2013 16:38:34 +0900
Message-ID: <1381995514-8816-4-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1381995514-8816-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1381995514-8816-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
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

v3: return error when --backing-store is invalid form

 usr/bs_sheepdog.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index de66d59..1eb09c0 100644
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
@@ -999,6 +1008,7 @@ trans_to_expect_nothing:
 			eprintf("invalid VDI path of sheepdog, unexpected"\
 				" token: %s (entire: %s)\n",
 				result, orig_filename);
+			ret = -1;
 			goto out;
 		default:
 			eprintf("BUG: invalid state of parser: %d\n",
@@ -1011,6 +1021,7 @@ trans_to_expect_nothing:
 	    parse_state != EXPECT_TAG_OR_SNAP) {
 		eprintf("invalid VDI path of sheepdog: %s (state: %d)\n",
 			orig_filename, parse_state);
+		ret = -1;
 		goto out;
 	}
 
@@ -1020,6 +1031,26 @@ trans_to_expect_nothing:
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
+		ret = -1;
+		goto out;
+	}
+
+	close(fd);		/* we don't need this connection */
+
 	if (snapid == -1)
 		dprintf("tag: %s\n", tag);
 	else
-- 
1.7.10.4

