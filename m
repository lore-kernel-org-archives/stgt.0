From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: [PATCH v2] trivial: support cscope in Makefile and gitignore
Date: Sun,  8 Dec 2013 17:07:18 +0900
Message-ID: <1386490038-28488-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=vnJUcfyhwllLiQc2VP6k8vucklVdXYxTd5WwX87HAyg=;
        b=Vp88ghrTK2Byt4d4o1/40dBpTB4WTl5eM2nix8a9cr9WYU4wRne42qnmTKfhxVjl2h
         /q8eW77/g5obyY84dT7n1ZghiWQ0R2FHRurZQZS2kopbZl9lgbYzsB/TXF76DGz7WYDJ
         8tIcthUHxujvxW9UWmZll+ByRPTyjB1LhxyjxhHZe20gNgVf5mqotyWslI0/MUXuM1/h
         KFl3EI9L6OieldoirBjVKbjSjGA2ZWLrgoz6EwQ3llI4YjO2qbVfroOt5/TrnorQTUNS
         dAilT4dPDGY1aM3ODeWVpZaYDh1jEt6XGyLALTmxDWuRLKEnq+l0fOM3eewpdeNx+G7L
         P3gA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

After applying this patch, "make cscope" can generate cscope files for
tag jump. The generated files are ignored by the .gitignore file.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 .gitignore | 3 ++-
 Makefile   | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

v2: fix a style warning

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
index e34d861..6c96441 100644
--- a/Makefile
+++ b/Makefile
@@ -93,3 +93,7 @@ check32:
 check64: override ARCH=-m64
 check64:
 	CC=$(CHECK_CC_FLAGS) $(MAKE) all
+
+cscope:
+	find -name '*.[ch]' > cscope.files
+	cscope -bq
-- 
1.8.1.2
