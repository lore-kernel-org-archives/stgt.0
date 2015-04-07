From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 3/3] mgmt.c: check that the socket is owned by the current user, not root
Date: Tue,  7 Apr 2015 11:29:09 -0700
Message-ID: <1428431349-24087-4-git-send-email-ronniesahlberg@gmail.com>
References: <1428431349-24087-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H1iBt7yB5TC6APGEOi5y4pafcAAMuhPQ2ymcHZFzFSo=;
        b=g+JJuyKjcUEVkEBUXrD+jSnBLd1tGAplPK7+ttcoB5zSISbzOgSAU9juu8TT52ob4J
         QZVbSYHfcTn2CtzuSkDWg4qqhqtWbUWLMjH16oLw2KfYm7JxpKNUHIXs1X1XVDcDlI0u
         BbSggZ0dFYkLLVjo2iGJ2y7ZiiYQgSMu19m8J8jvqsrfzo8gAIhDG5mLmzC0pK3312VD
         pcwGsymgNIDkdGkBZBbVUauytuSb0sEH/1Ns4ZwATfKr3X6UQK3++ADLF+tM1Jj0yktS
         rMjx9D7mI3EhECUWXc0jxt6Q5zkcXktes2yugPJ/7aKe9dzNmC44CoojtdxrPu3ssohZ
         ov+g==
In-Reply-To: <1428431349-24087-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

Change the ipc_perm() check from being a check that the socket user and group
is set to root into instead check that the socket user/group matches
the running tgtd process.
This is needed in order to run tgtd as a normal non-root user.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/mgmt.c b/usr/mgmt.c
index 364b3c8..ebe0fd6 100644
--- a/usr/mgmt.c
+++ b/usr/mgmt.c
@@ -569,7 +569,7 @@ static int ipc_perm(int fd)
 		return -1;
 	}
 
-	if (cred.uid || cred.gid)
+	if (cred.uid != getuid() || cred.gid != getgid())
 		return -EPERM;
 
 	return 0;
-- 
2.1.0
