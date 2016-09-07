From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 0/6] sheepdog driver cleanup
Date: Wed, 07 Sep 2016 09:24:57 +0900 (JST)
Message-ID: <20160907.092457.1305564732068165423.tomof@acm.org>
References: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Tue,  6 Sep 2016 16:37:23 +0900
Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp> wrote:

> This patchset does some cleaning of the sheepdog driver related to the
> iSCSI multipath functionality.
> 
> Hitoshi Mitake (6):
>   sheepdog: prevent double locking during inode reload
>   sheepdog: serialize overwrapping request
>   sheepdog: pass a correct flag to reload_inode()
>   sheepdog: handle a case of snapshot -> failover
>   sheepdog: don't let ai have min and max dirty data indexes
>   sheepdog: handle an inconsistent state of metadata
> 
>  usr/bs_sheepdog.c | 182 +++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 153 insertions(+), 29 deletions(-)

Applied, thanks!
