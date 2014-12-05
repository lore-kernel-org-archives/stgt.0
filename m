From: Andy Grover <agrover@redhat.com>
Subject: Re: new comer questions on tgt,lio-utils and iscsitarget
Date: Fri, 05 Dec 2014 11:42:09 -0800
Message-ID: <54820A91.20105@redhat.com>
References: <1785a48b-abb3-4262-97ff-c7bf6951804a@googlegroups.com> <c16aa0b5-3c31-4287-a41c-436af3b54896@googlegroups.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <c16aa0b5-3c31-4287-a41c-436af3b54896@googlegroups.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: open-iscsi@googlegroups.com
Cc: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

On 12/04/2014 01:13 PM, The Lee-Man wrote:
> On Tuesday, December 2, 2014 6:59:02 PM UTC-8, pilla...@gmail.com wrote:
>     1 \ both lio-utils and tgt are pure user space program? Both of them
>     are using the kernel iscsi module ? So ,what is the difference
>     between them?
>
> No, I believe the "tgt" (or stgt) package uses a user-space daemon, but
> it only handles administration of connections. The transport is handled
> by the kernel. See http://stgt.sourceforge.net

Actually the website is a little out of date. stgt moved to entirely 
userspace, around 2011.

-- Andy
