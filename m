From: Jon Heese <jheese@inetu.net>
Subject: Problems with targets.conf syntax
Date: Wed, 23 Sep 2015 18:22:37 +0000
Message-ID: <3e3e0c715f06419c84f8883fcd102b1b@int-exch6.int.inetu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

Hello,

I'm using tgtd 1.0.60 on CentOS 7 to provide iSCSI targets on top of Ceph RBD storage, and I'm having some trouble working out the proper targets.conf syntax to make it work how I want...

So here's a snippet of my current targets.conf:

<target iqn.1996-12.net.inetu.ceph-storage01>
        bs-type rbd
        <backing-store cmikolay-sqlcluster_mssql>
                initiator-name iqn.1996-12.net.inetu:cmikolay-winlab.cslabs.inetu.net-r4zsbpwh2nfy
        </backing-store>
        ...
</target>

This works on a basic level - that is, it provides an iSCSI LUN for the "cmikolay-sqlcluster_mssql" RBD device, but the "initiator-name" directive appears to be being ignored.  If I switch from the container format to the inline format, i.e.:

<target iqn.1996-12.net.inetu.ceph-storage01>
        bs-type rbd
       backing-store cmikolay-sqlcluster_mssql
       initiator-name iqn.1996-12.net.inetu:cmikolay-winlab.cslabs.inetu.net-r4zsbpwh2nfy
        ...
</target>

Then the ACL by IQN works, but I can't add any more LUs to that target without breaking the ACL.

What I'm looking for is a way to have a single target with multiple LUNs under it, each ACL'd to a set of IQNs.  Does anyone know of a way to do this?  Thanks in advance!

Jon Heese
Systems Engineer
INetU Managed Hosting
P: 610.266.7441 x 261
F: 610.266.7434
www.inetu.net

** This message contains confidential information, which also may be privileged, and is intended only for the person(s) addressed above. Any unauthorized use, distribution, copying or disclosure of confidential and/or privileged information is strictly prohibited. If you have received this communication in error, please erase all copies of the message and its attachments and notify the sender immediately via reply e-mail. **
