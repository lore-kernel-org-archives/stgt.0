From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH v3] tgtd: refresh ready fds of event loop after event
 deletion
Date: Tue, 4 Mar 2014 17:14:41 +0200
Message-ID: <5315EDE1.80103@mellanox.com>
References: <1393391602-6801-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1393391602-6801-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Roi Dayan <roid@mellanox.com>

On 26/02/2014 07:13, Hitoshi Mitake wrote:
> For example, we can produce segfault of tgtd under heavy load. Below
> is a backtrace obtained from the core file:
>   (gdb) bt
>   #0  0x0000000000000000 in ?? ()
>   #1  0x0000000000411419 in event_loop () at tgtd.c:414
>   #2  0x0000000000411b65 in main (argc=<value optimized out>, argv=<value optimized out>) at tgtd.c:591
>
> To be honest, I still don't find an event handler which calls
> tgt_event_del() for other fds. But with this modification, the above
> segfault is avoided. The change seems to be effective.

Just want to make sure I follow --- you do have a way to reproduce the 
bug, but from code inspection you didn't find an event handler in tgt 
which calls  tgt_event_del() for "other" fds which is the trigger for 
the bug, right?

Can you please provide the steps to reproduce the bug?

Or.
