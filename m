From: Frank Michel <fmfranck@gmail.com>
Subject: Tgtd dirty pages issue
Date: Fri, 16 Oct 2015 12:43:42 +0200
Message-ID: <CAKn=86PDwiWgVMKRkCCKuv8YddnBO6LVcCe1aSA1pZdi85058Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        bh=qFIo3UEnK7T30xaFD71ENhTGY2669wDjsYBDDRvPCFE=;
        b=he0Gg3xv7gIRCGysOmPigH/DwckPINXUOlV+uKKUUWynjwXkK8UAdUMPkIPuyY3ZYK
         +MvT9i4T/3Vjwk7NT5w1xX17pInaFQ9+PnsNpxULf2sT6QqlZxXReHskQFwonF1IIpxk
         oNq0ruOL0+F0S6PlxAbWc7h2NqIaDrpTRAweORUY3XFkPA9Mks95fkRpC1+gVR54QgfR
         3HdZLlAHM+1bafNB/u7O/Y3PYgUzVz9vPapLBAWERP/2S4AE6npChSq6J44ODP0YnZPO
         RGbJaffGsZUGbn4t0mlJZXxpMtd41bXF6GZV2T4ntpHOe7BJQxkpA5oBQoNST1H6m+0c
         xv5A==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: stgt@vger.kernel.org

Hello,

We are encountering a backup problem using tgtd.

Though, we believe it to be a kernel problem, you might have
encountered such an issue before and have some lights about it.

We backup a Linux RHEL 6 system using an iSCSI link connected to an
usb3 drive on another system. The problem is that the backup process
on the source system is writing too fast for the network to send data.

The number of dirty pages of unwritten data keep rising on the source
system because of the network bottleneck.This keep growing until the
source system freeze because of too much allocated memory.

We believe it=E2=80=99s a kernel issue which has not been fixed even in=
 the
most recent kernel versions (3.3). To fix that, it would require a max
dirty pages per device kernel parameter which is not available at this
moment.

Have you heard of any =C2=AB strategy =C2=BB which we could use as a wo=
rkaround
for this specific problem ?

Thanks for your help,
