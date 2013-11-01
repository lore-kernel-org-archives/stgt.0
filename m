From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: fix error handling issue in
 bs_sheepdog_request()
Date: Fri, 1 Nov 2013 09:46:18 +0900
Message-ID: <20131101092114X.fujita.tomonori@lab.ntt.co.jp>
References: <1383226564-21505-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1383226564-21505-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: mitake.hitoshi@lab.ntt.co.jp, stgt@vger.kernel.org, sheepdog@lists.wpkg.org

On Thu, 31 Oct 2013 22:36:04 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> bs_sheepdog_request function, the request handler of sheepdog driver,
> doesn't set scsi status code if the driver failed to create writable
> VDI from snapshot.
> 
> In that case, CHECK_CONDITION result code should be set to cmd->result
> through scsi_set_result() macro.  This fix corrects the error
> handling issue.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied.
