From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] tgtadm: Correct mode names in the option error
 message
Date: Sat, 18 Jan 2014 15:22:59 +0900
Message-ID: <20140118144930U.fujita.tomonori@lab.ntt.co.jp>
References: <52DA10B3.7010309@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <52DA10B3.7010309@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zhangyanfei.yes@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org, zhangyanfei@cn.fujitsu.com

On Sat, 18 Jan 2014 13:27:15 +0800
Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> When an error option is specified for some mode and operation,
> tgtadm outputs an error message which contains the mode name.
> But some of the mode names are obviously wrong so the patch fixes
> them.
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  usr/tgtadm.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)

Both look good. Applied, thanks!
