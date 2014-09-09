From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] SMC: add a 32 byte volume tag to storage slots
Date: Mon,  8 Sep 2014 21:19:48 -0700
Message-ID: <1410236389-21112-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=y7MGimTV+SvRMMldvdtUkpa5ffoQeJSz8ekMYKIls9I=;
        b=d5EC4pvm8rf7QWRB4/72QWLlEM03U8qK8Rwre0+LXQd/vPlHL5+35V1PgIl0YYOb1A
         hWbLBYsyCz6A5jdvjrhM7/2zoKnaHaJ5eJrAa4NMFetyW/U4fda+u3o6EtTy+G1VxM30
         3tZadmxeUOsf86cnUzRtBJcB7Sb4KbCbUfEVOO7RHUbDVRdHCHTj18F0pxvzlH6d+XZG
         jJRHD405mUzSixqXCd3Bf5ZV6Ogp5/mL68RPQi9h5I0LWPt5FPvi02Qo8jKoBXdDWxR+
         RpX2e9OSAiwB9F2dYPxF7SE5q68qrdipw9s7Yq6EvFXdX6NpqYOrm8EermbFfG1NKCh1
         nWWw==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>

List, Tomo,

Please find a small patch that adds a new argument to SMC storage slots
to set the volume tag for the medium.
This allows to use the full 32 bytes for the volume tag which is much more
descreptive to a human user than the 10 character barcode we currently use.


Ronnie Sahlberg (1):
  SMC: add a new volume_tag parameter to storage slots

 doc/README.dvdjukebox |   29 ++++++-----------------------
 doc/tgtadm.8.xml      |   17 ++++++++++++++---
 usr/smc.c             |   25 +++++++++++++++++++------
 usr/smc.h             |    5 ++++-
 4 files changed, 43 insertions(+), 33 deletions(-)

-- 
1.7.3.1
