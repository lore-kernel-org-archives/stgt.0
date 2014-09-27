From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] sheepdog driver update for iSCSI multipath
Date: Sat, 27 Sep 2014 21:32:27 +0900 (JST)
Message-ID: <20140927.213227.722554765817596326.fujita.tomonori@lab.ntt.co.jp>
References: <1411713866-12355-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1411713866-12355-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, mitake.hitoshi@gmail.com

On Fri, 26 Sep 2014 15:44:23 +0900
Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp> wrote:

> This patchset updates the sheepdog driver. With this change, sheepdog
> can support iSCSI multipath correctly with failover path grouping
> policy.
> 
> Hitoshi Mitake (3):
>   sheepdog: refresh invalidated inode in update_inode() path
>   sheepdog: set flag for indicating requests are from tgt
>   sheepdog: change a method for detecting invalidation of inode
> 
>  usr/bs_sheepdog.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)

Applied, thanks.
