From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] DOCS: add an example dvd jukebox script
Date: Wed, 20 Aug 2014 19:21:45 -0700
Message-ID: <1408587705-19310-2-git-send-email-ronniesahlberg@gmail.com>
References: <1408587705-19310-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZBmvPyAQSOwH6MSC3VgCYgwCy5kzaFFAkY+3Y/kQR5c=;
        b=OwnGQYSxbFEaw0zzon+uUNN/23VkyZFswMJPh/l4bkHxkMW4ZaqqN/0jXqJ/Jbtv99
         bJrAsnT0qAwaKbE2CTeO89EMxShHgMlrnTv4J4yz2hiLRG5r0vG5XdPoHp3LZZG+XInR
         VED/L8R9In+CT/Iaopt3vR7ebc8kXlu8evMAvuqlZYhbItjn54YPElu3ps4MscefbK7G
         6kOzjNSFXdtk2WDTazqUQaEOlC1npy8k5Sskjcv22sG0N1/eI6D/LwywAJ0y8UukAFzz
         0zw/2b0HN5+CjL7Cfjjh+yFWAi9T2PWRcWjuNn7z1SelU/UbxSUZaByUxXmbBqUji+BQ
         tAvA==
In-Reply-To: <1408587705-19310-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

Add an example script that can be used to automatically set up a DVD jukebox
with a dvd drive and a medium changer that will export all your ISO images.

Use the mtx command to operate which media should be loaded.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 doc/README.dvdjukebox |  100 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 100 insertions(+), 0 deletions(-)
 create mode 100755 doc/README.dvdjukebox

diff --git a/doc/README.dvdjukebox b/doc/README.dvdjukebox
new file mode 100755
index 0000000..49ab257
--- /dev/null
+++ b/doc/README.dvdjukebox
@@ -0,0 +1,100 @@
+#!/bin/sh
+#
+# This is a script to set up a SCSI DVD JUKEBOX for all your ISO images.
+#
+# This script should be run from a directory that contains ISO images
+# with the extension .iso .
+# When run, the script will create an iSCSI target containing one DVD drive
+# and one media changer. The DVD drive will not have a disk mounted but
+# the medium changer will have one slot for each ISO image found.
+# Use the 'mtx' tool to load/unload media.
+#
+# By default, any ISO images found will be populated with a barcode of
+# DVD_????. These are the barcodes that mtx will show when you list the
+# status of the changer.
+# To have more human readable names you can provide a $TRANSLATE file
+# to set explicit barcodes for each ISO image.
+# The format of this file is one line for each mapping consisting of
+# <ISO image minus .iso suffix> SPACE <barcode>
+#
+# Example:
+# utopic-desktop-amd64 Ubuntu14
+#
+# Note that a barcode can have at most 8 characters.
+#
+# CON: This is the connection index for TGTD. This is needed if you run
+# multiple instances of TGTD on the same host. Each instance must use a unique
+# CON value.
+#
+# TARGETNAME: The iSCSI name to use for the target.
+#
+# TARGETPORT: The TCP port that this target will be hosted from.
+#
+# TRANSLATE: Optional. A file providing mapping between the iso image filenames
+# and the barcode to assign for these images.
+
+CON=1
+TARGETNAME=iqn.ronnie.iso:distros
+TARGETPORT=3261
+TRANSLATE=translate
+
+
+nc -z 127.0.0.1 $TARGETPORT || {
+	echo "Starting iSCSI target on port $TARGETPORT"
+	tgtd -C $CON --iscsi portal=0.0.0.0:$TARGETPORT
+}
+
+tgtadm -C $CON --op delete --mode target --tid 1 --force 2>/dev/null
+tgtadm -C $CON --op new --mode target --tid 1 -T $TARGETNAME
+
+# Create a DVD drive
+tgtadm -C $CON --op new --mode logicalunit --tid 1 --lun 1 -Y cd
+tgtadm -C $CON --op update --mode logicalunit --tid 1 --lun 1 --params vendor_id=STGT_DVD,product_id=DVD101,product_rev=0010,scsi_sn=STGTDVD01,removable=1
+
+# We need a backend store file for the media changer
+SMC=`pwd`/smc-$CON
+if [ ! -f $SMC ]; then
+	dd if=/dev/zero of=$SMC bs=1k count=1
+fi
+
+# Create the SMC device and give it a nice name
+tgtadm -C $CON --mode logicalunit --op new --tid 1 --lun 2 -b $SMC --device-type=changer
+tgtadm -C $CON --mode logicalunit --op update --tid 1 --lun 2 --params vendor_id=STK,product_id=L700,product_rev=0010,scsi_sn=XYZZY_0,removable=1
+
+# Add a Data Transfer devices (1 drive)
+tgtadm -C $CON --mode logicalunit --op update --tid 1 --lun 2 --params element_type=4,start_address=1,quantity=1
+
+# Specify that the DVD above (LUN 1) is the data transfer device we created
+tgtadm -C $CON --mode logicalunit --op update --tid 1 --lun 2 --params element_type=4,address=1,tid=1,lun=1
+
+# Medium Transport Elements (robot arm / picker)
+tgtadm -C $CON --mode logicalunit --op update --tid 1 --lun 2 --params element_type=1,start_address=16,quantity=1
+
+
+# define path to virtual media
+VTL=`pwd`/vtl
+mkdir -p ${VTL} 2>/dev/null
+rm ${VTL}/*
+tgtadm -C $CON --mode logicalunit --op update --tid 1 --lun 2 --params media_home=${VTL}
+
+NUM_ELEM=`ls *.iso | wc -l`
+echo "Creating $NUM_ELEM storage elements for media"
+
+# Storage Elements - starting at addr 1024
+tgtadm -C $CON --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,start_address=1024,quantity=$NUM_ELEM
+
+# Populate the slots
+SLOT=0
+ls *.iso | sed -e "s/.iso$//" | while read ISO; do
+	BARCODE=`egrep "^${ISO} " $TRANSLATE | sed -e "s/^[^ ]* *//"`
+	[ -z "$BARCODE" ] && {
+		BARCODE=`echo $SLOT | awk '{printf "DVD_%04d", $1}'`
+	}
+	ln `pwd`/${ISO}.iso ${VTL}/$BARCODE
+	tgtadm -C $CON --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,address=`expr "1024" "+" "$SLOT"`,barcode="$BARCODE",sides=1
+
+	SLOT=`expr "$SLOT" "+" "1"`
+done
+
+tgtadm -C $CON --op bind --mode target --tid 1 -I ALL
+tgtadm -C $CON --op show --mode target
-- 
1.7.3.1
