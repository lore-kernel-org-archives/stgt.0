From: Ahmed Al-Mehdi <ahmedalmehdi@gmail.com>
Subject: Pass through device support in tgt
Date: Tue, 2 Jun 2015 19:02:59 -0700
Message-ID: <CAKNWCPa8isRsGB0HhW0EE4c65qOPay8cD96wRpO=7yVFSm1Rxg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=oDu5FKosc82YH3WWjeA8EQMKK8W8lnqFAWX6zCPGGo8=;
        b=k8VkGl3KRbEPff3GPxH+Uw+OdMpLQ3Y8Kgs+pqasVcRFux8VenCN3uhDzt+hTp6Z77
         Ky0rfGA2U6kVb+wYK6w1LcBmcgZOAIRydQd7asy0PcrJaerhn7LC7UtkvnlRsBYYiVzG
         deAHPcQP0Ldsshq/o2Zh0PtR/nSqBGAmcA1PHfunJ/U7HTUKsmWkdPpvSLGnkHAOPIrp
         j6WtRseP3kpvND0xoFpTw3GdaUPXD4f5XL0q2eFlfNvtGUB/+JWONlYeddmZbX/oS8zc
         JPYIi9jIHwjyrvoDDUoCBv3Au5IREvxkKxaCeRylctdZnI0/U5VzLZBgwXNwW/7Edmm2
         KDVw==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hello,

I am trying to understand the passthrough device support of tgt.  For
a regular block device, to create a LU I use the following command ( I
explicitly stated the default values below):

tgtadm --mode logicalunit --op new --tid 1 --lun 1 --device-type disk
--bstype rdwr --backing-store  /dev/sdb

The above command takes the block device "/dev/sdb" and exports it as
LU 1 to the initiator.
- What does it mean the tgt "creates a device of type disk"  Creates
where, internal to tgt?
- What is the implication of that? Is it how the SCSI commands coming
over iSCSI is treated/handled  (with respect to caching, buffering,
read ahead, etct)? Or something else?

The following example is cited in  the man pages for a passthrough:

tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1
--bstype=sg --device-type=pt --backing-store=/dev/sg4

- How does the "bstype" affect the handling of the SCSI commands?
Does this affect how the IO to the actual device is done (manipulated
before sending to the actual device)?
- What does it mean for the backend storage type to be sg?

Really appreciate any help / pointers.

Regards,
Ahmed.
