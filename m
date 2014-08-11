From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH] sheepdog: protocol update for revivng backward compatibility
Date: Mon, 11 Aug 2014 14:48:39 +0900
Message-ID: <1407736119-18601-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=PiMwtuSRrsI+P2HfICil9+q7oaCZXO15PvK9c2cgiC4=;
        b=DGgvppHweWvZpaw1kSeyFZcEsCwMqIzrzt1KQU9E0ndkNjvS4kuYPjZ4ho92y4Lkk7
         OdKAtL2ZTidJ6mZoh4jdk0B27gExkJj66NwnUp4IMcuugmzIreKqZr1eS5cHkNbAGmF6
         hDir1guHRkG0yYk9/MbSAowpAF0ZqwwXIA2ZAXVPF9vHmQVPDZ1t/RseysNOttg9rOB3
         1eCwjHpC9F6Tfyn+eJwKaWQAFkYwAobcL4JzyNuHVXX04F+w/7Va/kiAnxygcRajTZH5
         huO6X1r5r1TjYApv014BWFm78Vy6h78mm/SMAjMZLKWVKQYy8Yuk0a7YBa4E9W/ELP6D
         ShqQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

This update is just for updating protocol of sheepdog. Recent
discussion in the sheepdog community requires it.

Singed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index ffc2519..bbbd392 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -171,8 +171,8 @@ struct sheepdog_obj_rsp {
 	uint32_t pad[6];
 };
 
-#define LOCK_TYPE_NORMAL 1
-#define LOCK_TYPE_SHARED 2      /* for iSCSI multipath */
+#define LOCK_TYPE_NORMAL 0
+#define LOCK_TYPE_SHARED 1      /* for iSCSI multipath */
 
 struct sheepdog_vdi_req {
 	uint8_t proto_ver;
-- 
1.8.3.2
