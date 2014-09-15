From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] SMC: add a new volume_tag parameter to storage slots
Date: Mon, 15 Sep 2014 21:00:09 +0900 (JST)
Message-ID: <20140915.210009.1568838937885778280.fujita.tomonori@lab.ntt.co.jp>
References: <1410236389-21112-1-git-send-email-ronniesahlberg@gmail.com>
	<1410236389-21112-2-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1410236389-21112-2-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org

On Mon,  8 Sep 2014 21:19:49 -0700
Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:

> SMC barcodes in TGTD are limited to just 10 characters while T10
> VolumeTags for smc storage slots allow up to 32 bytes.
> Introduce a new argument when populating slots for specifying a volume tag
> of up to 32 characters. If no volume tag is specified we fallback to use the
> barcode as the volume tag.
> 
> Leave the current barcode as is, limited to 10 characters to not break
> compatibility with scripts that might use SMC devices.
> 
> Update the dvdjukebox example script to use volume tag. This allows us to
> hand a much more useful name back to the MTX tool than the barcode.
> (10 characters is pretty restrictive as an ASCII text string. The full
> ISO image file name is most likely much more meaningful to a human.)
> 
> Update the tgtadm manpage and show the new volume_tag argument.
> 
> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> ---
>  doc/README.dvdjukebox |   29 ++++++-----------------------
>  doc/tgtadm.8.xml      |   17 ++++++++++++++---
>  usr/smc.c             |   25 +++++++++++++++++++------
>  usr/smc.h             |    5 ++++-
>  4 files changed, 43 insertions(+), 33 deletions(-)

Applied, thanks.
