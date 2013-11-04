From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] Fix AIO backing store not being registered
Date: Mon,  4 Nov 2013 16:42:53 +0200
Message-ID: <1383576173-32010-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

Missing the constructor attribute

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/bs_aio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/usr/bs_aio.c b/usr/bs_aio.c
index 32ceec5..1f46a2a 100644
--- a/usr/bs_aio.c
+++ b/usr/bs_aio.c
@@ -414,7 +414,7 @@ static struct backingstore_template aio_bst = {
 	.bs_cmd_submit  	= bs_aio_cmd_submit,
 };
 
-void register_bs_module(void)
+__attribute__((constructor)) static void register_bs_module(void)
 {
 	register_backingstore_template(&aio_bst);
 }
-- 
1.7.8.2
