From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sheepdog: fix to clear create flag when reloading inode
Date: Wed, 05 Nov 2014 16:21:33 +0900 (JST)
Message-ID: <20141105.162133.1305564732068185209.fujita.tomonori@lab.ntt.co.jp>
References: <1415165480-15541-1-git-send-email-yamada.hideki@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1415165480-15541-1-git-send-email-yamada.hideki@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: yamada.hideki@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Wed,  5 Nov 2014 14:31:20 +0900
YAMADA Hideki <yamada.hideki@lab.ntt.co.jp> wrote:

> This bug causes duplicated CREATE_AND_WRITE requests
> in case of iSCSI multipath failover.
> 
> Signed-off-by: YAMADA Hideki <yamada.hideki@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Applied, thanks.
