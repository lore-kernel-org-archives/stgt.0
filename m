From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] iser: fix tasks leak with all its resources
Date: Mon, 26 Jan 2015 13:23:40 +0900 (JST)
Message-ID: <20150126.132340.1305564732068174437.fujita.tomonori@lab.ntt.co.jp>
References: <1420648934-10219-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1420648934-10219-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: stgt@vger.kernel.org

Very sorry about the delay,

On Wed,  7 Jan 2015 18:42:14 +0200
Roi Dayan <roid@mellanox.com> wrote:

> On timewait_exit cm event we expect to put the last refcount on conn and
> release it. Since we already after the connection was closed we
> could have tasks in tx_list that won't be processed.
> We need to clean them or refcount won't reach 0.
> Not cleaning the tasks will also leak any rdma_bufs associated with those
> tasks.
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  usr/iscsi/iser.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)

Applied, thanks a lot!
