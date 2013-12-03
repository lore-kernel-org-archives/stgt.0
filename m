From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: fix up buffer overrun issues with unix domain socket
Date: Tue,  3 Dec 2013 10:28:42 +0900
Message-ID: <1386034122-8854-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

The current sheepdog driver still has two buffer overrun issues due to
unsafe strncpy uses for the pathname buffer of unix domain socket:

1) The size of "sun_path" string buffer of "sockaddr_un" structure is
   108 bytes, however, UNIX_PATH_MAX macro is locally defined as 109.
   So, the following strncpy use at connect_to_sdog_unix function
   still can be filled without a terminating null byte.

      strncpy(un.sun_path, path, UNIX_PATH_MAX - 1);

2) The following use of strncpy at sd_open function also has a buffer
   overrun issue because the size of ai->uds_path is the same as
   UNIX_PATH_MAX.

      strncpy(ai->uds_path, result, UNIX_PATH_MAX);

Moreover, the local definition of UNIX_PATH_MAX, which gives the
buffer size of unix domain socket pathname, is confusing.  It is
traditionally used to define the size of "sun_path" string buffer of
"sockaddr_un", which is 108 bytes including a terminating null byte,
but this local macro sets it to 109 bytes.

This patch fixes up these issues.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 315f3aa..43f3157 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -220,7 +220,7 @@ struct sheepdog_fd_list {
 	struct list_head list;
 };
 
-#define UNIX_PATH_MAX (108 + 1)
+#define UNIX_PATH_MAX 108
 
 struct sheepdog_access_info {
 	int is_unix;
@@ -398,7 +398,7 @@ static int connect_to_sdog_unix(const char *path)
 
 	memset(&un, 0, sizeof(un));
 	un.sun_family = AF_UNIX;
-	strncpy(un.sun_path, path, UNIX_PATH_MAX - 1);
+	strncpy(un.sun_path, path, sizeof(un.sun_path) - 1);
 
 	ret = connect(fd, (const struct sockaddr *)&un, (socklen_t)sizeof(un));
 	if (ret < 0) {
@@ -967,7 +967,7 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
 			}
 			break;
 		case EXPECT_PATH:
-			strncpy(ai->uds_path, result, UNIX_PATH_MAX);
+			strncpy(ai->uds_path, result, UNIX_PATH_MAX - 1);
 			parse_state = EXPECT_VDI;
 			break;
 		case EXPECT_HOST:
-- 
1.7.9.3
