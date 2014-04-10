From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] iser: fix a warning about container_of being redefined
Date: Thu, 10 Apr 2014 18:40:51 +0300
Message-ID: <1397144451-4393-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

container_of is being defined in list.h and verbs.h differently.
To keep tgtd toe use the container_of from list.h as today, Instead of
wrapping ifndef which exists in verbs.h I moved the inclusion of verbs
to after list.h

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/iscsi/iser.c      |    4 +---
 usr/iscsi/iser.h      |    3 +++
 usr/iscsi/iser_text.c |    2 --
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index 7a0d20c..d748184 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -30,18 +30,16 @@
 #include <assert.h>
 #include <netdb.h>
 #include <sys/epoll.h>
-#include <infiniband/verbs.h>
-#include <rdma/rdma_cma.h>
 #include <sys/ipc.h>
 #include <sys/shm.h>
 
 #include "util.h"
 #include "iscsid.h"
 #include "target.h"
-#include "iser.h"
 #include "driver.h"
 #include "scsi.h"
 #include "work.h"
+#include "iser.h"
 
 #if defined(HAVE_VALGRIND) && !defined(NDEBUG)
 #include <valgrind/memcheck.h>
diff --git a/usr/iscsi/iser.h b/usr/iscsi/iser.h
index 4e4c8f2..48d0a8c 100644
--- a/usr/iscsi/iser.h
+++ b/usr/iscsi/iser.h
@@ -25,6 +25,9 @@
 
 #include "iscsid.h"
 
+#include <infiniband/verbs.h>
+#include <rdma/rdma_cma.h>
+
 extern short control_port;
 
 /*
diff --git a/usr/iscsi/iser_text.c b/usr/iscsi/iser_text.c
index 16520cb..8180dbc 100644
--- a/usr/iscsi/iser_text.c
+++ b/usr/iscsi/iser_text.c
@@ -31,8 +31,6 @@
 #include <assert.h>
 #include <netdb.h>
 #include <sys/epoll.h>
-#include <infiniband/verbs.h>
-#include <rdma/rdma_cma.h>
 
 #include "util.h"
 #include "iscsid.h"
-- 
1.7.8.2
