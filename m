From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in
 release
Date: Thu, 21 Jun 2018 06:03:27 -0700
Message-ID: <20180621130327.GB24925@infradead.org>
References: <20180615152335.208202-1-jannh@google.com>
 <20180615164009.GD30522@ZenIV.linux.org.uk>
 <90063ef3-68fa-e983-9b47-838e6076b0f4@interlog.com>
 <813e817b-bb2f-4a47-6225-9e39f19be278@kernel.dk>
 <20180621123431.GA558@infradead.org>
 <CAG48ez3BWeZkW5XG814K4o7p0KWXVm9Gpzh2rTthNei=4fhH-A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9IXDWkAXBmF71F26ka05Xhv15UCQmVpOrP73Kt2mfHk=; b=BcrTgjsfSzRN7ycJu/L75BmXq
        cjgMs4QrXp8ygBEr6TZ3AfU+71Q2+6hmZP6wjPLEGuuH601qRAw4sim51qnPAJMXgUfXD/cr97fQ0
        PX5TMaSXPHFbaC6S1f1QlBulVS4N57YL3hPYplDUVuU3lsrSN8wC5g+xiXVv+iuIVdmU/8Lx/7EXp
        AMmfSQT9EMRfQ62tTpJeTVx4nUspt2UI6rGWJUom0A0BXYZTEbX66CGtSJgaBPwzKAWexcDzT80dT
        bwhISU0jVI58EhdSdKhRR7o5FM25xb2pRz7Ile1mornUF3e3RA6Xrva10Q6P7zjq1JN7UQvXXkvFo
    
Content-Disposition: inline
In-Reply-To: <CAG48ez3BWeZkW5XG814K4o7p0KWXVm9Gpzh2rTthNei=4fhH-A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jann Horn <jannh@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, dgilbert@interlog.com, Al Viro <viro@zeniv.linux.org.uk>, fujita.tomonori@lab.ntt.co.jp, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, stgt@vger.kernel.org

On Thu, Jun 21, 2018 at 02:51:16PM +0200, Jann Horn wrote:
> In the package https://packages.debian.org/stretch/tgt:
>   https://sources.debian.org/src/tgt/1:1.0.73-1/usr/bs_sg.c/?hl=131#L131
>   https://sources.debian.org/src/tgt/1:1.0.73-1/usr/bs_sg.c/?hl=236#L236

This is for real, although it is an optional case in an optional plug
in, so I'm not sure if any one actually uses bsg read/write with it
for real.

The usual aspects added. (the question is if bsg read/write support
is actually used in real life or can be removed)

> In the package https://packages.debian.org/stretch/sg3-utils:
>   https://sources.debian.org/src/sg3-utils/1.42-2/examples/bsg_queue_tst.c/?hl=60#L60

This is just example code.
