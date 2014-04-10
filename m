From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] iser: fix a warning about container_of being redefined
Date: Fri, 11 Apr 2014 05:10:54 +0900 (JST)
Message-ID: <20140411.051054.1305564732068195960.fujita.tomonori@lab.ntt.co.jp>
References: <1397144451-4393-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1397144451-4393-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: stgt@vger.kernel.org

On Thu, 10 Apr 2014 18:40:51 +0300
Roi Dayan <roid@mellanox.com> wrote:

> container_of is being defined in list.h and verbs.h differently.
> To keep tgtd toe use the container_of from list.h as today, Instead of
> wrapping ifndef which exists in verbs.h I moved the inclusion of verbs
> to after list.h
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  usr/iscsi/iser.c      |    4 +---
>  usr/iscsi/iser.h      |    3 +++
>  usr/iscsi/iser_text.c |    2 --
>  3 files changed, 4 insertions(+), 5 deletions(-)

Applied, thanks.
