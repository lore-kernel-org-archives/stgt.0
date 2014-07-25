From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_rbd: fix error assignment in if condition
Date: Fri, 25 Jul 2014 16:31:07 +0900 (JST)
Message-ID: <20140725.163107.1568838937885778732.fujita.tomonori@lab.ntt.co.jp>
References: <1406083114-28024-1-git-send-email-liangry@ucweb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1406083114-28024-1-git-send-email-liangry@ucweb.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: liangry@ucweb.com
Cc: stgt@vger.kernel.org

On Wed, 23 Jul 2014 10:38:34 +0800
Ruoyu <liangry@ucweb.com> wrote:

> The statement
> 
> if ((x == f()) < 0) {}
> 
> is strange. I think it should be
> 
> if ((x = f()) < 0) {}
> 
> For the reasone of coding style, I modify it as
> 
> x = f();
> if (x < 0) {}
> 
> Signed-off-by: Ruoyu <liangry@ucweb.com>
> ---
>  usr/bs_rbd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.
