From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] doc: tgtd.8.xml: add reference to targets.conf.5
Date: Mon,  5 Jun 2017 17:20:08 +0200
Message-ID: <20170605152008.31254-1-xypron.glpk@gmx.de>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Andy Grover <agrover@redhat.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Heinrich Schuchardt <xypron.glpk@gmx.de>

It is helpful to know targets.conf to understand tgtd.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 doc/tgtd.8.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/tgtd.8.xml b/doc/tgtd.8.xml
index 57ac805..65c1684 100644
--- a/doc/tgtd.8.xml
+++ b/doc/tgtd.8.xml
@@ -173,7 +173,7 @@
 
   <refsect1><title>SEE ALSO</title>
     <para>
-      tgtadm(8), tgt-admin(8), tgtimg(8), tgt-setup-lun(8).
+      targets.conf(5), tgtadm(8), tgt-admin(8), tgtimg(8), tgt-setup-lun(8).
       <ulink url="http://stgt.sourceforge.net/"/>
     </para>
   </refsect1>
-- 
2.11.0
