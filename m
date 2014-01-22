From: Thomas Matysik <thomas@belton.co.nz>
Subject: [PATCH 1/2] Fix bs_rbd.c slurp_to_semi() not consuming terminating semicolon
Date: Wed, 22 Jan 2014 15:14:18 +1300
Message-ID: <1390356859-7557-1-git-send-email-thomas@belton.co.nz>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Thomas Matysik <thomas@belton.co.nz>

slurp_to_semi() would not consume the terminating semicolon on a
option specified in --bsopts, so any options other than the first
would be ignored as invalid.

Signed-off-by: Thomas Matysik <thomas@belton.co.nz>
---
 usr/bs_rbd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/usr/bs_rbd.c b/usr/bs_rbd.c
index 3ea9d36..f797fd5 100644
--- a/usr/bs_rbd.c
+++ b/usr/bs_rbd.c
@@ -480,6 +480,9 @@ static char *slurp_to_semi(char **p)
 	strncpy(ret, *p, len);
 	ret[len] = '\0';
 	*p = end;
+	// Jump past the semicolon, if we stopped at one
+	if (**p == ';')
+		*p = end + 1;
 	return ret;
 }
 
-- 
1.8.1.2
