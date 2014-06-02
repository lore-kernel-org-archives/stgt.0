From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: scsi_id not valid in iscsi node
Date: Mon, 02 Jun 2014 14:43:41 -0700
Message-ID: <1401745421.32085.12.camel@haakon3.risingtidesystems.com>
References: <CAN+bsqg+rrCRHci=8K8_Az6EjONByTuadOGw-NfXdgjQSAvT_A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=linux-iscsi.org;
	s=default.private; t=1401743928; bh=MMjjC4ZQ4fio976vbqnBsJcWEyvBeDd
	k57bcLo6NcgQ=; h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Mime-Version:Content-Transfer-Encoding;
	b=w6ECRJMq536ck1ihouA64ocPiTfMjosE1MKA8Stp9XADFUo8gyaQ5dHmD+165Ywd3
	teYV/cw3fTrlLU6Dx9nCe+NS5kz88ooEvMf+6/iTTGN9EmKZJvizDzV4X8OEZojqYIg
	i1gICcfLEEhdyayLfWgqatDOOsJriqWqJvT/PRU=
In-Reply-To: <CAN+bsqg+rrCRHci=8K8_Az6EjONByTuadOGw-NfXdgjQSAvT_A@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: lingli tang <tanglingli001@gmail.com>
Cc: STGT-Devel <stgt@vger.kernel.org>

=46orwarding to the correct stgt-devel list..

On Fri, 2014-05-30 at 17:38 +0800, lingli tang wrote:
> =E7=82=B9=E5=87=BB=E5=B1=95=E7=A4=BA=EF=BC=9A
> 1. =E7=82=B9=E5=87=BB=E6=9C=8D=E5=8A=A1=E5=99=A8=E5=B1=95=E7=A4=BA=E6=
=9C=8D=E5=8A=A1=E5=99=A8=E7=9A=84=EF=BC=9Acpu=EF=BC=88%user,%sys,%iowai=
t,%idle=EF=BC=89,memory(Total=EF=BC=8Cused, free,
> buffer, cache), IOPS(read request, write request), Througthput(read
> kb, write kb)=EF=BC=8C
>=20
> we use tgtd 1.0.47 to export a disk and use iscsiadm to load it.
> but the ID_SERIAL of this disk is not the same with scsi_id of export=
 disk.
> if we use tgtd 1.0.24 it is the same.
>=20
> using tgtd 1.0.47, export the disk, and show target info like:
>     Target 1: shadow.qlink3261
>         System information:
>             Driver: iser
>             State: ready
>         I_T nexus information:
>             I_T nexus: 1
>                 Initiator: iqn.1994-05.com.redhat:2fe5d8395c2f alias:=
 master
>                 Connection: 0
>                     RDMA IP Address: 172.16.128.102
>             I_T nexus: 2
>                 Initiator: iqn.1994-05.com.redhat:2fe5d8395c2f alias:=
 master
>                 Connection: 0
>                     RDMA IP Address: 172.16.129.102
>         LUN information:
>             LUN: 0
>                 Type: controller
>                 SCSI ID: IET     00010000
>                 SCSI SN: beaf10
>                 Size: 0 MB, Block size: 1
>                 Online: Yes
>                 Removable media: No
>                 Prevent removal: No
>                 Readonly: No
>                 SWP: No
>                 Thin-provisioning: No
>                 Backing store type: null
>                 Backing store path: None
>                 Backing store flags:
>             LUN: 1
>                 Type: disk
>                 SCSI ID: test1-iscsi-iser
>                 SCSI SN: test1-iscsi-iser
>                 Size: 104858 MB, Block size: 512
>                 Online: Yes
>                 Removable media: No
>                 Prevent removal: No
>                 Readonly: No
>                 SWP: No
>                 Thin-provisioning: No
>                 Backing store type: rdwr
>                 Backing store path: /dev/memdiska1
>                 Backing store flags: direct
>         Account information:
>         ACL information:
>             172.16.128.0/24
>             172.16.129.0/24
>=20
> after iscsiadm log in, we check the ID_SERIAL of this disk using
> =E2=80=9Cudevadm info --query=3Dall --path=3D/block/sdb=E2=80=9D=EF=BC=
=9A
>     E: ID_SERIAL_RAW=3D360000000000000000e001000c00000e0
>     E: ID_SERIAL=3D360000000000000000e001000c00000e0
>     E: ID_SERIAL_SHORT=3D60000000000000000e001000c00000e0
>=20
> but with tgtd 1.0.24, it is correct:
>     E: ID_SERIAL_RAW=3D1test1-iscsi-iser
>     E: ID_SERIAL=3D1test1-iscsi-iser
>     E: ID_SERIAL_SHORT=3Dtest1-iscsi-iser
>=20
> test environment rhel6.2
> --
> To unsubscribe from this list: send the line "unsubscribe target-deve=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

