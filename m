From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: TGT and DPO,FUA
Date: Mon, 10 Nov 2014 12:28:16 -0800
Message-ID: <CAN05THTJWVAi6+vFoAeaW2an1nD0PwghkYDWUdA02PDtV065Tw@mail.gmail.com>
References: <CAD5Pd4jUgeup0tUU8NpBMUUX=h0rv18oDdDNLgJAgYGa2bATeA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=2TOnJQ0wJ4ODQ7E8XQX/pBQhv9OIVMskGZScrdrVQxs=;
        b=YAYn0TCWtYGUfkGjnn6Td+lz1geu2pVqQmd6F+X2SCC7Fk3kTKzmccYcxEX6osOzdk
         DKBOcGCST4q6BFyV3H7dkjI1LrQAgnuzlqEHfHqXK9M9q1HQWZht+ju5BEL6A5tk2SXR
         72T3AC3REuOPECqyF415WzblV9v41zIWCyl2HecMIfDDulD7ZoP2OGMYkZ/e9Yqgy/Nv
         pklg1ZKgfVL4yfAR/MSi0EsEa5FwLOWxOiIkBToeJZggIRCJ/ViCVCsuuh0dEgPoBjuZ
         0rDOymcxG4WiaUg64FZNoNc1DSzvOKL6Rq/TlRuoPYbZf+4ZejqEWe71Yo8VwbRLCBqX
         s+Rw==
In-Reply-To: <CAD5Pd4jUgeup0tUU8NpBMUUX=h0rv18oDdDNLgJAgYGa2bATeA@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xi Tom <xitom900@gmail.com>
Cc: stgt <stgt@vger.kernel.org>

TGTD supports if the client sets these flags, but TGTD does not
advertize that FUA/DPO is available.
Since TGTD does not do any caching internally but always performs
system calls to read/write the underlying data, I
do not know if it would be useful to advertize "we support DPO/FUA
(but we actually don't do any caching)"

This support is communicated via the device specific byte in mode-sense.

https://github.com/fujita/tgt/blob/master/usr/sbc.c#L120

We currently signal back to the initiator only if the device is WP
(write protected)


If you want to have TGTD tell the initiator that FUA/DPO are available
we would need to add

if (mode6)
  data[2] |= 0x10;
else
  data[3] |= 0x10;


I see no reason to not report DPO/FUA support back to the initiator so
I can send a patch to the list later that does this change unless
someone objects.

regards
ronnie sahlberg



On Sun, Nov 9, 2014 at 1:12 AM, Xi Tom <xitom900@gmail.com> wrote:
> Hi,
>
> I am using tgt as iscsi server, and found linux kernel said that a tgt
> scsi target does not support DPO and FUA:
>
> [ 4671.673196] scsi8 : iSCSI Initiator over TCP/IP
> [ 4671.928530] scsi 8:0:0:0: RAID              IET      Controller
>   0001 PQ: 0 ANSI: 5
> [ 4671.928800] scsi 8:0:0:0: Attached scsi generic sg5 type 12
> [ 4671.929454] scsi 8:0:0:1: Direct-Access     IET      VIRTUAL-DISK
>   0001 PQ: 0 ANSI: 5
> [ 4671.930878] sd 8:0:0:1: Attached scsi generic sg6 type 0
> [ 4671.932074] sd 8:0:0:1: [sde] 6144000 512-byte logical blocks:
> (3.14 GB/2.92 GiB)
> [ 4671.932273] sd 8:0:0:1: [sde] Write Protect is off
> [ 4671.932277] sd 8:0:0:1: [sde] Mode Sense: 69 00 00 08
> [ 4671.932420] sd 8:0:0:1: [sde] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
>
>
> Why does not tgt support these two features ? but I have found its
> source code handle
> DPO and FUA flag in its bs_rdwr.c.
>
> Regards,
> Tom
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
