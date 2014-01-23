From: Artyom Pervukhin <artyom@evasive.ru>
Subject: tgtadm/tgtd management issue: buffer size truncated sometimes
Date: Thu, 23 Jan 2014 16:51:17 +0400
Message-ID: <96DAABF5-8A43-4969-8708-5751A053FBEE@evasive.ru>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

I cannot find any information regarding practical limits on amount of iSCSI targets supported by tgtd. Trying to use tgtd with many targets (hundreds of, say 400-500), I've experienced some issues in its management interface (tgtadm <-> tgtd).

Each target has only one disk attached, the greater target count is, the higher probability of experiencing the bug. Sometimes command showing all targets returns incomplete output, as if it was randomly stripped.

# tgtadm -C 0 --op show --mode target | grep -c ^Target                                                                                                   
301
# tgtadm -C 0 --op show --mode target | grep -c ^Target                                                                                                   
300

# tgtadm -C 0 --op show --mode target | wc -c                                                                                                             
317914
# tgtadm -C 0 --op show --mode target | wc -c                                                                                                             
316690
# tgtadm -C 0 --op show --mode target | wc -c                                                                                                             
317914
# tgtadm -C 0 --op show --mode target | wc -c                                                                                                             
310695

The closest description to this bug I've managed to find is this thread: http://lists.wpkg.org/pipermail/stgt/2012-July/005324.html (op had the same symptoms).

I was able to reproduce this bug on tgt 1.0.4 (Debian Squeeze), 1.0.17 (Debian Wheezy), 1.0.43 (latest so far). Tested on linux kernels 2.6.32, 3.2.0 (both amd64).

