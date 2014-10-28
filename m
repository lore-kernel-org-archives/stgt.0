From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] iser: fix local conn params being reset to default
Date: Wed, 29 Oct 2014 06:58:09 +0900 (JST)
Message-ID: <20141029.065809.1568838937885767616.fujita.tomonori@lab.ntt.co.jp>
References: <1414510866-14770-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1414510866-14770-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: stgt@vger.kernel.org

On Tue, 28 Oct 2014 17:41:06 +0200
Roi Dayan <roid@mellanox.com> wrote:

> Instead of reseting the params to default if they pass it
> we should reset to max if they pass it.
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  usr/iscsi/iser_text.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks!
