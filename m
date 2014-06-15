From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: scsi_id not valid in iscsi node
Date: Sun, 15 Jun 2014 09:23:14 +0300
Message-ID: <539D3BD2.4070904@mellanox.com>
References: <CAN+bsqg+rrCRHci=8K8_Az6EjONByTuadOGw-NfXdgjQSAvT_A@mail.gmail.com> <1401745421.32085.12.camel@haakon3.risingtidesystems.com> <20140603060910.GA1436@marvin.ws.skroutz.gr>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20140603060910.GA1436@marvin.ws.skroutz.gr>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Apollon Oikonomopoulos <apoikos@debian.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: lingli tang <tanglingli001@gmail.com>, STGT-Devel <stgt@vger.kernel.org>, "Cullison, Dennis" <Dennis.Cullison@Teradata.com>

On 03/06/2014 09:09, Apollon Oikonomopoulos wrote:
> On 14:43 Mon 02 Jun     , Nicholas A. Bellinger wrote:
>> Forwarding to the correct stgt-devel list..
>>
>> On Fri, 2014-05-30 at 17:38 +0800, lingli tang wrote:
>>> [...]
>>> 1. [...] cpu=EF=BC=88%user,%sys,%iowait,%idle=EF=BC=89,memory(Total=
=EF=BC=8Cused, free,
>>> buffer, cache), IOPS(read request, write request), Througthput(read
>>> kb, write kb)=EF=BC=8C
>>>
>>> we use tgtd 1.0.47 to export a disk and use iscsiadm to load it.
>>> but the ID_SERIAL of this disk is not the same with scsi_id of expo=
rt disk.
>>> if we use tgtd 1.0.24 it is the same.
>>> after iscsiadm log in, we check the ID_SERIAL of this disk using
>>> =E2=80=9Cudevadm info --query=3Dall --path=3D/block/sdb=E2=80=9D=EF=
=BC=9A
>>>      E: ID_SERIAL_RAW=3D360000000000000000e001000c00000e0
>>>      E: ID_SERIAL=3D360000000000000000e001000c00000e0
>>>      E: ID_SERIAL_SHORT=3D60000000000000000e001000c00000e0
>>>
>>> but with tgtd 1.0.24, it is correct:
>>>      E: ID_SERIAL_RAW=3D1test1-iscsi-iser
>>>      E: ID_SERIAL=3D1test1-iscsi-iser
>>>      E: ID_SERIAL_SHORT=3Dtest1-iscsi-iser
>>>
>>> test environment rhel6.2
> We were debugging the exact same thing yesterday, after our persisten=
t
> links under /dev stopped working, so here's the short version of the
> story:
>
> Commit 6402eb8 added an NAA local designator (WWN) field to tgt's 0x8=
3
> VPD (the Device Identification page), and commit 8141d67b further add=
ed
> an extended WWN. All three identifiers are sent out in tgt's 0x83 VPD=
,
> but udev's scsi_id helper always picks the binary WWN by preference a=
nd
> uses it as ID_SERIAL, i.e. ignores the ASCII T10 (ID_SERIAL) identifi=
er
> present in the VPD. If you use sg_inq from the sg3-utils package you
> will get both.
>
> I'm not sure tgt can do much more than make both NAA identifiers
> optional, the issue seems to lie with udev at this point.
>
>

I added Dennis who is the author of commit 8141d67b -- he made the=20
following comment: "[...] This is most likely an issue with udev. Most=20
of the udev tools look at Inquiry VPD 0x83 before looking at VPD 0x80. =
=20
With the NAA pages now defined in VPD 0x83, the tools are using that=20
information instead of VPD 0x80."
