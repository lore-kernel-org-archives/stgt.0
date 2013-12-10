From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] util.h: correct range check of str_to_int_gt() and
 str_to_int_lt()
Date: Tue, 10 Dec 2013 15:17:21 +0900
Message-ID: <20131210144807I.fujita.tomonori@lab.ntt.co.jp>
References: <1386650987-15110-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1386650987-15110-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Tue, 10 Dec 2013 13:49:47 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> The range checks of str_to_int_gt() and str_to_int_lt() are not
> implemented literally.  The current definitions fail to reject a
> marginal value.
> 
> Due to this difference, tgtd accepts option "-t 0" without an error,
> which overrides nr_iothreads to 0 and causes clients to hang.
> 
> This corrects str_to_int_gt()/str_to_int_lt() and prevents the issue.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/util.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Nice catch, thanks!
