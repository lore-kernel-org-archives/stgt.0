From: Dan Mick <dan.mick@inktank.com>
Subject: Re: poor rbd performance
Date: Fri, 22 Aug 2014 15:17:11 -0700
Message-ID: <53F7C167.4010705@inktank.com>
References: <CAGbvivLncZVGVROR1rEP_=_kRGK7pTBdD9siOXdYJkg-H+bPFw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAGbvivLncZVGVROR1rEP_=_kRGK7pTBdD9siOXdYJkg-H+bPFw@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>, stgt@vger.kernel.org

Hello, name from a past life...

I wrote the original port to rbd, and there was very little attempt to
even consider performance, and certainly no study; it was and is a
proof-of-concept.  I don't know offhand what may be at fault, but I know
it's a target-rich environment, because no one's ever gone hunting at
all to my knowledge.

Several have recommended making use of Ceph async interfaces; I don't
know how much of a win this would be, because stgt already has a pool of
worker threads for outstanding requests.  I also don't know how hard it
is to monitor things like thread utilization inside stgt.

but I'm interested in the subject and can help answer Ceph questions if
you have them.

On 08/22/2014 05:55 AM, Wyllys Ingersoll wrote:
> Im seeing some disappointing performance numbers using the bs_rbd backend
> with a Ceph RBD pool backend over a 10GB Ethernet link.
> 
> Read operations appear to max out at about 100MB/second, regardless of
> block size or amount of data being read and write operations fare much
> worse, maxing out somewhere in the 40MB/second range.   Any ideas why this
> would be so limited?
> 
> I've tested using 'fio' as well as some other perf testing utilities.  On
> the same link, talking to the same ceph pool/image, using librados directly
> (either through the C or Python bindings), the read performance is 5-8x
> faster and write performance is 2-3x faster.
> 
> Any suggestions as to how to tune the iSCSI or bs_rbd interface to perform
> better?
> 
> thanks,
>   Wyllys Ingersoll
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
