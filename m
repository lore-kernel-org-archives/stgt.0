From: =?iso-2022-jp?B?TUlOT1VSQSBNYWtvdG8gLyAbJEJMJzE6GyhCIBskQj8/GyhC?= 
	<minoura@valinux.co.jp>
Subject: Re: ExpCmdSn and MaxCmdSn in ISCSI_OP_R2T
Date: Mon, 26 Jan 2015 12:49:57 +0900
Message-ID: <kk5twzeb3q2.fsf@brer.local.valinux.co.jp>
References: <kk5iofyfjem.fsf@brer.local.valinux.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <kk5iofyfjem.fsf@brer.local.valinux.co.jp> ("MINOURA Makoto \/
 \=\?iso-2022-jp\?B\?GyRCTCcxOhsoQgkbJEI\/PxsoQiIncw\=\=\?\= message of "Fri, 23 Jan
 2015 09:08:33 +0900")
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org


|> In <kk5iofyfjem.fsf@brer.local.valinux.co.jp>
|>  "MINOURA Makoto / 箕浦 真" <minoura@valinux.co.jp> wrote:

> tgtd does not send ExpCmdSn and MaxCmdSn with OP_R2T (Ready
> To Transfer) operations.  Is this behaviour correct?

I found the following in 3.5.1.6. Ready To Transfer (R2T),
RFC 3720.

---- 
R2T also carries information required for proper operation
of the iSCSI protocol, such as:

     - R2TSN (to enable an initiator to detect a missing R2T)
     - StatSN
     - ExpCmdSN
     - MaxCmdSN
---- 

Thus I think it is a bug in tgtd not in the Linux initiator.


> At least Linux (RHEL6.2) initiators take 0 MaxCmdSn value
> and get confused.

Linux initiator ensures on updating CmdSn's that the new
value is greater (in terms of RFC1982) than the previous.
When the previous value is less than 0x80000000 the new
value 0 is less than the previous and is simply ignored.
Once the session's MaxCmdSn counts up to 0x80000000, it is
updated to 0 (greater than the previous) when tgtd sends an
R2T.  The next CmdSn should be around 0x7fffff80, which is
greater than the MaxCmdSn value (0), and flow control works
to prevent sending the next command.

If there's no R2T in the small window where MaxCmdSn >= 0x80000000
and CmdSn < 0x80000000 probably nothing happens except
that MaxCmdSn flow control would not work (no limit) until
the actual MaxCmdSn wraps to 0.

diff --git a/usr/iscsi/iscsid.c b/usr/iscsi/iscsid.c
index f0abe39..4b97a11 100644
--- a/usr/iscsi/iscsid.c
+++ b/usr/iscsi/iscsid.c
@@ -1181,6 +1181,9 @@ static int iscsi_r2t_build(struct iscsi_task *task)
 	rsp->data_offset = cpu_to_be32(task->offset);
 	/* return next statsn for this conn w/o advancing it */
 	rsp->statsn = cpu_to_be32(conn->stat_sn);
+	rsp->exp_cmdsn = cpu_to_be32(conn->session->exp_cmd_sn);
+	rsp->max_cmdsn = cpu_to_be32(conn->session->exp_cmd_sn +
+				     conn->session->max_queue_cmd);
 	rsp->ttt = (unsigned long) task;
 	length = min_t(uint32_t, task->r2t_count,
 		       conn->session_param[ISCSI_PARAM_MAX_BURST].val);

-- 
Minoura Makoto <minoura@valinux.co.jp>
