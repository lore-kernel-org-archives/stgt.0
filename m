From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: ensure that vdi names and tag names are
 null-terminated
Date: Tue, 10 Dec 2013 09:47:17 +0900
Message-ID: <20131210091657U.fujita.tomonori@lab.ntt.co.jp>
References: <1386565241-9793-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1386565241-9793-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, sheepdog@lists.wpkg.org, mitake.hitoshi@lab.ntt.co.jp

On Mon,  9 Dec 2013 14:00:41 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> In the current sheepdog driver, tag names and vdi names are truncated
> to 256 bytes if they are longer than the size.
> 
> The request data will not be null-terminated if those names are
> truncated to the maximum byte size.
> 
> This implementation causes the following two issues with sheepdog:
> 
>  1) Since CLI of sheepdog (i.e. dog command) truncates tag names and
>     vdi names to 255 bytes to ensure that string buffers are
>     null-terminated, vdi lookup function of sheep daemon can fail for
>     long vdi names or long tag names due to this difference of buffer
>     termination.
> 
>  2) The absence of a null byte causes potential buffer overrun issue
>     with the sheep daemon even though we are trying to fix this sort
>     of dangerous implementation.
> 
> This patch ensures that tag names and vdi names set to the request
> buffer are both null terminated and fixes these issues.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.
