From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] iscsi: fix leak of session->initiator_alias
Date: Sun, 23 Feb 2014 21:55:12 +0900
Message-ID: <20140223215255T.fujita.tomonori@lab.ntt.co.jp>
References: <1392988502-8734-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1392988502-8734-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Fri, 21 Feb 2014 22:15:02 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> session->initiator_alias is not freed in error paths of
> session_create() and even in the normal path of session_destroy().
> 
> This fixes these leak bugs.
> 
> Note that we don't have to do a null check for
> session->initiator_alias before calling free(session->initiator_alias)
> because free() function simply ignores NULL pointer.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/iscsi/session.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Applied, thanks a lot!
