From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 3/3] mgmt.c: check that the connecting user is the same as the user tgtd runs as
Date: Tue,  7 Apr 2015 11:40:34 -0700
Message-ID: <1428432034-28682-4-git-send-email-ronniesahlberg@gmail.com>
References: <1428432034-28682-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gdl8i9WknijheGaNpN9bJY2oe7JDwrYEqjqAXf0FLfI=;
        b=wriZmZkm6nj+Z2Hzy56qilhizKsr98mV9QwbvVwxgT3coXGxzitj4eIkfj2TAkmv6c
         +W6uKZCYZBo4aqwC0Y5+kNtOIrB4tyI2bw4IVxmUa9naGitND1usM1cBaIIB1Rg7k4xD
         ueh5nrdiigwTNSmtYDMWMRfJyyGsn2xt9qFjUNVSHQh3aXNKMs+vn/IVA04fxVnYNCD2
         xWOUUHQz06STqGxL3nGS1Lzrw3FSHRm4Z+ad+pqaFtmXniiwy8RtdeOVsEZwkYSdqfkW
         VeyE3XdwEgQx7/AkRLHCKXoaAmRn/jcJmZIUc6WyZSO4yeIMhSF8M1aezcMuL9s+KYm5
         tRWQ==
In-Reply-To: <1428432034-28682-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

Change the ipc_perm() check from being a check that the connected user and group
is set to root into instead check that the user/group matches
the running tgtd process.
This is needed in order to run tgtd as a normal non-root user.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/mgmt.c b/usr/mgmt.c
index 3587f4b..c2bd176 100644
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
