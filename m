From: Dan Mick <dan.mick@inktank.com>
Subject: [PATCH] Add bsopts flag
Date: Mon, 28 Oct 2013 11:17:28 -0700
Message-ID: <1382984248-7631-2-git-send-email-dan.mick@inktank.com>
References: <1382984248-7631-1-git-send-email-dan.mick@inktank.com>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1382984248-7631-1-git-send-email-dan.mick@inktank.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Dan Mick <dan.mick@inktank.com>

tgtadm: accept and pass bsopts
spc.c: permit bsopts as a legal option
target.c: accept bsopts=
tgtd.h: add char *bsopts to bs_init signature
bs_*.c: add char *bsopts as second arg to bs_init function
tgt-admin: process bsopts
doc/tgtadm.8.xml: add doc for bsopts and example

Signed-off-by: Dan Mick <dan.mick@inktank.com>
---
 doc/tgtadm.8.xml  |   20 +++++++++++++++++---
 scripts/tgt-admin |   13 ++++++++++++-
 usr/bs_aio.c      |    2 +-
 usr/bs_rbd.c      |    3 ++-
 usr/bs_rdwr.c     |    2 +-
 usr/bs_sg.c       |    2 +-
 usr/bs_sheepdog.c |    2 +-
 usr/bs_ssc.c      |    2 +-
 usr/spc.c         |    3 ++-
 usr/target.c      |   12 +++++++++---
 usr/tgtadm.c      |   18 +++++++++++++-----
 usr/tgtd.h        |    2 +-
 12 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/doc/tgtadm.8.xml b/doc/tgtadm.8.xml
index 28a5ede..ffff3a7 100644
--- a/doc/tgtadm.8.xml
+++ b/doc/tgtadm.8.xml
@@ -26,6 +26,7 @@
 		<arg choice="opt">-l --lun &lt;lun&gt;</arg>
 		<arg choice="opt">-b --backing-store &lt;path&gt;</arg>
 		<arg choice="opt">-f --bsoflags {direct|sync}</arg>
+		<arg choice="opt">-S --bsopts {backing-store opt string}</arg>
 		<arg choice="opt">-E --bstype &lt;type&gt;</arg>
 		<arg choice="opt">-I --initiator-address &lt;address&gt;</arg>
 		<arg choice="opt">-Q --initiator-name &lt;name&gt;</arg>
@@ -153,16 +154,28 @@ Possible backend types are:
         </listitem>
       </varlistentry>
 
-      <varlistentry><term><option>--lld &lt;driver&gt; --op new --mode logicalunit --tid &lt;id&gt; --lun &lt;lun&gt; --backing-store &lt;path&gt;</option></term>
+      <varlistentry><term><option>--lld &lt;driver&gt; --op new --mode logicalunit --tid &lt;id&gt; --lun &lt;lun&gt; --backing-store &lt;path&gt; --bsopts=&lt;backing store options&gt;</option></term>
         <listitem>
           <para>
 	    Add a new logical unit with &lt;lun&gt; to specific target with &lt;id&gt;. The
 	    logical unit is offered to the initiators. &lt;path&gt; must be block device
 	    files (including LVM and RAID devices) or regular files, or an RBD image or
-	    snapshot name for --driver rbd. lun0 is reserved for a special device
+	    snapshot name for --bstype rbd. lun0 is reserved for a special device
 	    automatically created.
           </para>
-        </listitem>
+	  <screen format="linespecific">
+Example:
+If tgt is compiled with the bs_rbd backing store for
+Ceph RBD images (see tgtadm --mode system --op show to
+verify), set up a target mapping the rbd image named
+"rbdimage", and pass options to bs_rbd:
+
+tgtadm --lld iscsi --op new --mode logicalunit --tid 1 \
+--lun 1 --bstype=rbd --backing-store=rbdimage \
+--bsopts="conf=/etc/ceph/ceph.conf;id=tgt"
+
+	   </screen>
+	</listitem>
       </varlistentry>
 
       <varlistentry><term><option>--lld &lt;driver&gt; --op delete --mode logicalunit --tid &lt;id&gt; --lun &lt;lun&gt;</option></term>
@@ -607,6 +620,7 @@ Example:
 Open the backing file with O_SYNC.
 
 tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1 --bsoflags="sync" --backing-store=/data/100m_image.raw
+
     </screen>
 
   </refsect1>
