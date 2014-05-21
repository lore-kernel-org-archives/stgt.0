From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] systemd notification support
Date: Wed, 21 May 2014 11:43:27 +0900
Message-ID: <1400640207-2743-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Apollon Oikonomopoulos <apoikos@debian.org>

From: Apollon Oikonomopoulos <apoikos@debian.org>

tgtd may take some time to initialize before accepting management
commands. Since management commands are used to bring the targets up
during service startup, we have to make sure that tgtd is responsive
before proceeding. To this end, we add a call to sd_notify(3) right
before entering the event loop to signal systemd (if applicable) that
the main process is ready.

Systemd support with the relevant includes and linker flags is optional,
controlled by the SD_NOTIFY make flag.

Signed-off-by: Apollon Oikonomopoulos <apoikos@debian.org>
---
 Makefile     | 1 +
 usr/Makefile | 8 ++++++++
 usr/tgtd.c   | 4 ++++
 usr/tgtd.h   | 4 ++++
 4 files changed, 17 insertions(+)

diff --git a/Makefile b/Makefile
index eb56bb5..0b5163b 100644
--- a/Makefile
+++ b/Makefile
@@ -13,6 +13,7 @@ export VERSION PREFIX
 export ISCSI_RDMA
 export CEPH_RBD
 export GLFS_BD
+export SD_NOTIFY
 
 .PHONY: all
 all: programs doc conf scripts
diff --git a/usr/Makefile b/usr/Makefile
index 6234f3f..817a3fb 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -21,6 +21,10 @@ ifneq ($(GLFS_BD),)
 MODULES += bs_glfs.so
 endif
 
+ifneq ($(SD_NOTIFY),)
+CFLAGS += -DUSE_SYSTEMD
+endif
+
 ifneq ($(shell test -e /usr/include/sys/eventfd.h && test -e /usr/include/libaio.h && echo 1),)
 CFLAGS += -DUSE_EVENTFD
 TGTD_OBJS += bs_aio.o
@@ -47,6 +51,10 @@ CFLAGS += -DBSDIR=\"$(DESTDIR)$(libdir)/backing-store\"
 
 LIBS += -lpthread -ldl
 
+ifneq ($(SD_NOTIFY),)
+LIBS += -lsystemd-daemon
+endif
+
 PROGRAMS += tgtd tgtadm tgtimg
 TGTD_OBJS += tgtd.o mgmt.o target.o scsi.o log.o driver.o util.o work.o \
 		concat_buf.o parser.o spc.o sbc.o mmc.o osd.o scc.o smc.o \
diff --git a/usr/tgtd.c b/usr/tgtd.c
index 9975e03..23ad413 100644
--- a/usr/tgtd.c
+++ b/usr/tgtd.c
@@ -617,6 +617,10 @@ int main(int argc, char **argv)
 
 	bs_init();
 
+#ifdef USE_SYSTEMD
+	sd_notify(0, "READY=1\nSTATUS=Starting event loop...");
+#endif
+
 	event_loop();
 
 	lld_exit();
diff --git a/usr/tgtd.h b/usr/tgtd.h
index 8a25521..d8b2ac1 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -5,6 +5,10 @@
 #include "scsi_cmnd.h"
 #include "tgtadm_error.h"
 
+#ifdef USE_SYSTEMD
+#include <systemd/sd-daemon.h>
+#endif
+
 struct concat_buf;
 
 #define NR_SCSI_OPCODES		256
-- 
1.8.5.2 (Apple Git-48)
