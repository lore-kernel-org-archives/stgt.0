From: Alban Rrustemi <alban@fonleap.com>
Subject: Re: segfault in tgtd
Date: Fri, 24 Jan 2014 11:44:01 +0000
Message-ID: <CAMHDSMwHUTp_ixGJ6DXqRC2wZM_xLcpoxCUTj44fwVN9=1mQow@mail.gmail.com>
References: <CAMHDSMzjsJWtkkK0NBm48+iukgKLzDiB-j22viuJ=GwnrCXqJA@mail.gmail.com>
	<20140124.142737.1568838937885766578.fujita.tomonori@lab.ntt.co.jp>
	<20140124.175852.474517972.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fonleap.com; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=JQdqQ8vyJq+7pmCO+9pRgvekFuP25ooQHhDkPyWJB3g=;
        b=FaYziLmLJJ/usuzJB3jCrGhsZEFVH0vXxfkntJ2CuYJ3Yz/hViuHlV+BVPSJKyUs3l
         Zek8YoF7PnSuedYWOOU6ISml3+Ca0U4GPAPQuEga3knvetHkm+wt1v37RjJhss0Mwb60
         /9Exrfr32pOZf6tVxxZlgXHB5scAsqbliod9k=
In-Reply-To: <20140124.175852.474517972.konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: fujita.tomonori@lab.ntt.co.jp, stgt <stgt@vger.kernel.org>

Hi Fujita, Ryusuke,

I can't find any core files anywhere. On the other hand, syslog reports this:

Jan 24 15:27:25 test-machine tgtd: abort_task_set(1325) found 0 0
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found fd1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found fc1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found fb1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found fa1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found f91b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found f81b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found f71b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found f61b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found f51b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found f41b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found f31b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found f21b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found f11b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found f01b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found ef1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found ee1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found ed1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found ec1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found eb1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found ea1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found e91b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found e81b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found e71b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found e61b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found e51b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found e41b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found e31b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found e11b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found e01b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found df1b0000 6
Jan 24 15:27:25 test-machine tgtd: abort_cmd(1301) found d61b0000 6
Jan 24 15:27:45 test-machine tgtd: conn_close(103) connection closed,
0xed3ec0 26
Jan 24 15:27:45 test-machine tgtd: conn_close(109) sesson 0xdda890 1
Jan 24 15:27:48 test-machine tgtd: tgt_event_modify(241) Cannot find event 11
Jan 24 15:27:48 test-machine tgtd: iscsi_event_modify(557)
tgt_event_modify failed
Jan 24 15:27:53 test-machine tgtd: tgt_event_modify(241) Cannot find event 11
Jan 24 15:27:53 test-machine tgtd: iscsi_event_modify(557)
tgt_event_modify failed
Jan 24 15:27:58 test-machine tgtd: tgt_event_modify(241) Cannot find event 11
Jan 24 15:27:58 test-machine tgtd: iscsi_event_modify(557)
tgt_event_modify failed
Jan 24 15:28:03 test-machine tgtd: tgt_event_modify(241) Cannot find event 11
Jan 24 15:28:03 test-machine tgtd: iscsi_event_modify(557)
tgt_event_modify failed
Jan 24 15:28:05 test-machine tgtd: conn_close(92) already closed 0xed3ec0 25
Jan 24 15:28:08 test-machine tgtd: tgt_event_modify(241) Cannot find event 11
Jan 24 15:28:08 test-machine tgtd: iscsi_event_modify(557)
tgt_event_modify failed
Jan 24 15:28:13 test-machine tgtd: iscsi_event_modify(557)
tgt_event_modify failed
Jan 24 15:28:18 test-machine tgtd: iscsi_tcp_nop_work_handler(110) tcp
connection timed out after 6 failed NOP-OUT
Jan 24 15:28:24 test-machine tgtd: tgtd logger exits abnormally, pid:3794
Jan 24 15:28:24 test-machine kernel: [3033879.644595] tgtd[3792]:
segfault at 0 ip 00000000004076aa sp 00007fffdee18b10 error 6 in
tgtd[400000+43000]
Jan 24 15:29:26 test-machine kernel: [3033940.814673] init: tgt main
process (3792) killed by SEGV signal
Jan 24 15:29:26 test-machine kernel: [3033940.814709] init: tgt main
process ended, respawning
Jan 24 15:29:26 test-machine tgtd: semkey 0x610f435c
Jan 24 15:29:26 test-machine tgtd: tgtd daemon started, pid:15001
Jan 24 15:29:26 test-machine tgtd: tgtd logger started, pid:15003 debug:0
Jan 24 15:29:27 test-machine tgtd: iser_ib_init(3349) Failed to
initialize RDMA; load kernel modules?
Jan 24 15:29:27 test-machine tgtd: work_timer_start(150) use signal
based scheduler
Jan 24 15:29:27 test-machine tgtd: bs_init(316) use signalfd notification

I should point out that after iSCSI targets are created the following
commands are executed:
sudo tgtadm --op update --mode target --tid 1 -n nop_count -v 6
sudo tgtadm --op update --mode target --tid 1 -n nop_interval -v 5

Thanks for your help.

Alban


On Fri, Jan 24, 2014 at 8:58 AM, Ryusuke Konishi
<konishi.ryusuke@lab.ntt.co.jp> wrote:
> Hi Alban,
> On Fri, 24 Jan 2014 14:27:37 +0900 (JST), FUJITA Tomonori wrote:
>> On Tue, 21 Jan 2014 11:29:26 +0000
>> Alban Rrustemi <alban@fonleap.com> wrote:
>>
>>> We've been evaluating the tgt version 1.0.38 on a 64bit Linux kernel
>>> (version 3.2.0-39-generic) in an Ubuntu installation. Occasionally, we
>>> get a segmentation fault in tgtd and it's not clear what went wrong or
>>> how to get more information in order to investigate the root cause.
>>>
>>> All I get to see is lines like the ones below in the kernel log:
>>> Jan 21 07:03:40 test-machine kernel: [2744939.501604] tgtd[12887]:
>>> segfault at 0 ip 00000000004076aa sp 00007fffe0bcfa40 error 6 in
>>> tgtd[400000+43000]
>>> Jan 21 07:04:04 test-machine kernel: [2744963.554504] init: tgt main
>>> process (12887) killed by SEGV signal
>>>
>>> Is there any documentation out there or any other type of information
>>> on some tgt diagnostics I could use to investigate this?
>>
>> Unfortunately, I can't tell much with the above. Did you see anything
>> in syslog? Anything (workload, etc) changed right before the crash?
>
> Was there a core file in the root directory or at your home directory
> ?
>
> If it exists, you can get backtrace of the segmentation fault with
> gdb, and it may give very helpful information to narrow down the root
> cause of the problem.
>
> Usually, we use gdb for this purpose as follows:
>
>  # gdb tgtd /core.12345
>   ...
>  (gdb) bt
>
> You may need to install *-dbg package if your tgt has no symbol
> information.
>
> For more details, please see instructions described in the distro
> sites like below:
>
>  [1] https://wiki.ubuntu.com/Backtrace
>  [2] https://wiki.ubuntu.com/DebuggingProcedures
>
>
> Regards,
> Ryusuke Konishi



-- 
Dr Alban Rrustemi
Co-founder and Director, Fonleap Ltd
http://www.fonleap.com
