From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: fix a descriptor leak in connect_to_sdog_tcp()
Date: Tue, 17 Dec 2013 00:52:45 +0900
Message-ID: <1387209165-14668-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, sheepdog@lists.wpkg.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

When connect_to_sdoc_tcp function failed to connect a socket due to an
error other than EINTR, it doesn't free the socket file descriptor.

This fixes the leak bug.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 3edc720..07ad0de 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -372,6 +372,7 @@ reconnect:
 			if (errno == EINTR)
 				goto reconnect;
 
+			close(fd);
 			break;
 		}
 
-- 
1.7.9.3
