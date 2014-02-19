From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: Re: [PATCH v4 RFC 0/5] tgtd: offload iSCSI PDU send/recv to worker threads
Date: Wed, 19 Feb 2014 12:11:39 +0900
Message-ID: <CAE1WaK+gMw1pxrB5h+_wr1ZM+gmKV-vCTv3EOOUG++cymgFgXg@mail.gmail.com>
References: <1392376893-26106-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=CjvvhNOkbAP6r//8cPZlPSw3zGruyzapjSzrOeIvHGg=;
        b=zn0T+nVn9IhQsbCjiof6o5nFLZ+3gERO2RjMnyJg2GmxQ2QLOW8opSlyuL0WvmgRiQ
         CXtXBSOIzgmoY/GPgzItqRBBjaiO9AZFNYKHPbaagqaEU8aOWwlmU2n32OFBJxDdoQsP
         ESJDz+sc9Vr0WtPjaKxLpDLYgSPPF95y+AyOUBDj7slF9RpqHFn87azPnBs+DZBPnRu6
         ofBqSJs8FDyd2jfHPR4hAPiucKcUnZEGmoV7jvA/+tUI6WyFq02hDJTyBqzu/AsUsoXC
         a4Gns/W3LMjyWIYsjqTKrng6W7qN0gk477wie48TpZLtavmC0DLBpOdcy6ZtjWldwDgV
         tIfg==
In-Reply-To: <1392376893-26106-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Cc: stgt <stgt@vger.kernel.org>

Sorry, please discard this patchset. We found that the previous commit:
https://github.com/fujita/tgt/commit/0e23d5754d3bc3cf0328255fa7dab8547ecb6e60
improves throughput of tgtd enough.

We've evaluated this patchset based on RHEL's tgt, which doesn't have
the above commit.

Thanks,
Hitoshi


On Fri, Feb 14, 2014 at 8:21 PM, Hitoshi Mitake
<mitake.hitoshi@lab.ntt.co.jp> wrote:
> Current tgtd sends and receives iSCSI PDUs in its main event
> loop. This design can cause bottleneck when many iSCSI clients connect
> to single tgtd process. For example, we need multiple tgtd processes
> for utilizing fast network like 10 GbE because typical single
> processor core isn't fast enough for processing a bunch of requests.
>
> This patchset lets tgtd offload send/recv iSCSI PDUs and digest checking to
> worker threads. The basic strategy of this change is like below:
> 1. decompose iscsi_[rt]x_handler()
> 2. re-implement single threaded version of iscsi_tcp_event_handler()
> 3. implement multi-threaded version of iscsi_tcp_event_handler()
>
> This patch also adds a new option "-T" to specify a number of threads which
> send/recieve PDUs. When 1 is passed with the option, the above single threaded
> version will be used, because the multi-threaded version incurs overhead which
> comes from frequent communication between threads in some case. If users don't
> want to use the multi-threaded version, they don't have to use it.
>
> Below is a summary of our performance evaluation:
> - 4 physical hosts connected with 10Gbps ethernet
> - 1 tgtd process provides 1 logical unit
> - 16 VMs read 4GB iso file by dd command in parallel
> -- average time required to complete the dd command of 16 VMs is a score
> --- original tgtd: 93.718 second
> --- changed tgtd (with -T 16): 57.449 second
>
> The above scores show that this patchset can improve performance of parallel
> access of initiators. This patchset is not so heavily tested yet. I'd like to
> hear your opinion about the design.
>
> Hitoshi Mitake (5):
>   tgtd: add helper functions for checking iostate of iscsi connections
>   tgtd: decompose iscsi_[rt]x_handler()
>   tgtd: add a new option "-T" for specifying a number of threads which
>     send/recv iSCSI PDUs
>   tgtd: implement a deferred event modification mechanism
>   tgtd: offload iSCSI PDU send/recv to worker threads
>
>  usr/iscsi/iscsi_tcp.c |  405 +++++++++++++++++++++++++++++++++++++++++++++++--
>  usr/iscsi/iscsid.c    |  101 ++++++++----
>  usr/iscsi/iscsid.h    |   11 +-
>  usr/tgtd.c            |   10 +-
>  usr/tgtd.h            |    1 +
>  5 files changed, 483 insertions(+), 45 deletions(-)
>
> --
> 1.7.10.4
>
