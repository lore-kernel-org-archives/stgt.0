From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] Handle access of a target that has been removed
Date: Wed, 25 Nov 2015 21:06:14 -0800
Message-ID: <56569346.6090804@suse.com>
References: <561D4909.8040006@suse.com>
 <20151017.215737.1568838937885765085.fujita.tomonori@lab.ntt.co.jp>
 <56251296.7000600@suse.com>
 <20151028.142854.1568838937885774624.fujita.tomonori@lab.ntt.co.jp>
 <564636E6.1020801@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <564636E6.1020801@suse.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org

Hi:

Response below ...

On 11/13/2015 11:15 AM, Lee Duncan wrote:
> On 10/28/2015 06:28 AM, FUJITA Tomonori wrote:
>> On Mon, 19 Oct 2015 08:56:06 -0700
>> Lee Duncan <lduncan@suse.com> wrote:
>>
>>> On 10/17/2015 05:57 AM, FUJITA Tomonori wrote:
>>>> On Tue, 13 Oct 2015 11:10:17 -0700
>>>> Lee Duncan <lduncan@suse.com> wrote:
>>>>
>>>>> Hello:
>>>>>

>>>>> I recently got a report of a tgtd core dump from our opencloud
>>>>> group. The stack trace showed that a strcmp against a NULL was causing
>>>>> the failure:
>>>>>
>>>>> ...
>>>>>
>>>>> It looks like target_find_by_name() uses tgt_targetname(), but doesn't
>>>>> account for the fact that it can return a NULL when the target being
>>>>> looked up does not (now) exist:
>>>>
>>>> Thanks for theI supplied a patch you appliedI supplied a patch you applied patch. But I'm confused why this happens. target with
>>>> the same tid as iscsi_target must exist?
>>>>
>>>
>>> No, I believe this is happening because the targets are getting
>>> dynamically removed. But I will verify that. Because if tgt_targetname()
>>> can return a NULL (as apparently it did this time), there are probably
>>> other places in the code that need to check for that.
>>
>> Ok, I'm still confused but applied the patch. Let's see if it would
>> help.
>>
>> Thanks,
> 
> I am still trying to look more deeply into how this could happen.
> 
> This bug was triggered when using cloud storage as the back-end for for
> their target, and that cloud storage "goes away". (I am still trying to
> determine what that actually means.) If so, I should be able to simulate
> by allowing my back-end storage to go away.
> 
> As you say, let's see if we see any other instances of tgt_targetname()
> returning null, in other spots in the code.
> 

I thought that you might like to know that I finally tested this. I
created a test bed where I randomly created and deleted 4 target nodes
by changing the configuration files then running "tgt-admin --update
ALL -f".

At the same time, I randomly attempted to log out of then back into
all 4 targets.

It only takes a minute to hit the case the patch I sent fixes, where
target_find_by_name() dies when tgt_targetname() returns an unexpected
NULL. It was nice to validate that the patch was actually needed.

You might remember, though, that I was worried that other places where
tgt_targetname() where used might need to check for NULL as well. So
I tested for that.

Surprisingly, none of the other places that uses tgt_targetname() ever
got NULL back. I tested for several hours. So either I just didn't hit
the corner case needed to tickle such a bug, or that just doesn't
happen. I would love to investigate further, but I may not have the
time to get to it soon. In the mean time, it appears we are in good
shape.
-- 
Lee Duncan
