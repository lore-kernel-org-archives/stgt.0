From: Forza <forza@tnonline.net>
Subject: New user of tgtd
Date: Fri, 14 Jul 2023 17:07:25 +0200 (GMT+02:00)
Message-ID: <80102ab.d19c822c.18954f143dc@tnonline.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

I am a new user of tgtd. I am intending to replace LIO with tgtd because it's a user-space target.

My use-case is to export files to remote initiators, so I will be using the backing-store option.

I have been trying to go through the docs and examples but I have some questions I'd like to clarify.

* aio driver. Does this mean tgtd won't pass down flush/barrier requests from initiators (like in LIO)? I. E. data loss on power failure?
* I am using btrfs on the target server and I'd like to use the thin_provisioning option. Am I correct in that this has to be enabled via "params  thin_provisioning=1" in the backing-store section?
* Is there a way to hint to the initiators that the LUN is non-rotational? Some OSes use this parameter to adjusts its internal io scheduling.
* i notice that tgtd uses 16 IO threads no matter the number of cpus. Is there a guideline on a suitable number for my use-case?
* Is ErrorRecoveryLevel=1/2 implemented in tgtd so that supporting clients transparently can recreate the connection after interruption or target restarts?
* the targets.conf.5.xml doesn't seem to include all available options. I am glad for the examples which helped me get going :)

I also noticed the following warning:

tgtd: bs_init_signalfd(267) could not open backing-store module directory /usr/lib/tgt/backing-store

I created the dir, but can't see it is actualky being used. What is the purpose of this directory?

Thanks,

~ Forza
