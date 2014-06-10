From: lingli tang <tanglingli001@gmail.com>
Subject: Re: scsi_id not valid in iscsi node
Date: Tue, 10 Jun 2014 12:44:50 +0800
Message-ID: <CAN+bsqjcK9mUrTSx1WMR7TZnVvQEc87T=e=OH3Vjcyf-jW2cyg@mail.gmail.com>
References: <CAN+bsqg+rrCRHci=8K8_Az6EjONByTuadOGw-NfXdgjQSAvT_A@mail.gmail.com>
	<1401745421.32085.12.camel@haakon3.risingtidesystems.com>
	<20140603060910.GA1436@marvin.ws.skroutz.gr>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=+YupI2BnKqhD/YkesEwqV/m0OdTZ6PZmu61BKEX+/Xc=;
        b=ulOVCj65nZ1V6QcwXqauTBz30L6G6yVMik8SxYKPTgE+qnY/Leff6hT+yt7CqbibcX
         ofIFne6nUjgfM+oJy/5qw45P9NC1yoVbvZRgtiEw19+wnSVtPPxvaaKL1deidKiQzrkg
         3W7m0th5oC8CopqUCbBW/WaGBnVUQySjxvEzk7ujvAMGUzuKzkvOr6cuOyXnuo0N5PCq
         vcxpdVx6pYnJKOdYDd5+jgJ01beXQW8cdgJ2L6yek/N4PRZYnA1I9HBldf69zIjLBmEw
         sn7eg1+WXq/Y3/MjHKsjd3E3Cca+MFKnULfHV+/2xNGN7A+dmr46v6wgigKxEZadeeAP
         mt5w==
In-Reply-To: <20140603060910.GA1436@marvin.ws.skroutz.gr>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Apollon Oikonomopoulos <apoikos@debian.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, STGT-Devel <stgt@vger.kernel.org>

if we use the scsi_id, it return the same thing.
scsi_id --export --whitelisted --device=3D/dev/sdb
  E: ID_SERIAL_RAW=3D360000000000000000e001000c00000e0
  E: ID_SERIAL=3D360000000000000000e001000c00000e0
  E: ID_SERIAL_SHORT=3D60000000000000000e001000c00000e0

Do we need another tool or update iscsiadm/scsi_id/multipath
or return to tgt 1.0.24=EF=BC=9F

2014-06-03 14:09 GMT+08:00 Apollon Oikonomopoulos <apoikos@debian.org>:
> Hi,
> On 14:43 Mon 02 Jun     , Nicholas A. Bellinger wrote:
>> Forwarding to the correct stgt-devel list..
>>
>> On Fri, 2014-05-30 at 17:38 +0800, lingli tang wrote:
>> > =E7=82=B9=E5=87=BB=E5=B1=95=E7=A4=BA=EF=BC=9A
>> > 1. =E7=82=B9=E5=87=BB=E6=9C=8D=E5=8A=A1=E5=99=A8=E5=B1=95=E7=A4=BA=
=E6=9C=8D=E5=8A=A1=E5=99=A8=E7=9A=84=EF=BC=9Acpu=EF=BC=88%user,%sys,%io=
wait,%idle=EF=BC=89,memory(Total=EF=BC=8Cused, free,
>> > buffer, cache), IOPS(read request, write request), Througthput(rea=
d
>> > kb, write kb)=EF=BC=8C
>> >
>> > we use tgtd 1.0.47 to export a disk and use iscsiadm to load it.
>> > but the ID_SERIAL of this disk is not the same with scsi_id of exp=
ort disk.
>> > if we use tgtd 1.0.24 it is the same.
>
>> >
>> > after iscsiadm log in, we check the ID_SERIAL of this disk using
>> > =E2=80=9Cudevadm info --query=3Dall --path=3D/block/sdb=E2=80=9D=EF=
=BC=9A
>> >     E: ID_SERIAL_RAW=3D360000000000000000e001000c00000e0
>> >     E: ID_SERIAL=3D360000000000000000e001000c00000e0
>> >     E: ID_SERIAL_SHORT=3D60000000000000000e001000c00000e0
>> >
>> > but with tgtd 1.0.24, it is correct:
>> >     E: ID_SERIAL_RAW=3D1test1-iscsi-iser
>> >     E: ID_SERIAL=3D1test1-iscsi-iser
>> >     E: ID_SERIAL_SHORT=3Dtest1-iscsi-iser
>> >
>> > test environment rhel6.2
>
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
> Regards,
> Apollon
