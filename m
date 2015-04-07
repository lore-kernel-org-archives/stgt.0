From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 1/3] tgtd.c: allow oom adjust failures for non-root users
Date: Tue,  7 Apr 2015 11:29:07 -0700
Message-ID: <1428431349-24087-2-git-send-email-ronniesahlberg@gmail.com>
References: <1428431349-24087-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bjcBLwxxRbI6xAC4kDfZ40yNQKAWdBQP4g0I21s1GLs=;
        b=1CXPq6H48kKUYD2iexaFjGQ0IM2JI34zElTZ8LCs1qvPocWZB0RRn5R+CnxMIIr6kQ
         QV0bleS92IP3Y7CZuL7MBRoX7qEKfTakgBtDYA2ew9Y6ot496tjzUkFks1dgk5M8JiUk
         FQhzNIgaUAXLFjFh5m9U5in0pd6FxEmwFJJKpy16OnvFDDUSp2679MowrqRZzYGa0yyl
         Um9qMxvSkPR+euMvx7hqs88GLOOUt0QZ17jky8As0xg+McZxwHMZZloAOFNUARmMHGH5
         oSFehUiiydX6b6hrH3DxLWxhHZw0rrWG+vMrRAEukw1cD5C1Eg/4MlLT42Px2+nzEmxI
         VCuw==
In-Reply-To: <1428431349-24087-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

If run as non-root, allow failure to adjust the oom settings for
the process without aborting.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 usr/tgtd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/tgtd.c b/usr/tgtd.c
index 23ad413..65bc888 100644
--- a/usr/tgtd.c
+++ b/usr/tgtd.c
@@ -604,7 +604,7 @@ int main(int argc, char **argv)
 	}
 
 	err = oom_adjust();
-	if (err)
+	if (err && getuid() == 0)
 		exit(1);
 
 	err = nr_file_adjust();
-- 
2.1.0
