From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: fix a descriptor leak in
 connect_to_sdog_tcp()
Date: Tue, 17 Dec 2013 06:45:26 +0900 (JST)
Message-ID: <20131217.064526.1568838937885771271.fujita.tomonori@lab.ntt.co.jp>
References: <1387209165-14668-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1387209165-14668-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, mitake.hitoshi@lab.ntt.co.jp, sheepdog@lists.wpkg.org

On Tue, 17 Dec 2013 00:52:45 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> When connect_to_sdoc_tcp function failed to connect a socket due to an
> error other than EINTR, it doesn't free the socket file descriptor.
> 
> This fixes the leak bug.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.
