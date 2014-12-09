From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sheepdog: fix data format for sheepdog request and
 response
Date: Tue, 09 Dec 2014 22:54:57 +0900 (JST)
Message-ID: <20141209.225457.1305564732068202615.fujita.tomonori@lab.ntt.co.jp>
References: <1417679438-6118-1-git-send-email-ishizaki.teruaki@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1417679438-6118-1-git-send-email-ishizaki.teruaki@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ishizaki.teruaki@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Thu,  4 Dec 2014 16:50:38 +0900
Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp> wrote:

> Data format of sheepdog backing store is different from that of Sheepdog.
> This patch fixes data format of sheepdog request and response.
> 
> Signed-off-by: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |   29 ++++++++++++++++++++---------
>  1 files changed, 20 insertions(+), 9 deletions(-)

Applied, thanks.
