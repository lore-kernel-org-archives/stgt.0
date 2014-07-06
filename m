From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: [PATCH 3/3] sheepdog: add documentation
Date: Sun,  6 Jul 2014 23:30:32 +0900
Message-ID: <1404657032-17629-4-git-send-email-mitake.hitoshi@gmail.com>
References: <1404657032-17629-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BbBIXU8mNkFNLMR8bFWWc3PzkHvgZbByq+2DYhoLTOk=;
        b=TsET4yAonlihaaQgxyX9kZJOrr9Pixj1TmOxwLVuTYHVv+ZaftG4XNsQCQM/bLmYGO
         fotSl30IN6A4qjgXqRtj5ZWcjvEM2bmwCsTiuEkmOEhKbUs52+dQRl5H8uZ0EtlvJpao
         wncW9i6NP5VmuqK5/WatdNTE5jCddTGhGfEqcdRrHJXoegeG1WAeciTbCtTclm3vtn8w
         Z4vnv2LtBveiG/qZjMo3BTVSjDN9MsLm+DX8otwbpaavlfBm13y+d4eHFsVS9ZL6xnQ6
         5j4DewwxLoZxULtfpfxkaHQpYx1C9c9IL4qZe9/aSheuagwYsbr5HkvuRsVlvOrTCYkd
         pJfA==
In-Reply-To: <1404657032-17629-1-git-send-email-mitake.hitoshi@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@gmail.com>, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 doc/README.sheepdog | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)
 create mode 100644 doc/README.sheepdog

diff --git a/doc/README.sheepdog b/doc/README.sheepdog
new file mode 100644
index 0000000..64452fe
--- /dev/null
+++ b/doc/README.sheepdog
@@ -0,0 +1,100 @@
+Sheepdog is a distributed storage system for QEMU, iSCSI clients and
+RESTful services. It provides highly available block level storage
+volumes that can be attached to QEMU-based virtual machines. The
+volumes can also be attached to other virtual machines and operating
+systems run on baremetal hardware if they support iSCSI
+protocol. Sheepdog scales to several hundreds nodes, and supports
+advanced volume management features such as snapshot, cloning, and
+thin provisioning. Stuff like volumes, snapshots, QEMU's vm-state
+(from live snapshot), even ISO files can be stored in the Sheepdog
+cluster.
+
+With tgt, sheepdog's virtual disks can be used by iSCSI
+initiators. Below is a brief description of setup.
+
+1. Install and launch tgt
+
+$ git clone https://github.com/fujita/tgt.git
+$ cd tgt
+$ make
+# make install
+2. Create a sheepdog VDI
+
+There is no special procedures in this step.
+
+$ dog vdi create tgt0 100G
+Of course you can use existing VDIs as iSCSI logical units.
+
+3. Setup iSCSI target provided by tgt
+
+One logical unit corresponds to one VDI of sheepdog. In this step, we
+create iSCSI target and logical unit which can be seen by iSCSI
+initiator.
+
+# tgtd
+# tgtadm --op new --mode target --tid 1 --lld iscsi --targetname iqn.2013-10.org.sheepdog-project
+# tgtadm --op new --mode lu --tid 1 --lun 2 --bstype sheepdog --backing-store unix:/sheep_store/sock:tgt0
+# tgtadm --lld iscsi --op bind --mode target --tid 1 -I ALL
+
+The most important parameter is --backing-store which is required by
+tgtadm when we create the logical unit in the target (the third line
+of the above commands). With this parameter, we tell the tgtd
+process how to connect to the sheep process, which VDI we use as the
+logical unit, which snapshot ID of the VDI we use. The form of the
+--backing-store option is like this:
+
+ unix:path_of_unix_domain_socket:vdi
+ unix:path_of_unix_domain_socket:vdi:tag
+ unix:path_of_unix_domain_socket:vdi:snapid
+ tcp:host:port:vdi
+ tcp:host:port:vdi:tag
+ tcp:host:port:vdi:snapid
+
+We use a special case of the first one in the above command
+sequence. It means "connect to sheep process via unix domain socket
+protocol, path of unix domain socket is /sheep_store/sock, use VDI
+named tgt0 as a backing store of newly created logical unit".
+
+You can also specify sheep which is running on remote host via
+TCP. But if tgtd process is running on a same host of sheep process,
+there is no benefit of using TCP. Unix domain socket can provide
+faster connection than TCP.
+
+You can also specify tag or ID of snapshots via suffix of the
+--backing-store option.
+
+4. Setup iSCSI session (example of the open-iscsi initiator on Linux)
+
+After setting up iSCSI target, you can use the VDIs from any virtual
+machines and operating systems which supports iSCSI initiator. Many of
+popular hypervisors and operating systems support it (e.g. VMware ESX
+Family, Linux, Windows, etc). In this example, the way of Linux +
+open-iscsi is described.
+
+At first, you have to install open-iscsi ( http://www.open-iscsi.org/
+) and launch it. Major linux distros provide their open-iscsi
+package. Below is a way of installation in Debian and Ubuntu based
+systems.
+
+# apt-get install open-iscsi
+# /etc/init.d/open-iscsi start
+
+Next, we need to let iscsid discover and login to the target we've
+already created in the above sequence. If the initiator is running
+on different host from the target, you have to change the IP
+addresses in the below commands.
+
+# iscsiadm -m discovery -t st -p 127.0.0.1
+# iscsiadm -m node --targetname iqn.2013-10.org.sheepdog-project --portal 127.0.0.1:3260 --login
+
+New device files, e.g. /dev/sdb, will be created on your system after
+login completion. Now your system can use the speepdog VDIs like
+ordinal HDDs.
+
+ToDo
+
+Currently, iSCSI multipath is not supported by sheepdog. It will be
+implemented in v0.9.0.
+
+The latest version of this guide can be found here:
+https://github.com/sheepdog/sheepdog/wiki/General-protocol-support-%28iSCSI-and-NBD%29
-- 
1.9.1
