From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Fix buffer overrun issue of lld name
Date: Tue, 10 Dec 2013 18:36:46 +0900
Message-ID: <20131210180727Q.fujita.tomonori@lab.ntt.co.jp>
References: <1386667534-2914-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1386667534-2914-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Tue, 10 Dec 2013 18:25:34 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> The string buffer of lld name in tgtadm_req struct (req->lld) will not
> be null-terminated if user specifies very long lld name for the
> argument of -L or --lld option.
> 
> This is because the lld name is copied with strncpy function and its
> size argument is the same as buffer size.  In such a case, strncpy()
> can truncate the string without appending a terminating null byte.
> 
> As a result, accesses to the lld name in mtask_execute function, for
> instance, strlen(req->lld) or eprintf("...%s\n", req->lld), can
> overrun.
> 
> This patch fixes the issue by setting a terminating null byte at the
> end of the lld name buffer before mtask_execute() uses it.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/mgmt.c |    2 ++
>  1 file changed, 2 insertions(+)

Looks good. Applied, thanks.
