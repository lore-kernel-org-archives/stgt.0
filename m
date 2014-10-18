From: eric pretorious <epretorious@gmail.com>
Subject: Basic Configuration Troubles
Date: Sat, 18 Oct 2014 11:16:01 -0700
Message-ID: <CAHtv24UiOOSx2F5cOmaPxXtQzrnVCfOQTOvm2euQFQbz33ZLtA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=I1GWZ1QpJGJljzJV4D+Yo9i6HWP6hhm50IesyQPeLJw=;
        b=clR7PLa4uYKZlAnk40rmE0ppEqljdS60ylKchmr8x6rtY7juORZ6dU0AyOgcAyGSoD
         1HxsXuv3MIrAErBAGqUXNHYtpaiqiM/BPkENlvPMlxeF+G6on2T7Ebbq76etoOz11RcH
         cVElD8pVXisLQtVeKAvc8Odk2kMjheJzJURm2X8Bw5iYDj7tWTxuQoQq0eNGtPXuZNTF
         F4/psL3dtX+JY2oCs1Ng6bSeuCdh8Ir0ef6DI+JC4mVp7qBz26qRvNyA8h1/8VMbck6D
         AsTuT5kRPTn9PlWDujJCgyEI8fBsrg/0/3jaxkmA5iWqeaaI1h+eS3M1zA25jV556/ks
         dI4A==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hello:

I'm having some difficulty configuring tgt and I need your help: I've
added this stanza at the bottom of /etc/tgt/targets.conf...

> [root@aoe-1 ~]# grep -v '#' /etc/tgt/targets.conf
> <target iqn.2014-09.com.example.san-1:drbd0>
>     backing-store /dev/drbd0
> </target>

...and verified that it had the intended effect:

> [root@aoe-1 ~]# tgt-admin -s
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

However, when using iscsiadm to login to the target, LUN 1 isn't
available on the initiator:

> [root@clvm-1 ~]# iscsiadm -m session
> iscsiadm: No active sessions.
>
> [root@clvm-1 ~]# iscsiadm -m discovery -t sendtargets -p san-1.example.com
> 192.168.56.120:3260,1 iqn.2014-09.com.example.san-1:drbd0
>
> [root@clvm-1 ~]# iscsiadm -m node -T iqn.2014-09.com.example.san-1:drbd0 -p san-1.example.com -l
> Logging in to [iface: default, target: iqn.2014-09.com.example.san-1:drbd0, portal: 192.168.56.120,3260] (multiple)
> Login to [iface: default, target: iqn.2014-09.com.example.san-1:drbd0, portal: 192.168.56.120,3260] successful.
>
> [root@clvm-1 ~]# iscsiadm -m session -P3
> iSCSI Transport Class version 2.0-870
> version 6.2.0-873.10.el6
> Target: iqn.2014-09.com.example.san-1:drbd0
>     Current Portal: 192.168.56.120:3260,1
>     Persistent Portal: 192.168.56.120:3260,1
>         **********
>         Interface:
>         **********
>         Iface Name: default
>         Iface Transport: tcp
>         Iface Initiatorname: iqn.1994-05.com.redhat:645e14dfb4
>         Iface IPaddress: 192.168.56.103
>         Iface HWaddress: <empty>
>         Iface Netdev: <empty>
>         SID: 11
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
>         Host Number: 13    State: running
>         scsi13 Channel 00 Id 0 Lun: 0
>
>
> [root@clvm-1 ~]# tail /var/log/messages
> ...
> Oct 17 05:37:11 clvm-1 kernel: scsi13 : iSCSI Initiator over TCP/IP
> Oct 17 05:37:11 clvm-1 kernel: scsi 13:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
> Oct 17 05:37:11 clvm-1 kernel: scsi 13:0:0:0: Attached scsi generic sg2 type 12
> Oct 17 05:37:12 clvm-1 iscsid: Connection11:0 to [target: iqn.2014-09.com.example.san-1:drbd0, portal: 192.168.56.120,3260] through [iface: default] is operational now

What have I overlooked?

TIA,
Eric Pretorious
