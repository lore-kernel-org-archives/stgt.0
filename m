From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] SMC: add a new volume_tag parameter to storage slots
Date: Mon,  8 Sep 2014 21:19:49 -0700
Message-ID: <1410236389-21112-2-git-send-email-ronniesahlberg@gmail.com>
References: <1410236389-21112-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4Fhr+V46LNUgBsvEG9ki6pC/+yTUm0iXlzeEragKZ3c=;
        b=q8Op9i+9gxcJpkbkKexDBGEBDR5ZHdsaxq67l+HFK+zD16knsuXDV+Y2qpBF9xCQoY
         qQhFc784KVtRj4J8FQ/BIlYeiBhUfnpu3Is7fL3D1EW4H6xKPm/UGbZclro5Qi+oE4pl
         xCsnbDbJrGF//1R44gDsiOM5+7MAjdfjfI+HcMKJkFxnr1mRdDBGv5d0iS5yTRvMA0u2
         13pFyLEh99K/JpHciwvPCraSLcjvMzIlHZnei/sts8n8zLJdIaQmzlwNbJG9RNVb0CZf
         HiMcGqAvFVmZ2fJhkrZA8qhz3KTbgM0h2yP0AjjWoo44du2mCCQwXuRG4iLqeN82PJoo
         U1hQ==
In-Reply-To: <1410236389-21112-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>

SMC barcodes in TGTD are limited to just 10 characters while T10
VolumeTags for smc storage slots allow up to 32 bytes.
Introduce a new argument when populating slots for specifying a volume tag
of up to 32 characters. If no volume tag is specified we fallback to use the
barcode as the volume tag.

Leave the current barcode as is, limited to 10 characters to not break
compatibility with scripts that might use SMC devices.

Update the dvdjukebox example script to use volume tag. This allows us to
hand a much more useful name back to the MTX tool than the barcode.
(10 characters is pretty restrictive as an ASCII text string. The full
ISO image file name is most likely much more meaningful to a human.)

Update the tgtadm manpage and show the new volume_tag argument.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 doc/README.dvdjukebox |   29 ++++++-----------------------
 doc/tgtadm.8.xml      |   17 ++++++++++++++---
 usr/smc.c             |   25 +++++++++++++++++++------
 usr/smc.h             |    5 ++++-
 4 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/doc/README.dvdjukebox b/doc/README.dvdjukebox
index 49ab257..f9bde95 100755
--- a/doc/README.dvdjukebox
+++ b/doc/README.dvdjukebox
@@ -9,18 +9,8 @@
 # the medium changer will have one slot for each ISO image found.
 # Use the 'mtx' tool to load/unload media.
 #
-# By default, any ISO images found will be populated with a barcode of
-# DVD_????. These are the barcodes that mtx will show when you list the
-# status of the changer.
-# To have more human readable names you can provide a $TRANSLATE file
-# to set explicit barcodes for each ISO image.
-# The format of this file is one line for each mapping consisting of
-# <ISO image minus .iso suffix> SPACE <barcode>
-#
-# Example:
-# utopic-desktop-amd64 Ubuntu14
-#
-# Note that a barcode can have at most 8 characters.
+# By default, any ISO images found will be populated with a barcode of the
+# form DVD_%04d and a volume_tag based on the filename.
 #
 # CON: This is the connection index for TGTD. This is needed if you run
 # multiple instances of TGTD on the same host. Each instance must use a unique
@@ -29,19 +19,15 @@
 # TARGETNAME: The iSCSI name to use for the target.
 #
 # TARGETPORT: The TCP port that this target will be hosted from.
-#
-# TRANSLATE: Optional. A file providing mapping between the iso image filenames
-# and the barcode to assign for these images.
 
 CON=1
 TARGETNAME=iqn.ronnie.iso:distros
 TARGETPORT=3261
-TRANSLATE=translate
-
 
 nc -z 127.0.0.1 $TARGETPORT || {
 	echo "Starting iSCSI target on port $TARGETPORT"
 	tgtd -C $CON --iscsi portal=0.0.0.0:$TARGETPORT
+	sleep 3
 }
 
 tgtadm -C $CON --op delete --mode target --tid 1 --force 2>/dev/null
@@ -86,12 +72,9 @@ tgtadm -C $CON --mode logicalunit --op update --tid 1 --lun 2 --params element_t
 # Populate the slots
 SLOT=0
 ls *.iso | sed -e "s/.iso$//" | while read ISO; do
