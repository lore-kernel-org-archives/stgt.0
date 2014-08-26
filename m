From: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>
Subject: Re: poor rbd performance
Date: Tue, 26 Aug 2014 14:23:15 -0400
Message-ID: <CAGbvivLcjs2YcJShdvNSm-Je8+q52pgFmzxWUGm2dW4dABd+Og@mail.gmail.com>
References: <CAGbvivLncZVGVROR1rEP_=_kRGK7pTBdD9siOXdYJkg-H+bPFw@mail.gmail.com>
	<53F7C167.4010705@inktank.com>
	<CAGbvivL4gNSZwOKbGvEQ=4oi5bwKm02hxrFQBvVDc-MCv1FTsA@mail.gmail.com>
	<20140825.082506.1305564732068193901.fujita.tomonori@lab.ntt.co.jp>
	<CAGbvivLfVUobJTwXSRX4q=4jC9iwkJtUvMRz8kZKGQaCHEY9Bg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAGbvivLfVUobJTwXSRX4q=4jC9iwkJtUvMRz8kZKGQaCHEY9Bg@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Dan Mick <dan.mick@inktank.com>, stgt@vger.kernel.org

I dont think using RBD AIO makes much difference.  The bs worker
thread ultimately has to block until the backend request handler
completes before it can put the cmd structure back in the queue  (see:
 bs_thread_worker_fn in bs.c).  If the request handler function in
bs_rbd returns before the asynchronous call has actually completed,
the data gets corrupted and it eventually crashes.

So, changing to using the rados aio functions didnt matter, but
bumping up the nr_threads from 16 to 64 made a significant difference.
On a multi-processor/multi-core system it might make sense to raise
that value way up to maximize the request handling.

On Sun, Aug 24, 2014 at 11:38 PM, Wyllys Ingersoll
<wyllys.ingersoll@keepertech.com> wrote:
> On Sun, Aug 24, 2014 at 7:25 PM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
>> Hello,
>>
>> On Sat, 23 Aug 2014 09:46:37 -0400
>> Wyllys Ingersoll <wyllys.ingersoll@keepertech.com> wrote:
>>
>>> Hey Dan, its always good to hear from another former Sun eng.
>>>
>>> I saw your blog posts about the RBD backend and it seems to work as
>>> advertised.  I don't know if the rados aio calls will make it better
>>> or not.  I do know that it is possible to get better throughput using
>>> the standard IO functions (the ones you used) because all of the
>>> non-iSCSI tests we've done just use the standard rbd_read/rbd_write
>>> calls just like bs_rbd.  It might be an architectural limitation in
>>> tgtd, but I am not familiar enough with the tgtd code yet to know
>>> where to look for the bottlenecks.  I tried changing the timing
>>> interval in 'work.c' to be much shorter, but it didn't make a
>>> difference.  When I enabled some debug logging, I see that the maximum
>>> data size that the tgtd read or write operation handles is only
>>> 128Kb,
>>
>> You mean that the read/write size from iSCSI initiators is 128K? If
>> so, probably it's due to your configuration. tgt doesn't have such
>> limit. iSCSI has lots of negotiation parameters between an initiator
>> and a target, which affects the performance. You need to configure
>> both properly to get good performance.
>
>
>
> I believe the initiator is from open-iSCSI.  I have tried changing
> some settings but apparently haven't found the right ones that will
> make a difference.
>
>
>
>>> Any suggestions for further ceph tuning or other areas in tgtd to look
>>> at for possible problems?
>>
>> I would suggest you to work on a simpler backend like bs_null to know
>> the best performance of tgt on your env. I think that the first step
>> is knowing where is the bottleneck.
>
>
> Thanks, I'll take a look.
