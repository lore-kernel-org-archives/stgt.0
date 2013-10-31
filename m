From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH] Add an array that describes which opcodes are supported
 by the RDWR and SHEEPDOG backends.
Date: Wed, 30 Oct 2013 18:44:19 -0700
Message-ID: <CAN05THSJYc9ESqVJQmBWuaKhVoZGHMp3bj7u4Wp5iBQf__soAA@mail.gmail.com>
References: <1381588740-25968-1-git-send-email-ronniesahlberg@gmail.com>
	<1381588740-25968-2-git-send-email-ronniesahlberg@gmail.com>
	<20131021101059Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=jaGkhIGboDFcec9fpjhq46nsIFCi8ZSTZrS0I7lwsZ0=;
        b=boY2A36CQ9lqf7XbVwo53tS/2W8R5vrqXB+vmWbRq3EjmKeEsxxs3SUPQXyW3Bd5oo
         kpp3qVjRKx1YW7jOEJuAjtjwPgb0xmzXPXIKpoqLKHXFyHRbARQ50d/IdSpaEb8zMEw+
         U3EGLHCaN0bCAQLBGeDqPwWFjMd20YaI7aN8pU6aJZ1eAO1+xXVGxoEKcYxmIFtGffp/
         RZ7y5Lj9dbIvJakRIy8wv9thv5octdGMxZCLO3ayvJpQoSsD7ZQ4g6BXGWSVuL2Qkd42
         4mAIAwcoNb5k3bJZjexJJzhabmtNfZM/fIi0cR4/koJZ/TzT9N4DcNI/BSr/VkkmU+nB
         HWNw==
In-Reply-To: <20131021101059Q.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt <stgt@vger.kernel.org>

On Sun, Oct 20, 2013 at 6:34 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Sat, 12 Oct 2013 07:38:59 -0700
> Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:
>
>> While RDWR supports all SBC opcodes that TGTD implement SHEEPDOG
>> only supports a subset and lacks the following opcodes:
>>             WRITE_VERIFY10/12/16 VERIFY10/12/16 PREFETCH10/16
>>             WRITE_SAME10/16 UNMAP and ORWRITE
>>
>> This allows backends to specify which opcodes it is prepared to process
>> and which commands should fail with invalid op code
>> and allows SHEEPDOG backed LUNs to respond with INVALID_OP_CODE
>> correctly.
>>
>> This is most useful for block devices where we have several different backens
>> and where some backends only support a subset of the commands
>>
>> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> ---
>>  usr/bs.c          |    8 ++++++++
>>  usr/bs_rdwr.c     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  usr/bs_sheepdog.c |   38 ++++++++++++++++++++++++++++++++++++++
>>  usr/scsi.c        |    6 ++++++
>>  usr/tgtd.h        |    1 +
>>  5 files changed, 104 insertions(+), 0 deletions(-)
>
> Why backend store's bs_cmd_submit cannot return a proper error and
> sbr_rc returns that error to an initiator?


It could, but this way it is more explicit which opcodes are
available, and a simple compare of the array between opcodes
makes it easy for non-bs_rdwr backend developers to see the delta
between their backend and rdwr.

A second reason is for a followup patch.
The followup patch will use this array so that it can prune which
opcodes to report back for the REPORT_SUPPORTED_OPCODE opcode.
So that when you issue that command to a sheepdog LUN  you get a
pruned list back that only lists the opcodes that sheepdog supports.


regards
ronnie sahlberg
