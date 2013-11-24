From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: [PATCH] bs_sheepdog.c: fix an unsafe strncpy() call
Date: Sun, 24 Nov 2013 23:18:09 +0900
Message-ID: <1385302689-22999-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=gnl85Slga5TzOzDDzi5DsLAgN+0cHY8Uu1h0eivRqDM=;
        b=N8fchB2rRitOUxC63yI6HTLb9sbWVbSDF9G80a/oHrh5Pe4AaJ+KwPlAP6m4P+sYfh
         S4/LLW83a1cRDG/WYUUQVqbxafsZa0mZ125cIsw9Y85Q1mL4ROAj7MDTKrjfHvoGyhxz
         IsSX6rayqJpyiSBP+aXRFStxA7K8uVbUjXqURcdjHxSU1LQChjV1S87/JGTFai6gre0r
         3D8t2G6FjUT4FGuND7ns/5B4oCKeM1lRA2k4CHgvKMCOqsbPZuUVelRUOGYrghwtd4uO
         +tG33DQ8LiQij5ylvVyiBFqfiIP4if7Zw09LNJumhN2hIf0EMXaw5bvlJa0BcTRtpMgn
         3TMQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

The strncpy() call doesn't take a null terminator into account. On
some environment, it conflicts with __builtin___strncpy_chk() and gcc
warns.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 1dda915..16547d0 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -398,7 +398,7 @@ static int connect_to_sdog_unix(const char *path)
 
 	memset(&un, 0, sizeof(un));
 	un.sun_family = AF_UNIX;
-	strncpy(un.sun_path, path, UNIX_PATH_MAX);
+	strncpy(un.sun_path, path, UNIX_PATH_MAX - 1);
 
 	ret = connect(fd, (const struct sockaddr *)&un, (socklen_t)sizeof(un));
 	if (ret < 0) {
-- 
1.8.1.2
