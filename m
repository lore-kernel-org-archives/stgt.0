From: Mark Harvey <markh794@gmail.com>
Subject: Re: LinuxIO (LIO) target @ Debian 10 and VMware 6.7 Initiator: Detected WRITE_PROTECTED LUN Access for 0x00000000
Date: Wed, 30 Dec 2020 14:09:09 +1100
Message-ID: <80CCB4DD-F9C9-4506-9B24-17473507B6C4@gmail.com>
References: <zarafa.5fea1937.73b4.3947be6e1a89f482@lx18.cmks.de>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=content-transfer-encoding:mime-version:subject:from:in-reply-to
         :date:cc:message-id:references:to;
        bh=5X12qgqH5qS8Oc+0JtwfUN3DlRM3iw+z2K7QpQmXaLQ=;
        b=By0jEjV5ef85uG0HvnqUDjrKL+xOr3S0ZQzhHaTtp9YP3puykSnyZqcyEU3EtKdjUJ
         xCcMDsh4NHwfJdxLGLx2aJ5vqRU3H8/oaJCs1EmrQ8KsbtYWZDx8D78fB6c/jaVEByRc
         R5WPECGs6oG4hmhDjIIuQlkIMVnOJ5C4IQf/t/WSvCh8Tw/0wqjrqKTIe51E+sN8s2hn
         WdmsbJFY+fRwL25FAfJOY2CB4yp08XZ09KHME9Yo3szcm8nKBLlzhE47WJJfGrESDZcH
         T2RM/ShnYZ9pRtFWeDQe1IfxVZdPUoM8aM9fm92SyXbrGGSHXYIvJ9ZL519oRqhVr7C1
         RMdg==
In-Reply-To: <zarafa.5fea1937.73b4.3947be6e1a89f482@lx18.cmks.de>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?Q?Bj=C3=B6rn_Wiggert?= <b@wiggert.it>
Cc: stgt@vger.kernel.org

Looks and feels like ESXi is trying to set a persistent scsi reservation=20

Sent from my iPhone

> On 29 Dec 2020, at 12:20, Bj=C3=B6rn Wiggert <b@wiggert.it> wrote:
>=20
> =EF=BB=BFHi, we are running
> *    QNAP NAS
> *    Debian 10
> *    Host VMware 6.7U3 Hypervisor
>=20
> a) Exporting an iSCSI-LUN-target with the QNAP, what is using LIO therfor,=
 and accessing it from VMware (read/write) works fine.
> b) Exporting an iSCSI-LUN-target with a fresh Debian 10 using LIO and acce=
ssing it with a Windows 7 iSCSI initiator (read/write) works fine.
>=20
> Using the target b) (Debian 10 / LIO) and the initiator a) (VMware v6.7) w=
orks as far as
> *    VMware sees the target host
> *    VMware can login and sees the target
> *    VMware can READ the data on the LUN (sees partition table, size of it=
, partition types, etc)
>=20
> As soon as we try to write anything VMware reports
>=20
>> 2020-12-28T14:36:00.775Z info hostd[2098690] [Originator@6876 sub=3DParti=
tionsvc opID=3Desxui-2f96-fbd9 user=3Droot] Status : 255 Output: gpt 0 0 0 0=

>>=20
>> Error : Error: Read-only file system during write on /dev/disks/naa.60014=
054b666e78a1c443ee941c60e3e SetPtableGpt: Unable to commit to disk
>=20
>=20
> and the Debian 10 box reports:
>=20
>> kernel: [ 80.210044] TARGET_CORE[iSCSI]: Detected WRITE_PROTECTED LUN Acc=
ess for 0x00000000
>=20
> I don't recognize why VMware mounts the iSCSI LUN read-only but Windows 7 m=
ounts it read-write and VMware mount the QNAP-iSCSI-LUN also read-write.
>=20
> I appreciate any hint - thank you therfor in advance.
>=20
> Jan=20
>=20
> =20
