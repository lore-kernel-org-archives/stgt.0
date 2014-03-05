From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: spc: Support NAA IEEE Registered Extended field in VPD page 0x83
Date: Wed, 5 Mar 2014 22:52:57 +0200
Message-ID: <CAJZOPZJ50ii3N5OFWKgcOLHH4__D_i4axxyTCOOKwwaoUZ+rwQ@mail.gmail.com>
References: <1393332853-12965-1-git-send-email-ogerlitz@mellanox.com>
	<5314B874.40408@mellanox.com>
	<20140304.072817.1305564732068178449.fujita.tomonori@lab.ntt.co.jp>
	<53159377.2040209@mellanox.com>
	<1141D71E19287C49B3013E3E675E0DCE23615C74@SUSHDC8002.TD.TERADATA.COM>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=dITGozFRcdqxhSEpeE298OQ7qh7vFutowBtKBA4MGWo=;
        b=sZYbEx06LCN2D6ic/z6kciVMQ5pStFFswJ3USGn7tI/mBAg8jk/ZwZVxu4LB1+dGjg
         eAWTY1/iyL5F/YtqDBUGfpvvFzyaxB2xwpZ1WrPyQNtxmJTjDrULED7jlgMjyKDhJjpA
         wvMRHeq2im8cvFPqZpWNdfY7zHwaJtCwpOE4wncOf7z0PIv6U0/gc270aRifo4YcEKzq
         VRWyYyeUxAgvDg5CVUin4tVkylRuQZo5vosiWFggpJB/YSsIGENTr9I5vF591gdoGQxk
         6wths+kqaSQBD8btUl1hVMkhkWvTJGwn2CEWEHCs64qP2K83Q3Hoxa7Dsnh/pAvuWQXD
         i4rA==
In-Reply-To: <1141D71E19287C49B3013E3E675E0DCE23615C74@SUSHDC8002.TD.TERADATA.COM>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, "stgt@vger.kernel.org" <stgt@vger.kernel.org>, "Cullison, Dennis" <Dennis.Cullison@teradata.com>

On Tue, Mar 4, 2014 at 7:08 PM, Cullison, Dennis
<Dennis.Cullison@teradata.com> wrote:

> Page 755, Section 7.8.6.6.5 "NAA IEEE Registered Extended designation format" from T10 document 'spc4r36q.pdf'.

Hi Tomo,

So this helps?

Or.
