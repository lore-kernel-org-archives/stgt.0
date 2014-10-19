From: eric pretorious <epretorious@gmail.com>
Subject: Re: Basic Configuration Troubles
Date: Sat, 18 Oct 2014 19:06:13 -0700
Message-ID: <CAHtv24Ur8ko8Z__6SqAudF8OAVzC+PRK0bjv1aMmF4h_Uuem4w@mail.gmail.com>
References: <CAHtv24UiOOSx2F5cOmaPxXtQzrnVCfOQTOvm2euQFQbz33ZLtA@mail.gmail.com>
	<CAHtv24U4JUqLh2spTP2sEmUgQWYVerYYx+w0b+aBo3NfWzDhmw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=M81NgHj6qhzmS1bn5whJsVEVuX7JZmZJ4rdfPDGTXh8=;
        b=jID5AH+eDcbtnG6cZbdZAqvurVqtlhfdR7DRp5imuOfhPgCZUXm3+zO1OayhZhjy3V
         mHwJUTQl2IlG4mNW7K632seq/f61EsS49gpok/oBGLSpH7jRiLEh2Uv3pTONFQL+/D/a
         ASUjwS2pS7Xd1fZgZ4vTCJ1Ayf44/RuJJu8xmW3vLJtT19QQtebgeLrmqqWwBAFm5hot
         GIiIW4ENENrRXxTflxOXdnYNZxohunzmyH1sPXle8qy3Kzx6hlzRCEP6Ge6sB6SntKuv
         bBJdHw6xr//EXd+r9egeVjV2q7GCioYa4J89378AYtkA6gPPijdfIYRaPmGtFM0tWpQt
         Dc4Q==
In-Reply-To: <CAHtv24U4JUqLh2spTP2sEmUgQWYVerYYx+w0b+aBo3NfWzDhmw@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

AFAICT, the problem was the status of the DRBD resource "r0"
_at_the_time_that_tgtd_was_started_. i.e., fixing the status of the
DRBD resource without restarting tgtd doesn't seem to change the
behavior of tgtd.

I noticed that after restarting aoe-1.example.com (192.168.56.101)
that the resource "r0" was in secondary mode...

> [root@aoe-1 ~]# drbd-overview
>  0:r0/0  Connected Secondary/Secondary UpToDate/UpToDate

...so I promoted aoe-1.example.com to primary:

> [root@aoe-1 ~]# drbdadm primary r0
>
> [root@aoe-1 ~]# drbd-overview
>  0:r0/0  Connected Primary/Secondary UpToDate/UpToDate

...and then I restarted tgtd:

> [root@aoe-1 ~]# /etc/init.d/tgtd stop
> Stopping SCSI target daemon:                               [  OK  ]
>
> [root@aoe-1 ~]# /etc/init.d/tgtd start
> Starting SCSI target daemon:                               [  OK  ]

...then, on the initiator, I disconnected from the session and cleared
the open-iscsi database:

> [root@clvm-1 ~]# iscsiadm -m node -u all
> Logging out of session [sid: 13, target: iqn.2014-09.com.example.san-1:drbd0, portal: 192.168.56.101,3260]
> Logout of [sid: 13, target: iqn.2014-09.com.example.san-1:drbd0, portal: 192.168.56.101,3260] successful.
>
> [root@clvm-1 ~]# iscsiadm -m node -o delete all

Meanwhile, on the target, everything continued to appear normal:

> [root@aoe-1 ~]# tgtadm --lld iscsi --mode target --op show
> Target 1: iqn.2014-09.com.example.san-1:drbd0
>     System information:
>         Driver: iscsi
>         State: ready
>     I_T nexus information:
>     LUN information:
>         LUN: 0
>             Type: controller
>             SCSI ID: IET     00010000
>             SCSI SN: beaf10
>             Size: 0 MB, Block size: 1
>             Online: Yes
>             Removable media: No
>             Prevent removal: No
>             Readonly: No
>             Backing store type: null
>             Backing store path: None
>             Backing store flags:
>         LUN: 1
>             Type: disk
>             SCSI ID: IET     00010001
>             SCSI SN: beaf11
>             Size: 535 MB, Block size: 512
>             Online: Yes
>             Removable media: No
>             Prevent removal: No
>             Readonly: No
>             Backing store type: rdwr
>             Backing store path: /dev/drbd0
>             Backing store flags:
>     Account information:
>     ACL information:
>         ALL

