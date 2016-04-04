From: Andy Grover <agrover@redhat.com>
Subject: [PATCH] Enable tgt-admin to bring up Gluster backing stores
Date: Mon,  4 Apr 2016 15:32:14 -0700
Message-ID: <1459809134-17751-1-git-send-email-agrover@redhat.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: nathan@bravenet.com

As reported in:

https://bugzilla.redhat.com/show_bug.cgi?id=1323356

tgt-admin needs a small change to properly bring up Gluster glfs
backing stores, which do not have an associated local block device.

Reported-by: Nathan Coulson <nathan@bravenet.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 scripts/tgt-admin | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/tgt-admin b/scripts/tgt-admin
index 7130a3d..8f6fb7f 100755
--- a/scripts/tgt-admin
+++ b/scripts/tgt-admin
@@ -488,7 +488,7 @@ sub add_backing_direct {
 	}
 
 	if ($can_alloc == 1 &&
-	   ($bstype =~ "rbd" || (-e $backing_store && ! -d $backing_store))) {
+	   ($bstype =~ "glfs" || $bstype =~ "rbd" || (-e $backing_store && ! -d $backing_store))) {
 		my @exec_commands;
 		my $device_type;
 		my $bs_type;
-- 
2.5.5