diff --git a/scripts/tgt-admin b/scripts/tgt-admin
index 8dfc01d..5486507 100755
--- a/scripts/tgt-admin
+++ b/scripts/tgt-admin
@@ -492,6 +492,7 @@ sub add_backing_direct {
 		my @exec_commands;
 		my $device_type;
 		my $bs_type;
+		my $bsopts;
 		my $block_size;
 		my %luns;
 		my @added_luns;
@@ -543,6 +544,10 @@ sub add_backing_direct {
 							$bs_type = $result;
 							$params_added{$store_option} = 1;
 						}
+						if ($store_option eq "bsopts") {
+							$bsopts = $result;
+							$params_added{$store_option} = 1;
+						}
 						if ($store_option eq "block-size") {
 							$block_size = $result;
 							$params_added{$store_option} = 1;
@@ -694,6 +699,11 @@ sub add_backing_direct {
 				check_if_hash_array($$target_options_ref{"bs-type"}, "bs-type");
 				$bs_type = $$target_options_ref{"bs-type"};
 			}
+			# bsopts
+			if ($params_added{"bsopts"} ne 1) {
+				check_if_hash_array($$target_options_ref{"bsopts"}, "bsopts");
+				$bsopts = $$target_options_ref{"bsopts"};
+			}
 		} else {
 			print "If you got here, this means your config file is not supported.\n";
 			print "Please report it to stgt mailing list and attach your config files.\n";
@@ -702,8 +712,9 @@ sub add_backing_direct {
 		# Execute commands for a given LUN
 		if (length $device_type) { $device_type = "--device-type $device_type" };
 		if (length $bs_type) { $bs_type = "--bstype $bs_type" };
+		if (length $bsopts) { $bsopts = "--bsopts $bsopts" };
 		if (length $block_size) { $block_size = "--blocksize $block_size" };
-		execute("tgtadm -C $control_port --lld $driver --op new --mode logicalunit --tid $next_tid --lun $lun -b $backing_store $device_type $bs_type $block_size");
+		execute("tgtadm -C $control_port --lld $driver --op new --mode logicalunit --tid $next_tid --lun $lun -b $backing_store $device_type $bs_type $bsopts $block_size");
 
 		# Commands should be executed in order
 		my @execute_last;
diff --git a/usr/bs_aio.c b/usr/bs_aio.c
index cc59cf6..32ceec5 100644
--- a/usr/bs_aio.c
+++ b/usr/bs_aio.c
@@ -380,7 +380,7 @@ static void bs_aio_close(struct scsi_lu *lu)
 	close(lu->fd);
 }
 
-static tgtadm_err bs_aio_init(struct scsi_lu *lu)
+static tgtadm_err bs_aio_init(struct scsi_lu *lu, char *bsopts)
 {
 	struct bs_aio_info *info = BS_AIO_I(lu);
 	int i;
diff --git a/usr/bs_rbd.c b/usr/bs_rbd.c
index 82c516f..77b27f7 100644
--- a/usr/bs_rbd.c
+++ b/usr/bs_rbd.c
@@ -466,7 +466,7 @@ static void bs_rbd_close(struct scsi_lu *lu)
 	}
 }
 
-static tgtadm_err bs_rbd_init(struct scsi_lu *lu)
+static tgtadm_err bs_rbd_init(struct scsi_lu *lu, char *bsopts)
 {
 	tgtadm_err ret = TGTADM_UNKNOWN_ERR;
 	int rados_ret;
@@ -474,6 +474,7 @@ static tgtadm_err bs_rbd_init(struct scsi_lu *lu)
 	struct active_rbd *rbd = RBDP(lu);
 
 	rados_ret = rados_create(&rbd->cluster, NULL);
+	eprintf("bs_rbd_init bsopts=%s\n", bsopts);
 	if (rados_ret < 0) {
 		eprintf("bs_rbd_init: rados_create: %d\n", rados_ret);
 		return ret;
diff --git a/usr/bs_rdwr.c b/usr/bs_rdwr.c
index 47d2d99..ff009eb 100644
--- a/usr/bs_rdwr.c
+++ b/usr/bs_rdwr.c
@@ -398,7 +398,7 @@ static void bs_rdwr_close(struct scsi_lu *lu)
 	close(lu->fd);
 }
 
-static tgtadm_err bs_rdwr_init(struct scsi_lu *lu)
+static tgtadm_err bs_rdwr_init(struct scsi_lu *lu, char *bsopts)
 {
 	struct bs_thread_info *info = BS_THREAD_I(lu);
 
diff --git a/usr/bs_sg.c b/usr/bs_sg.c
index 5f1e687..66f4a3b 100644
--- a/usr/bs_sg.c
+++ b/usr/bs_sg.c
@@ -420,7 +420,7 @@ static int init_sg_device(int fd)
 	return 0;
 }
 
-static tgtadm_err bs_sg_init(struct scsi_lu *lu)
+static tgtadm_err bs_sg_init(struct scsi_lu *lu, char *bsopts)
 {
 	/*
 	 * Setup struct scsi_lu->cmd_perform() passthrough pointer
diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
index 1eb09c0..cfe1046 100644
--- a/usr/bs_sheepdog.c
+++ b/usr/bs_sheepdog.c
@@ -1245,7 +1245,7 @@ static void bs_sheepdog_close(struct scsi_lu *lu)
 	sd_close(ai);
 }
 
-static tgtadm_err bs_sheepdog_init(struct scsi_lu *lu)
+static tgtadm_err bs_sheepdog_init(struct scsi_lu *lu, char *bsopts)
 {
 	struct bs_thread_info *info = BS_THREAD_I(lu);
 	struct sheepdog_access_info *ai =
diff --git a/usr/bs_ssc.c b/usr/bs_ssc.c
index 117e274..a7e062d 100644
--- a/usr/bs_ssc.c
+++ b/usr/bs_ssc.c
@@ -610,7 +610,7 @@ static void tape_rdwr_request(struct scsi_cmd *cmd)
 			cmd, cmd->scb[0], ret, length, cmd->offset);
 }
 
-static tgtadm_err bs_ssc_init(struct scsi_lu *lu)
+static tgtadm_err bs_ssc_init(struct scsi_lu *lu, char *bsopts)
 {
 	struct bs_thread_info *info = BS_THREAD_I(lu);
 	return bs_thread_open(info, tape_rdwr_request, 1);
diff --git a/usr/spc.c b/usr/spc.c
index 00e0dd7..88fdf7d 100644
--- a/usr/spc.c
+++ b/usr/spc.c
@@ -1869,7 +1869,7 @@ enum {
 	Opt_optimal_xfer_gran, Opt_optimal_xfer_len,
 	Opt_removable, Opt_readonly, Opt_online,
 	Opt_mode_page,
-	Opt_path,
+	Opt_path, Opt_bsopts,
 	Opt_bsoflags, Opt_thinprovisioning,
 	Opt_err,
 };
@@ -1890,6 +1890,7 @@ static match_table_t tokens = {
 	{Opt_online, "online=%s"},
 	{Opt_mode_page, "mode_page=%s"},
 	{Opt_path, "path=%s"},
+	{Opt_bsopts, "bsopts=%s"},
 	{Opt_bsoflags, "bsoflags=%s"},
 	{Opt_thinprovisioning, "thin_provisioning=%s"},
 	{Opt_err, NULL},
diff --git a/usr/target.c b/usr/target.c
index b1729b3..257135d 100644
--- a/usr/target.c
+++ b/usr/target.c
@@ -457,12 +457,13 @@ __device_lookup(int tid, uint64_t lun, struct target **t)
 }
 
 enum {
-	Opt_path, Opt_bstype, Opt_bsoflags, Opt_blocksize, Opt_err,
+	Opt_path, Opt_bstype, Opt_bsopts, Opt_bsoflags, Opt_blocksize, Opt_err,
 };
 
 static match_table_t device_tokens = {
 	{Opt_path, "path=%s"},
 	{Opt_bstype, "bstype=%s"},
+	{Opt_bsopts, "bsopts=%s"},
 	{Opt_bsoflags, "bsoflags=%s"},
 	{Opt_blocksize, "blocksize=%s"},
 	{Opt_err, NULL},
@@ -473,7 +474,7 @@ static void __cmd_done(struct target *, struct scsi_cmd *);
 tgtadm_err tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
 		      int backing)
 {
-	char *p, *path = NULL, *bstype = NULL;
+	char *p, *path = NULL, *bstype = NULL, *bsopts = NULL;
 	char *bsoflags = NULL, *blocksize = NULL;
 	int lu_bsoflags = 0;
 	tgtadm_err adm_err = TGTADM_SUCCESS;
@@ -500,6 +501,9 @@ tgtadm_err tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
 		case Opt_bstype:
 			bstype = match_strdup(&args[0]);
 			break;
+		case Opt_bsopts:
+			bsopts = match_strdup(&args[0]);
+			break;
 		case Opt_bsoflags:
 			bsoflags = match_strdup(&args[0]);
 			break;
@@ -618,7 +622,9 @@ tgtadm_err tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
 	}
 
 	if (lu->bst->bs_init) {
-		adm_err = lu->bst->bs_init(lu);
+		if (bsopts)
+			dprintf("bsopts=%s\n", bsopts);
+		adm_err = lu->bst->bs_init(lu, bsopts);
 		if (adm_err)
 			goto fail_lu_init;
 	}
diff --git a/usr/tgtadm.c b/usr/tgtadm.c
index 7c6deae..91e46c9 100644
--- a/usr/tgtadm.c
+++ b/usr/tgtadm.c
@@ -112,6 +112,7 @@ struct option const long_options[] = {
 	{"value", required_argument, NULL, 'v'},
 	{"backing-store", required_argument, NULL, 'b'},
 	{"bstype", required_argument, NULL, 'E'},
+	{"bsopts", required_argument, NULL, 'S'},
 	{"bsoflags", required_argument, NULL, 'f'},
 	{"blocksize", required_argument, NULL, 'y'},
 	{"targetname", required_argument, NULL, 'T'},
@@ -130,7 +131,7 @@ struct option const long_options[] = {
 };
 
 static char *short_options =
-		"dhVL:o:m:t:s:c:l:n:v:b:E:f:y:T:I:Q:u:p:H:F:P:B:Y:O:C:";
+		"dhVL:o:m:t:s:c:l:n:v:b:E:f:y:T:I:Q:u:p:H:F:P:B:Y:O:C:S:";
 
 static void usage(int status)
 {
@@ -161,12 +162,13 @@ static void usage(int status)
 		"--lld <driver> --mode target --op unbind --tid <id> --initiator-name <name>\n"
 		"\tdisable the specific permitted initiators.\n"
 		"--lld <driver> --mode logicalunit --op new --tid <id> --lun <lun>\n"
-		"  --backing-store <path> --bstype <type> --bsoflags <options>\n"
+		"  --backing-store <path> --bstype <type> --bsopts <bs options> --bsoflags <options>\n"
 		"\tadd a new logical unit with <lun> to the specific\n"
 		"\ttarget with <id>. The logical unit is offered\n"
 		"\tto the initiators. <path> must be block device files\n"
 		"\t(including LVM and RAID devices) or regular files.\n"
 		"\tbstype option is optional.\n"
+		"\tbsopts are specific to the bstype.\n"
 		"\tbsoflags supported options are sync and direct\n"
 		"\t(sync:direct for both).\n"
 		"--lld <driver> --mode logicalunit --op delete --tid <id> --lun <lun>\n"
@@ -484,7 +486,7 @@ int main(int argc, char **argv)
 	uint32_t cid, hostno;
 	uint64_t sid, lun, force;
 	char *name, *value, *path, *targetname, *address, *iqnname, *targetOps;
-	char *portalOps, *bstype;
+	char *portalOps, *bstype, *bsopts;
 	char *bsoflags;
 	char *blocksize;
 	char *user, *password;
@@ -499,7 +501,7 @@ int main(int argc, char **argv)
 	dev_type = TYPE_DISK;
 	ac_dir = ACCOUNT_TYPE_INCOMING;
 	name = value = path = targetname = address = iqnname = NULL;
-	targetOps = portalOps = bstype = NULL;
+	targetOps = portalOps = bstype = bsopts = NULL;
 	bsoflags = blocksize = user = password = NULL;
 	force = 0;
 
@@ -587,6 +589,9 @@ int main(int argc, char **argv)
 		case 'E':
 			bstype = optarg;
 			break;
+		case 'S':
+			bsopts = optarg;
+			break;
 		case 'Y':
 			dev_type = str_to_device_type(optarg);
 			break;
@@ -809,7 +814,7 @@ int main(int argc, char **argv)
 		}
 		switch (op) {
 		case OP_NEW:
-			rc = verify_mode_params(argc, argv, "LmofytlbEYC");
+			rc = verify_mode_params(argc, argv, "LmofytlbEYCS");
 			if (rc) {
 				eprintf("target mode: option '-%c' is not "
 					  "allowed/supported\n", rc);
@@ -935,6 +940,9 @@ int main(int argc, char **argv)
 	else if (bstype)
 		concat_printf(&b, "%sbstype=%s", concat_delim(&b, ","),
 			      bstype);
+	if (bsopts)
+		concat_printf(&b, "%sbsopts=%s", concat_delim(&b, ","),
+			      bsopts);
 	if (bsoflags)
 		concat_printf(&b, "%sbsoflags=%s", concat_delim(&b, ","),
 			      bsoflags);
diff --git a/usr/tgtd.h b/usr/tgtd.h
index 484e6e9..b0528b4 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -161,7 +161,7 @@ struct backingstore_template {
 	int bs_datasize;
 	int (*bs_open)(struct scsi_lu *dev, char *path, int *fd, uint64_t *size);
 	void (*bs_close)(struct scsi_lu *dev);
-	tgtadm_err (*bs_init)(struct scsi_lu *dev);
+	tgtadm_err (*bs_init)(struct scsi_lu *dev, char *bsopts);
 	void (*bs_exit)(struct scsi_lu *dev);
 	int (*bs_cmd_submit)(struct scsi_cmd *cmd);
 	int bs_oflags_supported;
-- 
1.7.10.4
