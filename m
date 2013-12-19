From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: add missing initialization of request
 header
Date: Thu, 19 Dec 2013 22:48:31 +0900
Message-ID: <20131219221817K.fujita.tomonori@lab.ntt.co.jp>
References: <1387451777-25196-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1387451777-25196-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, sheepdog@lists.wpkg.org, mitake.hitoshi@lab.ntt.co.jp

On Thu, 19 Dec 2013 20:16:17 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> The create_branch function of the sheepdog driver sends a partially
> uninitialized request to sheepdog.  This fixes the defect.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    1 +
>  1 file changed, 1 insertion(+)

Applied.
