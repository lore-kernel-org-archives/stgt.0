From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Add bsopts flag
Date: Tue, 29 Oct 2013 07:20:18 +0900 (JST)
Message-ID: <20131029.072018.1568838937885770516.fujita.tomonori@lab.ntt.co.jp>
References: <1382984248-7631-1-git-send-email-dan.mick@inktank.com>
	<1382984248-7631-2-git-send-email-dan.mick@inktank.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1382984248-7631-2-git-send-email-dan.mick@inktank.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dan.mick@inktank.com
Cc: stgt@vger.kernel.org

On Mon, 28 Oct 2013 11:17:28 -0700
Dan Mick <dan.mick@inktank.com> wrote:

> tgtadm: accept and pass bsopts
> spc.c: permit bsopts as a legal option
> target.c: accept bsopts=
> tgtd.h: add char *bsopts to bs_init signature
> bs_*.c: add char *bsopts as second arg to bs_init function
> tgt-admin: process bsopts
> doc/tgtadm.8.xml: add doc for bsopts and example
> 
> Signed-off-by: Dan Mick <dan.mick@inktank.com>
> ---
>  doc/tgtadm.8.xml  |   20 +++++++++++++++++---
>  scripts/tgt-admin |   13 ++++++++++++-
>  usr/bs_aio.c      |    2 +-
>  usr/bs_rbd.c      |    3 ++-
>  usr/bs_rdwr.c     |    2 +-
>  usr/bs_sg.c       |    2 +-
>  usr/bs_sheepdog.c |    2 +-
>  usr/bs_ssc.c      |    2 +-
>  usr/spc.c         |    3 ++-
>  usr/target.c      |   12 +++++++++---
>  usr/tgtadm.c      |   18 +++++++++++++-----
>  usr/tgtd.h        |    2 +-
>  12 files changed, 61 insertions(+), 20 deletions(-)

Applied, thanks.
