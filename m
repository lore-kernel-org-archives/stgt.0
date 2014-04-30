From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/3] Fix race on thread shutdown causing deadlock
Date: Wed, 30 Apr 2014 23:29:06 +0900
Message-ID: <20140430231940U.fujita.tomonori@lab.ntt.co.jp>
References: <1398736282-1193-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1398736282-1193-1-git-send-email-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: agrover@redhat.com
Cc: stgt@vger.kernel.org

On Mon, 28 Apr 2014 18:51:20 -0700
Andy Grover <agrover@redhat.com> wrote:

> This patch and the next are somewhat a revert of 318e9f2, but the previous
> fix didn't quite close the race. This only happens when we create threads
> for a backstore that turns out to be invalid, which we then tear down.
> 
> See https://bugzilla.redhat.com/show_bug.cgi?id=848585 .
> 
> This is occurring because there's still a window where a thread misses
> seeing info->stop == 1 but is not yet in cond_wait so it misses the
> broadcast:
> 
> thread_close:              thread_worker_fn:
>                            info->stop is seen as 0
> info->stop = 1
> pthread_cond_broadcast     -- misses broadcast
>                            pthread_cond_wait
> pthread_join (hangs)
> 
> I believe the solution is to go back to using pthread_cancel. We can call
> it before pthread_cond_wait is called (or after) and it will do the right
> thing: pop out and exit. The only tricky bit is we need to use the
> pthread_cleanup_push mechanism to properly release info->pending_lock.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  usr/bs.c        | 25 ++++++++++++++-----------
>  usr/bs_thread.h |  2 --
>  2 files changed, 14 insertions(+), 13 deletions(-)

Thanks a lot for the fixes and detailed explanation. Surely, looks
like there is a race. The whole patchset looks good. Applied, thanks!
