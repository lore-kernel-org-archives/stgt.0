From: Dan Mick <dan.mick@inktank.com>
Subject: Re: [PATCH] Add an array that describes which opcodes are supported
 by the RDWR and SHEEPDOG backends.
Date: Thu, 07 Nov 2013 13:46:36 -0800
Message-ID: <527C0A3C.9080904@inktank.com>
References: <CAN05THSJYc9ESqVJQmBWuaKhVoZGHMp3bj7u4Wp5iBQf__soAA@mail.gmail.com>	<20131107154208N.fujita.tomonori@lab.ntt.co.jp>	<CAN05THTQnoSKyvLdJv2r7EoQ8zA=7v574ZvHo-jf4fGtJC27Qw@mail.gmail.com> <20131108061347I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20131108061347I.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org


>>> I see, thanks. Using the bitmaps is simpler than the array of char if
>>> you calculate delta and such?
>>
>> I think using the array with opcode names is simpler for a human to
>> comparing when reading the sourcecode.
>>
>>
>> I had a bitmap of 32 bytes, one bit for each opcode,   and I also
>> tried using an array of 256 bytes, one byte 0/1 for each opcode
>> but it was horrible to read from a human standpoint.
>>
>> When reading the code and the bitmap/array it was very difficult to
>> see which opcodes were supported and which were not
>> by just looking at the bits.
>> It was also errorprone and I did several mistakes when building the
>> bitmap manually.
>
> Why you built it manually? You can do something like
>
> set_bit(WRITE_6, bitmap_addr);
>
> ?
>
> As usual, you can steal bitmap functions from Linux kernel.

Is it worth it to mess around with bits when chars are easily
manipulated?  Sure, it's 8x the data, but it's much easier to dump,
examine in debuggers, etc., and it's 256 bytes; hardly worthy of notice.
Bitmaps are a pain in general.
