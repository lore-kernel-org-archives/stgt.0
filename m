From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: fix a compiler warning due to an unused
 label
Date: Sat, 11 Oct 2014 16:01:08 +0900 (JST)
Message-ID: <20141011.160108.1568838937885760502.fujita.tomonori@lab.ntt.co.jp>
References: <1413000802-11886-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1413000802-11886-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Sat, 11 Oct 2014 13:13:22 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> This gets rid of the following gcc warning in sd_open function by
> removing the unused label 'retry':
> 
>  bs_sheepdog.c: In function 'sd_open':
>  bs_sheepdog.c:1199:1: warning: label 'retry' defined but not used [-Wunused-label]
>   retry:
>   ^
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c | 1 -
>  1 file changed, 1 deletion(-)

Applied, thanks.
