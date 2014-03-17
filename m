From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] tgtd: fix leak of task_in_scsi flag
Date: Mon, 17 Mar 2014 14:48:32 +0900 (JST)
Message-ID: <20140317.144832.1568838937885780027.fujita.tomonori@lab.ntt.co.jp>
References: <1395027541-11479-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1395027541-11479-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Mon, 17 Mar 2014 12:39:01 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> When target_mgmt_request() function receives unknown or unsupported
> task management function code or task was already completed for
> ABORT_TASK request, iscsi_tm_execute() and iser_tm_exec() functions
> exit without clearing task_in_scsi flag even though scsi command is
> not in processing.
> 
> This is because the current implementation of target_mgmt_request()
> function returns -EINVAL or -EEXIST for the above cases and
> iscsi_tm_execute() and iser_tm_exec() do not handle these return
> codes.
> 
> This fixes the issue by changing the return value of
> target_mgmt_request() to MGMT_REQ_FAILED for such cases.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/target.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.
