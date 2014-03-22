From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] iscsi: fix leak of task for delayed management request
Date: Sat, 22 Mar 2014 20:57:25 +0900
Message-ID: <20140322205135N.fujita.tomonori@lab.ntt.co.jp>
References: <1395109198-15307-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1395109198-15307-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Tue, 18 Mar 2014 11:19:58 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> Fix the following crash of tgtd which occured when removing a target
> with --force option:
> 
>   conn_close(90) already closed 0x2058598 1
>   iscsi_target_destroy(416) bug still have sessions 91
> 
> This crash happens if a task remains after the following calls of
> conn_close() function for every connection on the target.
> 
>   list_for_each_entry_safe(session, stmp, &target->sessions_list, slist) {
>           list_for_each_entry_safe(conn, ctmp, &session->conn_list, clist) {
>                   conn_close(conn);
>           }
>   }
> 
> The leaked task turned out to be a task for handling ABORT_TASK
> management request which was delayed due to a flying io.  The delayed
> management request is attached to cmd->mreq of the io command and is
> completed by iscsi_tm_done() function.  However, this function fails
> with the following error and leaks the task if associated connection
> (task->conn) is already closed:
> 
>  tgt_event_modify(245) Cannot find event 25
>  iscsi_event_modify(560) tgt_event_modify failed
> 
> This fixes the issue by freeing task in iscsi_tm_done() if state of
> the connection is STATE_CLOSE.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/iscsi/iscsid.c |    5 +++++
>  1 file changed, 5 insertions(+)

Great catch! Thanks a lot!!
