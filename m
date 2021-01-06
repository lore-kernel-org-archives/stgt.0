From: Michael Ablassmeier <abi@grinser.de>
Subject: VTL emulation, no barcodes shown in mtx
Date: Wed, 6 Jan 2021 19:58:25 +0100
Message-ID: <20210106185825.h7v4dpn2cg3gdejc@lrrr.dead-link.org>
Reply-To: Michael Ablassmeier <abi@grinser.de>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
Content-Disposition: inline
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

hi,

im trying to create a virtual tape library based on the DVD/CD example,
the commands used are:

> tgtadm --op new --mode logicalunit --tid 1 --lun 1 --device-type tape 
> tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 1 --params vendor_id=IBM,product_id=LTO1,product_rev=0010,scsi_sn=IBMLTO1,removable=1
> tgtadm --lld iscsi --mode logicalunit --op new --tid 1 --lun 2 --backing-store $HOME/smc --device-type changer
> tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params vendor_id=STK,product_id=L700,product_rev=0010,scsi_sn=XYZZY_0,removable=1
> tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params element_type=4,start_address=1,quantity=1
> tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params element_type=4,address=1,tid=1,lun=1
> tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params element_type=1,start_address=16,quantity=1
> tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params media_home=${VTL}
> tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,start_address=1024,quantity=8
> tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,address=1024,barcode=TAPE001,sides=1
> tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 2 --params element_type=2,address=1025,barcode=TAPE002,sides=1

while the device seems to work (loading and unloading the vtl medias),
mtx and other tools i used to query the VTL do not show any barcodes:

> mtx -f /dev/sg8 status
> Storage Changer /dev/sg8:1 Drives, 8 Slots ( 0 Import/Export )
> Data Transfer Element 0:Empty
> Storage Element 1:Full 
> Storage Element 2:Full 
> Storage Element 3:Empty:VolumeTag=

(4.19.0, 1.0.74)

am i missing something?

thanks,
    - michael

