From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH] Add an array that describes which opcodes are supported
 by the RDWR and SHEEPDOG backends.
Date: Thu, 7 Nov 2013 08:42:43 -0800
Message-ID: <CAN05THTQnoSKyvLdJv2r7EoQ8zA=7v574ZvHo-jf4fGtJC27Qw@mail.gmail.com>
References: <1381588740-25968-2-git-send-email-ronniesahlberg@gmail.com>
	<20131021101059Q.fujita.tomonori@lab.ntt.co.jp>
	<CAN05THSJYc9ESqVJQmBWuaKhVoZGHMp3bj7u4Wp5iBQf__soAA@mail.gmail.com>
	<20131107154208N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=ck+4gKwkUSafHEQoNY8Yw21daFaiXap4A50NKQwfPuY=;
        b=o0gORZKnsHccp8Ow0QeCZiHFSWnWayFiVCJk3vtWxu/0haP+OebY5wWZBuuM0/lOeA
         LErZ0PtPeRT3ifs8t0JdSj6DqE9CcjFYUApPUgacuqQZbj5vjD683NpZ9yGlQtTJMdhk
         oOSsRCO1crQQVE3Tyq7UsCKaplC/Oj4T36sEX3EYfnXUuUIR+9f00PqGlz2JxZh9TRQU
         rESl9e5TXKLt2H7IlWgqtQxcBuL/r9K7C3Kxy4WkxincdhV04XB3o3b1J1gmPw5DTOJt
         oXB/MvSdesxnFg7ZE6pl83REKlIoJqIOQLPkIdcVr8hjcvRxII1qy39QVFiY+TWvc9qp
         NjJg==
In-Reply-To: <20131107154208N.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt <stgt@vger.kernel.org>

On Wed, Nov 6, 2013 at 11:07 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Wed, 30 Oct 2013 18:44:19 -0700
> ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
>> On Sun, Oct 20, 2013 at 6:34 PM, FUJITA Tomonori
>> <fujita.tomonori@lab.ntt.co.jp> wrote:
>> > On Sat, 12 Oct 2013 07:38:59 -0700
>> > Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:
>> >
>> >> While RDWR supports all SBC opcodes that TGTD implement SHEEPDOG
>> >> only supports a subset and lacks the following opcodes:
>> >>             WRITE_VERIFY10/12/16 VERIFY10/12/16 PREFETCH10/16
>> >>             WRITE_SAME10/16 UNMAP and ORWRITE
>> >>
>> >> This allows backends to specify which opcodes it is prepared to process
>> >> and which commands should fail with invalid op code
>> >> and allows SHEEPDOG backed LUNs to respond with INVALID_OP_CODE
>> >> correctly.
>> >>
>> >> This is most useful for block devices where we have several different backens
>> >> and where some backends only support a subset of the commands
>> >>
>> >> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> >> ---
>> >>  usr/bs.c          |    8 ++++++++
>> >>  usr/bs_rdwr.c     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>> >>  usr/bs_sheepdog.c |   38 ++++++++++++++++++++++++++++++++++++++
>> >>  usr/scsi.c        |    6 ++++++
>> >>  usr/tgtd.h        |    1 +
>> >>  5 files changed, 104 insertions(+), 0 deletions(-)
>> >
>> > Why backend store's bs_cmd_submit cannot return a proper error and
>> > sbr_rc returns that error to an initiator?
>>
>>
>> It could, but this way it is more explicit which opcodes are
>> available, and a simple compare of the array between opcodes
>> makes it easy for non-bs_rdwr backend developers to see the delta
>> between their backend and rdwr.
>>
>> A second reason is for a followup patch.
>> The followup patch will use this array so that it can prune which
>> opcodes to report back for the REPORT_SUPPORTED_OPCODE opcode.
>> So that when you issue that command to a sheepdog LUN  you get a
>> pruned list back that only lists the opcodes that sheepdog supports.
>
> I see, thanks. Using the bitmaps is simpler than the array of char if
> you calculate delta and such?

I think using the array with opcode names is simpler for a human to
comparing when reading the sourcecode.


I had a bitmap of 32 bytes, one bit for each opcode,   and I also
tried using an array of 256 bytes, one byte 0/1 for each opcode
but it was horrible to read from a human standpoint.

When reading the code and the bitmap/array it was very difficult to
see which opcodes were supported and which were not
by just looking at the bits.
It was also errorprone and I did several mistakes when building the
bitmap manually.

This approach uses an array of opcodes, making it really easy for a
human to see which opcodes are supported and which are not.
Then I call bs_create_opcode_map() to convert this array into a
byte-array to make it efficient for tgtd to check if the opcodes are
supported or not.
