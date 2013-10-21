From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] Several fixes for tgt-admin and rbd modifications
Date: Mon, 21 Oct 2013 10:42:17 +0900
Message-ID: <20131021101831D.fujita.tomonori@lab.ntt.co.jp>
References: <1381812477-5917-1-git-send-email-dan.mick@inktank.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1381812477-5917-1-git-send-email-dan.mick@inktank.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dan.mick@inktank.com
Cc: stgt@vger.kernel.org

On Mon, 14 Oct 2013 21:47:54 -0700
Dan Mick <dan.mick@inktank.com> wrote:

> In revisiting the patch for tgt-admin, I found a shell dependency
> that was masking my testing results, and an optimization for 
> the check_device function; also, this patch avoids a few
> bs_rdwr-specific checks when used with bs_rbd.  So in a sense
> this is version 2 of the recent tgt-admin patch, now with more
> goodness.
> 
> Dan Mick (3):
>   tgt-admin: avoid zsh-specific syntax in system() call
>   tgt-admin: abort check_device() early if -e returns false
>   tgt-admin: avoid in-use and backing_store existence tests for rbd
> 
>  scripts/tgt-admin |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Looks good. Applied, thanks.
