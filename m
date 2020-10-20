From: Apollon Oikonomopoulos <apoikos@debian.org>
Subject: [PATCH] Avoid passing NULL pointer to printf
Date: Tue, 20 Oct 2020 14:55:39 +0300
Message-ID: <20201020115541.184675-1-apoikos@debian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stgt-owner@vger.kernel.org>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org
Cc: Apollon Oikonomopoulos <apoikos@debian.org>

iscsi_add_portal sometimes passes a NULL pointer as a %s argument to
printf. This is was already considered an error when using
-Werror=format-overflow, but it is only since GCC 10 that GCC is able to
detect this particular case:

 In file included from iscsi/iscsid.h:29,
                  from iscsi/iscsi_tcp.c:35:
 In function 'iscsi_add_portal',
     inlined from 'iscsi_add_portal' at iscsi/iscsi_tcp.c:408:5,
     inlined from 'iscsi_tcp_init' at iscsi/iscsi_tcp.c:449:3:
 ./log.h:90:2: error: '%s' directive argument is null [-Werror=format-overflow=]
    90 |  log_error("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args); \
       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 iscsi/iscsi_tcp.c:411:3: note: in expansion of macro 'eprintf'
   411 |   eprintf("failed to create/bind to portal %s:%d\n", addr, port);
       |   ^~~~~~~

Fix this by passing the empty string to eprintf() if addr is NULL.

Signed-off-by: Apollon Oikonomopoulos <apoikos@debian.org>
---
 usr/iscsi/iscsi_tcp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/usr/iscsi/iscsi_tcp.c b/usr/iscsi/iscsi_tcp.c
index 2bb8356..39dfb71 100644
--- a/usr/iscsi/iscsi_tcp.c
+++ b/usr/iscsi/iscsi_tcp.c
@@ -407,8 +407,14 @@ int iscsi_tcp_init_portal(char *addr, int port, int tpgt)
 
 int iscsi_add_portal(char *addr, int port, int tpgt)
 {
+	const char *addr_str = "";
+
 	if (iscsi_tcp_init_portal(addr, port, tpgt)) {
-		eprintf("failed to create/bind to portal %s:%d\n", addr, port);
+		if (addr) {
+			addr_str = addr;
+		}
+		eprintf("failed to create/bind to portal %s:%d\n",
+			addr_str, port);
 		return -1;
 	}
 
-- 
2.28.0

