From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 1/2] Validate the DataOut length in WRITE_SAME_1*
Date: Wed, 05 Oct 2016 06:49:17 +0900 (JST)
Message-ID: <20161005.064917.1305564732068183038.tomof@acm.org>
References: <1475424242-18168-1-git-send-email-ronniesahlberg@gmail.com>
        <1475424242-18168-2-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1475424242-18168-2-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org, tomof@acm.org

On Sun,  2 Oct 2016 09:04:01 -0700
Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:

> WRITE_SAME_1* takes either no data at all or exactly one block of data
> as DataOut. Check for this and fail the cdb if the DataOut size differs.
> 
> (Some initiators use DataOut size == 0 (primarily together with unmap)
> to mean "use a block all filled with 0" so that is why I think we
> should be liberal and allow size==0 too here.)
> 
> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> ---
>  usr/sbc.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied both, thanks!
