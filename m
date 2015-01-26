From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: ExpCmdSn and MaxCmdSn in ISCSI_OP_R2T
Date: Mon, 26 Jan 2015 12:58:57 +0900 (JST)
Message-ID: <20150126.125857.1568838937885762852.fujita.tomonori@lab.ntt.co.jp>
References: <kk5iofyfjem.fsf@brer.local.valinux.co.jp>
	<kk5twzeb3q2.fsf@brer.local.valinux.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <kk5twzeb3q2.fsf@brer.local.valinux.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: minoura@valinux.co.jp
Cc: stgt@vger.kernel.org

On Mon, 26 Jan 2015 12:49:57 +0900
MINOURA Makoto / 箕浦 真 <minoura@valinux.co.jp> wrote:

> 
> |> In <kk5iofyfjem.fsf@brer.local.valinux.co.jp>
> |>  "MINOURA Makoto / 箕浦 真" <minoura@valinux.co.jp> wrote:
> 
>> tgtd does not send ExpCmdSn and MaxCmdSn with OP_R2T (Ready
>> To Transfer) operations.  Is this behaviour correct?
> 
> I found the following in 3.5.1.6. Ready To Transfer (R2T),
> RFC 3720.
> 
> ---- 
> R2T also carries information required for proper operation
> of the iSCSI protocol, such as:
> 
>      - R2TSN (to enable an initiator to detect a missing R2T)
>      - StatSN
>      - ExpCmdSN
>      - MaxCmdSN
> ---- 
> 
> Thus I think it is a bug in tgtd not in the Linux initiator.
> 
> 
>> At least Linux (RHEL6.2) initiators take 0 MaxCmdSn value
>> and get confused.
> 
> Linux initiator ensures on updating CmdSn's that the new
> value is greater (in terms of RFC1982) than the previous.
> When the previous value is less than 0x80000000 the new
> value 0 is less than the previous and is simply ignored.
> Once the session's MaxCmdSn counts up to 0x80000000, it is
> updated to 0 (greater than the previous) when tgtd sends an
> R2T.  The next CmdSn should be around 0x7fffff80, which is
> greater than the MaxCmdSn value (0), and flow control works
> to prevent sending the next command.
> 
> If there's no R2T in the small window where MaxCmdSn >= 0x80000000
> and CmdSn < 0x80000000 probably nothing happens except
> that MaxCmdSn flow control would not work (no limit) until
> the actual MaxCmdSn wraps to 0.

Applied, thanks a lot for the detailed investigation!
