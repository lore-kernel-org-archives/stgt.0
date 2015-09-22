From: Jon Heese <jheese@inetu.net>
Subject: Authorizing iSCSI access by IQN
Date: Tue, 22 Sep 2015 15:57:20 +0000
Message-ID: <8079a8c67d1d4e4c98d67c4794b4e9a9@int-exch6.int.inetu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

Hello,

I am attempting to use tgtd to provide iSCSI storage for a (large) group of initiators who are given IPs with DHCP, and thus cannot be relied upon to be static.  As such, I'd like to authorize access to the storage LUs based on the IQNs on each initiator.  For example:

<target iqn.storage.server:target02>
        backing-store /var/iscsi.file02
        initiator-address iqn.1996-12.net.inetu:server-name.domain.net-r4zsbpwh2nfy
</target>

However, when I connect an initiator with that IQN, they don't see any LUs.  If I remove the "initiator-address" restriction, or change it to "ALL" or the IP or subnet of the initiator, the LUs show up and work properly, albeit without sufficient access control.

On a RHEL6 initiator, using iscsi-initiator-utils-6.2.0.873-14, I get the following:
[root@jheese-rhel6 ~]# iscsiadm -m discovery -t sendtargets -p 10.174.1.101       
iscsiadm: No portals found

And on Windows 2012 R2, I get the following:
"No Targets available for Login using Quick Connect."

Can anyone help me to troubleshoot what's going wrong here?  Any suggestions of ways to gain more insight into what's happening?

FYI, I'm running tgtd 1.0.60, cloned from the git repo and built from scratch (because I needed the capability of using RBD backing-stores, and I couldn't find any CentOS 7 packages/repos that would provide that).

Thanks in advance!

Jon Heese
Systems Engineer
INetU Managed Hosting
P: 610.266.7441 x 261
F: 610.266.7434
www.inetu.net

** This message contains confidential information, which also may be privileged, and is intended only for the person(s) addressed above. Any unauthorized use, distribution, copying or disclosure of confidential and/or privileged information is strictly prohibited. If you have received this communication in error, please erase all copies of the message and its attachments and notify the sender immediately via reply e-mail. **