-	BARCODE=`egrep "^${ISO} " $TRANSLATE | sed -e "s/^[^ ]* *//"`
-	[ -z "$BARCODE" ] && {
-		BARCODE=`echo $SLOT | awk '{printf "DVD_%04d", $1}'`
-	}
-	ln `pwd`/${ISO}.iso ${VTL}/$BARCODE
-	tgtadm -C $CON --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,address=`expr "1024" "+" "$SLOT"`,barcode="$BARCODE",sides=1
+	BARCODE=`echo $SLOT | awk '{printf "DVD_%04d", $1}'`
+	ln `pwd`/${ISO}.iso ${VTL}/${BARCODE}
+	tgtadm -C $CON --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,address=`expr "1024" "+" "$SLOT"`,barcode="${BARCODE}",volume_tag="${ISO}",sides=1
 
 	SLOT=`expr "$SLOT" "+" "1"`
 done
diff --git a/doc/tgtadm.8.xml b/doc/tgtadm.8.xml
index ffff3a7..c88f208 100644
--- a/doc/tgtadm.8.xml
+++ b/doc/tgtadm.8.xml
@@ -497,7 +497,18 @@ Slot types:
       <varlistentry><term><option>barcode=&lt;string&gt;</option></term>
         <listitem>
           <para>
-	    This is used to assign a barcode to an element.
+	    This is used to assign a barcode to an element. Barcodes are limited
+	    to 10 characters in tgtd.
+          </para>
+        </listitem>
+      </varlistentry>
+
+      <varlistentry><term><option>volume_tag=&lt;string&gt;</option></term>
+        <listitem>
+          <para>
+	    This is used to assign a volume tag to SMC storage elements.
+	    If no volume tag is specified tgtd will use fall back to the
+	    barcode. The volume tag can be up to 32 characters.
           </para>
         </listitem>
       </varlistentry>
@@ -559,11 +570,11 @@ tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params eleme
 # slot 1
 # Create empty writeable virtual DVD-R media
 tgtimg --op new --device-type cd --type dvd+r --file ${VTL}/DISK_001
-tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,address=1024,barcode=DISK_001,sides=1
+tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,address=1024,barcode=DISK_001,volume_tag="A blank disk",sides=1
 
 # slot 2
 tgtimg --op new --device-type cd --type dvd+r --file ${VTL}/DISK_002
-tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,address=1025,barcode=DISK_002,sides=1
+tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,address=1025,barcode=DISK_002,volume_tag="My second blank disk",sides=1
 
 # Allow ALL initiators to connect to this target
 tgtadm --lld iscsi --mode target --op bind --tid 1 --initiator-address ALL
diff --git a/usr/smc.c b/usr/smc.c
index 9a40bdb..fb0143d 100644
--- a/usr/smc.c
+++ b/usr/smc.c
@@ -74,6 +74,7 @@ static void set_slot_empty(struct slot *s)
 	s->status &= 0xfe;
 	s->last_addr = 0;
 	memset(s->barcode, ' ', sizeof(s->barcode));
+	memset(s->volume_tag, ' ', sizeof(s->volume_tag));
 	if (s->element_type == ELEMENT_DATA_TRANSFER)
 		dtd_load_unload(s->drive_tid, s->drive_lun, UNLOAD, NULL);
 }
@@ -86,7 +87,7 @@ static int test_slot_full(struct slot *s)
 /**
  * determine_element_sz  --  read element status
  * @dvcid	Device ID - true, return device ID information
- * @voltag	true, return Volume Tag (barcode)
+ * @voltag	true, return Volume Tag (volume_tag)
  *
  * Ref: Working Draft SCSI Media Changer-3 (smc3r06.pdf), chapter 6.10
  *
@@ -106,7 +107,7 @@ static int determine_element_sz(uint8_t dvcid, uint8_t voltag)
  * element_status_data_hdr  --  Fill in Element Status Header
  * @data	uint8_t * - data pointer
  * @dvcid	Device ID - true, return device ID information
- * @voltag	true, return Volume Tag (barcode)
+ * @voltag	true, return Volume Tag (volume_tag)
  * @start	Start searching from slot 'start'
  * @count	and return 'count' elements
  *
@@ -159,10 +160,12 @@ static int add_element_descriptor(uint8_t *data, struct slot *s,
 
 	i = 12;
 	if (voltag) {
-		if (s->barcode[0] == ' ')
-			memset(&data[i], 0x20, 32);
-		else
+		if (s->volume_tag[0] != ' ' && s->volume_tag[0] != '\0')
+			snprintf((char *)&data[i], 32, "%-32s", s->volume_tag);
+		else if (s->barcode[0] != ' ' && s->barcode[0] != '\0')
 			snprintf((char *)&data[i], 32, "%-32s", s->barcode);
+		else
+			memset(&data[i], 0x20, 32);
 
 		/* Reserve additional 4 bytes if dvcid is set */
 		i += (dvcid) ? 36 : 32;
