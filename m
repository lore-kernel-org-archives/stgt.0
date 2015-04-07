From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 1/3] tgtd.c: allow oom adjust failures for non-root users
Date: Tue,  7 Apr 2015 11:40:32 -0700
Message-ID: <1428432034-28682-2-git-send-email-ronniesahlberg@gmail.com>
References: <1428432034-28682-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bjcBLwxxRbI6xAC4kDfZ40yNQKAWdBQP4g0I21s1GLs=;
        b=QiaDMU8Xi5gHDPuZ6g0inV79eosQL2090QHNKn6NS2ex86SNyvFqNwTfAuUGymdGUx
         hUce65v2aN4uaV+AHvB5G31LbzKvCsjAnMNjnacTCV1QGDrzSofQqvs66GAR5VDH+y/f
         kuY1BsGsEBmYTVqVO8HD7jnPSaUq3+E5Wr20nxy82adxvNxkizPZguJlB8VpJydem6gy
         Bv+AxN5c9Cdd7psRATcwWE98G1RTDdDPomUc8TkkNidmlzk9/oavsN+rCZvXBpLYpToA
         HSaYpamJ2df8wINRTwQINWHC7jJdP5lXYdZhl1VnMdW77PFKtoOCIuWB338S4qFyQax+
         XfeA==
In-Reply-To: <1428432034-28682-1-git-send-email-ronniesahlberg@gmail.com>
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
