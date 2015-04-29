From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] iser: Fix memory leak of addrinfo struct
Date: Wed, 29 Apr 2015 21:34:43 +0900 (JST)
Message-ID: <20150429.213443.1568838937885778515.fujita.tomonori@lab.ntt.co.jp>
References: <1430310683-17664-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1430310683-17664-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: stgt@vger.kernel.org

On Wed, 29 Apr 2015 15:31:23 +0300
Roi Dayan <roid@mellanox.com> wrote:

> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  usr/iscsi/iser.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Applied, thanks!
