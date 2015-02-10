From: Andy Grover <agrover@redhat.com>
Subject: [PATCH] Fix libs for current systemd linker name
Date: Tue, 10 Feb 2015 13:55:28 -0800
Message-ID: <1423605328-25931-1-git-send-email-agrover@redhat.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Systemd versions since 210 (Feb 2014) have merged libsystemd-daemon into
libsystemd.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 usr/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/Makefile b/usr/Makefile
index 817a3fb..1fae7e7 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -52,7 +52,7 @@ CFLAGS += -DBSDIR=\"$(DESTDIR)$(libdir)/backing-store\"
 LIBS += -lpthread -ldl
 
 ifneq ($(SD_NOTIFY),)
-LIBS += -lsystemd-daemon
+LIBS += -lsystemd
 endif
 
 PROGRAMS += tgtd tgtadm tgtimg
-- 
2.1.0
