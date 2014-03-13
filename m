From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Add support for gluster backing store
Date: Fri, 14 Mar 2014 05:44:33 +0900 (JST)
Message-ID: <20140314.054433.1568838937885771579.fujita.tomonori@lab.ntt.co.jp>
References: <1394636124-8660-1-git-send-email-dlambrig@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1394636124-8660-1-git-send-email-dlambrig@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dlambrig@redhat.com
Cc: stgt@vger.kernel.org

On Wed, 12 Mar 2014 10:55:24 -0400
Dan Lambright <dlambrig@redhat.com> wrote:

> Gluster is a distributed file system (www.gluster.org). The
> backing store gives block access protocols such as iSCSI
> access to data within gluster.
> 
> Gluster data resides on volumes which are physically located
> on servers. A "LUN" is represented by a file within
> a volume. To specify which file to use:
> 
> --bstype=glfs
> --backing-store="volume@hostname:filename"
> 
> Optionally, logs may be specified. See README.glfs
> 
> All I/Os are synchronous.  This is based off the rdrw and
> rbd backend storage drivers.
> 
> Signed-off-by: Dan Lambright <dlambrig@redhat.com>
> ---
>  Makefile        |   1 +
>  doc/README.glfs |  50 +++++
>  usr/Makefile    |   7 +
>  usr/bs_glfs.c   | 561 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Thanks! Can you fix the following some style errors?

fujita@rose:~/git/tgt$ ./scripts/checkpatch.pl
~/0001-Add-support-for-gluster-backing-store.patch 
WARNING: quoted string split across lines
#370: FILE: usr/bs_glfs.c:239:
+			eprintf("Failed to punch hole for "
+					   	      "WRITE_SAME
command\n");

WARNING: quoted string split across lines
#481: FILE: usr/bs_glfs.c:350:
+				eprintf("Failed to punch hole for"
+								"
UNMAP at offset:%" PRIu64

WARNING: line over 80 characters
#557: FILE: usr/bs_glfs.c:426:
+     	    ret = glfs_set_volfile_server(fs, "tcp", servername,
GLUSTER_PORT);

ERROR: code indent should use tabs where possible
#615: FILE: usr/bs_glfs.c:484:
+        /* Jump past the semicolon, if we stopped at one */$

ERROR: code indent should use tabs where possible
#616: FILE: usr/bs_glfs.c:485:
+        if (**p == ';')$

WARNING: please, no spaces at the start of a line
#616: FILE: usr/bs_glfs.c:485:
+        if (**p == ';')$

ERROR: code indent should use tabs where possible
#617: FILE: usr/bs_glfs.c:486:
+                *p = end + 1;$

WARNING: please, no spaces at the start of a line
#617: FILE: usr/bs_glfs.c:486:
+                *p = end + 1;$

total: 3 errors, 5 warnings, 637 lines checked

NOTE: whitespace errors detected, you may wish to use
scripts/cleanpatch or
      scripts/cleanfile

/home/fujita/0001-Add-support-for-gluster-backing-store.patch has
style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


