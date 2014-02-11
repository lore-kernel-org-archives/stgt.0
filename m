From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] Add "cluster" option to bs_rbd.c to specify
 cluster name
Date: Tue, 11 Feb 2014 09:16:48 +0900 (JST)
Message-ID: <20140211.091648.722554765817568549.fujita.tomonori@lab.ntt.co.jp>
References: <1390356859-7557-1-git-send-email-thomas@belton.co.nz>
	<1390356859-7557-2-git-send-email-thomas@belton.co.nz>
	<52F94EDE.70200@inktank.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <52F94EDE.70200@inktank.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dan.mick@inktank.com
Cc: thomas@belton.co.nz, stgt@vger.kernel.org

On Mon, 10 Feb 2014 14:12:46 -0800
Dan Mick <dan.mick@inktank.com> wrote:

> except for the one if() with no space after the 'if':
> 
> Reviewed-by: Dan Mick <dan.mick@inktank.com>

Thanks, applied. checkpatch.pl complains about the that if(). I fixed
the following warnings:

fujita@rose:~/git/tgt$ ./scripts/checkpatch.pl ~/2
ERROR: do not use C99 // comments
#124: FILE: usr/bs_rbd.c:526:
+     // look for conf= or id= or cluster=

WARNING: line over 80 characters
#146: FILE: usr/bs_rbd.c:553:
+     /* If clustername is set, then we use rados_create2, else
rados_create */

ERROR: space required before the open parenthesis '('
#149: FILE: usr/bs_rbd.c:556:
+     	    if(clientid)

WARNING: line over 80 characters
#150: FILE: usr/bs_rbd.c:557:
+		snprintf(clientid_full, sizeof clientid_full,
"client.%s", clientid);

WARNING: line over 80 characters
#152: FILE: usr/bs_rbd.c:559:
+		snprintf(clientid_full, sizeof clientid_full,
"client.admin");

WARNING: line over 80 characters
#153: FILE: usr/bs_rbd.c:560:
+     	    rados_ret = rados_create2(&rbd->cluster, clustername,
clientid_full, 0);

total: 2 errors, 4 warnings, 59 lines checked
