From: TommyLike Hu <tommylikehu@gmail.com>
Subject: tgtadm get stuck when adding new
Date: Thu, 19 Jan 2017 22:30:17 +0800
Message-ID: <CAE-tKwnwy-FcuxhuLk9i+08WQaLziz-i3_F=TEQZcHHhCRoSRg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cXyTfzTPm9Ir1PzlKkmqevuYQlfruYSzopzIrjLn/z4=;
        b=L/i5NQdqk2pWvJ3gVLhejuGBBOQHmS144TLGJYuJ7gB8pFWEoaTxpySHXP8uoEChPx
         s3MYJ8MWrvLDG6DdsVXlGAHfurAKbfIJrOvmKAJjzS/RUngqQ+FLPV+dGQSIbbXUgM0M
         7ipNngFy0bgR9xR3CSap23MacfEGe/MnepH6cAmjE4IAQlFxvbz3nMT5AM5BQ0wTw99A
         tQR+pgfzWdaCfcJ6oeN6vWIduExfq8u9d3fDxhA8TnoIlggpaGPJ8pWFBU1nfNVmaOLE
         d3xQApJDJpOBQDtPj9uRwvnGIdkxw6ZkQVRFIoWZWn3Bo64NDZnPBpOR9in2SoiCDS/3
         MRsQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hey guys, I am not sure whether I can put my issue here, I am from
openstack cinder project and found a issue about tgtadm tools, let me
describe it here:

0. This is my environment:
```
tgtadm --version
1.0.43
uname -a
Linux SZX1000159695 3.13.0-24-generic #47-Ubuntu SMP Fri May 2
23:30:00 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
```

1. show targets with command: tgtadm --lld iscsi --op show --mode target

output:
```
Target 1: iqn.2010-10.org.openstack:volume-8e414689-990c-4545-bfd7-435cef858513
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
        c5guKcoR7xUjS3KZdzmg
    ACL information:
        ALL

```

2. update target without force option command (if -f option is given,
everything seems good):sudo tgt-admin -u
iqn.2010-10.org.openstack:volume-8e414689-990c-4545-bfd7-435cef858513
-v
output:
```
# default-driver not defined, defaulting to iscsi.

# Removing target:
iqn.2010-10.org.openstack:volume-8e414689-990c-4545-bfd7-435cef858513
tgtadm -C 0 --mode target --op delete --tid=1

# Adding target:
iqn.2010-10.org.openstack:volume-8e414689-990c-4545-bfd7-435cef858513
tgtadm -C 0 --lld iscsi --op new --mode target --tid 1 -T
iqn.2010-10.org.openstack:volume-8e414689-990c-4545-bfd7-435cef858513

```
Then the shell stuck here and get no response. Is this a correct
behaviour? Or anyone have suggestion on this? looking forward to any
response :)

Thanks
TommyLike
