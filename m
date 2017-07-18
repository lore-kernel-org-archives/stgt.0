From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/2] Fix header warning with GCC 7 for major()
Date: Tue, 18 Jul 2017 13:52:57 -0700
Message-ID: <20170718205258.6246-2-agrover@redhat.com>
References: <20170718205258.6246-1-agrover@redhat.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 74CE4C0587FA
In-Reply-To: <20170718205258.6246-1-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

With GCC 7, there is a warning to include sys/sysmacros.h for "major"
instead of sys/types.h.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 usr/bs_sg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/usr/bs_sg.c b/usr/bs_sg.c
index 66f4a3b..6d03aa4 100644
--- a/usr/bs_sg.c
+++ b/usr/bs_sg.c
@@ -35,6 +35,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/epoll.h>
+#include <sys/sysmacros.h>
 #include <scsi/sg.h>
 
 #include "bsg.h" /* Copied from include/linux/bsg.h */
-- 
2.9.4
