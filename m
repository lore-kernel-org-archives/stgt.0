From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_ssc: remove unused variables
Date: Fri, 25 Jul 2014 16:31:14 +0900 (JST)
Message-ID: <20140725.163114.1305564732068188239.fujita.tomonori@lab.ntt.co.jp>
References: <1406083450-29957-1-git-send-email-liangry@ucweb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1406083450-29957-1-git-send-email-liangry@ucweb.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: liangry@ucweb.com
Cc: stgt@vger.kernel.org

On Wed, 23 Jul 2014 10:44:10 +0800
Ruoyu <liangry@ucweb.com> wrote:

> The variables, transfer_length and residue are never used in the
> function tape_rdwr_request()
> 
> Signed-off-by: Ruoyu <liangry@ucweb.com>
> ---
>  usr/bs_ssc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied, thanks.
