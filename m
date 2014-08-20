From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Fix for MMC so it works again
Date: Wed, 20 Aug 2014 16:45:37 -0700
Message-ID: <1408578338-9262-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=F7KQry/zThxWHNQVPXcF9iLesEWgfstEd45Xcd/g/6Y=;
        b=MVrYxyld22Y2dwT0wzgiErRFD0Pa9tfzprmkk1doQsyeU0gQIt7MAXRprzgvmncEkZ
         oEv+uduhIa/eZO+W0oedQsFO8uWGgQxGdAc1siN923PWq+T65/bFen36gUcb8cR4tIML
         4m6RBAfEVBd7sfPWaLeB7YDZLE6Hu4WdA5Jy2T4z8jGItDDkcnxOJwJQjzNT37Y7xNUb
         K1r04TF+Cb0UFqU52v6+7xK4UWi3VgkLKJxsfWhuhMuZpnq+IHb5sZ+avpgVe48nNxEZ
         20QaoYSnQy7QJCqW1qgWEYc98DSrfbA6bMMb6owJzzYcFWdSYedWY1L96xZc6xRyjiTR
         zzgA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>


List, Tomo,
Please disregard the patch I sent yesterday. This is a better solution
to the MMC is broken problem.

This patch adds a new backend "mmc" which we now use for MMC devices.
The real solution is probably not by patching the SBC whitelist as
the previous patch did but rather to add a new dedicated backend
and whitelist for MMC devices.


Please review/apply
Ronnie Sahlberg


Ronnie Sahlberg (1):
  MMC: add a dedicated backend for MMC so that supported-opcode map
    works

 usr/bs_rdwr.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 usr/mmc.c     |    6 +++---
 usr/scsi.h    |    9 +++++++++
 3 files changed, 62 insertions(+), 7 deletions(-)

-- 
1.7.3.1
