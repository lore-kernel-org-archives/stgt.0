From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: fix an unsafe strncpy() call
Date: Mon, 25 Nov 2013 04:29:57 +0900
Message-ID: <20131125024655B.fujita.tomonori@lab.ntt.co.jp>
References: <1385302689-22999-1-git-send-email-mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1385302689-22999-1-git-send-email-mitake.hitoshi@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@gmail.com
Cc: stgt@vger.kernel.org, mitake.hitoshi@lab.ntt.co.jp

On Sun, 24 Nov 2013 23:18:09 +0900
Hitoshi Mitake <mitake.hitoshi@gmail.com> wrote:

> The strncpy() call doesn't take a null terminator into account. On
> some environment, it conflicts with __builtin___strncpy_chk() and gcc
> warns.
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.
