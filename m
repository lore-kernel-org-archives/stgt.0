From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH] trivial: support cscope in Makefile and gitignore
Date: Tue, 29 Oct 2013 11:28:52 +0900
Message-ID: <1383013732-9345-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

After applying this patch, "make cscope" can generate cscope files for
tag jump. The generated files are ignored by the .gitignore file.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 .gitignore |    3 ++-
 Makefile   |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index ca1c5d3..8c28cb7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -31,4 +31,5 @@ usr/tgtd
 usr/tgtadm
 usr/tgtimg
 
-
+# cscope files
+cscope.*
diff --git a/Makefile b/Makefile
index b71ad7b..ad1f12f 100644
--- a/Makefile
+++ b/Makefile
@@ -93,3 +93,8 @@ check32:
 check64: override ARCH=-m64
 check64:
 	CC=$(CHECK_CC_FLAGS) $(MAKE) all
+
+cscope:
+	find -name '*.[ch]' > cscope.files
+	cscope -bq
+
-- 
1.7.10.4
