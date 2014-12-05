From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Report DPO/FUA support to the initiators for SBC devices
Date: Fri,  5 Dec 2014 06:51:58 -0800
Message-ID: <1417791119-30801-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=KvIruH18IFH71oz5+ILvu+P1meTe9Ii34KcyNGjtpvo=;
        b=v5V9MuTO8mXEqHZYL3W6wt5y9LgRj57tl0S6ZYWWJOcvYVXNY3c9evgDmFKjLUDOyy
         UScOO8tXloi/OhoYGNo+QWrIS/Ia0kzOHQXSqdZNqjA35V0gTuODaTtIrqYItgSCwsv1
         0LNhjESoNb/rJ60ua7rF9Uz4VWmE7AVt2+BTeTxiabiCC4DqPKHktHMaLjfjcNRm+xow
         OeBkpfzOzxzSSMYszOFQXk0gXm6UZPS6kEAL4LVuImyxEpTSkIuoVUaGOUtThwRtnIwI
         Vu7Dj6yMRRRlg1m2M+iDq1renHvgghFLNNqPuaqPydh/eDf49JCWCwFAMM4T0iJdvl59
         0xRw==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>


List,

A little while ago there was some questions about why TGTD did not report
DPO to the targets. There is no real good reason why we do not do that,
especially since we already implement DPO logic for the target for SBC devices
using the bs_rdwr.c backend.

This patch refactors the mode sense function for SBC sligtly and makes it
always repotr PDO/FUA. The end result is that initiators now become aware that
we do support these flags and thus we can start manage the target host
page cache a little more efficient.

ronnie sahlberg

Ronnie Sahlberg (1):
  sbc.c: report DPO/FUA support in modesense datain

 usr/sbc.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

-- 
2.1.0
