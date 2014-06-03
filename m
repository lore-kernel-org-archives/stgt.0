From: Apollon Oikonomopoulos <apoikos@debian.org>
Subject: Re: scsi_id not valid in iscsi node
Date: Tue, 3 Jun 2014 09:09:10 +0300
Message-ID: <20140603060910.GA1436@marvin.ws.skroutz.gr>
References: <CAN+bsqg+rrCRHci=8K8_Az6EjONByTuadOGw-NfXdgjQSAvT_A@mail.gmail.com>
 <1401745421.32085.12.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1401745421.32085.12.camel@haakon3.risingtidesystems.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: lingli tang <tanglingli001@gmail.com>, STGT-Devel <stgt@vger.kernel.org>

Hi,
On 14:43 Mon 02 Jun     , Nicholas A. Bellinger wrote:
> Forwarding to the correct stgt-devel list..
>=20
> On Fri, 2014-05-30 at 17:38 +0800, lingli tang wrote:
> > =E7=82=B9=E5=87=BB=E5=B1=95=E7=A4=BA=EF=BC=9A
> > 1. =E7=82=B9=E5=87=BB=E6=9C=8D=E5=8A=A1=E5=99=A8=E5=B1=95=E7=A4=BA=E6=
=9C=8D=E5=8A=A1=E5=99=A8=E7=9A=84=EF=BC=9Acpu=EF=BC=88%user,%sys,%iowai=
t,%idle=EF=BC=89,memory(Total=EF=BC=8Cused, free,
> > buffer, cache), IOPS(read request, write request), Througthput(read
> > kb, write kb)=EF=BC=8C
> >=20
> > we use tgtd 1.0.47 to export a disk and use iscsiadm to load it.
> > but the ID_SERIAL of this disk is not the same with scsi_id of expo=
rt disk.
> > if we use tgtd 1.0.24 it is the same.

> >=20
> > after iscsiadm log in, we check the ID_SERIAL of this disk using
> > =E2=80=9Cudevadm info --query=3Dall --path=3D/block/sdb=E2=80=9D=EF=
=BC=9A
> >     E: ID_SERIAL_RAW=3D360000000000000000e001000c00000e0
> >     E: ID_SERIAL=3D360000000000000000e001000c00000e0
> >     E: ID_SERIAL_SHORT=3D60000000000000000e001000c00000e0
> >=20
> > but with tgtd 1.0.24, it is correct:
> >     E: ID_SERIAL_RAW=3D1test1-iscsi-iser
> >     E: ID_SERIAL=3D1test1-iscsi-iser
> >     E: ID_SERIAL_SHORT=3Dtest1-iscsi-iser
> >=20
> > test environment rhel6.2

We were debugging the exact same thing yesterday, after our persistent=20
links under /dev stopped working, so here's the short version of the=20
story:

Commit 6402eb8 added an NAA local designator (WWN) field to tgt's 0x83=20
VPD (the Device Identification page), and commit 8141d67b further added=
=20
an extended WWN. All three identifiers are sent out in tgt's 0x83 VPD,=20
but udev's scsi_id helper always picks the binary WWN by preference and=
=20
uses it as ID_SERIAL, i.e. ignores the ASCII T10 (ID_SERIAL) identifier=
=20
present in the VPD. If you use sg_inq from the sg3-utils package you=20
will get both.

I'm not sure tgt can do much more than make both NAA identifiers=20
optional, the issue seems to lie with udev at this point.

Regards,
Apollon
