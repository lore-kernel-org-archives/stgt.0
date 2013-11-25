From: =?utf-8?Q?Popovics_L=C3=A1szl=C3=B3?= <cuttie@me.com>
Subject: iser problems
Date: Mon, 25 Nov 2013 11:35:55 +0100
Message-ID: <B5A712BD-9DBC-44A1-836F-E9A6289D0269@me.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

Dear stgt list,

I would like to ask, that, is there any information about that, tgtd can run in multiple instances ?
When we tried to run a second instance, it give an error message because rdma listening port is occupied.

We would like to test multiple tgt instance because we have a feeling about that, rdma connecion number is limited for one instance, and we reached this limit.

We configured multiple storage machines with each of 312 disk which has 624 connection because of the multipath access.

When we put load to the system get the following messages:

Nov 4 14:08:10 taistoreb04 tgtd: iser_task_alloc_rdma_bufs(715) conn:0x2d31920 task:0x2bcb9180 tag:0x0028, free list empty

On the initiator side we see devices disconnected.

Is there any idea how to solve this problem ?

Best regards,

       Laszlo Popovics