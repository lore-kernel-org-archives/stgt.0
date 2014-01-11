From: nia dev <niadev67@gmail.com>
Subject: tgt-admin utility not working anymore
Date: Sat, 11 Jan 2014 16:16:49 -0500
Message-ID: <CAM0v-CCfGKpHfSLN=EyaLv62eeUWYn6GVNu5b_ewv-ZHdZaD_Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=1DGD53en6aHnrnXBSzkvw87dblHhFLqKAPdZMW3UuKc=;
        b=JWqu22LYkpqbxp5MrlF6MonxbNV45XIy4F2hltc0MQzFfrFovrpMIlFpGnJJRYQ4wK
         z3YACn2cC9dzwFA9ASaXtFmhi3hj+Kgeht9q2xywuLthrbVGjujImNdbZJeDdbPLVhfH
         x69TkJXN3yUhmF5oZPqKtoMDLIJAgwYBINoP30VnI7mL2S+DvKxMSArYBKsyJMWpTz7B
         dppPSFMTBF0VHpnnAi8XRO4Z/etZjAPwq5Flktaltdm1Ixf6QmhIZx2QRcE77hybMFhi
         H25L19/ea43HbbXDr5HNbd36J+i0hf6ST7u+wd+fOs2BOG3bX+YoidLW9NYVeR/ZC5gY
         O1VA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hi,

This used to work ... Any idea ?

# tgt-admin --dump
-C argument value '0' out of range
Try `tgtadm --help' for more information.

All other options produce an error also.

Thanks
