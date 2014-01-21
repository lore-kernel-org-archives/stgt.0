From: Alban Rrustemi <alban@fonleap.com>
Subject: segfault in tgtd
Date: Tue, 21 Jan 2014 11:29:26 +0000
Message-ID: <CAMHDSMzjsJWtkkK0NBm48+iukgKLzDiB-j22viuJ=GwnrCXqJA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fonleap.com; s=google;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=pugTzjmldSajhMrDDLHmoGGG+mWHXoAb+zZVsOMOBEE=;
        b=g/3JjXbo6S6RGu5vMQcxVnCTvgugFMBKKhj5SBCcb4yqNf01bs0SvtwtE0Bck5VxYu
         KlS0Qpz367CEqY/rWToO28OVaVURKB4wnW8/hAhwNuZ++OMhdljaYTPWXfjpsIzNMnwR
         ApRFPrKbnRCmhHk1V09IR/o5FBRg0EU+fZtvA=
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt <stgt@vger.kernel.org>

Hello there,

We've been evaluating the tgt version 1.0.38 on a 64bit Linux kernel
(version 3.2.0-39-generic) in an Ubuntu installation. Occasionally, we
get a segmentation fault in tgtd and it's not clear what went wrong or
how to get more information in order to investigate the root cause.

All I get to see is lines like the ones below in the kernel log:
Jan 21 07:03:40 test-machine kernel: [2744939.501604] tgtd[12887]:
segfault at 0 ip 00000000004076aa sp 00007fffe0bcfa40 error 6 in
tgtd[400000+43000]
Jan 21 07:04:04 test-machine kernel: [2744963.554504] init: tgt main
process (12887) killed by SEGV signal

Is there any documentation out there or any other type of information
on some tgt diagnostics I could use to investigate this?

Thanks,
Alban
