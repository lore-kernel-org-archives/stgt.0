From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Fix broken MMC emulation
Date: Tue, 19 Aug 2014 20:00:08 -0700
Message-ID: <1408503609-11688-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=9wZvgfkz+BB1rnmIMfoUNfPE3adO9gkJ/ukFe5Kq7oQ=;
        b=yBVrBE+Wyhn2cogNiMYVCwsohOxxkagSuQ8SzM5P/8OguhjZxDhQ0OUL4xbkRpmrV5
         uGYWPnZHrqkRKH6M+OeIKEL0qoICWjLTT4NUoxi1TOnGDT82Tyq3gAiGeZIVI2LhpODd
         OmyqmBUb9bJEF9Mj/3EZGUFum8l2ItVbP3Hq5YBeq7bJ/PdFbcNaIiFlyRVI6IFSMeXh
         oPsJfg2gPxEofHIZE4GNDpVdrlpbFkBhQybNqK1DBJeUHA2o6a/YAR/utcl+7toqaBBQ
         zxsX8n6CkYQcPRPOt7l+mqzdbTcRSDuZC//I4V3Z0mreykfBIYNHdY6C4L0zfiXOcDZR
         AWKg==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

List, Tomo,

Please find a patch that repairs MMC.

MMC emulation has been broken for a while, and it saddens me that no one
has complained since it means no one is using it :-(


We need to add the MMC specific opcodes to the map of SUPPORTED_OPCODES we
build for the MMC backend since we share this backend with SBC.
Otherwise the target will return INVALID_OPCODE for some of the key
opcodes needed for the medium discovery.

With this patch MMC emulation works again.


Ronnie Sahlberg (1):
  bs_rdwr.c: add missing MMC opcodes to the backing store defs

 usr/bs_rdwr.c |   10 ++++++++++
 usr/scsi.h    |    9 +++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

-- 
1.7.3.1
