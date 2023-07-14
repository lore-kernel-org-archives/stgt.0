From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: New user of tgtd
Date: Sat, 15 Jul 2023 07:21:28 +1000
Message-ID: <CAN05THSTdWCL2f+oCK-wsfxk2scJ0JbH18eGTA=w63Yc8iUMiw@mail.gmail.com>
References: <80102ab.d19c822c.18954f143dc@tnonline.net> <CAN05THRvMQpUjLAeWJ9B+jz2KRgRQsOz7yF4GVWbm4xovY32sw@mail.gmail.com>
 <36d2168.d19c822d.1895575e5bf@tnonline.net>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689369701; x=1691961701;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vNwW2Esud3umrQAFZLZ49hEBA2SFP8qRMzC3R95q0Vo=;
        b=ELljlPDuX6kKd94yQqkZGTJu3hlfzrqHVdwhRY3WIVwtBH2Jbo/zY1Y7vB05nh2VCJ
         MpGy/E9dWm9QZzVgjFrf/JiSowlQLxA1/7H53VxCOLtrvgFy52zD/2xCpxnbbpgqKIkI
         62Thl3adqhu2Of2HONNS4LajehJ7VgDjMz3xbiZHttc+rahQ3XxCrkofZDBihtr73BZO
         YFb1jQid9UyTOajuZ1efE5GQ6cAMl0m87uDRT7Y+SxirPAnxVvhaMwBBwNLSzVb87fN2
         3IlJcegef8Zfh8uEQLlTqPddFbcNmrG2woP0rzWl/jXf7MlaYCb76qRsGig2nf6VJH8c
         YoCQ==
In-Reply-To: <36d2168.d19c822d.1895575e5bf@tnonline.net>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Forza <forza@tnonline.net>
Cc: stgt@vger.kernel.org

On Sat, 15 Jul 2023 at 03:32, Forza <forza@tnonline.net> wrote:
>
>
>
> ---- From: ronnie sahlberg <ronniesahlberg@gmail.com> -- Sent: 2023-07-14 - 17:46 ----
>
> >> * Is there a way to hint to the initiators that the LUN is non-rotational? Some OSes use this parameter to adjusts its internal io scheduling.
> >
> > I think the param rotation_rate=0 will do that.
>
> Thank you. I didn't see it as a documented opinion, but looking through the source code[*] it seems to be the correct option.
>
> [*] https://github.com/fujita/tgt/blob/1a5e14e678ba944986428f4abc586a68e7cdf31a/usr/tgtd.h#L93

The documentation might be missing here because it is possibly an
unusual thing to need.
Maybe create a pull request to add this to the docs?


>
> ~ Forza
>
