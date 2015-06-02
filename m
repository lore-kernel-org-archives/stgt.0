From: Ahmed Al-Mehdi <ahmedalmehdi@gmail.com>
Subject: Error when creating a logicalunit from a regular file
Date: Tue, 2 Jun 2015 14:47:48 -0700
Message-ID: <CAKNWCPb+GZcSaJ1QB8OE392HCm6Xi6s3OvgFzVxNRiiRgM3S_w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=rrhAw7/XkSUnZsPCk7/jx9XbJr5xY/TCHr90NFK/+rU=;
        b=WxhBnx1AgiFw8bvidqawcw7Ol5bMoqumT18cDlhU9GWdVjvbKfxPCe3PuGzfo18j9a
         I5KD6y/zZJXzzjyc0D+IYA+abs5n5RKomeZbbrHqBiB4LJkg37hWkDa8jgthO5NAZY7a
         soXFU9lIyrtZJR/RC+4/lFpURiw7qBVQDG0NnJHroJoFu+B/CpNlb90jPjbIHj2LPg9f
         wU5d/iiU2bCpGxplV7iMaAO25ic/JxAHEKbk/eAxz5iGQKlYuqWezfp7pOWWkrMHUylO
         dinWJN94VCBVur0KnOUP4gVRfSgyvbjONaAdp92KvwPwYWoAO8S2bwIbZB24pEb/CFKQ
         Jd4Q==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hello,

I am trying to setup tgt on a CentOS 7 system.    I created a target,
and enabled "ALL" initiators to login.  When I try to create a logical
unit from a regular file (which I believe is supported and should
work), I get the error message "tgtadm: invalid request".   In the
logs, I see an error message related to "Permission denied".  Can
someone please help or give me pointers to debug this issue.  Please
CC me in the response.


# tgtadm --mode target --op new --tid 1 --targetname target1
# tgtadm --mode target --op bind --tid 1 -I ALL
# tgtadm --mode target --op show
Target 1: target1
    System information:
        Driver: iscsi
        State: ready
    I_T nexus information:
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: IET     00010000
            SCSI SN: beaf10
            Size: 0 MB, Block size: 1
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: null
            Backing store path: None
            Backing store flags:
    Account information:
    ACL information:
        ALL


# ls -l /tmp/tgt_disk2_dd
-rwxrwxrwx. 1 root root 1048576 Jun  2 14:18 /tmp/tgt_disk2_dd

# tgtadm --lld iscsi  --mode logicalunit --op new --tid 1 --lun 2  -b
/tmp/tgt_disk2_dd
tgtadm: invalid request


I see the following log entries:

Jun 02 14:39:46 unknown0800275C3F01 tgtd[5505]: tgtd: device_mgmt(246)
sz:23 params:path=/tmp/tgt_disk2_dd
Jun 02 14:39:46 unknown0800275C3F01 tgtd[5505]: tgtd: bs_thread_open(412) 16
Jun 02 14:39:46 unknown0800275C3F01 tgtd[5505]: tgtd:
backed_file_open(92) Could not open /tmp/tgt_disk2_dd, Permission
denied
Jun 02 14:39:46 unknown0800275C3F01 tgtd[5505]: tgtd:
backed_file_open(92) Could not open /tmp/tgt_disk2_dd, Permission
denied


Thank you very much in advance,
Ahmed.
