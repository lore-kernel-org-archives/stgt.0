From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: add missing initialization of read data
 length
Date: Thu, 19 Dec 2013 22:48:30 +0900
Message-ID: <20131219221707S.fujita.tomonori@lab.ntt.co.jp>
References: <1387432018-746-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1387432018-746-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, sheepdog@lists.wpkg.org, mitake.hitoshi@lab.ntt.co.jp

On Thu, 19 Dec 2013 14:46:58 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> In the sheepdog driver, the read data length argument of do_req
> function is not initialized by some caller functions such as
> sd_sync(), sd_close(), and create_branch().
> 
> This patch adds those missing initializations to prevent uncertain
> behavior in do_req() and fixes the following warning of valgrind:
> 
>  ==1885== Conditional jump or move depends on uninitialised value(s)
>  ==1885==    at 0x425994: do_req (bs_sheepdog.c:598)
>  ==1885==    by 0x426A06: bs_sheepdog_close (bs_sheepdog.c:1100)
>  ==1885==    by 0x4142B4: tgt_device_destroy (target.c:705)
>  ==1885==    by 0x412335: tgt_mgmt (mgmt.c:222)
>  ==1885==    by 0x412776: mtask_handler (mgmt.c:494)
>  ==1885==    by 0x4106A8: event_loop (tgtd.c:411)
>  ==1885==    by 0x410D64: main (tgtd.c:583)
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Applied, thanks.
