From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] mgmt: Create ipc socket parent dir if does not exists
Date: Sun, 12 Apr 2015 18:11:06 +0300
Message-ID: <1428851466-22084-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

If the parent dir doesn't exists then tgtd will fail to create the
socket and exit.
This commit will check if the folder doesn't exists and create it.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/mgmt.c   | 5 +++++
 usr/tgtadm.h | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/usr/mgmt.c b/usr/mgmt.c
index c2bd176..18fbfc1 100644
--- a/usr/mgmt.c
+++ b/usr/mgmt.c
@@ -765,6 +765,11 @@ int ipc_init(void)
 	extern short control_port;
 	int fd = 0, err;
 	struct sockaddr_un addr;
+	struct stat st = {0};
+
+	if (stat(TGT_IPC_DIR, &st) == -1) {
+		mkdir(TGT_IPC_DIR, 0755);
+	}
 
 	sprintf(mgmt_lock_path, "%s.%d.lock", TGT_IPC_NAMESPACE, control_port);
 	ipc_lock_fd = open(mgmt_lock_path, O_WRONLY | O_CREAT,
diff --git a/usr/tgtadm.h b/usr/tgtadm.h
index 866aac9..e3fda6a 100644
--- a/usr/tgtadm.h
+++ b/usr/tgtadm.h
@@ -1,7 +1,8 @@
 #ifndef TGTADM_H
 #define TGTADM_H
 
-#define TGT_IPC_NAMESPACE	"/var/run/tgtd/socket"
+#define TGT_IPC_DIR		"/var/run/tgtd"
+#define TGT_IPC_NAMESPACE	TGT_IPC_DIR"/socket"
 #define TGT_LLD_NAME_LEN	64
 
 #define GLOBAL_TID (~0U)
-- 
1.8.4.3
