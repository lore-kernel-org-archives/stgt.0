From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] tgtd: fix memory access overrun on array of pthread_t
 type data
Date: Thu, 19 Dec 2013 22:48:31 +0900
Message-ID: <20131219221731M.fujita.tomonori@lab.ntt.co.jp>
References: <1387446989-19343-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1387446989-19343-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Thu, 19 Dec 2013 18:56:29 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> bs_thread_close function accesses memory outside allocated region
> because it reads each array element with an index before confirming
> that the index is within the range of the array.
> 
> This fixes the issue and gets rid of the following warning detected by
> valgrind:
> 
>  ==10848== Invalid read of size 8
>  ==10848==    at 0x42AF91: bs_thread_close (bs.c:461)
>  ==10848==    by 0x42BD94: bs_sheepdog_exit (bs_sheepdog.c:1275)
>  ==10848==    by 0x4183B7: tgt_device_destroy (target.c:739)
>  ==10848==    by 0x41608D: mtask_received (mgmt.c:251)
>  ==10848==    by 0x4164CB: mtask_recv_send_handler (mgmt.c:670)
>  ==10848==    by 0x4141F8: event_loop (tgtd.c:428)
>  ==10848==    by 0x414899: main (tgtd.c:611)
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/bs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks a lot!
