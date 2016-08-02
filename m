From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] tgt-setup-lun: fix error when blocksize not given
Date: Tue, 02 Aug 2016 12:31:51 +0900 (JST)
Message-ID: <20160802.123151.632868945383106275.tomof@acm.org>
References: <1469530165-16220-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1469530165-16220-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org

On Tue, 26 Jul 2016 13:49:25 +0300
Roi Dayan <roid@mellanox.com> wrote:

> A prev commit added option for blocksize but intorudced a bug
> when user didn't provide a value.
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  scripts/tgt-setup-lun | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Applied, thanks.
