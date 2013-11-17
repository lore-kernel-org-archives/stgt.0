From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Add an array that describes which opcodes are supported by backends
Date: Sat, 16 Nov 2013 17:18:25 -0800
Message-ID: <1384651106-18407-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=KYTw6BYvHTMftMtJzXv5Kp1ZSTBGPhxUKL89lr9Oy0E=;
        b=atqvHysDn8jBPrCLohL9Ls+TPKx3mmgOtw7G17k8dVf+1g1ySSaWefi4/wdOcimN17
         jE1eJxhXzsjv0ngfpFHp3xEoXYXitNB0rOzq96Fhis/pCynVmMCKDl8XAPe3+2S1/87T
         py8zWQvRSWe/Y1IAvzX1vJ2yJ/8YkAGGpvsV8J63U9JuWpIdE//Phh+8/2l+OwgC1xt7
         4MoOtkHJ4+Tv0qf3ecQ18rTvtIci9cNu2Rd4UgGVjYqroGGgElRuVBOzcE+09KA1aQr0
         GSgaf2KQ3UqKJcJzbn64g3UL9L2H/f+V9BrtowHJh9nWJF7DfdioRBhnL6zUeUGi0Fis
         mccA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

Tomo, List

Please find a new version of the patch to add per-backend bitmap to control
which opcodes are supported and which are not.

This version is changed to keep a 32 byte bitmap for the 256 opcodes instead of
using a 256 byte array.

Please review, apply.


regards
ronnie sahlberg
