From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] tgtd: fix memory leaks at it_nexus_create()
Date: Tue, 10 Dec 2013 09:47:17 +0900
Message-ID: <20131210091717O.fujita.tomonori@lab.ntt.co.jp>
References: <1386527539-30494-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1386527539-30494-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Mon,  9 Dec 2013 03:32:19 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> The it_nexus_create function exits without freeing it_nexus_lu_info
> struct nor it_nexus struct at error paths.
> 
> This fixes the leak bugs.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/target.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Nice catch, thanks!
