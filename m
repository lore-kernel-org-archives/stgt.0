From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Allow setting the IPC socket via environment variable
Date: Thu, 30 Apr 2015 18:29:11 -0700
Message-ID: <1430443752-30929-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=UKxmfWXnr2BqMzKjPwc/ZukTKnKpJB+ibrlnWomwLhc=;
        b=TXH5YB0+jMkJHfiPeL1QULQyX0Sb2eqlrBNzDayN5XgOtqAtYILsuu3eWJoqq7PoSp
         2S8KNQRdSNLzq/AWhE4fCUDdsM+8Hf6Hw+d5B1zFd8VcgT/4ynQHwn340wJyQHuUP/tI
         53/pnBHOTT4YQiBQZI31XPzdsWnb1tywoBaESXAXWExc/nzQrA1LVuTWUYLOSJlbpJkQ
         wuZaEoc0FB7JifGLN6i+5IOn1Arox4Nkzkjoq/VUXRF2Wopk9EFPqLfPwdPBCFKoJhpT
         u/4FOe6NjSyP/412Xv9ur02onlT+e4kCdgFnH+ekiRj+vlTKb1acaWb4c6/OnstSQLYv
         FecA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

List, Tomo

Another small patch. This time to set the IPC socket for TGTD and TGTADM
via the TGT_IPC_SOCKET environment variable.
This is useful for example for my libiscsi tests since it allows
spinning up a local TGT daemon just for 'make test'

regards
ronnie sahlberg


