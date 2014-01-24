From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: segfault in tgtd
Date: Fri, 24 Jan 2014 14:27:37 +0900 (JST)
Message-ID: <20140124.142737.1568838937885766578.fujita.tomonori@lab.ntt.co.jp>
References: <CAMHDSMzjsJWtkkK0NBm48+iukgKLzDiB-j22viuJ=GwnrCXqJA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAMHDSMzjsJWtkkK0NBm48+iukgKLzDiB-j22viuJ=GwnrCXqJA@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: alban@fonleap.com
Cc: stgt@vger.kernel.org

On Tue, 21 Jan 2014 11:29:26 +0000
Alban Rrustemi <alban@fonleap.com> wrote:

> We've been evaluating the tgt version 1.0.38 on a 64bit Linux kernel
> (version 3.2.0-39-generic) in an Ubuntu installation. Occasionally, we
> get a segmentation fault in tgtd and it's not clear what went wrong or
> how to get more information in order to investigate the root cause.
> 
> All I get to see is lines like the ones below in the kernel log:
> Jan 21 07:03:40 test-machine kernel: [2744939.501604] tgtd[12887]:
> segfault at 0 ip 00000000004076aa sp 00007fffe0bcfa40 error 6 in
> tgtd[400000+43000]
> Jan 21 07:04:04 test-machine kernel: [2744963.554504] init: tgt main
> process (12887) killed by SEGV signal
> 
> Is there any documentation out there or any other type of information
> on some tgt diagnostics I could use to investigate this?

Unfortunately, I can't tell much with the above. Did you see anything
in syslog? Anything (workload, etc) changed right before the crash?
