From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] iser: Fix memory leak of addrinfo struct
Date: Wed, 29 Apr 2015 15:31:23 +0300
Message-ID: <1430310683-17664-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/iscsi/iser.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index f262ed6..9519862 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -3452,10 +3452,14 @@ static int iser_ib_init(void)
 
 	for (res = res0; res; res = res->ai_next) {
 		err = iser_add_portal(res, port);
-		if (err)
+		if (err) {
+		    freeaddrinfo(res0);
 		    return err;
+		}
 	}
 
+	freeaddrinfo(res0);
+
 	dprintf("listening for iser connections on port %d\n", port);
 	err = tgt_event_add(rdma_evt_channel->fd, EPOLLIN,
 			    iser_handle_rdmacm, NULL);
-- 
1.8.4.3
