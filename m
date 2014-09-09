From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] SMC fixes
Date: Mon,  8 Sep 2014 19:53:08 -0700
Message-ID: <1410231190-28735-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=p0OnV14abv9UJZ1M4RMQGjWxFs8GUAWz8mnWiggwcD0=;
        b=zc4i3zNE9I6M855IrWeWNsx+SSP1CX0Z5O6TN78886g7oPSNKPjtWJWbFcaDckeRZD
         hr4mDIfVlDcxUxGzeS6BYJqIKh2ShIN/tYkRILTJTDO1QNpWQs+JP1Q8mdYDNgI16WvD
         vH4bp4SMdcoQZ091w5IF0JJAYyhuKqd+xTMjQqDgYWnwC0TAqtqLzVyUWCiAT0QL+JDF
         f3xAocSyg2zStaL2MSdmPWS/KXeQ0lEooP+/WEJZx0uCCe9RDIibvR8fEfvVGza5Bl8u
         j/h0a6M71RIDJeh7qAFEsnjCrXjYh02uq3/6sNhcydhlSSaaLFVGxV5n2dEhwtV+EP5S
         hxUw==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>

List, Tomo,

We need a proper whitelist for which opcodes are valid for SMC devices.
The following patch adds a trivial backing store template for smc with
a corresponding opcode whitelist. With this patch we can access the smc
device with mtx again.


Ronnie Sahlberg (1):
  SMC: add a smc backend template with an opcode whitelist

 usr/bs_rdwr.c |   33 +++++++++++++++++++++++++++++++++
 usr/scsi.h    |    1 +
 usr/smc.c     |    9 +++++++++
 3 files changed, 43 insertions(+), 0 deletions(-)

-- 
1.7.3.1
