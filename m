From: Dan Mick <dan.mick@inktank.com>
Subject: [PATCH] bs_rbd.c: accept and parse bsopts
Date: Mon, 28 Oct 2013 17:19:34 -0700
Message-ID: <1383005974-16499-1-git-send-email-dan.mick@inktank.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Dan Mick <dan.mick@inktank.com>

Options are supplied as one string, "key1=val1;key2=val2;" etc.

Legal options:
    conf=<conffile>
    id=<clientid>

For example, --bsopts "conf=/usr/local/ceph/ceph.conf;id=stgt"
(quoting is necessary to protect ; from the shell)

Unknown options are skipped.

Signed-off-by: Dan Mick <dan.mick@inktank.com>
---
 usr/bs_rbd.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 80 insertions(+), 6 deletions(-)

diff --git a/usr/bs_rbd.c b/usr/bs_rbd.c
index 77b27f7..3ea9d36 100644
--- a/usr/bs_rbd.c
+++ b/usr/bs_rbd.c
@@ -466,26 +466,96 @@ static void bs_rbd_close(struct scsi_lu *lu)
 	}
 }
 
+// Slurp up and return a copy of everything to the next ';', and update p
+static char *slurp_to_semi(char **p)
+{
+	char *end = index(*p, ';');
+	char *ret;
+	int len;
+
+	if (end == NULL)
+		end = *p + strlen(*p);
+	len = end - *p;
+	ret = malloc(len + 1);
+	strncpy(ret, *p, len);
+	ret[len] = '\0';
+	*p = end;
+	return ret;
+}
+
+static char *slurp_value(char **p)
+{
+	char *equal = index(*p, '=');
+	if (equal) {
+		*p = equal + 1;
+		return slurp_to_semi(p);
+	} else {
+		// uh...no?
+		return NULL;
+	}
+}
+
+static int is_opt(const char *opt, char *p)
+{
+	int ret = 0;
+	if ((strncmp(p, opt, strlen(opt)) == 0) &&
+	    (p[strlen(opt)] == '=')) {
+		ret = 1;
+	}
+	return ret;
+}
+
+
 static tgtadm_err bs_rbd_init(struct scsi_lu *lu, char *bsopts)
 {
+	struct bs_thread_info *info = BS_THREAD_I(lu);
 	tgtadm_err ret = TGTADM_UNKNOWN_ERR;
 	int rados_ret;
-	struct bs_thread_info *info = BS_THREAD_I(lu);
 	struct active_rbd *rbd = RBDP(lu);
+	char *confname = NULL;
+	char *clientid = NULL;
+	char *ignore = NULL;
+
+	dprintf("bs_rbd_init bsopts: \"%s\"\n", bsopts);
+
+	// look for conf= or id=
+
+	while (bsopts && strlen(bsopts)) {
+		if (is_opt("conf", bsopts))
+			confname = slurp_value(&bsopts);
+		else if (is_opt("id", bsopts))
+			clientid = slurp_value(&bsopts);
+		else {
+			ignore = slurp_to_semi(&bsopts);
+			eprintf("bs_rbd: ignoring unknown option \"%s\"\n",
+				ignore);
+			free(ignore);
+			break;
+		}
+	}
+
+	if (clientid)
+		eprintf("bs_rbd_init: clientid %s\n", clientid);
+	if (confname)
+		eprintf("bs_rbd_init: confname %s\n", confname);
 
-	rados_ret = rados_create(&rbd->cluster, NULL);
 	eprintf("bs_rbd_init bsopts=%s\n", bsopts);
+	/* clientid may be set by -i/--id */
+	rados_ret = rados_create(&rbd->cluster, clientid);
 	if (rados_ret < 0) {
 		eprintf("bs_rbd_init: rados_create: %d\n", rados_ret);
 		return ret;
 	}
-	/* read config from environment and then default files */
+	/*
+	 * Read config from environment, then conf file(s) which may
+	 * be set by conf=
+	 */
 	rados_ret = rados_conf_parse_env(rbd->cluster, NULL);
 	if (rados_ret < 0) {
 		eprintf("bs_rbd_init: rados_conf_parse_env: %d\n", rados_ret);
 		goto fail;
 	}
-	rados_ret = rados_conf_read_file(rbd->cluster, NULL);
+	rados_ret = rados_conf_read_file(rbd->cluster, confname);
 	if (rados_ret < 0) {
 		eprintf("bs_rbd_init: rados_conf_read_file: %d\n", rados_ret);
 		goto fail;
@@ -496,9 +566,12 @@ static tgtadm_err bs_rbd_init(struct scsi_lu *lu, char *bsopts)
 		goto fail;
 	}
 	ret = bs_thread_open(info, bs_rbd_request, nr_iothreads);
-	if (ret == TGTADM_SUCCESS)
-		return ret;
 fail:
+	if (confname)
+		free(confname);
+	if (clientid)
+		free(clientid);
+
 	return ret;
 }
 
@@ -507,6 +580,7 @@ static void bs_rbd_exit(struct scsi_lu *lu)
 	struct bs_thread_info *info = BS_THREAD_I(lu);
 	struct active_rbd *rbd = RBDP(lu);
 
+	/* do this first to try to be sure there's no outstanding I/O */
 	bs_thread_close(info);
 	rados_shutdown(rbd->cluster);
 }
-- 
1.7.10.4
