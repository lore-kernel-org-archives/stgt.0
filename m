From: Thomas Matysik <thomas@belton.co.nz>
Subject: [PATCH 2/2] Add "cluster" option to bs_rbd.c to specify cluster name
Date: Wed, 22 Jan 2014 15:14:19 +1300
Message-ID: <1390356859-7557-2-git-send-email-thomas@belton.co.nz>
References: <1390356859-7557-1-git-send-email-thomas@belton.co.nz>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1390356859-7557-1-git-send-email-thomas@belton.co.nz>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Thomas Matysik <thomas@belton.co.nz>

This patch allows the Ceph cluster name to be specified in --bsopts
using the 'cluster=' option.

Signed-off-by: Thomas Matysik <thomas@belton.co.nz>
---
 doc/README.rbd |  8 +++++++-
 usr/bs_rbd.c   | 20 ++++++++++++++++++--
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/doc/README.rbd b/doc/README.rbd
index 274cc4d..18aeceb 100644
--- a/doc/README.rbd
+++ b/doc/README.rbd
@@ -43,7 +43,13 @@ something like "tgt" so that the name of the ceph client is
 for the tgt client compared to others, and sets the default log path, etc.
 See the Ceph documentation regarding client names.
 
-To specify both options, separate them with ';', and since you are,
+cluster=<cluster name>
+
+This sets the Ceph cluster name, if you have multiple clusters or
+if your cluster name is anything other than "ceph".
+This is in turn used by librados to find the conf file and key files.
+
+To specify multiple options, separate them with ';', and since you are,
 make sure to quote the option string to protect the semicolon from
 the shell:
 
diff --git a/usr/bs_rbd.c b/usr/bs_rbd.c
index f797fd5..cbe2585 100644
--- a/usr/bs_rbd.c
+++ b/usr/bs_rbd.c
@@ -517,17 +517,21 @@ static tgtadm_err bs_rbd_init(struct scsi_lu *lu, char *bsopts)
 	struct active_rbd *rbd = RBDP(lu);
 	char *confname = NULL;
 	char *clientid = NULL;
+	char *clustername = NULL;
+	char clientid_full[128];
 	char *ignore = NULL;
 
 	dprintf("bs_rbd_init bsopts: \"%s\"\n", bsopts);
 
-	// look for conf= or id=
+	// look for conf= or id= or cluster=
 
 	while (bsopts && strlen(bsopts)) {
 		if (is_opt("conf", bsopts))
 			confname = slurp_value(&bsopts);
 		else if (is_opt("id", bsopts))
 			clientid = slurp_value(&bsopts);
+		else if (is_opt("cluster", bsopts))
+			clustername = slurp_value(&bsopts);
 		else {
 			ignore = slurp_to_semi(&bsopts);
 			eprintf("bs_rbd: ignoring unknown option \"%s\"\n",
@@ -541,10 +545,22 @@ static tgtadm_err bs_rbd_init(struct scsi_lu *lu, char *bsopts)
 		eprintf("bs_rbd_init: clientid %s\n", clientid);
 	if (confname)
 		eprintf("bs_rbd_init: confname %s\n", confname);
+	if (clustername)
+		eprintf("bs_rbd_init: clustername %s\n", clustername);
 
 	eprintf("bs_rbd_init bsopts=%s\n", bsopts);
 	/* clientid may be set by -i/--id */
-	rados_ret = rados_create(&rbd->cluster, clientid);
+	/* If clustername is set, then we use rados_create2, else rados_create */
+	if (clustername) {
+		/* rados_create2 wants the full client name */
+		if(clientid)
+			snprintf(clientid_full, sizeof clientid_full, "client.%s", clientid);
+		else /* if not specified, default to client.admin */
+			snprintf(clientid_full, sizeof clientid_full, "client.admin");
+		rados_ret = rados_create2(&rbd->cluster, clustername, clientid_full, 0);
+	} else {
+		rados_ret = rados_create(&rbd->cluster, clientid);
+	}
 	if (rados_ret < 0) {
 		eprintf("bs_rbd_init: rados_create: %d\n", rados_ret);
 		return ret;
-- 
1.8.1.2
