From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tgtadm/tgtd management issue: buffer size truncated sometimes
Date: Fri, 24 Jan 2014 14:11:52 +0900 (JST)
Message-ID: <20140124.141152.1568838937885768338.fujita.tomonori@lab.ntt.co.jp>
References: <96DAABF5-8A43-4969-8708-5751A053FBEE@evasive.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <96DAABF5-8A43-4969-8708-5751A053FBEE@evasive.ru>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: artyom@evasive.ru
Cc: stgt@vger.kernel.org

Hi,

On Thu, 23 Jan 2014 16:51:17 +0400
Artyom Pervukhin <artyom@evasive.ru> wrote:

> I cannot find any information regarding practical limits on amount
> of iSCSI targets supported by tgtd. Trying to use tgtd with many
> targets (hundreds of, say 400-500), I've experienced some issues in
> its management interface (tgtadm <-> tgtd).

We use int for the target number. Except for that, there is no limit.


> Each target has only one disk attached, the greater target count is,
> the higher probability of experiencing the bug. Sometimes command
> showing all targets returns incomplete output, as if it was randomly
> stripped.
>
> # tgtadm -C 0 --op show --mode target | grep -c ^Target                                                                                                   
> 301
> # tgtadm -C 0 --op show --mode target | grep -c ^Target                                                                                                   
> 300
> 
> # tgtadm -C 0 --op show --mode target | wc -c                                                                                                             
> 317914
> # tgtadm -C 0 --op show --mode target | wc -c                                                                                                             
> 316690
> # tgtadm -C 0 --op show --mode target | wc -c                                                                                                             
> 317914
> # tgtadm -C 0 --op show --mode target | wc -c                                                                                                             
> 310695
> 
> The closest description to this bug I've managed to find is this thread: http://lists.wpkg.org/pipermail/stgt/2012-July/005324.html (op had the same symptoms).
> 
> I was able to reproduce this bug on tgt 1.0.4 (Debian Squeeze), 1.0.17 (Debian Wheezy), 1.0.43 (latest so far). Tested on linux kernels 2.6.32, 3.2.0 (both amd64).
> 

Hmm, I think that the bug on the thread was fixed. I set up 600
targets with the latest code and doesn't hit such issue.

root@rose:~# tgtadm --op show --mode target|grep -c ^Target
600
root@rose:~# tgtadm --op show --mode target|grep -c ^Target
600
root@rose:~# tgtadm --op show --mode target|wc -c
688313
root@rose:~# tgtadm --op show --mode target|wc -c
