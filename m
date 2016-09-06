From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 6/6] sheepdog: handle an inconsistent state of metadata
Date: Tue,  6 Sep 2016 16:37:29 +0900
Message-ID: <1473147449-29377-7-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8K+eKRjhFFqnQzDbZPfv7WIBkUed09/9m3bE+i+G+WY=;
        b=QIFmz1q8vUa0XhIt5EPViM4cEVy0rR8q8kuJLlvabcXvI79YsB9dRVenAYuOlkHEsW
         YZWDZeKk8JEUSYSnSefvIbpOlz6WDlLAB2msmBxiRqOJ4D3VhvDLihhyuJ/fG6RjrOT8
         kIblXRwaEIrL8SUy/OVUyIFPoREARrofpec2+FxlMlRK3MYo81d2PQQOFdmnw+o0gcJE
         CKAK5P9/BlYnXkE8SrnDwCKnryow/g7M2mCBxqqy6Y+Jo+nxA9xBe/SbIuARjPLs72wR
         +f/M6fAhAlXOfCa/+Dx0Z6e2GbGTsCKW556Fs08F8aCd95RJ6hsdW947bpWlWLt38vHX
         zi6w==
In-Reply-To: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>, Takashi Menjo <menjo.takashi@lab.ntt.co.jp>

This commit lets the sheepdog driver to handle the case of no VDI
found during inode reloading. It can happen because sheepdog does not
provide metadata transaction.

Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Cc: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
Tested-by: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/bs_sheepdog.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 12bcfd9..fc91ad1 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -750,6 +750,7 @@ static int read_write_object(struct sheepdog_access_info *ai, char *buf,
 	unsigned int wlen, rlen;
 	int ret;
 
+retry:
 	memset(&hdr, 0, sizeof(hdr));
 
 	hdr.proto_ver = SD_PROTO_VER;
@@ -791,6 +792,17 @@ static int read_write_object(struct sheepdog_access_info *ai, char *buf,
 	case SD_RES_READONLY:
 		*need_reload = 1;
 		return 0;
+	case SD_RES_NO_OBJ:
+		if (!write && oid & (UINT64_C(1) << 63))
+			/*
+			 * sheepdog doesn't provide a mechanism of metadata
+			 * transaction, so tgt can see an inconsistent state
+			 * like this (old working VDI became snapshot already
+			 * but an inode object of new working VDI isn't
+			 * created yet).
+			 */
+			goto retry;
+		return -1;
 	default:
 		eprintf("%s (oid: %" PRIx64 ", old_oid: %" PRIx64 ")\n",
 			sd_strerror(rsp->result), oid, old_oid);
-- 
2.7.4
