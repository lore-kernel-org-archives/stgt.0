From: =?utf-8?Q?Bj=C3=B6rn_Wiggert_=28wiggert=2Eit=29?= <b@wiggert.it>
Subject: LinuxIO (LIO) target @ Debian 10 and VMware 6.7 Initiator: Detected
 WRITE_PROTECTED LUN Access for 0x00000000
Date: Mon, 28 Dec 2020 18:43:19 +0100
Message-ID: <zarafa.5fea1937.73b4.3947be6e1a89f482@lx18.cmks.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <stgt-owner@vger.kernel.org>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?utf-8?Q?stgt=40vger=2Ekernel=2Eorg?= <stgt@vger.kernel.org>

Hi, we are running
*	QNAP NAS
*	Debian 10
*	Host VMware 6.7U3 Hypervisor

a) Exporting an iSCSI-LUN-target with the QNAP, what is using LIO therfor, =
and accessing it from VMware (read/write) works fine.
b) Exporting an iSCSI-LUN-target with a fresh Debian 10 using LIO and acces=
sing it with a Windows 7 iSCSI initiator (read/write) works fine.

Using the target b) (Debian 10 / LIO) and the initiator a) (VMware v6.7) wo=
rks as far as
*	VMware sees the target host
*	VMware can login and sees the target
*	VMware can READ the data on the LUN (sees partition table, size of it, pa=
rtition types, etc)
=20
As soon as we try to write anything VMware reports

> 2020-12-28T14:36:00.775Z info hostd[2098690] [Originator@6876 sub=3DParti=
tionsvc opID=3Desxui-2f96-fbd9 user=3Droot] Status : 255 Output: gpt 0 0 0 0
>
> Error : Error: Read-only file system during write on /dev/disks/naa.60014=
054b666e78a1c443ee941c60e3e SetPtableGpt: Unable to commit to disk


and the Debian 10 box reports:

> kernel: [ 80.210044] TARGET_CORE[iSCSI]: Detected WRITE_PROTECTED LUN Acc=
ess for 0x00000000

I don't recognize why VMware mounts the iSCSI LUN read-only but Windows 7 m=
ounts it read-write and VMware mount the QNAP-iSCSI-LUN also read-write.

I appreciate any hint - thank you therfor in advance.

Jan=20

=C2=A0
