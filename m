From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 2/3] mgmt: change ipc socket address
Date: Tue,  7 Apr 2015 11:40:33 -0700
Message-ID: <1428432034-28682-3-git-send-email-ronniesahlberg@gmail.com>
References: <1428432034-28682-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wu1qIEP8fMYyMkOz4HXbAnQIQfjtT1ARXTnemObJ1dE=;
        b=EvsqGPwzFZKpiJhU5JbbqqOJFoZ1a2Exs4ihMjIE0d5NZ3vYzm+atTPyufWCrWecYY
         vuZy9PgWkPI3tsQxlA2+/FO1kIrUFPbe6OIelOTDjEwoRcQVPDLCn28in+f8dOJAOAjM
         a1tG83QvWZFBFLXiZlyuP2gIrotlPtdC2Z8oY1Lb06VFkfPqxHQ+OLOddAJ5J17jmrit
         FrSCJuLeUBtKeaNpanQs1toESExBRy+Ho4L41gOAGMvQlwGEpOjIOqESqMg53kypoA0y
         0EdnolbJS+xlMcxEGwV8PBU6H9t1xUXhL3WDAk0oA+wvb4hr3/K6QEuHznLH7G+5tou6
         kT9w==
In-Reply-To: <1428432034-28682-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

Change the ipc socket basename from /var/run/tgtd.ipc_abstract_namespace
to /var/run/tgtd/socket.

/var/run is usually only writeable by root, so putting the ipc socket
and its lockfile directly under /var/run prevents running tgtd as a
non-root user. Thus we place the socket file under /var/run/tgtd instead
and this directory can then be set up as owned and writeable by
a user tgtd and group tgtd.

Second is that ipc_abstract_namespace is unintuitive for what it does.
Lets just call it socket so it is clear that this is just a socket
we use to talk to the daemon with.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/tgtadm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/tgtadm.h b/usr/tgtadm.h
index 4e239c4..866aac9 100644
--- a/usr/tgtadm.h
+++ b/usr/tgtadm.h
@@ -1,7 +1,7 @@
 #ifndef TGTADM_H
 #define TGTADM_H
 
-#define TGT_IPC_NAMESPACE	"/var/run/tgtd.ipc_abstract_namespace"
+#define TGT_IPC_NAMESPACE	"/var/run/tgtd/socket"
 #define TGT_LLD_NAME_LEN	64
 
 #define GLOBAL_TID (~0U)
-- 
2.1.0
