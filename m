From: Apollon Oikonomopoulos <apollon@skroutz.gr>
Subject: [PATCH] Use ULLONG_MAX when checking for strtoull overflow
Date: Tue, 24 May 2016 12:15:04 +0300
Message-ID: <1464081304-21761-1-git-send-email-apollon@skroutz.gr>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Stas Sergeev <stsp@users.sourceforge.net>, Ryan Harper <ryan.harper@canonical.com>, Apollon Oikonomopoulos <apoikos@debian.org>

From: Apollon Oikonomopoulos <apoikos@debian.org>

According to strtoull(3):

 [...] Precisely the same holds for strtoull() (with ULLONG_MAX instead
 of ULONG_MAX).

Since we are using strtoull(3) and not strtoul(3), the check should be
made against ULLONG_MAX. Note that at least on amd64 ULONG_MAX and
ULLONG_MAX are the same, but this is not guaranteed to be the case for
other architectures as well.

Signed-off-by: Apollon Oikonomopoulos <apoikos@debian.org>
---
 usr/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/util.h b/usr/util.h
index 019ff1c..256bdb8 100644
--- a/usr/util.h
+++ b/usr/util.h
@@ -148,7 +148,7 @@ struct signalfd_siginfo {
 	unsigned long long ull_val;     		\
 	ull_val = strtoull(str, &ptr, 0);       	\
 	val = (typeof(val)) ull_val;    		\
-	if (ull_val == ULONG_MAX || ptr == str)		\
+	if (ull_val == ULLONG_MAX || ptr == str)	\
 		ret = EINVAL;   			\
 	else if (val != ull_val)			\
 		ret = ERANGE;   			\
-- 
2.8.1
