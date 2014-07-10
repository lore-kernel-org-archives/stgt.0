From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: what do these abort_cmd(1324) and abort_task_set(1348)
 messages in the logs mean?
Date: Thu, 10 Jul 2014 09:14:35 +0900 (JST)
Message-ID: <20140710.091435.1305564732068198316.fujita.tomonori@lab.ntt.co.jp>
References: <53BD4E8E.9030900@powercraft.nl>
	<20140709.231656.1568838937885785702.fujita.tomonori@lab.ntt.co.jp>
	<53BD52AE.6030206@powercraft.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <53BD52AE.6030206@powercraft.nl>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jelledejong@powercraft.nl
Cc: stgt@vger.kernel.org

On Wed, 09 Jul 2014 16:33:18 +0200
Jelle de Jong <jelledejong@powercraft.nl> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Dear FUJITA,
> 
> On 09/07/14 16:16, FUJITA Tomonori wrote:
>> On Wed, 09 Jul 2014 16:15:42 +0200 Jelle de Jong
>> <jelledejong@powercraft.nl> wrote:
>> 
>>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>>> 
>>> Dear FUJITA,
>>> 
>>> On 27/06/14 13:57, FUJITA Tomonori wrote:
>>>> On Tue, 17 Jun 2014 12:24:07 +0200 Jelle de Jong 
>>>> <jelledejong@powercraft.nl> wrote:
>>>> 
>>>>> What do these tgtd messages mean? Is something wrong? Why
>>>>> are they there?
>>>>> 
>>>>> http://paste.debian.net/105427/
>>>> 
>>>> A SCSI command was aborted for some reason (e.g. the time-out
>>>> of a SCSI command due to the overloaded iscsi target).
>>>> 
>>>> The cricial bug about this was fixed in 1.0.48. I would
>>>> recommend you to update tgt if you use the older version.
>>> 
>>> I upgraded to version 1.0.48 about a week ago for further
>>> testing, I also added a complete new network path, with new
>>> network cards and direct connections, but I keep getting these
>>> same errors:
>>> 
>>> http://paste.debian.net/108884/
>>> 
>>> Is this a bug in tgtd? Is there some tgtd option or environment 
>>> variable that I can set to get more information.
>> 
>> It's not a bug. It's just a message tells that SCSI command
>> time-out happens for some reasons.
> 
> Can you help me with some more information to solve the problems?
> 
> Is this SCSI command time-out something that happened on the target
> server with the storage, my storage is having a hard time with high
> latencies, but I am not having any hardware warnings/errors. Or is
> this related to the iSCSI client servers as well?

Without any hardware errors, a target could takes long time to execute
SCSI commands (e.g., simply overloaded). It depends on your
environment.

You could set a longer value for SCSI command time-out on the client
side.
