From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH] SMC fixes
Date: Sun, 14 Sep 2014 08:18:13 -0700
Message-ID: <CAN05THQLHi1zHyHq7=5rUfXKEpQXQN7HRBakREfhVK0E-Xx+_Q@mail.gmail.com>
References: <1410231190-28735-1-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=02CoW9IzKDidcBS2wFHgV61Ul+rAMsjCAlF1qSnt9Zw=;
        b=LkSPCloTBRhy652Si/rILQpolaY0jKOoKlF8O5G0hlTshCH7rgp25MatCCaQkiJuGB
         CNCuZFc5pMU37cZRpGWDXbXJnF2R8/NQKfMrUrfUZNekj+OCqGuYB5xi9QvjJIvK7f4w
         vC4NGqpIxDjzAHaJcd0EHema0s5GWF614GVaeMGzyx2Cu03XoydjvLQQ/pSTBzP+ZGnX
         haKIxdKsgMk3lPgq60ZTeBK1tRZRACP5jj9eDfSkpwdILDMm43uHQ/b3ahOY+Dtm8MBe
         QJWwcCRPWJn+VMWzZMi9/rj5th5LHu+E3w2e8y+rmE69z6E2DlHImm/H4uiQIfe9omuC
         sV+Q==
In-Reply-To: <1410231190-28735-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt <stgt@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

ping?

On Mon, Sep 8, 2014 at 7:53 PM, Ronnie Sahlberg
<ronniesahlberg@gmail.com> wrote:
> List, Tomo,
>
> We need a proper whitelist for which opcodes are valid for SMC devices.
> The following patch adds a trivial backing store template for smc with
> a corresponding opcode whitelist. With this patch we can access the smc
> device with mtx again.
>
>
> Ronnie Sahlberg (1):
>   SMC: add a smc backend template with an opcode whitelist
>
>  usr/bs_rdwr.c |   33 +++++++++++++++++++++++++++++++++
>  usr/scsi.h    |    1 +
>  usr/smc.c     |    9 +++++++++
>  3 files changed, 43 insertions(+), 0 deletions(-)
>
> --
> 1.7.3.1
>