After re-discovering the targets and logging-in again:

> [root@clvm-1 ~]# iscsiadm -m discovery -t sendtargets -p aoe-1.example.com
> 192.168.56.101:3260,1 iqn.2014-09.com.example.san-1:drbd0
>
> [root@clvm-1 ~]# iscsiadm -m node -T iqn.2014-09.com.example.san-1:drbd0 -l
> Logging in to [iface: default, target: iqn.2014-09.com.example.san-1:drbd0, portal: 192.168.56.101,3260] (multiple)
> Login to [iface: default, target: iqn.2014-09.com.example.san-1:drbd0, portal: 192.168.56.101,3260] successful.
>
> [root@clvm-1 ~]# iscsiadm -m session -P3
> iSCSI Transport Class version 2.0-870
> version 6.2.0-873.10.el6
> Target: iqn.2014-09.com.example.san-1:drbd0
>     Current Portal: 192.168.56.101:3260,1
>     Persistent Portal: 192.168.56.101:3260,1
>         **********
>         Interface:
>         **********
>         Iface Name: default
>         Iface Transport: tcp
>         Iface Initiatorname: iqn.1994-05.com.redhat:645e14dfb4
>         Iface IPaddress: 192.168.56.103
>         Iface HWaddress: <empty>
>         Iface Netdev: <empty>
>         SID: 14
>         iSCSI Connection State: LOGGED IN
>         iSCSI Session State: LOGGED_IN
>         Internal iscsid Session State: NO CHANGE
>         *********
>         Timeouts:
>         *********
>         Recovery Timeout: 120
>         Target Reset Timeout: 30
>         LUN Reset Timeout: 30
>         Abort Timeout: 15
>         *****
>         CHAP:
>         *****
>         username: <empty>
>         password: ********
>         username_in: <empty>
>         password_in: ********
>         ************************
>         Negotiated iSCSI params:
>         ************************
>         HeaderDigest: None
>         DataDigest: None
>         MaxRecvDataSegmentLength: 262144
>         MaxXmitDataSegmentLength: 8192
>         FirstBurstLength: 65536
>         MaxBurstLength: 262144
>         ImmediateData: Yes
>         InitialR2T: Yes
>         MaxOutstandingR2T: 1
>         ************************
>         Attached SCSI devices:
>         ************************
>         Host Number: 16    State: running
>         scsi16 Channel 00 Id 0 Lun: 0
>         scsi16 Channel 00 Id 0 Lun: 1
>             Attached scsi disk sdb        State: running

...the LUN is available on the initiator.  =D

-- 
Eric Pretorious
+1.530.386.3649

> On Sat, Oct 18, 2014 at 11:16 AM, eric pretorious <epretorious@gmail.com> wrote:
>>> [root@aoe-1 ~]# tgt-admin -s
>>> Target 1: iqn.2014-09.com.example.san-1:drbd0
>>>     System information:
>>>         Driver: iscsi
>>>         State: ready
>>>     I_T nexus information:
>>>     LUN information:
>>>         LUN: 0
>>>             Type: controller
>>>             SCSI ID: IET     00010000
>>>             SCSI SN: beaf10
>>>             Size: 0 MB, Block size: 1
>>>             Online: Yes
>>>             Removable media: No
>>>             Prevent removal: No
>>>             Readonly: No
>>>             Backing store type: null
>>>             Backing store path: None
>>>             Backing store flags:
>>>         LUN: 1
>>>             Type: disk
>>>             SCSI ID: IET     00010001
>>>             SCSI SN: beaf11
>>>             Size: 535 MB, Block size: 512
>>>             Online: Yes
>>>             Removable media: No
>>>             Prevent removal: No
>>>             Readonly: No
>>>             Backing store type: rdwr
>>>             Backing store path: /dev/drbd0
>>>             Backing store flags:
>>>     Account information:
>>>     ACL information:
>>>         ALL



-- 
Eric Pretorious
+1.530.386.3649
