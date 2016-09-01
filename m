From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Disable NOP-IN and adjust state for closed conn
Date: Thu, 01 Sep 2016 11:16:46 +0900 (JST)
Message-ID: <20160901.111646.1568838937885772685.fujita.tomonori@lab.ntt.co.jp>
References: <1472576961463.91961@acronis.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1472576961463.91961@acronis.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Anton.Kovalenko@acronis.com
Cc: stgt@vger.kernel.org

On Tue, 30 Aug 2016 17:09:21 +0000
Anton Kovalenko <Anton.Kovalenko@acronis.com> wrote:

> From ac1b732b612fe2c188dcc2441e5dd247d3452836 Mon Sep 17 00:00:00 2001
> From: Anton Kovalenko <anton.kovalenko@acronis.com>
> Date: Tue, 30 Aug 2016 19:02:51 +0300
> Subject: [PATCH] Disable NOP-IN and adjust state for closed conn
> 
> There is a couple of problems when a connection is closed by
> iscsi_tcp_nop_work_handler, and there are uncompleted scsi commands for
> that connection:
> 
> 1) usr/iscsi/iscsid.c:iscsi_scsi_cmd_done assumes that a closed connection
> has .state == STATE_CLOSE. The assumption fails if the connection is
> closed not as a reaction to STATE_CLOSE, but by a raw conn_close call
> outside of rx/tx handlers (like it happens for unanswered NOP-INs).
> This commit takes care to set .state = STATE_CLOSE in ep_close callback,
> so incomplete scsi commands will be freed on completion.
> 
> 2) the connection doesn't go away from iscsi_tcp_conn_list until its
> refcount reaches zero (see iscsi_tcp_release). It makes
> iscsi_tcp_nop_work_handler call conn_close for the same connection
> repeatedly, as long as it has incomplete scsi commands (hence non-zero
> refcount). This commit zeroes out nop_interval for closed connections,
> so next iscsi_tcp_nop_work_handler calls won't try to close the
> connection any more.
> ---
>  usr/iscsi/iscsi_tcp.c | 2 ++
>  1 file changed, 2 insertions(+)

Looks good. Thanks!

