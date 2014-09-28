From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sheepdog: optimize reloading of inode
Date: Mon, 29 Sep 2014 05:05:22 +0900 (JST)
Message-ID: <20140929.050522.1568838937885776089.fujita.tomonori@lab.ntt.co.jp>
References: <1411908485-28924-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1411908485-28924-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, mitake.hitoshi@gmail.com

On Sun, 28 Sep 2014 21:48:05 +0900
Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp> wrote:

> Current sheepdog driver reloads inode when in both cases of snapshot
> and invalidateion with iSCSI multipath. In the first case, reloading
> whole inode isn't required. This patch reduces the overhead produced
> by whole reloading in the case of snapshot.
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c | 47 +++++++++++++++++++++++++++++++++++------------
>  1 file changed, 35 insertions(+), 12 deletions(-)

Applied, thanks.
