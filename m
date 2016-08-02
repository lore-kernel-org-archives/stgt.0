From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] Fix accepting invalid block size
Date: Tue, 02 Aug 2016 12:31:40 +0900 (JST)
Message-ID: <20160802.123140.653026525707339900.tomof@acm.org>
References: <1469531192-30570-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1469531192-30570-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org

On Tue, 26 Jul 2016 14:06:32 +0300
Roi Dayan <roid@mellanox.com> wrote:

> bshift can be negative so its type should not be unsigned or the
> comparison of its negative never succeeds.
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  usr/target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.
