From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Tgtd dirty pages issue
Date: Fri, 16 Oct 2015 08:41:08 -0700
Message-ID: <CAN05THQPr0HQDQtoNRUP3WMy3-WY6XjZz0JdofktpNr-=kv8ew@mail.gmail.com>
References: <CAKn=86PDwiWgVMKRkCCKuv8YddnBO6LVcCe1aSA1pZdi85058Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=rfvvS0IQFo0otjw4Dv194h+Z4oaEl3jNESY4h2QR3Cg=;
        b=GNV89t+rO1oC51eR+VdKLJYNRrykklOF+PLp0qYabq0aIPNTP+sE/Na5sX7Wr4HYIH
         1GsPoH6jIJtXRhfRmGKbvWSl8dv2z64pu73eTBiWqvUJEeoE1+zwiqHnIxJI15U6bIU9
         9NSL3fxwhkXViDiH1JtihgAhh1tvX1qCRt0j21A5sEPrwqNwurTxb4SYcuRLCArqjBCd
         1RdlOxqnTU3z5vZw/Pvc1lNpU/3eCoI7VoDtk+SOnvXp2+yfIOTigey916VHapBziCxX
         eaB64dAsVZnhdkUApcV51wNlWP+QFVf+7Mj2HcFvpkAfJWvkH8mBUp7dum12fcT01yNP
         mklA==
In-Reply-To: <CAKn=86PDwiWgVMKRkCCKuv8YddnBO6LVcCe1aSA1pZdi85058Q@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Frank Michel <fmfranck@gmail.com>
Cc: stgt <stgt@vger.kernel.org>

On Fri, Oct 16, 2015 at 3:43 AM, Frank Michel <fmfranck@gmail.com> wrot=
e:
> Hello,
>
> We are encountering a backup problem using tgtd.
>
> Though, we believe it to be a kernel problem, you might have
> encountered such an issue before and have some lights about it.
>
> We backup a Linux RHEL 6 system using an iSCSI link connected to an
> usb3 drive on another system. The problem is that the backup process
> on the source system is writing too fast for the network to send data=
=2E
>
> The number of dirty pages of unwritten data keep rising on the source
> system because of the network bottleneck.This keep growing until the
> source system freeze because of too much allocated memory.

That sounds likely.
I often encounter similar issues, for example using rsync to copy a
lot of data from one usb drive to another.
Very very annoying.

>
> We believe it=E2=80=99s a kernel issue which has not been fixed even =
in the
> most recent kernel versions (3.3). To fix that, it would require a ma=
x
> dirty pages per device kernel parameter which is not available at thi=
s
> moment.
>
> Have you heard of any =C2=AB strategy =C2=BB which we could use as a =
workaround
> for this specific problem ?

Since you say it is the pagecache that completely fills up, I assume
you are mounting the remote iSCSI device locally ?

I don't have any great strategies, but you could try :

* mount the filesystem using 'sync' mount option. It MIGHT prevent the
buildup of dirty pages.

* the tool you use to copy/write the files to the backup direcotry,
does it support O_DIRECT ? That might allow writing to the destination
completely bypassing  the page cache.

Both these suggestions are probably likely to have a HUGE negative
impact on performance when accessing a block device across the
network. :-(  Maybe that is not critical in a backup application ?


Or, you could also do this, it is very likely to guarantee to avoid
this issue,  but it means that what you store on the remote USB device
is no longer just a copy of the directory structure :

* Use TGTD as a virtual tape library  and do backups to "virtual tape"
instead. Since this is no longer a block device as far as the kernel
is concerned it will not consume any pagecache. Also, since tape
access is designed to be in streaming mode you will likely still have
very high throughput when writing your backup. I.e. you will not have
the performance issues from above.

TGTD supports VTL emulation , yey!

If you are willing to do "virtual tape" I would recommend that you set
your USB device to keep as many xxxGB files as possible.
The command to create and initialize a file to be used as a "virtual
tape" is tgtimg.

This document describes the basics on how to set TGTD up as a virtual
tape library :
https://github.com/fujita/tgt/blob/master/doc/README.vtl


Since VTL means you will have to talk to the virtual media changer to
switch tapes,   you can use the mtx tool that should be available on
every linux distro.

It you rather want a simple but nice GUI to swap/load/unload tapes,
you can use this:
https://github.com/rosjat/mtx-gui




regards
ronnie sahlberg

>
> Thanks for your help,
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
