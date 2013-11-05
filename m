From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH] Add an array that describes which opcodes are supported
 by the RDWR and SHEEPDOG backends.
Date: Tue, 5 Nov 2013 06:39:36 -0800
Message-ID: <CAN05THQ0Y0AAaNy619aQbw48325nKZVyRKqE+N+vE+s9hsAdyQ@mail.gmail.com>
References: <1381588740-25968-1-git-send-email-ronniesahlberg@gmail.com>
	<1381588740-25968-2-git-send-email-ronniesahlberg@gmail.com>
	<20131021101059Q.fujita.tomonori@lab.ntt.co.jp>
	<CAN05THSJYc9ESqVJQmBWuaKhVoZGHMp3bj7u4Wp5iBQf__soAA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=ihVNS/sUMkjIvFcBS3ISHQ9h6JBxdk76KtY9E0ftCjM=;
        b=yknEBVwxswVdtQb/rkWEEEWtv1fToP7goSoa62Fx7HVkWpQ/jGzO70kD1SQtwaKxVs
         335zVXb26ilRLkvfOWm2YB6iAdNZ9JsLc1VwbU4RQ3nqQpbEoT+ivi2Z9vmWjG4dKnq4
         FH2y6vvG5SbWnBW55Kr9UlaIzy+kQG8BJFwOdppuLlu3bUmXUBWxFr8JNLaVeiTu6uip
         D7MMnPEegVmIs0jGNo6tyvZr5vd5qjTIX/d2sJ33aP4E9s0aewb86xz2s463YY0bSXvX
         JxEVD1kCAKF2Qk/7od9LOif3nxRXCp3x+x+c585FOzwphZ8Wr7oaWkKI4cNc/1o7NzX7
         5YPA==
In-Reply-To: <CAN05THSJYc9ESqVJQmBWuaKhVoZGHMp3bj7u4Wp5iBQf__soAA@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt <stgt@vger.kernel.org>

Ping?

We need something like an array like this so that we can also update
REPORT_SUPPORTED_OPCODES correctly
and have this opcode only return the opcodes that the particular
backend supports.


On Wed, Oct 30, 2013 at 6:44 PM, ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
> On Sun, Oct 20, 2013 at 6:34 PM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
>> On Sat, 12 Oct 2013 07:38:59 -0700
>> Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:
>>
>>> While RDWR supports all SBC opcodes that TGTD implement SHEEPDOG
>>> only supports a subset and lacks the following opcodes:
>>>             WRITE_VERIFY10/12/16 VERIFY10/12/16 PREFETCH10/16
>>>             WRITE_SAME10/16 UNMAP and ORWRITE
>>>
>>> This allows backends to specify which opcodes it is prepared to process
>>> and which commands should fail with invalid op code
>>> and allows SHEEPDOG backed LUNs to respond with INVALID_OP_CODE
>>> correctly.
>>>
>>> This is most useful for block devices where we have several different backens
>>> and where some backends only support a subset of the commands
>>>
>>> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>>> ---
>>>  usr/bs.c          |    8 ++++++++
>>>  usr/bs_rdwr.c     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  usr/bs_sheepdog.c |   38 ++++++++++++++++++++++++++++++++++++++
>>>  usr/scsi.c        |    6 ++++++
>>>  usr/tgtd.h        |    1 +
>>>  5 files changed, 104 insertions(+), 0 deletions(-)
>>
>> Why backend store's bs_cmd_submit cannot return a proper error and
>> sbr_rc returns that error to an initiator?
>
>
> It could, but this way it is more explicit which opcodes are
> available, and a simple compare of the array between opcodes
> makes it easy for non-bs_rdwr backend developers to see the delta
> between their backend and rdwr.
>
> A second reason is for a followup patch.
> The followup patch will use this array so that it can prune which
> opcodes to report back for the REPORT_SUPPORTED_OPCODE opcode.
> So that when you issue that command to a sheepdog LUN  you get a
> pruned list back that only lists the opcodes that sheepdog supports.
>
>
> regards
> ronnie sahlberg
