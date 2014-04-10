From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] Update debian build to use local docbook-xsl for generating docs
Date: Thu, 10 Apr 2014 17:49:02 +0300
Message-ID: <1397141342-5259-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

Building debian package procedure generates a lot of errors generating
the docs and takes forever to finish.
This patch will change the procedure to use local available docbook-xsl.
Added build dependency for docbook-xsl and updated debian build script to
set it as build dependency.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 scripts/deb/control                                |    2 +-
 ...001-Use-local-docbook-for-generating-docs.patch |   70 ++++++++++++++++++++
 2 files changed, 71 insertions(+), 1 deletions(-)
 create mode 100644 scripts/deb/patches/0001-Use-local-docbook-for-generating-docs.patch

diff --git a/scripts/deb/control b/scripts/deb/control
index 7bdfc8d..549a8e3 100644
--- a/scripts/deb/control
+++ b/scripts/deb/control
@@ -4,7 +4,7 @@ Section: net
 Priority: optional
 Standards-Version: 3.9.1
 Build-Depends: debhelper (>= 8), dpkg-dev (>= 1.13.19), bash-completion,
-    librdmacm-dev, libibverbs-dev, xsltproc
+    librdmacm-dev, libibverbs-dev, xsltproc, docbook-xsl
 Homepage: http://stgt.berlios.de/
 
 Package: tgt
diff --git a/scripts/deb/patches/0001-Use-local-docbook-for-generating-docs.patch b/scripts/deb/patches/0001-Use-local-docbook-for-generating-docs.patch
new file mode 100644
index 0000000..ac788af
--- /dev/null
+++ b/scripts/deb/patches/0001-Use-local-docbook-for-generating-docs.patch
@@ -0,0 +1,70 @@
+From 1edc4f6428dfdbd86a2d47177148e12fd617c3b1 Mon Sep 17 00:00:00 2001
+From: Roi Dayan <roid@mellanox.com>
+Date: Thu, 10 Apr 2014 17:36:45 +0300
+Subject: [PATCH] Use local docbook for generating docs
+
+Signed-off-by: Roi Dayan <roid@mellanox.com>
+---
+ doc/Makefile | 24 ++++++++++++------------
+ 1 file changed, 12 insertions(+), 12 deletions(-)
+
+diff --git a/doc/Makefile b/doc/Makefile
+index 0516dc8..e56695d 100644
+--- a/doc/Makefile
++++ b/doc/Makefile
+@@ -34,40 +34,40 @@ clean:
+ 	-rm -f manpages htmlpages
+ 
+ manpages/tgtd.8: tgtd.8.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl $<
+ 
+ htmlpages/tgtd.8.html: tgtd.8.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/html/docbook.xsl $<
+ 
+ manpages/tgtadm.8: tgtadm.8.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl $<
+ 
+ htmlpages/tgtadm.8.html: tgtadm.8.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/html/docbook.xsl $<
+ 
+ manpages/tgt-admin.8: tgt-admin.8.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl $<
+ 
+ htmlpages/tgt-admin.8.html: tgt-admin.8.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/html/docbook.xsl $<
+ 
+ manpages/tgtimg.8: tgtimg.8.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl $<
+ 
+ htmlpages/tgtimg.8.html: tgtimg.8.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/html/docbook.xsl $<
+ 
+ manpages/targets.conf.5: targets.conf.5.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl $<
+ 
+ htmlpages/targets.conf.5.html: targets.conf.5.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/html/docbook.xsl $<
+ 
+ manpages/tgt-setup-lun.8: tgt-setup-lun.8.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl $<
+ 
+ htmlpages/tgt-setup-lun.8.html: tgt-setup-lun.8.xml
+-	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl $<
++	-test -z "$(XSLTPROC)" || $(XSLTPROC) -o $@ /usr/share/xml/docbook/stylesheet/docbook-xsl/html/docbook.xsl $<
+ 
+ xmlman: $(XMLMAN)
+ 
+-- 
+1.8.1.2
+
-- 
1.7.8.2
