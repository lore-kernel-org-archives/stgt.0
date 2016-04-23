From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] fix errno use after strtoull
Date: Sun, 24 Apr 2016 08:46:35 +0900 (JST)
Message-ID: <20160424.084635.2201605309636487716.tomof@acm.org>
References: <20160421162240.GA15513@foudres>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20160421162240.GA15513@foudres>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ryan.harper@canonical.com
Cc: stgt@vger.kernel.org, stsp@users.sourceforge.net

On Thu, 21 Apr 2016 11:22:40 -0500
Ryan Harper <ryan.harper@canonical.com> wrote:

> From 3f3991ee3345f9728928711f6be7a0020568faf6 Mon Sep 17 00:00:00 2001
> From: Stas Sergeev <stsp@users.sourceforge.net>
> Date: Thu, 18 Feb 2016 18:35:23 +0300
> Subject: [PATCH] fix errno check
> 
> errno can only be checked if the return value indicates an error.
> The result of this bug is the following:
> 
>  ./tgtd -d 1
> -d argument value '1' invalid
> Try `tgtd --help' for more information.
> 
> As can be seen, it rejects the valid parameter because errno just
> happens to be non-zero.
> ---
>  usr/util.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks!
