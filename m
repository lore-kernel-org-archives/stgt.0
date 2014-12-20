From: Fritz Stauffacher <fritzstauff@gmail.com>
Subject: Sendtarget Multiple IP's
Date: Sat, 20 Dec 2014 00:09:14 -0500
Message-ID: <CALTLVXH44vUNR=aLfvY15Bqw4DHJabuDXDUZQ+WKPedJ0=vTJg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=3bcVu1zmpGeOopgWTpsrFLPMkpMqkgMtBI71Rj0sN14=;
        b=dkpG4GBbACtnp3hqH1D0Dnvz57LxBjE3QhN7rmMYd42MJDQ7mhAy7LWVlxTsEKv6Fn
         airtIUY07AuoNPi9wcubEnThi7PkmRlsm+OlziWRsDLbBgImhzKVge1aIoPAxcAwS98g
         0DVvNNR8N4z8jaMcFThQn7CTjuHmix0iMbXsQoeKcNFbJ5iFfmIJSxjHWWInG7mYIOJ+
         8QnDS0VUiWwFSy6rd2B1q223vBm76UN5c6CclUDoHpVuAteEw7yUvBoAp4Kwr7pcJO43
         u7tpLbnwhcrff0vlhWqtn1HdiCQw9A6OviURiJb+hcDCjhLwOEubd7QU8YdNbgCo4U1d
         itDA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt <stgt@vger.kernel.org>

I was wondering if it was possible to configure tgt to send all
available portal IP's when 'sendtargets' is requested. Currently
Openstack Cinder does not support Multipath unless all Portal IP's are
sent.


 iscsiadm -m discovery -t sendtargets -p 192.168.2.10
192.168.2.10:3260,1
iqn.2010-10.org.openstack:volume-8ea27c0d-ea6e-4059-9d65-232e07d8717f
192.168.2.10:3260,1
iqn.2010-10.org.openstack:volume-9e8afcd5-c6eb-4e4f-826b-49fc1e693235
192.168.2.10:3260,1
iqn.2010-10.org.openstack:volume-323fe78a-c98f-4f16-9b12-ec59c0c7b297
192.168.2.10:3260,1
iqn.2010-10.org.openstack:volume-da560d9c-2d4a-488e-b3f9-b6a6f17a140e


 iscsiadm -m discovery -t sendtargets -p 10.0.65.10
10.0.65.10:3260,1
iqn.2010-10.org.openstack:volume-8ea27c0d-ea6e-4059-9d65-232e07d8717f
10.0.65.10:3260,1
iqn.2010-10.org.openstack:volume-9e8afcd5-c6eb-4e4f-826b-49fc1e693235
10.0.65.10:3260,1
iqn.2010-10.org.openstack:volume-323fe78a-c98f-4f16-9b12-ec59c0c7b297
10.0.65.10:3260,1
iqn.2010-10.org.openstack:volume-da560d9c-2d4a-488e-b3f9-b6a6f17a14


Cinder is working on a patch for the issue I describe at
review.openstack.org/#/c/134681/
