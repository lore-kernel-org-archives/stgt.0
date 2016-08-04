From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] Fix compile warnings
Date: Thu, 04 Aug 2016 21:57:15 +0900 (JST)
Message-ID: <20160804.215715.1305564732068166318.tomof@acm.org>
References: <1470313589-15347-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1470313589-15347-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org

On Thu,  4 Aug 2016 15:26:29 +0300
Roi Dayan <roid@mellanox.com> wrote:

> Because of unused return values.
> Also set gcc Werror flag to consider warnings as errors.
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  usr/Makefile       |  2 +-
>  usr/bs_rdwr.c      |  2 --
>  usr/bs_ssc.c       |  2 --
>  usr/iscsi/iscsid.c |  6 ++----
>  usr/iscsi/iser.c   | 11 ++++-------
>  usr/parser.c       |  9 ++++-----
>  6 files changed, 11 insertions(+), 21 deletions(-)

Applied, thanks!
