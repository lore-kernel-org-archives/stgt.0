From: Mr Dini <diniboy74@gmail.com>
Subject: open-iscsi Cannot connect to my tgt target
Date: Sat, 31 Dec 2016 10:30:46 +0100
Message-ID: <CANVNt1axh1GoC28Y+Ztph_=gQP1zHeG-8BDdW47onAFX3dSH9Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=UIBqJOvMCYFM7dxmUT7/DykucEwQFnnRot9S7dzJ3Xk=;
        b=V2NdZ92YQxJ43GNnFT4M/pwiblSwUT4LgHHJnMj0oxKDSzGBJh8eTks0myuqcvchRq
         aYrjLZYNkjw/eUTKoG0pkJJhMSZyG7aWDSAfBGVtsVyUW2hMWhmy9IXFHnzoZM4RKO3/
         kkUenUZEaMXvfB+I8R8bCUelGzGbNplqY0G4y8jTTn/L9VCAZ0eg14oRDi/ceRJhsVcR
         TPGCp/ISVJmT6amK+aasuXet07vbTFVcUQg0a1vXAnizPk4FBn2sZnnRsDaAiGw7+8HH
         DJCNJX6L8uyVhYFUY+yTUtmm2D+y+rmS3cRiONVT6j92f5BVjo3M8R4LWNRVcOcUnrvB
         bd/w==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hi,

i am new at the iSCSI's wonderful world, So please ignore my noobness...

I wanted to install the tgt to my ARM NAS, So I had to compile the
source and create a package. That was successfull. :)

After it, I configured a target to a simple test environment, see here
(http://pastebin.com/u24gZ6JC).

But when I try to login, using open-iscsi on my Ubuntu 16.04v desktop,
it gives me the following error:

sudo iscsiadm -m node --login
Logging in to [iface: default, target: iqn.<secret>:<secret>, portal:
10.0.0.27,3260] (multiple)
iscsiadm: Could not login to [iface: default, target:
iqn.<secret>:<secret>, portal: 10.0.0.27,3260].
iscsiadm: initiator reported error (24 - iSCSI login failed due to
authorization failure)
iscsiadm: Could not log into all portals

What Can I Do?

Many thanks!
