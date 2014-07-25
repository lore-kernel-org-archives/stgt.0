From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: STGT fork for "broken disk emulation"
Date: Fri, 25 Jul 2014 16:34:37 +0900 (JST)
Message-ID: <20140725.163437.1545942096518972665.fujita.tomonori@lab.ntt.co.jp>
References: <A5F00220-DFD8-41D2-B722-7D274622F44B@gmail.com>
	<20140723.235018.2201605309636499063.fujita.tomonori@lab.ntt.co.jp>
	<CAN05THS9Sb=Oz7H-kUv3K0NuQtAa9E5T4tJABifU1+hezZQBcw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAN05THS9Sb=Oz7H-kUv3K0NuQtAa9E5T4tJABifU1+hezZQBcw@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: markh794@gmail.com, stgt@vger.kernel.org

On Wed, 23 Jul 2014 10:55:56 -0700
ronnie sahlberg <ronniesahlberg@gmail.com> wrote:

> On Wed, Jul 23, 2014 at 7:50 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
>> On Tue, 22 Jul 2014 16:23:54 +1000
>> Mark Harvey <markh794@gmail.com> wrote:
>>
>>> Could this be simply a new backing store type ?
>>
>> Sounds reasonable to me. If we could inject an error dynamically, it
>> would be useful, I think.
> 
> Thanks. That is useful to know.
> 
> I will refactor the code and move the error injection into a new
> backing store instead.  bs_errorinject.c or something.
> 
> Only drawback wiht a backing store I think would be that you can not
> test non-medium access CDBs from it, nor can we error inject on the
> iscsi layer.

Good point. If I remember correctly, there was discussion on using
scsi_debug for such. But I guess that nobody implemented it.

> That said, I do not know if that would be all that useful anyway.
> At this stage I am mainly interested in trying to create a disk with
> failing medium so that we can test scsi initiators and filesystem
> error recovery paths to make both
> easier to test and more robust against medium failures.
> 
> This all depends on if I can reach a stage where people like file
> system developers, raid driver developers etc, will find it useful and
> will want to use it.
> 
> 
> regards
> ronnie sahlberg
> 
> 
>>
>>> Depends on error injection you want/need. If it is scsi command related, should be achievable in backing store. If it's transport related then I could see it being more invasive.
>>>
>>> Another idea would be to hijack send/receive diagnostic op code. Initiator could send "injection commands" via receive diag op code payload & check status etc via send diag
>>>
>>> Sent from my iPhone
>>>
>>>> On 22 Jul 2014, at 7:52, ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>>>>
>>>> List,
>>>>
>>>> I have created a temporary work version of TGTD at:
>>>> https://github.com/rsahlberg/flaky-stgt
>>>>
>>>> This is not a production TGTD or a version that any normal users should use,
>>>> instead I had an idea to try to add features to make it possible to create an
>>>> iSCSI device that is broken and misbehaves in controllable ways.
>>>>
>>>> For example, imagine a scsi disk that is "good" right now but after a
>>>> certain stage in a scripted test the disk goes bad and start failing
>>>> all WRITE commands.
>>>> Just like a disk that suddenly has run out of reallocation space.
>>>>
>>>>
>>>> The only people I see that could find this type of feature useful
>>>> would be, I guess,
>>>> filesystem developers, SCSI initiator midlayer developers or perhaps
>>>> people writing
>>>> code that talks directly to the disk and want to test that their error
>>>> recovery paths
>>>> work.
>>>> I see no use or benefit from these features to normal users.
>>>>
>>>>
>>>> Right now it is a bit in flux, and I also need to see if I can find
>>>> buy-in and convince
>>>> filesystem and block device driver developer folks that this could
>>>> actually be useful to them.
>>>>
>>>> Later on would come the question, should I refactor the code and
>>>> should we push this into STGT mainline?
>>>> I personally think that this usecase I am aiming for is so special
>>>> case, and is only
>>>> features that are useful or relevant to an almost infinitely small set
>>>> of filesystem and block device driver developers that it would not
>>>> make much sense.
>>>> But if the TGTD community would rather have this built-in to official TGTD I am
>>>> more than happy to rework the patches once things stabilize and submit.
>>>>
>>>> This is not a hostile fork. this is a temporary work/scratch space
>>>> while I experiment
>>>> on "broken disk emulation" and while I try to see if there is interest
>>>> in the devlopment community of this as a test tool.
>>>>
>>>>
>>>> If anyone of you think this could be useful, please feel to try it out
>>>> or let your
>>>> filesystem developer friends know that "could you use a scsi disk that
>>>> is 'busted' in controllable ways for your testing?"
>>>>
>>>>
>>>> best regards
>>>> ronnie sahlberg
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe stgt" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe stgt" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
