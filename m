From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] The first byte in CDB USAGE DATA should be the opcode
 number and not 0xFF
Date: Wed, 26 Feb 2014 20:23:18 +0900 (JST)
Message-ID: <20140226.202318.1568838937885768236.fujita.tomonori@lab.ntt.co.jp>
References: <1393298109-16052-1-git-send-email-ronniesahlberg@gmail.com>
	<1393298109-16052-2-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1393298109-16052-2-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org

On Mon, 24 Feb 2014 19:15:09 -0800
Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:

> When we build the CDB USAGE DATA field for a REPORT SUPPORTED OPCODES reply
> we must set the first byte of the field to the opcode itself, and not
> to 0xFF as we currently do.
> 
> SPC4:
> ...
> The CDB USAGE DATA field contains information about the CDB for the command being queried.
> The first byte of the CDB USAGE FIELD field shall contain the operation code for the command being queried.
> ...
> 
> A test for this is available in the libiscsi test utility :
> 
> ./bin/iscsi-test-cu iscsi://127.0.0.1/iqn.ronnie.test/1 --test=SCSI.ReportSupportedOpcodes.OneCommand
> 
> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> ---
>  usr/scsi.c |  195 ++++++++++++++++++++++++++++++++++++------------------------
>  1 files changed, 118 insertions(+), 77 deletions(-)

Applied, thanks.
