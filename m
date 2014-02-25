From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Fix ReportSupportedOpcode command to set the opcode
Date: Mon, 24 Feb 2014 19:15:08 -0800
Message-ID: <1393298109-16052-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=gJXEF2w6s/THtTnOJyBJXKLi5wW0Yz7gWt21rJOPb2Q=;
        b=MEmnWE7wGpjVR38n7/I6OZtmCySXDMp0XhHWO79/1U5MyW99LhZGPBdjQwe8whlH89
         MBh+d7wzEs8z1vWxfKq2Vm9f16U5cCXmcvT1U5igiCSCYx9PiJvaAL8wn4ppiL3mSaUt
         e8rZm1AyBCFm4IAgJoMv73Pu7GSy+pzenNFNEpW1LXHfVD55sg+t0eDAh4qQSmI+QZ1E
         hAwOnQEkBzfIpCgnoEWp9Uev8aY/rxkowGl5FxGMUE2QaplfBiU0+B8L8SdvO+R77nGJ
         zBIx6Jnfp1bL1x40Wm7rtdrW/Rd8+eA6nc59XkaI2cgY5S6T3G+oog3Pj+npXethHEnS
         srGQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

List, Tomo

Please find a small patch to fix the REPORT SUPPORTED OPCODES command.
The first byte of the CDB USAGE FIELD should be the opcode number itself and not 0xFF.
There is also a test for this in libiscsi which is referenced from the commit message.
Commit message also references the relevant part of SPC which describes this byte.

regards
ronnie sahlberg
