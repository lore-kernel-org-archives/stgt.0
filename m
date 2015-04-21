From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sheepdog: fine grained locking in write path
Date: Tue, 21 Apr 2015 18:47:53 +0900 (JST)
Message-ID: <20150421.184753.1568838937885752472.fujita.tomonori@lab.ntt.co.jp>
References: <1429608833-11636-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1429608833-11636-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, mitake.hitoshi@gmail.com

On Tue, 21 Apr 2015 18:33:53 +0900
Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp> wrote:

> Current sheepdog driver has a big write lock section. It harms write
> performance significantly. This patch removes a needless big write
> lock section with checking submitted requests can cause COW or
> not. The write performance can be improved significantly.
> 
> In a case of 4k rand write by fio:
>  - before: 1144 IOPS
>  - after:  19074 IOPS
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)

Applied, thanks.
