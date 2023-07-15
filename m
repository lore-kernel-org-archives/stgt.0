From: Forza <forza@tnonline.net>
Subject: Re: New user of tgtd
Date: Sun, 16 Jul 2023 01:01:41 +0200 (GMT+02:00)
Message-ID: <3b007e0.13a32fc8.1895bc9d68a@tnonline.net>
References: <80102ab.d19c822c.18954f143dc@tnonline.net> <CAN05THRvMQpUjLAeWJ9B+jz2KRgRQsOz7yF4GVWbm4xovY32sw@mail.gmail.com> <36d2168.d19c822d.1895575e5bf@tnonline.net> <CAN05THSTdWCL2f+oCK-wsfxk2scJ0JbH18eGTA=w63Yc8iUMiw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAN05THSTdWCL2f+oCK-wsfxk2scJ0JbH18eGTA=w63Yc8iUMiw@mail.gmail.com>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: stgt@vger.kernel.org



---- From: ronnie sahlberg <ronniesahlberg@gmail.com> -- Sent: 2023-07-14 - 23:21 ----

> On Sat, 15 Jul 2023 at 03:32, Forza <forza@tnonline.net> wrote:
>>
>>
>>
>> ---- From: ronnie sahlberg <ronniesahlberg@gmail.com> -- Sent: 2023-07-14 - 17:46 ----
>>
>> >> * Is there a way to hint to the initiators that the LUN is non-rotational? Some OSes use this parameter to adjusts its internal io scheduling.
>> >
>> > I think the param rotation_rate=0 will do that.
>>
>> Thank you. I didn't see it as a documented opinion, but looking through the source code[*] it seems to be the correct option.
>>
>> [*] https://github.com/fujita/tgt/blob/1a5e14e678ba944986428f4abc586a68e7cdf31a/usr/tgtd.h#L93
> 
> The documentation might be missing here because it is possibly an
> unusual thing to need.
> Maybe create a pull request to add this to the docs?
> 
> 

Yes, good idea. I did a small PR.

Thanks.

>>
>> ~ Forza
>>


