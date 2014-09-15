From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] SMC: add a smc backend template with an opcode
 whitelist
Date: Mon, 15 Sep 2014 21:00:20 +0900 (JST)
Message-ID: <20140915.210020.1305564732068187842.fujita.tomonori@lab.ntt.co.jp>
References: <1410231190-28735-1-git-send-email-ronniesahlberg@gmail.com>
	<1410231190-28735-2-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1410231190-28735-2-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org

On Mon,  8 Sep 2014 19:53:09 -0700
Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:

> SMC is not working properly since we do not yet initialize a proper
> SMC backend to tell it which opcodes are valid and which are not.
> With this change SMC works again and we can create a jukebox that
> mtx can communicate with correctly.
> 
> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> ---
>  usr/bs_rdwr.c |   33 +++++++++++++++++++++++++++++++++
>  usr/scsi.h    |    1 +
>  usr/smc.c     |    9 +++++++++
>  3 files changed, 43 insertions(+), 0 deletions(-)

Applied, thanks!
