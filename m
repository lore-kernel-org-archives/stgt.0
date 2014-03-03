From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tgt backend driver for GlusterFS
Date: Mon, 03 Mar 2014 21:42:46 +0900 (JST)
Message-ID: <20140303.214246.1682271453232725247.fujita.tomonori@lab.ntt.co.jp>
References: <774404432.9632772.1393845388741.JavaMail.zimbra@redhat.com>
	<310162749.9636997.1393846422793.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <310162749.9636997.1393846422793.JavaMail.zimbra@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dlambrig@redhat.com
Cc: stgt@vger.kernel.org

Hi,

On Mon, 3 Mar 2014 06:33:42 -0500 (EST)
Dan Lambright <dlambrig@redhat.com> wrote:

> I've created a new backend driver for GlusterFS [1] based off
> bs_rbd.c and bs_rdwr.c. I think

Sounds great. I'm very happy to merge your patch if you submit the
patch in the following way:

https://www.kernel.org/doc/Documentation/SubmittingPatches

In short,

1. please your patch with your Signed-off-by.
2. please verify your patch with tgt/scripts/checkpatch.pl (your patch
has several coding style problems).

Thanks!
