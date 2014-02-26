From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] tgtd: let event_need_refresh be a static variable
Date: Wed, 26 Feb 2014 15:03:52 +0900
Message-ID: <20140226150118R.fujita.tomonori@lab.ntt.co.jp>
References: <1393392915-7682-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1393392915-7682-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, mitake.hitoshi@gmail.com

On Wed, 26 Feb 2014 14:35:15 +0900
Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp> wrote:

> The variable don't have to be visible from other source files.
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/tgtd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
