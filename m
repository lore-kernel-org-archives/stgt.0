From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] MMC: add a dedicated backend for MMC so that
 supported-opcode map works
Date: Fri, 22 Aug 2014 19:16:17 +0900 (JST)
Message-ID: <20140822.191617.1568838937885767760.fujita.tomonori@lab.ntt.co.jp>
References: <1408578338-9262-1-git-send-email-ronniesahlberg@gmail.com>
	<1408578338-9262-2-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1408578338-9262-2-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org

On Wed, 20 Aug 2014 16:45:38 -0700
Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:

> MMC has been broken for a while since some of the vital opcodes
> (GET_CONFIGURATION) and friends are not in the supported opcode
> whitelist in bs_rdwr.c.
> The real problem is that we have a bs_rdwr.c backend for SBC and we
> piggyback on this SBC backend also for the MMC emulation.
> 
> Add defines for the missing MMC opcodes and create a new backend
> dedicated for MMC that has the proper whitelist for MMC opcodes.
> This new backend is actually part of bs_rdwr.c and shares all the
> code with the SBC based backend.
> However the new MMC backend will have a different name "mmc" to indicate
> it is for the MMC emulation and it comes with a supported opcode
> whitelist that is appropriate for MMC devices.
> 
> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> ---
>  usr/bs_rdwr.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  usr/mmc.c     |    6 +++---
>  usr/scsi.h    |    9 +++++++++
>  3 files changed, 62 insertions(+), 7 deletions(-)

Applied, thanks!
