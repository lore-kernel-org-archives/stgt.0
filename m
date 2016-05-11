From: Alex Feng <li.feng@oracle.com>
Subject: Re: [PATCH] fix timerfd support
Date: Wed, 11 May 2016 15:37:44 +0800
Message-ID: <5732E148.2030601@oracle.com>
References: <1462265138-39308-1-git-send-email-li.feng@oracle.com>
 <20160510.083528.1682271453232720677.tomof@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20160510.083528.1682271453232720677.tomof@acm.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: FUJITA Tomonori <tomof@acm.org>
Cc: stgt@vger.kernel.org, lifeng1519@gmail.com

Hi Tomonori ,

Thanks for your response.
Please see my response inline.

On 2016/5/10 7:35, FUJITA Tomonori wrote:
> On Tue,  3 May 2016 16:45:38 +0800
> Feng Li <li.feng@oracle.com> wrote:
>
>> From: vonnyfly <lifeng1519@gmail.com>
>>
>> There are some exceptions when checking features in Makefile.
>> In my debian, timerfd.h path is not '/usr/include/sys/timerfd.h'.
>>
>>   $ find /usr/include -name "timerfd.h" | head -n1
>>   /usr/include/x86_64-linux-gnu/sys/timerfd.h
>>
>> In my raspberrypi, the path is also not here.
>>
>> So, it will not enable timerfd, even though it supports actually.
>> When I enable it after fix.  I have seen error logs.
>> "Failed to write to pipe".
>>
>>  From the code, we could know in add_work, it calls work_timer_schedule_evt.
>> work_timer_schedule_evt will call write(timer_fd[1], ...), then it will print error log,
>> because timer_fd[1] == -1.
> Looks like with timerfd enabled, work_timer_schedule_evt() isn't
> called. add_work() is always called with the non-zero second
> argument. How you hit the above bug?
The easiest way to see this log is to replace 'add_work(&nop_work, 1);' 
to 'add_work(&nop_work, 0);'.
Like this:

--- a/usr/iscsi/iscsi_tcp.c
+++ b/usr/iscsi/iscsi_tcp.c
@@ -438,7 +438,7 @@ static int iscsi_tcp_init(void)

         nop_work.func = iscsi_tcp_nop_work_handler;
         nop_work.data = &nop_work;
-       add_work(&nop_work, 1);
+       add_work(&nop_work, 0);

tgtd: work_timer_schedule_evt(69) Failed to write to pipe, Bad file 
descriptor

>
>> When enable timerfd support, makefile check incorrectly.
>> work_timer_schedule_evt should check support of timerfd.
>>
>> Signed-off-by: vonnyfly <lifeng1519@gmail.com>
>> ---
>>   usr/Makefile | 2 +-
>>   usr/work.c   | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
> Applied, thanks.
