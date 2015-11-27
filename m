From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Handle access of a target that has been removed
Date: Fri, 27 Nov 2015 14:56:59 +0900 (JST)
Message-ID: <20151127.145659.1568838937885758741.fujita.tomonori@lab.ntt.co.jp>
References: <20151028.142854.1568838937885774624.fujita.tomonori@lab.ntt.co.jp>
	<564636E6.1020801@suse.com>
	<56569346.6090804@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <56569346.6090804@suse.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lduncan@suse.com
Cc: stgt@vger.kernel.org

Hi,

On Wed, 25 Nov 2015 21:06:14 -0800
Lee Duncan <lduncan@suse.com> wrote:

> I thought that you might like to know that I finally tested this. I

Yeah, thanks a lot for the input!

> created a test bed where I randomly created and deleted 4 target nodes
> by changing the configuration files then running "tgt-admin --update
> ALL -f".
> 
> At the same time, I randomly attempted to log out of then back into
> all 4 targets.
> 
> It only takes a minute to hit the case the patch I sent fixes, where
> target_find_by_name() dies when tgt_targetname() returns an unexpected
> NULL. It was nice to validate that the patch was actually needed.
> 
> You might remember, though, that I was worried that other places where
> tgt_targetname() where used might need to check for NULL as well. So
> I tested for that.
> 
> Surprisingly, none of the other places that uses tgt_targetname() ever
> got NULL back. I tested for several hours. So either I just didn't hit
> the corner case needed to tickle such a bug, or that just doesn't
> happen. I would love to investigate further, but I may not have the
> time to get to it soon. In the mean time, it appears we are in good
> shape.

I see. I try to think more.
