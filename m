From: Ray Lee <hburaylee@gmail.com>
Subject: [PATCH 1/1] README: link README.md to README for building pkg
Date: Thu, 12 Jan 2023 22:01:32 +0800
Message-ID: <20230112140132.51449-1-hburaylee@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P0yF1fz1yJNI0l6eM9iVl65dmh2LO4QP845ym8oa1DE=;
        b=cRoxCBHnDdesIO0jRmDTRlHPgxXA+AX2Hq81hkL9gYSN5aGhORhAkdvgl52LArMCbB
         7PqpsYyGsJrVi6g4Z9qYfUa55tNUIIhmcPgHvX0ltaW8bUdoJaxQvHPish6k4XRPv6Xy
         JQyhtLimRDclL2yO/958fnRbs6ziDtBdsHJvoXBxgLysn0N8UWZAmLsezdeoHOvNyioI
         yTJX3QnoDGYjzsR+f6NpoIO24e6v4KMmEAGXc80J4itlorVCkkCtc2xlKcABXMmGUCKS
         SslmF0hz39iVsFUXKTyhiOsbRzeez45h3VmefNdkOnp25yaJiZtrbTLUgciKtxQ41u7w
         1vnQ==
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org
Cc: Ray Lee <hburaylee@gmail.com>

make rpm reports:
Building version: 1.0.85-v1.0.85
Creating rpm build dirs under /home/github/tgt/pkg
cp: cannot stat 'README': No such file or directory

File README is needed when building pkg.

Signed-off-by: Ray Lee <hburaylee@gmail.com>
---
 .gitignore           | 1 +
 scripts/build-pkg.sh | 1 +
 2 files changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index 8c28cb7..9ed9016 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,6 +23,7 @@ GTAGS
 GRTAGS
 GPATH
 GSYMS
+README
 
 #
 # programs
diff --git a/scripts/build-pkg.sh b/scripts/build-pkg.sh
index c6776c7..2b987fd 100755
--- a/scripts/build-pkg.sh
+++ b/scripts/build-pkg.sh
@@ -43,6 +43,7 @@ echo "Building version: $version-$release"
 
 cp_src() {
     local dest=$1
+    ln -sf README.md README
     cp -a conf $dest
     cp -a doc $dest
     cp -a scripts $dest
-- 
2.27.0

