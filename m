From: Scott Friedman <friedman@cass.idre.ucla.edu>
Subject: abort_task_set / abort_cmd problems
Date: Wed, 9 Dec 2015 15:46:44 -0800
Message-ID: <CADTz74ym8gHUw8pOm0NHgrnJBNdHk7uQy+5xAhD3rYT6VVuKWQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cass-idre-ucla-edu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=Fpq+iPqfdfOyoSHHiJ9P2ieYEL6dJksM8BamlZmBVY8=;
        b=iyyXjs+gM7VmvIGBVh1kqPhIxt9VJdfgXvVR1ze0YxLTruWtw/GLKxpAhsxBTTTO21
         z3yd4m6uDnUThVUBf9aIUU3vl2xZVzVrfoTVrrV7arfEdV8o6kUWcEZOytCG7NmgtcFG
         wRmkyjzcguaFcJgUjUCdJEsJC8fsUv4Uaf7H4OGXrlO/zImwshAAw8T9o1ZBb/EnPHKH
         tvDabd3esLel+hv956kDRPfgnQ8fMtVVXtz92XrZRWvr+S+ATwHltW79sterdsFYu8op
         Z2qgZ76tPlLN75ZLZNsa86m/zhFrEjfeQmOC9u/18DBnT+sfFQ5xPqAJEoe8DLTYCWi0
         FbQg==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt <stgt@vger.kernel.org>

Hi

I am running tgtd-1.0.54 currently (centos 6.7,
2.6.32-573.7.1.el6.x86_64) and under heavy load to a single target and
LUN my log fills up with:

Dec  8 08:09:44 library3 tgtd: abort_task_set(1348) found 0 0
Dec  8 08:09:44 library3 tgtd: abort_cmd(1324) found 3c7e0700 6
Dec  8 08:09:44 library3 tgtd: abort_cmd(1324) found d97c0700 6
Dec  8 08:09:44 library3 tgtd: abort_cmd(1324) found c0820700 6
<snip>
Dec  8 08:09:44 library3 tgtd: abort_cmd(1324) found 77800700 6
Dec  8 08:09:44 library3 tgtd: abort_cmd(1324) found e17f0700 6
Dec  8 08:10:04 library3 tgtd: conn_close(92) already closed 0x2495ab0 3

This sequence will happen every minute or so under writes from the
initiator (a windows 2008 r2 server). The backing store is a ZFS ZVOL
and it does not report any issues.

As time goes on the the system load continues to increase (I have seem
it in the low teens on a dual core VM).

The result of this is that there ends up being a lot of (I guess)
stale sessions - which are unremovable. The only we have found to
truely get rid of them is to reboot.

    I_T nexus information:
        I_T nexus: 2
            Initiator: iqn.blahblah alias: none
            Connection: 1
                IP Address: 1.2.3.4
        I_T nexus: 4
            Initiator: iqn.blahblah alias: none
            Connection: 1
                IP Address: 1.2.3.4
        I_T nexus: 6
            Initiator: iqn.blahblah alias: none
            Connection: 1
                IP Address: 1.2.3.4
        I_T nexus: 7
            Initiator: iqn.blahblah alias: none
            Connection: 1
                IP Address: 1.2.3.4

The fact that some of the sid seem to be gone makes me think that
sometimes the sessions get removed properly and some do not. The
initiator does complain about timeouts that correspond to the logging
above.

I figured it is time to run tgtd in debug mode but do not know what
level to use or what to look for.

Any pointers would be very appreciated as we cannot keep this system
up for more than a couple hours.

Thanks,
Scott
