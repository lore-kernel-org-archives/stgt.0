From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sheepdog: support iSCSI multipath
Date: Fri, 08 Aug 2014 12:37:20 +0900 (JST)
Message-ID: <20140808.123720.1281009750676927443.fujita.tomonori@lab.ntt.co.jp>
References: <1407374749-13610-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1407374749-13610-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, mitake.hitoshi@gmail.com

On Thu,  7 Aug 2014 10:25:49 +0900
Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp> wrote:

> This patch implements iSCSI multipath support in sheepdog backing
> store driver. Below is a brief description of the feature:
> 
> The main problem of enabling iSCSI multipath for sheepdog's VDI is
> keeping coherence of tgtd's internal inode data structure. Assume tgt
> A and B have logical units which point same sheepdog VDI. After
> initialization of the logical units, A and B have copies of inode
> object in their address space (let's X denote this object). When an
> initiator sends write request to A and the request causes COW, A
> creates a new object and updates the inode object X (let's X' denote
> the updated one).
> 
> After the update by A, A can die with hardware faults. In such a case,
> the initiator detects a connection error and switch its target to B if
> iSCSI multipath is configured correctly. But the problem can arise at
> this point. Because B doesn't know the update caused by A and its
> internal inode object is still X, not X'. B creates requests based on
> X, so it can read obsolete data which is already hidden by X' or
> update X' in wrong manner.
> 
> For solving the above problem, sheepdog implements inode object
> coherence protocol which mocks MSI protocol of shared memory multicore
> processors. With this mechanism sheepdog can prevent requests which
> are based on obsolete inode objects. This patch let sheepdog driver of
> tgtd adopt the coherence protocol.
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 81 insertions(+), 16 deletions(-)

Applied, thanks.
