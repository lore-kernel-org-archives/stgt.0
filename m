From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: fix pthread rwlock leak in sd_io()
Date: Fri, 1 Nov 2013 09:46:18 +0900
Message-ID: <20131101091959D.fujita.tomonori@lab.ntt.co.jp>
References: <1383183087-3789-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1383183087-3789-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: mitake.hitoshi@lab.ntt.co.jp, stgt@vger.kernel.org, sheepdog@lists.wpkg.org

On Thu, 31 Oct 2013 10:31:27 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> The current sd_io function exits without unlocking pthread rwlock in
> the error path.  This fixes the leak bug.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied, thanks.
