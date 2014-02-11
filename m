From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] Fix bs_rbd.c slurp_to_semi() not consuming
 terminating semicolon
Date: Tue, 11 Feb 2014 09:14:45 +0900 (JST)
Message-ID: <20140211.091445.632868945383102856.fujita.tomonori@lab.ntt.co.jp>
References: <1390356859-7557-1-git-send-email-thomas@belton.co.nz>
	<52F94EB6.3030701@inktank.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <52F94EB6.3030701@inktank.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dan.mick@inktank.com
Cc: thomas@belton.co.nz, stgt@vger.kernel.org

On Mon, 10 Feb 2014 14:12:06 -0800
Dan Mick <dan.mick@inktank.com> wrote:

> Reviewed-by: Dan Mick <dan.mick@inktank.com>

Thanks, applied.

Thomas, I fixed the following warning with checkpatch.pl:

fujita@rose:~/git/tgt$ ./scripts/checkpatch.pl ~/1
ERROR: do not use C99 // comments
#97: FILE: usr/bs_rbd.c:483:
+    // Jump past the semicolon, if we stopped at one

total: 1 errors, 0 warnings, 9 lines checked

/home/fujita/1 has style problems, please review.
