From: Forza <forza@tnonline.net>
Subject: Re: New user of tgtd
Date: Fri, 14 Jul 2023 19:32:17 +0200 (GMT+02:00)
Message-ID: <36d2168.d19c822d.1895575e5bf@tnonline.net>
References: <80102ab.d19c822c.18954f143dc@tnonline.net> <CAN05THRvMQpUjLAeWJ9B+jz2KRgRQsOz7yF4GVWbm4xovY32sw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAN05THRvMQpUjLAeWJ9B+jz2KRgRQsOz7yF4GVWbm4xovY32sw@mail.gmail.com>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: stgt@vger.kernel.org



---- From: ronnie sahlberg <ronniesahlberg@gmail.com> -- Sent: 2023-07-14 - 17:46 ----

>> * Is there a way to hint to the initiators that the LUN is non-rotational? Some OSes use this parameter to adjusts its internal io scheduling.
> 
> I think the param rotation_rate=0 will do that.

Thank you. I didn't see it as a documented opinion, but looking through the source code[*] it seems to be the correct option.

[*] https://github.com/fujita/tgt/blob/1a5e14e678ba944986428f4abc586a68e7cdf31a/usr/tgtd.h#L93

~ Forza

