From: Alexey Amerik <alexey.amerik@gmail.com>
Subject: tgtd tuning, poor performance at low throughput
Date: Mon, 27 Jan 2014 15:28:36 -0500
Message-ID: <CAKqJfTvUqO9e8LnZt5ysdZ=gh8sS0XizA-ieJaOgAkbvFm6VaQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=A6sYFBalHxvsD+cMPqpM7dlvQ7PdUAzoa8O1WUoA2CI=;
        b=GlVYXGSjudwzb4wOXb0HOKeFIyHc5nUWp87mg5RxuazIm+yjuLUSC1wRQ7zDgQcftE
         3pNoXiZ+BeboqMGktGeijvj2mxIHRcusjrTFQOqebq6jVXpIVy63V19zhI2V2SBObDTC
         peba2eYwwWXdNGZ7moYm1YwbghlSL4T9lpqMAJvZh3ir3jjtNsseOoUKkF+7E42onQyG
         laCRFaJDhafuAegVyVDH5uaK3UtGgJ8aHwT8kJfh4/4b7sU3Jc0kcke8ZGHJcfSxilMY
         3vN7udjjcbLNULgCuS0RNLyF1JyJm7C/Of5oOZHCz2fBtLAbiNiypBFz+mIdQbI5Nm46
         Eb3w==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hi folks,

I'm having high machine load on the tgtd side, and would like to ask
for help tuning.

background on hardware:
I have a 10 disk sw-raid10 array setup with mdadm on CentOS 6, 2
(dual)x6core E5-2620 0 @ 2.00GHz, 32GB ram target machine, dedicated
gigabit interfaces multipathed, and jumbo frames mtu 9000 between my
target/switch/initiators.

I plan to use this for KVM storage.  Local IO performance tested with
bonnie++ is ~ 250MB/sec for random writes, with minimal CPU load
during the test.

However after I introduced tgtd and iscsi into the mix, even at speeds
of ~10MB/sec coming from the initiators, my target machine load is
very high 10-15.  The load seems to be due to tgtd.

Can someone please help me tune tgtd? Thanks in advance!

target.conf:

default-driver iscsi
<target iqn.2014-01.com.foo.us1.storage1:vmstorage>
    backing-store /dev/md2
    initiator-address 192.168.84.29  #kvm5
    initiator-address 192.168.85.29  #kvm5
    initiator-address 192.168.84.78  #kvm6
    initiator-address 192.168.85.78  #kvm6
    initiator-address 192.168.84.76  #kvm7
    initiator-address 192.168.85.76  #kvm7
    write-cache off
</target>


iscsi initiator side:


[aamerik@kvm5 ~]$ iscsiadm -m session -P 3
iSCSI Transport Class version 2.0-870
version 6.2.0-873.10.el6
Target: iqn.2014-01.com.foo.us1.storage1:vmstorage
Current Portal: 192.168.84.77:3260,1
Persistent Portal: 192.168.84.77:3260,1
**********
Interface:
**********
Iface Name: default
Iface Transport: tcp
Iface Initiatorname: iqn.1994-05.com.redhat:65274b4cae8e
Iface IPaddress: 192.168.84.29
Iface HWaddress: <empty>
Iface Netdev: <empty>
SID: 1
iSCSI Connection State: Unknown
iSCSI Session State: LOGGED_IN
Internal iscsid Session State: Unknown
*********
Timeouts:
*********
Recovery Timeout: 120
Target Reset Timeout: 30
LUN Reset Timeout: 30
Abort Timeout: 15
*****
CHAP:
*****
username: <empty>
password: ********
username_in: <empty>
password_in: ********
************************
Negotiated iSCSI params:
************************
HeaderDigest: None
DataDigest: None
MaxRecvDataSegmentLength: 262144
MaxXmitDataSegmentLength: 8192
FirstBurstLength: 65536
MaxBurstLength: 262144
ImmediateData: Yes
InitialR2T: Yes
MaxOutstandingR2T: 1
************************
Attached SCSI devices:
************************
Host Number: 7 State: running
scsi7 Channel 00 Id 0 Lun: 0
scsi7 Channel 00 Id 0 Lun: 1
Attached scsi disk sdb State: running
Current Portal: 192.168.85.77:3260,1
Persistent Portal: 192.168.85.77:3260,1
**********
Interface:
**********
Iface Name: default
Iface Transport: tcp
Iface Initiatorname: iqn.1994-05.com.redhat:65274b4cae8e
Iface IPaddress: 192.168.85.29
Iface HWaddress: <empty>
Iface Netdev: <empty>
SID: 2
iSCSI Connection State: Unknown
iSCSI Session State: LOGGED_IN
Internal iscsid Session State: Unknown
*********
Timeouts:
*********
Recovery Timeout: 120
Target Reset Timeout: 30
LUN Reset Timeout: 30
Abort Timeout: 15
*****
CHAP:
*****
username: <empty>
password: ********
username_in: <empty>
password_in: ********
************************
Negotiated iSCSI params:
************************
HeaderDigest: None
DataDigest: None
MaxRecvDataSegmentLength: 262144
MaxXmitDataSegmentLength: 8192
FirstBurstLength: 65536
MaxBurstLength: 262144
ImmediateData: Yes
InitialR2T: Yes
MaxOutstandingR2T: 1
************************
Attached SCSI devices:
************************
Host Number: 8 State: running
scsi8 Channel 00 Id 0 Lun: 0
scsi8 Channel 00 Id 0 Lun: 1
Attached scsi disk sdc State: running

-- 
Alexey Amerik
