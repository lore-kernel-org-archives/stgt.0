From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Sendtarget Multiple IP's
Date: Sun, 21 Dec 2014 23:45:19 +0900 (JST)
Message-ID: <20141221.234519.1568838937885777801.fujita.tomonori@lab.ntt.co.jp>
References: <CALTLVXH44vUNR=aLfvY15Bqw4DHJabuDXDUZQ+WKPedJ0=vTJg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CALTLVXH44vUNR=aLfvY15Bqw4DHJabuDXDUZQ+WKPedJ0=vTJg@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: fritzstauff@gmail.com
Cc: stgt@vger.kernel.org

On Sat, 20 Dec 2014 00:09:14 -0500
Fritz Stauffacher <fritzstauff@gmail.com> wrote:

> I was wondering if it was possible to configure tgt to send all
> available portal IP's when 'sendtargets' is requested. Currently
> Openstack Cinder does not support Multipath unless all Portal IP's are
> sent.

You run two tgtd daemons, that is, one per an interface?

>  iscsiadm -m discovery -t sendtargets -p 192.168.2.10
> 192.168.2.10:3260,1
> iqn.2010-10.org.openstack:volume-8ea27c0d-ea6e-4059-9d65-232e07d8717f
> 192.168.2.10:3260,1
> iqn.2010-10.org.openstack:volume-9e8afcd5-c6eb-4e4f-826b-49fc1e693235
> 192.168.2.10:3260,1
> iqn.2010-10.org.openstack:volume-323fe78a-c98f-4f16-9b12-ec59c0c7b297
> 192.168.2.10:3260,1
> iqn.2010-10.org.openstack:volume-da560d9c-2d4a-488e-b3f9-b6a6f17a140e
> 
> 
>  iscsiadm -m discovery -t sendtargets -p 10.0.65.10
> 10.0.65.10:3260,1
> iqn.2010-10.org.openstack:volume-8ea27c0d-ea6e-4059-9d65-232e07d8717f
> 10.0.65.10:3260,1
> iqn.2010-10.org.openstack:volume-9e8afcd5-c6eb-4e4f-826b-49fc1e693235
> 10.0.65.10:3260,1
> iqn.2010-10.org.openstack:volume-323fe78a-c98f-4f16-9b12-ec59c0c7b297
> 10.0.65.10:3260,1
> iqn.2010-10.org.openstack:volume-da560d9c-2d4a-488e-b3f9-b6a6f17a14
> 
> 
> Cinder is working on a patch for the issue I describe at
> review.openstack.org/#/c/134681/
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
