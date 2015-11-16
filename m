From: Lee Duncan <lduncan@suse.com>
Subject: backing-store modules directory not present is not an error
Date: Sun, 15 Nov 2015 17:15:51 -0800
Message-ID: <56492E47.2010108@suse.com>
References: <56463BCF.6020001@suse.com>
 <20151114.214659.1568838937885775323.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20151114.214659.1568838937885775323.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stgt@vger.kernel.org

The backing-store modules directory, normally
/usr/lib/tgt/backing-store, is not created, needed, or used when there
are no backing store modules. So change the error message printed when
the directory is not present to a debug message.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
diff -aurp tgt-1.0.44.orig/usr/bs.c tgt-1.0.44/usr/bs.c
--- tgt-1.0.44.orig/usr/bs.c	2014-02-02 22:56:32.000000000 -0800
+++ tgt-1.0.44/usr/bs.c	2015-11-15 17:14:51.932000000 -0800
@@ -267,7 +267,8 @@ static int bs_init_signalfd(void)

 	dir = opendir(BSDIR);
 	if (dir == NULL) {
-		eprintf("could not open backing-store module directory %s\n",
+		/* not considered an error if there are no modules */
+		dprintf("could not open backing-store module directory %s\n",
 			BSDIR);
 	} else {
 		struct dirent *dirent;
