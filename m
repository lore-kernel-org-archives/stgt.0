From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Problems with targets.conf syntax
Date: Thu, 24 Sep 2015 09:25:41 -0700
Message-ID: <CAN05THSUDeW9PSqtQGo2S1ajdbVSruaTUN_EFocrBYBUMyDzHA@mail.gmail.com>
References: <3e3e0c715f06419c84f8883fcd102b1b@int-exch6.int.inetu.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=IiyF0OXDUejwGttKcZsgHi8A9ic8ojbE/5AAzdX/Nhg=;
        b=b8argn1WKgUwk6hTs2VjgkBRfceAPF1AhawdWPkDcv0Zl7hxvAGs1emY8Cm+k+yEbF
         iG/BJUOF2wd9VfFxVYlTpuT3Q83DDMsrCIGCycgMz8gQSGxNkGXu2uLzLeV5GUNRjupb
         PK/4HN/9Hm8s4wR02S7PTcgkzefhDoqCtAV3cWZQvnZRmLTlzp455QAbhSZB+5XFCp5y
         mGHKK1fTqDAi6/zKsWqnk1D3baBExqhXl0TzgsIOT0saYkVbWDQE1QJwfib8oOSsAQky
         oiwckPY580jHktGFKj7EYSOIt2Vmxg3iFSykf9GAwHfcYfVr9SoppWBeAmt8alLOtqUG
         y2iw==
In-Reply-To: <3e3e0c715f06419c84f8883fcd102b1b@int-exch6.int.inetu.net>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jon Heese <jheese@inetu.net>
Cc: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

On Wed, Sep 23, 2015 at 11:22 AM, Jon Heese <jheese@inetu.net> wrote:
> Hello,
>
> I'm using tgtd 1.0.60 on CentOS 7 to provide iSCSI targets on top of Ceph RBD storage, and I'm having some trouble working out the proper targets.conf syntax to make it work how I want...
>
> So here's a snippet of my current targets.conf:
>
> <target iqn.1996-12.net.inetu.ceph-storage01>
>         bs-type rbd
>         <backing-store cmikolay-sqlcluster_mssql>
>                 initiator-name iqn.1996-12.net.inetu:cmikolay-winlab.cslabs.inetu.net-r4zsbpwh2nfy
>         </backing-store>
>         ...
> </target>
>
> This works on a basic level - that is, it provides an iSCSI LUN for the "cmikolay-sqlcluster_mssql" RBD device, but the "initiator-name" directive appears to be being ignored.  If I switch from the container format to the inline format, i.e.:
>
> <target iqn.1996-12.net.inetu.ceph-storage01>
>         bs-type rbd
>        backing-store cmikolay-sqlcluster_mssql
>        initiator-name iqn.1996-12.net.inetu:cmikolay-winlab.cslabs.inetu.net-r4zsbpwh2nfy
>         ...
> </target>
>
> Then the ACL by IQN works, but I can't add any more LUs to that target without breaking the ACL.
>
> What I'm looking for is a way to have a single target with multiple LUNs under it, each ACL'd to a set of IQNs.  Does anyone know of a way to do this?  Thanks in advance!

I am not sure you can do that.  Afaik the ACLs are per target level
and not per LUN.
So if you want different LUNs for different initiators and have ACLs
to protect access you will need to use multiple targets.


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
