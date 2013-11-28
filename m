From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: fix length modifier of eprintf in read_write_object()
Date: Fri, 29 Nov 2013 01:18:06 +0900
Message-ID: <1385655486-11722-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

On 32-bit environments, the sheepdog driver causes the following
compile warning because "%lx" is used for uint64_t type variables:

cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2
-fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC
-DTGT_VERSION=\"\" -DBSDIR=\"/lib/tgt/backing-store\" bs_sheepdog.c -o
bs_sheepdog.o
bs_sheepdog.c: In function 'read_write_object':
bs_sheepdog.c:682: warning: format '%lx' expects type 'long unsigned
int', but argument 5 has type 'uint64_t'
bs_sheepdog.c:682: warning: format '%lx' expects type 'long unsigned
int', but argument 6 has type 'uint64_t'

This fixes the issue by using PRIx64 length modifier instead of "%lx".

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 9848e9f..315f3aa 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -679,7 +679,7 @@ static int read_write_object(struct sheepdog_access_info *ai, char *buf,
 			*need_reload = 1;
 		return 0;
 	default:
-		eprintf("%s (oid: %lx, old_oid: %lx)\n",
+		eprintf("%s (oid: %" PRIx64 ", old_oid: %" PRIx64 ")\n",
 			sd_strerror(rsp->result), oid, old_oid);
 		return -1;
 	}
-- 
1.7.9.3
