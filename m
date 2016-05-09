From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] fix timerfd support
Date: Tue, 10 May 2016 08:35:28 +0900 (JST)
Message-ID: <20160510.083528.1682271453232720677.tomof@acm.org>
References: <1462265138-39308-1-git-send-email-li.feng@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1462265138-39308-1-git-send-email-li.feng@oracle.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: li.feng@oracle.com
Cc: stgt@vger.kernel.org, lifeng1519@gmail.com

On Tue,  3 May 2016 16:45:38 +0800
Feng Li <li.feng@oracle.com> wrote:

> From: vonnyfly <lifeng1519@gmail.com>
> 
> There are some exceptions when checking features in Makefile.
> In my debian, timerfd.h path is not '/usr/include/sys/timerfd.h'.
> 
>  $ find /usr/include -name "timerfd.h" | head -n1
>  /usr/include/x86_64-linux-gnu/sys/timerfd.h
> 
> In my raspberrypi, the path is also not here.
> 
> So, it will not enable timerfd, even though it supports actually.
> When I enable it after fix.  I have seen error logs.
> "Failed to write to pipe".
> 
> From the code, we could know in add_work, it calls work_timer_schedule_evt.
> work_timer_schedule_evt will call write(timer_fd[1], ...), then it will print error log,
> because timer_fd[1] == -1.

Looks like with timerfd enabled, work_timer_schedule_evt() isn't
called. add_work() is always called with the non-zero second
argument. How you hit the above bug?

> When enable timerfd support, makefile check incorrectly.
> work_timer_schedule_evt should check support of timerfd.
> 
> Signed-off-by: vonnyfly <lifeng1519@gmail.com>
> ---
>  usr/Makefile | 2 +-
>  usr/work.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.
