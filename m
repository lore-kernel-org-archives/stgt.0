From: Ruoyu <liangry@ucweb.com>
Subject: [PATCH] bs_rbd: fix error assignment in if condition
Date: Wed, 23 Jul 2014 10:38:34 +0800
Message-ID: <1406083114-28024-1-git-send-email-liangry@ucweb.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ruoyu <liangry@ucweb.com>

The statement

if ((x == f()) < 0) {}

is strange. I think it should be

if ((x = f()) < 0) {}

For the reasone of coding style, I modify it as

x = f();
if (x < 0) {}

Signed-off-by: Ruoyu <liangry@ucweb.com>
---
 usr/bs_rbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/bs_rbd.c b/usr/bs_rbd.c
index 3a052ed..ef14797 100644
--- a/usr/bs_rbd.c
+++ b/usr/bs_rbd.c
@@ -431,8 +431,8 @@ static int bs_rbd_open(struct scsi_lu *lu, char *path, int *fd, uint64_t *size)
 	eprintf("bs_rbd_open: pool: %s image: %s snap: %s\n",
 		poolname, imagename, snapname);
 
-	if ((ret == rados_ioctx_create(rbd->cluster, poolname, &rbd->ioctx))
-	    < 0) {
+	ret = rados_ioctx_create(rbd->cluster, poolname, &rbd->ioctx);
+	if (ret < 0) {
 		eprintf("bs_rbd_open: rados_ioctx_create: %d\n", ret);
 		return -EIO;
 	}
-- 
1.8.3.2

