From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Fix AIO backing store not being registered
Date: Thu, 7 Nov 2013 16:07:48 +0900
Message-ID: <20131107153946K.fujita.tomonori@lab.ntt.co.jp>
References: <1383576173-32010-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1383576173-32010-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org

On Mon,  4 Nov 2013 16:42:53 +0200
Roi Dayan <roid@mellanox.com> wrote:

> Missing the constructor attribute
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  usr/bs_aio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks!
