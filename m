From: Xi Tom <xitom900@gmail.com>
Subject: TGT and DPO,FUA
Date: Sun, 9 Nov 2014 17:12:18 +0800
Message-ID: <CAD5Pd4jUgeup0tUU8NpBMUUX=h0rv18oDdDNLgJAgYGa2bATeA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=MYxs1uAaFjflecYgG/WWmjkPrGt4HZufo1MHdJQywx4=;
        b=Ef91C3SPho2D0Qw6KWxJM+IJI+Tg1YoCj4T72/sLDf6DNZVxIbTOPkxawoja/+NHoH
         yUM9YgPwFroaNDs3PDX8hzrF2qTbm28qqmtqgVroXXkbyfYJz7qYEe1KA5jg8fVQ30Fp
         RrFm/XQCoQln9BzamM1rQ++pkb0KX9rJHV9aTZmxsVT7wtVHfEy1Z/33GP65NLPMbg7F
         pXtyjoJyi/TOFfdfa1rX1LOVdq7Y6ko3HWCZ0+RpL8adC2OEvF7W887BU6gUlVSM9QZY
         a0v7mjFpOODY6Kf7aIb7YRjfVp3jUoY5uAHG2eQJ9Pl1yqSfD/U8HnICOo7rbD8j2qG9
         O9Dg==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hi,

I am using tgt as iscsi server, and found linux kernel said that a tgt
scsi target does not support DPO and FUA:

[ 4671.673196] scsi8 : iSCSI Initiator over TCP/IP
[ 4671.928530] scsi 8:0:0:0: RAID              IET      Controller
  0001 PQ: 0 ANSI: 5
[ 4671.928800] scsi 8:0:0:0: Attached scsi generic sg5 type 12
[ 4671.929454] scsi 8:0:0:1: Direct-Access     IET      VIRTUAL-DISK
  0001 PQ: 0 ANSI: 5
[ 4671.930878] sd 8:0:0:1: Attached scsi generic sg6 type 0
[ 4671.932074] sd 8:0:0:1: [sde] 6144000 512-byte logical blocks:
(3.14 GB/2.92 GiB)
[ 4671.932273] sd 8:0:0:1: [sde] Write Protect is off
[ 4671.932277] sd 8:0:0:1: [sde] Mode Sense: 69 00 00 08
[ 4671.932420] sd 8:0:0:1: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA


Why does not tgt support these two features ? but I have found its
source code handle
DPO and FUA flag in its bs_rdwr.c.

Regards,
Tom
