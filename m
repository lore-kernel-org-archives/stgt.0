From: Eric Millbrandt <eric.millbrandt@cacheio.com>
Subject: tgtd regression:  new NAA descriptor breaks multipathd
Date: Wed, 16 Oct 2013 19:51:24 -0400
Message-ID: <525F267C.8030109@cacheio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2phmseN5FuigreBIsSJ26xhrV3mPBBIiB"
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Alexander Nezhinsky <nezhinsky@gmail.com>
Cc: stgt@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2phmseN5FuigreBIsSJ26xhrV3mPBBIiB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello all,

Since commit 6402eb875488240a403c6d032b9e81d7802801eb "add NAA Locally
Assigned designator to 0x83 VPD page" added generated NAA descriptors,
the scsi_id field that I was assigning to each target lun is no longer
seen on the initiator side.This in turn breaks multipathing on my
initiators because it is seeing unique identifiers even though the
targets are the same.

This is a trivial example of the issue that I see. I have a target disk
(wwm 0x50014ee6036945cb) that I export with tgtd. Below is the
descriptor on the target from the host system:

[root@cio-5 ~]# sg_inq --page=3D0x83 /dev/sdj
VPD INQUIRY: Device Identification page
Designation descriptor number 1, descriptor length: 12
designator_type: NAA, code_set: Binary
associated with the addressed logical unit
NAA 5, IEEE Company_id: 0x14ee
Vendor Specific Identifier: 0x6036945cb
[0x50014ee6036945cb]

I run two instances of tgtd on two seperate Infiniband interfaces and
export the target on both so that I can use multipathd to provide
redundancy. I configure the lun using the following targets.conf file.

default-driver iser
<target
iqn.2012-07.com.cacheio:cio-5.cio-ATA-WDC_WD5000LPVX-5-350014ee6036945cb>=

<backing-store /dev/disk/cacheio/ATA-WDC_WD5000LPVX-5-350014ee6036945cb>
lun 1
vendor_id "ATA "
product_id "WD5000LPVX-5"
product_rev "1A01"
scsi_sn "WX81A33E1930"
scsi_id 350014ee6036945cb
bs-type aio
mode_page "0x0A:1:4:0x01:0x04:0x0:0x0"
write-cache off
</backing-store>
</target>

Then I connect the initiator to the lun over the two paths. They appear
as sdb and sdc. Now when I look at the descriptors from the initiator, I
see two descriptors for each lun:

[root@cio-2 ~]# sg_inq --page=3D0x83 /dev/sdb
VPD INQUIRY: Device Identification page
Designation descriptor number 1, descriptor length: 40
designator_type: T10 vendor identification, code_set: ASCII
associated with the addressed logical unit
vendor id: 350014ee
vendor specific: 6036945cb
Designation descriptor number 2, descriptor length: 12
designator_type: NAA, code_set: Binary
associated with the addressed logical unit
NAA 3, Locally assigned:
[0x3000000200000001]

[root@cio-2 ~]# sg_inq --page=3D0x83 /dev/sdc
VPD INQUIRY: Device Identification page
Designation descriptor number 1, descriptor length: 40
designator_type: T10 vendor identification, code_set: ASCII
associated with the addressed logical unit
vendor id: 350014ee
vendor specific: 6036945cb
Designation descriptor number 2, descriptor length: 12
designator_type: NAA, code_set: Binary
associated with the addressed logical unit
NAA 3, Locally assigned:
[0x3000000100000001]

Notice that the NAA descriptors are now different even though the target
is the same!

[root@cio-2 tgt]# scsi_id --whitelisted --page=3D0x83 /dev/sdb
33000000200000001
[root@cio-2 tgt]# scsi_id --whitelisted --page=3D0x83 /dev/sdc
33000000100000001

This has the effect of breaking multipathd because the identifiers no
longer match...

[root@cio-2 ~]# lsblk
NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda 8:0 0 93.2G 0 disk
=E2=94=9C=E2=94=80sda1 8:1 0 1000M 0 part /boot
=E2=94=94=E2=94=80sda2 8:2 0 87.9G 0 part
=E2=94=9C=E2=94=80vg_cio-lv_root (dm-0) 253:0 0 78.1G 0 lvm /
=E2=94=94=E2=94=80vg_cio-lv_home (dm-1) 253:1 0 9.8G 0 lvm /home
sdb 8:16 0 465.8G 0 disk
=E2=94=94=E2=94=8033000000200000001 (dm-2) 253:2 0 465.8G 0 mpath
sdc 8:32 0 465.8G 0 disk
=E2=94=94=E2=94=8033000000100000001 (dm-3) 253:3 0 465.8G 0 mpath

[root@cio-2 tgt]# multipath -ll
33000000100000001 dm-3 ATA,WD5000LPVX-5
size=3D466G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D-1 status=3Dactive
`- 32:0:0:1 sdc 8:32 active ready running
Oct 16 19:19:06 | sdb: alua not supported
33000000200000001 dm-2 ATA,WD5000LPVX-5
size=3D466G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D-1 status=3Dactive
`- 31:0:0:1 sdb 8:16 active ready running

I've reverted the commit for my local systems to restore the previous
behavior. But I'm interested in correctly assigning the NAA instead of
using the generated one.

Eric





--2phmseN5FuigreBIsSJ26xhrV3mPBBIiB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSXyZ8AAoJEEGoGVjD4GfIL3oQANzF7ZO0tLExa182rrfgRChf
34xdYLfiYSOD0bzkiAMr99Q6EUa2XEEN88+fJEKkJKsPbruHIVfjNDVFVYdB2O8d
bEs1Da02LcLZsrgmuFrZKLwuDF9gpZpGAhAMbj2tZr4WIy/HfgtMeXOaZEZ7uZKV
G7RqCvd1W5TlVuN2aGzHnsNOSz6INhOBfwgT2ri8jYiq1adz0kYZRSR7QpTdDAc1
bCU1jnEzVwX3UY4HGfGmV/FXuGjwTpRbQPS5IzF2h9fbv4dMbmEmtAsUqpRUoX7y
w0dPe/YUUv2qqWviqi2tDq6r1lXOGfa5dt2hPZJfw3gFHB1HuJdz8g8HUm5fytuk
wC3u8DAs6n/vD8CJx2FnJ+5/VkFasJzzLYaTJ5JbKTkQGVikOgJ4Y8XJFYzyGNF5
WKotIuQw9PmXxM0GTnJT8oanr3RcChW9E8vs7xiYBNfpmMsr+Der/XAbp05PcALD
Y/WrV59BmdBVQJf+GX+VdDxe/ZzPxHTe6+eMEEeI2HWkbvmsYLMNJAKCqETK6oR/
slB403c4LQwUjAqZx6F1MRR5y3Iljil+RUTQ/o2Da3bb5ABPUAe23PC38cdRRnO/
+PvR0n2pZBX7Bo66E4YnaRNxu5agcNzbPkoXy/w+DoAFfekR90tvNn742vsRyhJe
vw7+r0l5I0mNo+IwY+UI
=P0ZW
-----END PGP SIGNATURE-----

--2phmseN5FuigreBIsSJ26xhrV3mPBBIiB--
