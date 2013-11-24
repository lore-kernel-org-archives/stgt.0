From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH] REPORT SUPPORTED OPCODES: Only return opcodes supported
 by the backend.
Date: Sun, 24 Nov 2013 15:17:35 -0800
Message-ID: <CAN05THTqh_xPTPV=vsQ76p8ynN6XgZGO2GU+WOpt9VSOnqGY0w@mail.gmail.com>
References: <1385334153-12171-1-git-send-email-ronniesahlberg@gmail.com>
	<1385334153-12171-2-git-send-email-ronniesahlberg@gmail.com>
	<20131125074519E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=CP7U1Wux7Th+5exIJVWi8Hj8iiw3MuzQX3001Gq3C2U=;
        b=OR4akQuu6xio6lEtwIoGNBSMRWvz1ySeZc2UJNdnBZ5Vzguv04O5+WQgljGAu6h0o7
         fKFDRCJiR3rC7PvSzhEiNuTR6/KR34H5ePBdjmISuux1aHGlgY+GyAg5g9d7axvJSh1Y
         9rzZCyyvPgPe8ahvgLMpw7JSibGU0aZnaIGz+Ua+ZrEeAZY2b7GOpP6zUo6RIQCjA0ex
         F9IPcr2acq6LPWPeiCND6Z1ltABrQzSN43AoKRpzqCniocnz5q4uHqz7DqHy1vAwjWES
         yZY0AhBUE43bgFtYrX4qffQFwaPErMZwcBKd9EZEO/SMayAMsr/d5gTCK6O9ID6WT5II
         gPjQ==
In-Reply-To: <20131125074519E.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt <stgt@vger.kernel.org>

On Sun, Nov 24, 2013 at 3:12 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Sun, 24 Nov 2013 15:02:33 -0800
> Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:
>
>> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> ---
>>  usr/spc.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> Applied, thanks.
>
> You still have a pending patch related with this opcode stuff?

I dont have any more patches right now, but I plan to send you patches
to add an opcode list to all the other backends in a few days.
