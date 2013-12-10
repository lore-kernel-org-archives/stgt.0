From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] iscsi/conn.c: fix a typo s/sesson/session/
Date: Tue, 10 Dec 2013 23:29:06 +0900 (JST)
Message-ID: <20131210.232906.1305564732068186510.fujita.tomonori@lab.ntt.co.jp>
References: <1386685637-24388-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1386685637-24388-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Tue, 10 Dec 2013 23:27:17 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> This fixes a typo "sesson" in an error message of conn_close function.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/iscsi/conn.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied.
