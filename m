From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH] tgtd: let event_need_refresh be a static variable
Date: Wed, 26 Feb 2014 14:35:15 +0900
Message-ID: <1393392915-7682-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

The variable don't have to be visible from other source files.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/tgtd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/tgtd.c b/usr/tgtd.c
index 04b31dc..9975e03 100644
--- a/usr/tgtd.c
+++ b/usr/tgtd.c
@@ -212,7 +212,7 @@ static struct event_data *tgt_event_lookup(int fd)
 	return NULL;
 }
 
-int event_need_refresh;
+static int event_need_refresh;
 
 void tgt_event_del(int fd)
 {
-- 
1.7.10.4
