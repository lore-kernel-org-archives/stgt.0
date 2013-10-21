From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Add an array that describes which opcodes are
 supported by the RDWR and SHEEPDOG backends.
Date: Mon, 21 Oct 2013 10:34:44 +0900
Message-ID: <20131021101059Q.fujita.tomonori@lab.ntt.co.jp>
References: <1381588740-25968-1-git-send-email-ronniesahlberg@gmail.com>
	<1381588740-25968-2-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1381588740-25968-2-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org

On Sat, 12 Oct 2013 07:38:59 -0700
Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:

> While RDWR supports all SBC opcodes that TGTD implement SHEEPDOG
> only supports a subset and lacks the following opcodes:
>             WRITE_VERIFY10/12/16 VERIFY10/12/16 PREFETCH10/16
>             WRITE_SAME10/16 UNMAP and ORWRITE
> 
> This allows backends to specify which opcodes it is prepared to process
> and which commands should fail with invalid op code
> and allows SHEEPDOG backed LUNs to respond with INVALID_OP_CODE
> correctly.
> 
> This is most useful for block devices where we have several different backens
> and where some backends only support a subset of the commands
> 
> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> ---
>  usr/bs.c          |    8 ++++++++
>  usr/bs_rdwr.c     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  usr/bs_sheepdog.c |   38 ++++++++++++++++++++++++++++++++++++++
>  usr/scsi.c        |    6 ++++++
>  usr/tgtd.h        |    1 +
>  5 files changed, 104 insertions(+), 0 deletions(-)

Why backend store's bs_cmd_submit cannot return a proper error and
sbr_rc returns that error to an initiator?
