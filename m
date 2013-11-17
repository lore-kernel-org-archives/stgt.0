From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH RFC v2] tgtd: send/recv iSCSI PDUs in worker threads
Date: Sun, 17 Nov 2013 22:50:58 +0900 (JST)
Message-ID: <20131117.225058.1568838937885772695.fujita.tomonori@lab.ntt.co.jp>
References: <1384073347-3067-1-git-send-email-mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1384073347-3067-1-git-send-email-mitake.hitoshi@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@gmail.com
Cc: stgt@vger.kernel.org, mitake.hitoshi@lab.ntt.co.jp

On Sun, 10 Nov 2013 17:49:07 +0900
Hitoshi Mitake <mitake.hitoshi@gmail.com> wrote:

> From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> 
> Current tgtd sends and receives iSCSI PDUs in its main event
> loop. This design can cause bottleneck when many iSCSI clients connect
> to single tgtd process. For example, we need multiple tgtd processes
> for utilizing fast network like 10 GbE because typical single
> processor core isn't fast enough for processing bunch of requests.
> 
> This patch lets tgtd send/receive iSCSI PDUs and check digests in its
> worker threads. After applying this patch, the bottleneck in the main
> event loop is removed and the performance is improved.
> 
> The improvement can be seen even if tgtd and iSCSI initiator are
> running on a single host. Below is a snippet of fio result on my
> laptop. The workload is 128MB random RW. Backingstore is sheepdog.
> 
> Original tgtd:
>   read : io=65392KB, bw=4445.2KB/s, iops=1111, runt= 14711msec
>   write: io=65680KB, bw=4464.8KB/s, iops=1116, runt= 14711msec
> 
> tgtd with this patch:
>   read : io=65392KB, bw=5098.9KB/s, iops=1274, runt= 12825msec
>   write: io=65680KB, bw=5121.3KB/s, iops=1280, runt= 12825msec

Can you check how this scales with tcp connections on a
reasonably-high-performance server?
