From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] bs_sheepdog.c: ensure that vdi names and tag names are null-terminated
Date: Mon,  9 Dec 2013 14:00:41 +0900
Message-ID: <1386565241-9793-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

In the current sheepdog driver, tag names and vdi names are truncated
to 256 bytes if they are longer than the size.

The request data will not be null-terminated if those names are
truncated to the maximum byte size.

This implementation causes the following two issues with sheepdog:

 1) Since CLI of sheepdog (i.e. dog command) truncates tag names and
    vdi names to 255 bytes to ensure that string buffers are
    null-terminated, vdi lookup function of sheep daemon can fail for
    long vdi names or long tag names due to this difference of buffer
    termination.

 2) The absence of a null byte causes potential buffer overrun issue
    with the sheep daemon even though we are trying to fix this sort
    of dangerous implementation.

This patch ensures that tag names and vdi names set to the request
buffer are both null terminated and fixes these issues.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 43f3157..3edc720 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -873,8 +873,8 @@ static int find_vdi_name(struct sheepdog_access_info *ai, char *filename,
 	char buf[SD_MAX_VDI_LEN + SD_MAX_VDI_TAG_LEN];
 
 	memset(buf, 0, sizeof(buf));
-	strncpy(buf, filename, SD_MAX_VDI_LEN);
-	strncpy(buf + SD_MAX_VDI_LEN, tag, SD_MAX_VDI_TAG_LEN);
+	strncpy(buf, filename, SD_MAX_VDI_LEN - 1);
+	strncpy(buf + SD_MAX_VDI_LEN, tag, SD_MAX_VDI_TAG_LEN - 1);
 
 	memset(&hdr, 0, sizeof(hdr));
 	if (for_snapshot)
-- 
1.7.9.3
