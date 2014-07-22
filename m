From: Mark Harvey <markh794@gmail.com>
Subject: Re: STGT fork for "broken disk emulation"
Date: Tue, 22 Jul 2014 16:23:54 +1000
Message-ID: <A5F00220-DFD8-41D2-B722-7D274622F44B@gmail.com>
References: <CAN05THRgcZUb=6Z3_YVuYShPUPveW4V7aanFCfU-ceYehwpRkQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=references:mime-version:in-reply-to:content-type
         :content-transfer-encoding:message-id:cc:from:subject:date:to;
        bh=WAEIuDa/1taiG2+ovfP0Ywqni9goon4AhO+pgxL17xU=;
        b=TIT5u1paR6iJnZlDbBTILIA8r9WyGi/aClKVJQWI8OcugHJr9zhg1gMeLsGdYZKqaD
         SdiHEybfEiFIrZ9bc+amqxjBzuXm/XtBDXusZ1FtWJ38aYoBqbLw2SQirOxfYIYZ1oTp
         n0NHKyy5EF8AmPpCbbr4c2d2SDuX2cOurwTC7hJo5XwhLVWPywnmdLN7AqUZ7ZDckJmW
         Ac+peqwOARQO9CehrXAr7crR0iQ2v9La+1TkGCfl4QJld8nVoURdzJE/SnhlCvRM8P6E
         TEfGhW/RsuwvqYhF4KaaoW7l7OHgFuduepxyZlK+co0ggys+ppxied8zRJP/wv5vxIvq
         07oA==
In-Reply-To: <CAN05THRgcZUb=6Z3_YVuYShPUPveW4V7aanFCfU-ceYehwpRkQ@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: stgt <stgt@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Could this be simply a new backing store type ?

Depends on error injection you want/need. If it is scsi command related, should be achievable in backing store. If it's transport related then I could see it being more invasive.

Another idea would be to hijack send/receive diagnostic op code. Initiator could send "injection commands" via receive diag op code payload & check status etc via send diag

Sent from my iPhone

> On 22 Jul 2014, at 7:52, ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> 
> List,
> 
> I have created a temporary work version of TGTD at:
> https://github.com/rsahlberg/flaky-stgt
> 
> This is not a production TGTD or a version that any normal users should use,
> instead I had an idea to try to add features to make it possible to create an
> iSCSI device that is broken and misbehaves in controllable ways.
> 
> For example, imagine a scsi disk that is "good" right now but after a
> certain stage in a scripted test the disk goes bad and start failing
> all WRITE commands.
> Just like a disk that suddenly has run out of reallocation space.
> 
> 
> The only people I see that could find this type of feature useful
> would be, I guess,
> filesystem developers, SCSI initiator midlayer developers or perhaps
> people writing
> code that talks directly to the disk and want to test that their error
> recovery paths
> work.
> I see no use or benefit from these features to normal users.
> 
> 
> Right now it is a bit in flux, and I also need to see if I can find
> buy-in and convince
> filesystem and block device driver developer folks that this could
> actually be useful to them.
> 
> Later on would come the question, should I refactor the code and
> should we push this into STGT mainline?
> I personally think that this usecase I am aiming for is so special
> case, and is only
> features that are useful or relevant to an almost infinitely small set
> of filesystem and block device driver developers that it would not
> make much sense.
> But if the TGTD community would rather have this built-in to official TGTD I am
> more than happy to rework the patches once things stabilize and submit.
> 
> This is not a hostile fork. this is a temporary work/scratch space
> while I experiment
> on "broken disk emulation" and while I try to see if there is interest
> in the devlopment community of this as a test tool.
> 
> 
> If anyone of you think this could be useful, please feel to try it out
> or let your
> filesystem developer friends know that "could you use a scsi disk that
> is 'busted' in controllable ways for your testing?"
> 
> 
> best regards
> ronnie sahlberg
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
