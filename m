From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 2/3] mgmt: change ipc socket address and make it group writeable
Date: Tue,  7 Apr 2015 11:29:08 -0700
Message-ID: <1428431349-24087-3-git-send-email-ronniesahlberg@gmail.com>
References: <1428431349-24087-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dXL2/47ktcAbNu6LGTTzFwaY10RPp+/IXIL8e2QEh+s=;
        b=tas4Tf3WpclTIXogUBnqXuc1oy3Tk0ACkuDPMsbucLJQRqDzflBy3FpD8L+u4kCLBn
         lQN1PlqCzd94Hs56xh++W5MrIxkkmbvN3FV3O477P4iN8WaMACxNxvbOVZsDIYcF/ndW
         GEvtSNz2zI16PXxzvXveRvtvsyVqfwdLuzqRhd3thuN4PpC9UUkbdTqlQ3L9Ux/cM9Nd
         jc8sr//dIdyl3FMiFXzPrDlIGROs7wizJX2T3Z4qRScwOZHLv8o8HUvpySWRm8J0ShhS
         GUNDBMzAyqDfV/38MLza9yUiFjRuC4KJbdsLirsYJFnuwbZSLMJwWAV2rkpwDhL7T0DH
         757A==
In-Reply-To: <1428431349-24087-1-git-send-email-ronniesahlberg@gmail.com>
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

We also change the socket to be group writeable. This then will allow
running tgtd as a dedicated group tgtd and then group membership to
tgtd can control who can connect to the daemon.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/mgmt.c   | 2 +-
 usr/tgtadm.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/usr/mgmt.c b/usr/mgmt.c
index 3587f4b..364b3c8 100644
--- a/usr/mgmt.c
+++ b/usr/mgmt.c
@@ -768,7 +768,7 @@ int ipc_init(void)
 
 	sprintf(mgmt_lock_path, "%s.%d.lock", TGT_IPC_NAMESPACE, control_port);
 	ipc_lock_fd = open(mgmt_lock_path, O_WRONLY | O_CREAT,
-			   S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+			   S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 	if (ipc_lock_fd < 0) {
 		eprintf("failed to open lock file for management IPC\n");
 		return -1;
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