@@ -192,7 +195,7 @@ static int add_element_descriptor(uint8_t *data, struct slot *s,
  * @first:	Return address of first slot found
  * @start;	Start processing from this element #
  * @dvcid;	Device ID
- * @voltag;	Volume tag (barcode)
+ * @voltag;	Volume tag (volume_tag)
  *
  * Fill each Element Descriptor for slot *s
  * Return number of elements
@@ -459,6 +462,8 @@ static int smc_move_medium(int host_no, struct scsi_cmd *cmd)
 	}
 
 	memcpy(&dest_slot->barcode, &src_slot->barcode, sizeof(s->barcode));
+	memcpy(&dest_slot->volume_tag, &src_slot->volume_tag,
+	       sizeof(s->volume_tag));
 	if (dest_slot->element_type == ELEMENT_DATA_TRANSFER) {
 		char path[128];
 		int sz;
@@ -469,6 +474,8 @@ static int smc_move_medium(int host_no, struct scsi_cmd *cmd)
 			key = ILLEGAL_REQUEST;
 			asc = ASC_INTERNAL_TGT_FAILURE;
 			memset(&dest_slot->barcode, ' ', sizeof(s->barcode));
+			memset(&dest_slot->volume_tag, ' ',
+			       sizeof(s->volume_tag));
 			goto sense;
 		}
 
@@ -617,6 +624,7 @@ static void slot_dump(struct list_head *head)
 			dprintf("  Last Addr: %d\n", s->last_addr);
 			dprintf("  Type: %d\n", s->element_type);
 			dprintf("  Barcode: %s\n", s->barcode);
+			dprintf("  Volume Tag: %s\n", s->volume_tag);
 			if (s->drive_tid) {
 				dprintf("  TID : %d\n", s->drive_tid);
 				dprintf("  LUN : %" PRIu64 "\n", s->drive_lun);
@@ -720,6 +728,7 @@ static tgtadm_err config_slot(struct scsi_lu *lu, struct tmp_param *tmp)
 			break;
 		}
 		strncpy(s->barcode, tmp->barcode, sizeof(s->barcode));
+		strncpy(s->volume_tag, tmp->volume_tag, sizeof(s->volume_tag));
 		set_slot_full(s, 0, NULL);
 		adm_err = TGTADM_SUCCESS;
 		break;
@@ -785,6 +794,10 @@ static tgtadm_err __smc_lu_config(struct scsi_lu *lu, char *params)
 			match_strncpy(sv_param.barcode, &args[0],
 				      sizeof(sv_param.barcode));
 			break;
+		case Opt_volumetag:
+			match_strncpy(sv_param.volume_tag, &args[0],
+				      sizeof(sv_param.volume_tag));
+			break;
 		case Opt_tid:
 			match_strncpy(buf, &args[0], sizeof(buf));
 			sv_param.tid = atoi(buf);
diff --git a/usr/smc.h b/usr/smc.h
index eb50f45..b92fded 100644
--- a/usr/smc.h
+++ b/usr/smc.h
@@ -60,6 +60,7 @@ struct slot {
 	char barcode[11];
 	uint8_t drive_tid;
 	uint64_t drive_lun;
+	char volume_tag[32];
 };
 
 /**
@@ -80,7 +81,7 @@ enum {
 	Opt_tid, Opt_lun,
 	Opt_type, Opt_dump,
 	Opt_media_home,
-	Opt_err,
+	Opt_err, Opt_volumetag,
 };
 
 static match_table_t tokens = {
@@ -96,6 +97,7 @@ static match_table_t tokens = {
 	{Opt_type, "type=%s"},
 	{Opt_dump, "dump=%s"},
 	{Opt_media_home, "media_home=%s"},
+	{Opt_volumetag, "volume_tag=%s"},
 	{Opt_err, NULL},
 };
 
@@ -118,6 +120,7 @@ struct tmp_param {
 	char barcode[20];
 	int sides;
 	int clear_slot;
+	char volume_tag[32];
 } sv_param;
 
 #endif // _SMC_H_
-- 
1.7.3.1
