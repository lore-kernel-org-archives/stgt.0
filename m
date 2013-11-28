From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: fix length modifier of eprintf in
 read_write_object()
Date: Fri, 29 Nov 2013 02:02:33 +0900
Message-ID: <20131129013433N.fujita.tomonori@lab.ntt.co.jp>
References: <1385655486-11722-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1385655486-11722-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, mitake.hitoshi@lab.ntt.co.jp

On Fri, 29 Nov 2013 01:18:06 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> On 32-bit environments, the sheepdog driver causes the following
> compile warning because "%lx" is used for uint64_t type variables:
> 
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2
> -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC
> -DTGT_VERSION=\"\" -DBSDIR=\"/lib/tgt/backing-store\" bs_sheepdog.c -o
> bs_sheepdog.o
> bs_sheepdog.c: In function 'read_write_object':
> bs_sheepdog.c:682: warning: format '%lx' expects type 'long unsigned
> int', but argument 5 has type 'uint64_t'
> bs_sheepdog.c:682: warning: format '%lx' expects type 'long unsigned
> int', but argument 6 has type 'uint64_t'
> 
> This fixes the issue by using PRIx64 length modifier instead of "%lx".
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.
