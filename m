From: lingli tang <tanglingli001@gmail.com>
Subject: Re: scsi_id not valid in iscsi node
Date: Mon, 23 Jun 2014 11:09:14 +0800
Message-ID: <CAN+bsqh4NdGCoOa=eYyGFe3qTVww1rLPV_7CuB0VMDRP9G-Puw@mail.gmail.com>
References: <CAN+bsqg+rrCRHci=8K8_Az6EjONByTuadOGw-NfXdgjQSAvT_A@mail.gmail.com>
	<1401745421.32085.12.camel@haakon3.risingtidesystems.com>
	<20140603060910.GA1436@marvin.ws.skroutz.gr>
	<539D3BD2.4070904@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=J2pcXotV4CAVMds7ytAt4uwwClVRQfvd1SC3+gWF5gM=;
        b=t9Za6FEtJHa1T4WD6+XpGRhueywLXhpdSJgscpmcNIgeMGXiK0hV177cxRv5R64cx6
         u2R6Lf7vbJIUMKS61+W8DcneR5dScbRygXBua40/04GnjfG/AG0oKx2xVB6u5eUfSXd9
         H8S/I2PUEzUe0I2ysNlmAs2v2g3SSdEyOISVRojfDTAMNHIvpovQHEMk3IxfYPwqLyvE
         JXuEjvXxgjyxCEE9iNUwzwcsQQ9niHc1ue7dtlE2lMWXqZMbs6Hw8TFCfOGG34U8QnWU
         YeQ470G2+5ujHtN0ElFHFUmj7a/bLfcufHcf/k04HQgb87ElLur09MhZjSyKufJAfvVf
         hF2A==
In-Reply-To: <539D3BD2.4070904@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Apollon Oikonomopoulos <apoikos@debian.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, STGT-Devel <stgt@vger.kernel.org>, "Cullison, Dennis" <Dennis.Cullison@teradata.com>

so after commit 8141d67b. the tgtd is not Backward compatible?
and we have to use tgtd before commit 8141d67b for compatible with
multipath/udev of rhel6.2
or rebuild a different multipath/udev in  rhel6.2?

2014-06-15 14:23 GMT+08:00 Or Gerlitz <ogerlitz@mellanox.com>:
> On 03/06/2014 09:09, Apollon Oikonomopoulos wrote:
>>
>> On 14:43 Mon 02 Jun     , Nicholas A. Bellinger wrote:
>>>
>>> Forwarding to the correct stgt-devel list..
>>>
>>> On Fri, 2014-05-30 at 17:38 +0800, lingli tang wrote:
>>>>
>>>> [...]
>>>> 1. [...] cpu=EF=BC=88%user,%sys,%iowait,%idle=EF=BC=89,memory(Tota=
l=EF=BC=8Cused, free,
>>>>
>>>> buffer, cache), IOPS(read request, write request), Througthput(rea=
d
>>>> kb, write kb)=EF=BC=8C
>>>>
>>>> we use tgtd 1.0.47 to export a disk and use iscsiadm to load it.
>>>> but the ID_SERIAL of this disk is not the same with scsi_id of exp=
ort
>>>> disk.
>>>> if we use tgtd 1.0.24 it is the same.
>>>> after iscsiadm log in, we check the ID_SERIAL of this disk using
>>>> =E2=80=9Cudevadm info --query=3Dall --path=3D/block/sdb=E2=80=9D=EF=
=BC=9A
>>>>      E: ID_SERIAL_RAW=3D360000000000000000e001000c00000e0
>>>>      E: ID_SERIAL=3D360000000000000000e001000c00000e0
>>>>      E: ID_SERIAL_SHORT=3D60000000000000000e001000c00000e0
>>>>
>>>> but with tgtd 1.0.24, it is correct:
>>>>      E: ID_SERIAL_RAW=3D1test1-iscsi-iser
>>>>      E: ID_SERIAL=3D1test1-iscsi-iser
>>>>      E: ID_SERIAL_SHORT=3Dtest1-iscsi-iser
>>>>
>>>> test environment rhel6.2
>>
>> We were debugging the exact same thing yesterday, after our persiste=
nt
>> links under /dev stopped working, so here's the short version of the
>> story:
>>
>> Commit 6402eb8 added an NAA local designator (WWN) field to tgt's 0x=
83
>> VPD (the Device Identification page), and commit 8141d67b further ad=
ded
>> an extended WWN. All three identifiers are sent out in tgt's 0x83 VP=
D,
>> but udev's scsi_id helper always picks the binary WWN by preference =
and
>> uses it as ID_SERIAL, i.e. ignores the ASCII T10 (ID_SERIAL) identif=
ier
>> present in the VPD. If you use sg_inq from the sg3-utils package you
>> will get both.
>>
>> I'm not sure tgt can do much more than make both NAA identifiers
>> optional, the issue seems to lie with udev at this point.
>>
>>
>
> I added Dennis who is the author of commit 8141d67b -- he made the fo=
llowing
> comment: "[...] This is most likely an issue with udev. Most of the u=
dev
> tools look at Inquiry VPD 0x83 before looking at VPD 0x80.  With the =
NAA
> pages now defined in VPD 0x83, the tools are using that information i=
nstead
> of VPD 0x80."
