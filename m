From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: fix gcc warning at sd_open()
Date: Fri, 29 Nov 2013 02:02:32 +0900
Message-ID: <20131129013424C.fujita.tomonori@lab.ntt.co.jp>
References: <1385652486-7498-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1385652486-7498-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Fri, 29 Nov 2013 00:28:06 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> This fixes the following warning at sd_open function, which happens
> because gcc isn't always perfect with determining whether a variable
> is used uninitialized:
> 
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2
> -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC DTGT_VERSION=\"\"
> --DBSDIR=\"/lib/tgt/backing-store\" bs_sheepdog.c o bs_sheepdog.o
> bs_sheepdog.c: In function 'sd_open':
> bs_sheepdog.c:920: warning: 'saveptr' may be used uninitialized in
> this function
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.
