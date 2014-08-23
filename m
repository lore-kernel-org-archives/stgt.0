From: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>
Subject: Re: poor rbd performance
Date: Sat, 23 Aug 2014 09:46:37 -0400
Message-ID: <CAGbvivL4gNSZwOKbGvEQ=4oi5bwKm02hxrFQBvVDc-MCv1FTsA@mail.gmail.com>
References: <CAGbvivLncZVGVROR1rEP_=_kRGK7pTBdD9siOXdYJkg-H+bPFw@mail.gmail.com>
	<53F7C167.4010705@inktank.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <53F7C167.4010705@inktank.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Mick <dan.mick@inktank.com>
Cc: stgt@vger.kernel.org

Hey Dan, its always good to hear from another former Sun eng.

I saw your blog posts about the RBD backend and it seems to work as
advertised.  I don't know if the rados aio calls will make it better
or not.  I do know that it is possible to get better throughput using
the standard IO functions (the ones you used) because all of the
non-iSCSI tests we've done just use the standard rbd_read/rbd_write
calls just like bs_rbd.  It might be an architectural limitation in
tgtd, but I am not familiar enough with the tgtd code yet to know
where to look for the bottlenecks.  I tried changing the timing
interval in 'work.c' to be much shorter, but it didn't make a
difference.  When I enabled some debug logging, I see that the maximum
data size that the tgtd read or write operation handles is only 128Kb,
which is something that may be worth tracking down, perhaps theres a
way to make it ask for bigger chunks of data.  We've even tried
changing the replication on the ceph pool to 1 (just for testing
purposes) to eliminate the duplication from the equation, but its not
making much difference in this situation.

I might try modifying the code to use the aio calls to see how it
goes, it might yield some interesting results if I add some timing
measurements, and maybe it will end up being faster.

Any suggestions for further ceph tuning or other areas in tgtd to look
at for possible problems?

thanks,
  Wyllys



On Fri, Aug 22, 2014 at 6:17 PM, Dan Mick <dan.mick@inktank.com> wrote:
> Hello, name from a past life...
>
> I wrote the original port to rbd, and there was very little attempt to
> even consider performance, and certainly no study; it was and is a
> proof-of-concept.  I don't know offhand what may be at fault, but I know
> it's a target-rich environment, because no one's ever gone hunting at
> all to my knowledge.
>
> Several have recommended making use of Ceph async interfaces; I don't
> know how much of a win this would be, because stgt already has a pool of
> worker threads for outstanding requests.  I also don't know how hard it
> is to monitor things like thread utilization inside stgt.
>
> but I'm interested in the subject and can help answer Ceph questions if
> you have them.
>
> On 08/22/2014 05:55 AM, Wyllys Ingersoll wrote:
>> Im seeing some disappointing performance numbers using the bs_rbd backend
>> with a Ceph RBD pool backend over a 10GB Ethernet link.
>>
>> Read operations appear to max out at about 100MB/second, regardless of
>> block size or amount of data being read and write operations fare much
>> worse, maxing out somewhere in the 40MB/second range.   Any ideas why this
>> would be so limited?
>>
>> I've tested using 'fio' as well as some other perf testing utilities.  On
>> the same link, talking to the same ceph pool/image, using librados directly
>> (either through the C or Python bindings), the read performance is 5-8x
>> faster and write performance is 2-3x faster.
>>
>> Any suggestions as to how to tune the iSCSI or bs_rbd interface to perform
>> better?
>>
>> thanks,
>>   Wyllys Ingersoll
>> --
>> To unsubscribe from this list: send the line "unsubscribe stgt" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
