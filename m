From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: New user of tgtd
Date: Sat, 15 Jul 2023 01:46:49 +1000
Message-ID: <CAN05THRvMQpUjLAeWJ9B+jz2KRgRQsOz7yF4GVWbm4xovY32sw@mail.gmail.com>
References: <80102ab.d19c822c.18954f143dc@tnonline.net>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689349622; x=1691941622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VZJz3mvP7VCr80jZ44/9FvdR3R4FoNMfPkjQBvtoEvw=;
        b=KnGrq1XQIFtkEjspLvYjYI6VtewBNGFI90wXCMBODCmBU2/+9lw9kYOn3PH3Pg18j8
         KA4BDahhCXuIyFmkYZ3BqdsmDe4tGSVyn8zFAfdMqXREQhSgP0HK7YF31oT0KxjHj5fo
         Uhhc4PkxqpCIgZ/GRLQCIX7IN5zXBbzBqdgwvLjJAhM1n20wzRW6G3FnHTYT9cYZ8G1c
         ZVtuwP+RB2uenEVu2ALeBgaqQBwkYfqgFCP5mX9Fq554pDLZojxL+iqT+UhAtqD36BVe
         Hzv8ZklilVGGpgw+UvcpCffbJaYsaU6G/oN4Nd0UEjuvKq/f3LpHZouVrqtv18G9zE2R
         UP0w==
In-Reply-To: <80102ab.d19c822c.18954f143dc@tnonline.net>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Forza <forza@tnonline.net>
Cc: stgt@vger.kernel.org

> * Is there a way to hint to the initiators that the LUN is non-rotational? Some OSes use this parameter to adjusts its internal io scheduling.

I think the param rotation_rate=0 will do that.
