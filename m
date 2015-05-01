From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Allow overriding the IPC socket path via TGT_IPC_SOCKET
Date: Thu, 30 Apr 2015 18:29:12 -0700
Message-ID: <1430443752-30929-2-git-send-email-ronniesahlberg@gmail.com>
References: <1430443752-30929-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H0Vg1dbBbKTyWugdPuuK1q+rwh77KJu3OeZkue2bIPs=;
        b=k0x4g9mDmDkteyAD6N2C2rJV9GV0gDy5cfLNDvCPT8joQ4nd2TMen59UTs70kxgtVm
         ZUlzg9dz051PsRdRowl9iGwoYAkVE/y/HUcg4FRan9I/omAZT1WL8ghZnIx/PWQ7xysJ
         sUayUMmQ6Flil3NYUriIgTQWsAoGVbO2FsOo4p+D7ZfFcb2+GIA+rHGneV4G+fiI4LOC
         HKrmXjwGe39a2Y0ii4V+bdqWHM5AH7AualFQL8pjwk99SKrjD7fiZzoqWy0YJXWsJwY3
         pVMaVH37bcP+a909KBHZ3CXmAF95rEjHZ1EH3DS3AOXMzC6xteriZU/ap1ECdHN6RbKh
         rYjA==
In-Reply-To: <1430443752-30929-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 doc/tgtd.8.xml |  9 +++++++++
 usr/mgmt.c     | 11 +++++++----
 usr/tgtadm.c   |  8 ++++++--
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/doc/tgtd.8.xml b/doc/tgtd.8.xml
index a0020c6..57ac805 100644
--- a/doc/tgtd.8.xml
+++ b/doc/tgtd.8.xml
@@ -162,6 +162,15 @@
   </refsect1>
 
 
+  <refsect1><title>ENVIRONMENT VARIABLES</title>
+    <refsect2><title>TGT_IPC_SOCKET=&lt;path&gt;</title>
+      <para>
+	When set tgtd and tgtadm will use the specified path as the
+	IPC socket instead of the default '/var/run/tgtd/socket.0'
+      </para>
+    </refsect2>
+  </refsect1>
+
   <refsect1><title>SEE ALSO</title>
     <para>
       tgtadm(8), tgt-admin(8), tgtimg(8), tgt-setup-lun(8).
diff --git a/usr/mgmt.c b/usr/mgmt.c
index 18fbfc1..de23f14 100644
--- a/usr/mgmt.c
+++ b/usr/mgmt.c
@@ -766,12 +766,15 @@ int ipc_init(void)
 	int fd = 0, err;
 	struct sockaddr_un addr;
 	struct stat st = {0};
+	char *path;
 
-	if (stat(TGT_IPC_DIR, &st) == -1) {
-		mkdir(TGT_IPC_DIR, 0755);
+	if ((path = getenv("TGT_IPC_SOCKET")) == NULL) {
+		path = TGT_IPC_NAMESPACE;
+		if (stat(TGT_IPC_DIR, &st) == -1)
+			mkdir(TGT_IPC_DIR, 0755);
 	}
 
-	sprintf(mgmt_lock_path, "%s.%d.lock", TGT_IPC_NAMESPACE, control_port);
+	sprintf(mgmt_lock_path, "%s.%d.lock", path, control_port);
 	ipc_lock_fd = open(mgmt_lock_path, O_WRONLY | O_CREAT,
 			   S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 	if (ipc_lock_fd < 0) {
@@ -794,7 +797,7 @@ int ipc_init(void)
 		goto close_lock_fd;
 	}
 
-	sprintf(mgmt_path, "%s.%d", TGT_IPC_NAMESPACE, control_port);
+	snprintf(mgmt_path, sizeof(mgmt_path), "%s.%d", path, control_port);
 	unlink(mgmt_path);
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
diff --git a/usr/tgtadm.c b/usr/tgtadm.c
index 7a2dc35..b8df58d 100644
--- a/usr/tgtadm.c
+++ b/usr/tgtadm.c
@@ -211,7 +211,7 @@ static int ipc_mgmt_connect(int *fd)
 {
 	int err;
 	struct sockaddr_un addr;
-	char mgmt_path[256];
+	char mgmt_path[256], *path;
 
 	*fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (*fd < 0) {
@@ -221,7 +221,11 @@ static int ipc_mgmt_connect(int *fd)
 
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
-	sprintf(mgmt_path, "%s.%d", TGT_IPC_NAMESPACE, control_port);
+	if ((path = getenv("TGT_IPC_SOCKET")) == NULL)
+		path = TGT_IPC_NAMESPACE;
+	snprintf(mgmt_path, sizeof(mgmt_path), "%s.%d",
+			 path, control_port);
+
 	strncpy(addr.sun_path, mgmt_path, sizeof(addr.sun_path));
 
 	err = connect(*fd, (struct sockaddr *) &addr, sizeof(addr));
-- 
2.1.0
