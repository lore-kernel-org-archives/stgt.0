From: Andy Grover <agrover@redhat.com>
Subject: [PATCH] Fix segfault if device_type set to pt but bstype not sg or bsg
Date: Tue, 18 Mar 2014 11:02:02 -0700
Message-ID: <1395165722-25402-1-git-send-email-agrover@redhat.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

If bstype not set to sg or bsg, it will default to rdwr, and we will
call target_cmd_perform instead of target_cmd_perform_passthrough when
accessing the device, which crashes tgtd. There's an existing check for
setting bstype without setting dev_type, but also add a check the other
way, setting dev_type without setting bstype to a valid value for pt.

Add an error message to the existing check, as well.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 usr/target.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/usr/target.c b/usr/target.c
index 0f3066b..6dce46b 100644
--- a/usr/target.c
+++ b/usr/target.c
@@ -547,6 +547,16 @@ tgtadm_err tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
 	if ((!strncmp(bst->bs_name, "bsg", 3) ||
 	     !strncmp(bst->bs_name, "sg", 2)) &&
 	    dev_type != TYPE_PT) {
+		eprintf("Must set device type to pt for bsg/sg bstype\n");
+		adm_err = TGTADM_INVALID_REQUEST;
+		goto out;
+	}
+
+	if (!(!strncmp(bst->bs_name, "bsg", 3) ||
+	     !strncmp(bst->bs_name, "sg", 2)) &&
+	    dev_type == TYPE_PT) {
+		eprintf("Must set bstype to bsg or sg for devicetype pt, not %s\n",
+			bst->bs_name);
 		adm_err = TGTADM_INVALID_REQUEST;
 		goto out;
 	}
-- 
1.8.5.3
