From: Dan Mick <dan.mick@inktank.com>
Subject: [PATCH] README.rbd: add documentation for the rbd --bsopts parameters
Date: Mon, 28 Oct 2013 17:45:28 -0700
Message-ID: <1383007528-19684-1-git-send-email-dan.mick@inktank.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Dan Mick <dan.mick@inktank.com>

Signed-off-by: Dan Mick <dan.mick@inktank.com>
---
 doc/README.rbd |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/doc/README.rbd b/doc/README.rbd
index a91305a..274cc4d 100644
--- a/doc/README.rbd
+++ b/doc/README.rbd
@@ -24,3 +24,28 @@ where poolname is the RADOS pool containing the rbd image (defaults to
 optional (readonly) snapshot of the image imagename.  (Obviously when
 a snapshot is exported, writes are not supported.)
 
+You may also want to use the --bsopts parameter to pass Ceph-specific
+parameters to bs_rbd.  Accepted keywords are
+
+conf=<path to ceph.conf file>
+
+This sets the path to the ceph.conf file for the cluster that
+stgt should connect to for this target/lun creation (luns may
+use different cluster connections).
+
+id=<client id>
+
+This sets the id portion of the ceph "client name" (which is
+"type.id").  Type is fixed at "client", and the default name is
+"client.admin", but you probably want this to set id to
+something like "tgt" so that the name of the ceph client is
+"client.tgt".  This lets you control permissions differently
+for the tgt client compared to others, and sets the default log path, etc.
+See the Ceph documentation regarding client names.
+
+To specify both options, separate them with ';', and since you are,
+make sure to quote the option string to protect the semicolon from
+the shell:
+
+	--bsopts "conf=/usr/local/ceph/ceph.conf;id=tgt"
+
-- 
1.7.10.4
