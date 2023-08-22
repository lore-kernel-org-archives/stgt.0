From: Forza <forza@tnonline.net>
Subject: Daemon not immediately available after start.
Date: Tue, 22 Aug 2023 14:14:04 +0200 (GMT+02:00)
Message-ID: <ffaa7cb.1727b74a.18a1d2a93f0@tnonline.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

I have taken over as maintainer for the tgt package (scsi-tgt) in Alpine Linux.

On Alpine we like to split packages to keep their footprint small. I have written an init script in two parts, one for the tgtd daemon and one for tgt-admin that loads the config file. I assume some people use tgtadm directly instead of tgt-admin and the config files.

I have one issue during launch of the tgtd, which is that it starts and returns ok to init system, which now tries to load the config via tgt-admin. This, however, sometimes fails. I saw that the same issue was documented in Gentoo, which solved the issue by adding a one second delay after starting tgtd, before issuing tgtadm or tgt-admin commands.

I think this is not an ideal situation as it is conceivable that an initiator tries to connect during that second, but finds an empty target.

Is there a good solution for this? 
* can tgtd wait until it is fully ready for connections from tgtadm before returning to shell/init system?
* or can tgtd start in offline mofd, and we can keep the one second delay before activating again via tgtadm?

Thanks,

~ Forza
