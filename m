From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: [PATCH 1/3] sheepdog: turn on cache flag of write request
Date: Sun,  6 Jul 2014 23:30:30 +0900
Message-ID: <1404657032-17629-2-git-send-email-mitake.hitoshi@gmail.com>
References: <1404657032-17629-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h4BGpvomSbPHj65B095PnKuVUp1cbUknNbMeG69cE1E=;
        b=JOheljPAb3Br2sMkEAtl3UMnZ/IWIqCQMJm+vbBvopTwpXpPQ48zMylgJjlQno9tJs
         WJW1g4OoAcZKRAG4AW8316nXIFukaKn8HRWgTlGZpGENaHIeSBjmT5ttpRKhRTtJp8x0
         k8vHj9h1Tx/bCDvS91O9mJ5fwsO1Zdu4uBuQOAdH8j6c7hrK8OG1kgSi7Zy+vwIfVqei
         6FU8p2fqdK/2f695d7rp+lcFhPZRxy70xZWsEMzGBq2zZ2zWbyTYX7j21IFEdAEOqPfW
         k+VK46AWFcJgnzdS7lyspsh1bodKD0wx1k2VdgEbBmnFZjlKEUdggZNyIqSHarmR7YAM
         x9Lw==
In-Reply-To: <1404657032-17629-1-git-send-email-mitake.hitoshi@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@gmail.com>, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

tgtd doesn't affect semantics of caching, so we can always turn on
cache feature of sheepdog layer.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 6d60bd6..a333675 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -795,13 +795,19 @@ retry:
 		old_oid = 0;
 
 		if (write) {
+			/*
+			 * tgt doesn't affect semantics of caching, so we can
+			 * always turn on cache of sheep layer
+			 */
+			flags = SD_FLAG_CMD_CACHE;
+
 			if (ai->inode.data_vdi_id[idx] != vid) {
 				create = 1;
 
 				if (ai->inode.data_vdi_id[idx]) {
 					/* COW */
 					old_oid = oid;
-					flags = SD_FLAG_CMD_COW;
+					flags |= SD_FLAG_CMD_COW;
 				}
 
 				oid = vid_to_data_oid(ai->inode.vdi_id, idx);
-- 
1.9.1
