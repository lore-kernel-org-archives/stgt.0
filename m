From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Authorizing iSCSI access by IQN
Date: Tue, 22 Sep 2015 12:29:56 -0700
Message-ID: <CAN05THRjt=fhdMJ8NuNy3ReSi9zoovxupfmHZ6raruOJ=r4AWA@mail.gmail.com>
References: <8079a8c67d1d4e4c98d67c4794b4e9a9@int-exch6.int.inetu.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=5UEoB8QwpwT+9ScWcSuB6WeafQwfUUK86VQnLz0FhR8=;
        b=f1SbNxgpgRn9V3YDHh7/dfbrtOf9Dcn1lfhZs9Sxxy92NeWXLI52PBaa/MmuvhtB/d
         DqV3Z/SlV4U2XZmWbFE2cauxKrlxcX2L3noHeQyH8k3a3nHmzFbAxPVa3W02DzkS+gsa
         TvKaXKWgVK/GMEtkeSJcc6RgUV+HKWLOdKD0x+we8/CI1vp/LU+uqtCb9+eSQrKwWphI
         lJrk5DlJMc//8kNgglyvpEVlEP4V1u7N/1ugrIrfLdrkd9jbhwpiTiq6FXhbEYFUy3Fr
         VHfpwwH6fdJHYOQVyLY6eaiT/mBbvxh2fr82DpT7XI7kzA4K+VwsfxkAphUhwLXHHvFA
         1Cuw==
In-Reply-To: <8079a8c67d1d4e4c98d67c4794b4e9a9@int-exch6.int.inetu.net>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jon Heese <jheese@inetu.net>
Cc: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

Change initiator-address to initiator-name

initiator-address is for specifying an ip address to allow access from.
initiator-name is to specify the iqn name to allow access from.


See
http://linux.die.net/man/5/targets.conf



On Tue, Sep 22, 2015 at 8:57 AM, Jon Heese <jheese@inetu.net> wrote:
> Hello,
>
> I am attempting to use tgtd to provide iSCSI storage for a (large) group of initiators who are given IPs with DHCP, and thus cannot be relied upon to be static.  As such, I'd like to authorize access to the storage LUs based on the IQNs on each initiator.  For example:
>
> <target iqn.storage.server:target02>
>         backing-store /var/iscsi.file02
>         initiator-address iqn.1996-12.net.inetu:server-name.domain.net-r4zsbpwh2nfy
> </target>
>
> However, when I connect an initiator with that IQN, they don't see any LUs.  If I remove the "initiator-address" restriction, or change it to "ALL" or the IP or subnet of the initiator, the LUs show up and work properly, albeit without sufficient access control.
>
> On a RHEL6 initiator, using iscsi-initiator-utils-6.2.0.873-14, I get the following:
> [root@jheese-rhel6 ~]# iscsiadm -m discovery -t sendtargets -p 10.174.1.101
> iscsiadm: No portals found
>
> And on Windows 2012 R2, I get the following:
> "No Targets available for Login using Quick Connect."
>
> Can anyone help me to troubleshoot what's going wrong here?  Any suggestions of ways to gain more insight into what's happening?
>
> FYI, I'm running tgtd 1.0.60, cloned from the git repo and built from scratch (because I needed the capability of using RBD backing-stores, and I couldn't find any CentOS 7 packages/repos that would provide that).
>
> Thanks in advance!
>
> Jon Heese
> Systems Engineer
> INetU Managed Hosting
> P: 610.266.7441 x 261
> F: 610.266.7434
> www.inetu.net
>
> ** This message contains confidential information, which also may be privileged, and is intended only for the person(s) addressed above. Any unauthorized use, distribution, copying or disclosure of confidential and/or privileged information is strictly prohibited. If you have received this communication in error, please erase all copies of the message and its attachments and notify the sender immediately via reply e-mail. **
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
