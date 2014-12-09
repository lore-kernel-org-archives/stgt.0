From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sbc.c: report DPO/FUA support in modesense datain
Date: Tue, 09 Dec 2014 22:26:26 +0900 (JST)
Message-ID: <20141209.222626.1568838937885773407.fujita.tomonori@lab.ntt.co.jp>
References: <1417791119-30801-1-git-send-email-ronniesahlberg@gmail.com>
	<1417791119-30801-2-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1417791119-30801-2-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org

On Fri,  5 Dec 2014 06:51:59 -0800
Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:

> We already do support DPO in the bs_rdwr backend and we pass DPO==1 as a
> hint to the kernel using POSIX_FADV_NOREUSE for WRITE_10/12/16.
> The idea here is that IF DPO==1 then this is a hint from the initiator that
> we should not cache the data. TGTD itself does not do any caching but the
> pagecache on the host might, hence the POSIX_FADV_NOREUSE hint.
> 
> So we already do support some basic DPO functionality in bs_rdwr.c. For the
> other backends we do not yet, but all those backends ignore the DPO bit
> anyway (i.e. they will not fail the command with INVALID_FIELD_IN_CDB).
> 
> This patch sets the 0x10 flag in the device specific parameters for block
> device mode pages so that we tell the initiator that we support DPO (and FUA).
> 
> With this patch the linux kernel initiator now recognizes that it may use
> DPO/FUA. As will hopefully other initiators as well.
> [160973.210942] sd 18:0:0:2: Attached scsi generic sg15 type 0
> [160973.211761] sd 18:0:0:1: [sdk] Write Protect is off
> [160973.211765] sd 18:0:0:1: [sdk] Mode Sense: 69 00 10 08
> [160973.211868] sd 18:0:0:1: [sdk] Write cache: enabled, read cache: enabled,
> supports DPO and FUA
> 
> Supporting DPO can have a positive performance impact since it can allow
> more efficient use of the target cache. I.e. an initiator can hint to the
> target which writes should not pollute the cache.
> 
> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> ---
>  usr/sbc.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)

Applied, thanks!
