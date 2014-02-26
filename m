From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] tgtd: fix internal error of __inaccount_bind()
Date: Wed, 26 Feb 2014 17:11:34 +0900 (JST)
Message-ID: <20140226.171134.1568838937885763670.fujita.tomonori@lab.ntt.co.jp>
References: <1393224206-21585-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1393224206-21585-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Mon, 24 Feb 2014 15:43:26 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> When trying to bind 32 accounts to the same target, tgtadm outputs
> "unknown error" and exits returing status code 22 (EINVAL).
> 
> This is because __inaccount_bind() function of tgtd does not increment
> target->account.nr_inaccount when it doubles maximum number of
> accounts for the target, and therefore it tries to allocate an aid
> slot on target->account.in_aids[] array even though no free aid slot
> is available there.
> 
> This fixes the bug.
> 
> Reported-by: Satoshi Yoshida <yoshida.satoshi@po.ntts.co.jp>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/target.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good, thanks a lot!
