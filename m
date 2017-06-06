From: Apollon Oikonomopoulos <apoikos@debian.org>
Subject: [PATCH] doc: install targets.conf(5) as well
Date: Wed,  7 Jun 2017 00:52:30 +0300
Message-ID: <20170606215230.25215-1-apoikos@debian.org>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Apollon Oikonomopoulos <apoikos@debian.org>

doc/Makefile would only install section 8 manpages. Extend this to
include targets.conf(5) as well.

Signed-off-by: Apollon Oikonomopoulos <apoikos@debian.org>
---
 doc/Makefile | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/doc/Makefile b/doc/Makefile
index 0516dc8..4af9d54 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -2,7 +2,8 @@ mandir ?= $(PREFIX)/share/man
 docdir ?= $(PREFIX)/share/doc/tgt
 
 MANPAGES = manpages/tgtadm.8 manpages/tgt-admin.8 manpages/tgtimg.8 \
-		manpages/tgt-setup-lun.8 manpages/tgtd.8
+		manpages/tgt-setup-lun.8 manpages/tgtd.8 \
+		manpages/targets.conf.5
 
 DOCS = README.iscsi README.iser \
 	    README.lu_configuration README.mmc tmf.txt \
@@ -21,8 +22,9 @@ all: xmlman xmlhtml
 
 .PHONY: install
 install: $(MANPAGES) $(DOCS)
-	install -d -m 755 $(DESTDIR)$(mandir)/man8
-	install -m 644 $(MANPAGES) $(DESTDIR)$(mandir)/man8
+	install -d -m 755 $(DESTDIR)$(mandir)/man8 $(DESTDIR)$(mandir)/man5
+	install -m 644 $(filter %.8,$(MANPAGES)) $(DESTDIR)$(mandir)/man8
+	install -m 644 $(filter %.5,$(MANPAGES)) $(DESTDIR)$(mandir)/man5
 	install -d -m 755 $(DESTDIR)$(docdir)
 	install -m 644 $(DOCS) $(DESTDIR)$(docdir)
 	install -d -m 755 $(DESTDIR)$(docdir)/html
-- 
2.11.0
