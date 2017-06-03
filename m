From: Andy Grover <agrover@redhat.com>
Subject: [PATCH] Fix compiler error in tgtd.c call_program
Date: Sat,  3 Jun 2017 14:33:59 -0700
Message-ID: <20170603213359.16089-1-agrover@redhat.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com AB6D83D956
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Using a newer version of gcc, we see an error:

tgtd.c:313:14: error: comparison between pointer and zero character
 constant [-Werror=pointer-compare]
   while (pos != '\0')
              ^~
tgtd.c:313:10: note: did you mean to dereference the pointer?
   while (pos != '\0')
          ^
I think gcc is right, so deref pos.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 usr/tgtd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/tgtd.c b/usr/tgtd.c
index 19c703d..ae2f489 100644
--- a/usr/tgtd.c
+++ b/usr/tgtd.c
@@ -310,7 +310,7 @@ int call_program(const char *cmd, void (*callback)(void *data, int result),
 	pos = arg;
 	str_spacecpy(&pos, cmd);
 	if (strchr(cmd, ' ')) {
-		while (pos != '\0')
+		while (*pos != '\0')
 			argv[i++] = strsep(&pos, " ");
 	} else
 		argv[i++] = arg;
-- 
2.9.4
