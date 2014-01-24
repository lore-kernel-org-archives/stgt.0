From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: segfault in tgtd
Date: Fri, 24 Jan 2014 17:58:52 +0900 (JST)
Message-ID: <20140124.175852.474517972.konishi.ryusuke@lab.ntt.co.jp>
References: <CAMHDSMzjsJWtkkK0NBm48+iukgKLzDiB-j22viuJ=GwnrCXqJA@mail.gmail.com>
	<20140124.142737.1568838937885766578.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20140124.142737.1568838937885766578.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: alban@fonleap.com
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org

Hi Alban,
On Fri, 24 Jan 2014 14:27:37 +0900 (JST), FUJITA Tomonori wrote:
> On Tue, 21 Jan 2014 11:29:26 +0000
> Alban Rrustemi <alban@fonleap.com> wrote:
> 
>> We've been evaluating the tgt version 1.0.38 on a 64bit Linux kernel
>> (version 3.2.0-39-generic) in an Ubuntu installation. Occasionally, we
>> get a segmentation fault in tgtd and it's not clear what went wrong or
>> how to get more information in order to investigate the root cause.
>> 
>> All I get to see is lines like the ones below in the kernel log:
>> Jan 21 07:03:40 test-machine kernel: [2744939.501604] tgtd[12887]:
>> segfault at 0 ip 00000000004076aa sp 00007fffe0bcfa40 error 6 in
>> tgtd[400000+43000]
>> Jan 21 07:04:04 test-machine kernel: [2744963.554504] init: tgt main
>> process (12887) killed by SEGV signal
>> 
>> Is there any documentation out there or any other type of information
>> on some tgt diagnostics I could use to investigate this?
> 
> Unfortunately, I can't tell much with the above. Did you see anything
> in syslog? Anything (workload, etc) changed right before the crash?

Was there a core file in the root directory or at your home directory
?

If it exists, you can get backtrace of the segmentation fault with
gdb, and it may give very helpful information to narrow down the root
cause of the problem.

Usually, we use gdb for this purpose as follows:

 # gdb tgtd /core.12345
  ...
 (gdb) bt

You may need to install *-dbg package if your tgt has no symbol
information.

For more details, please see instructions described in the distro
sites like below:

 [1] https://wiki.ubuntu.com/Backtrace 
 [2] https://wiki.ubuntu.com/DebuggingProcedures


Regards,
Ryusuke Konishi
