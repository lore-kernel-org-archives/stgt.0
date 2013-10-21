From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] add --bsopts flag, pass to bs_init()
Date: Mon, 21 Oct 2013 10:54:12 +0900
Message-ID: <20131021103026C.fujita.tomonori@lab.ntt.co.jp>
References: <1381539243-13245-1-git-send-email-dan.mick@inktank.com>
	<5260965B.90002@inktank.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <5260965B.90002@inktank.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dan.mick@inktank.com
Cc: stgt@vger.kernel.org

On Thu, 17 Oct 2013 19:00:59 -0700
Dan Mick <dan.mick@inktank.com> wrote:

> ping
> 
> On 10/11/2013 05:54 PM, Dan Mick wrote:
> > This patch implements the generic mechanism of passing backing-store-
> > specific options to the backing store module's bs_init entry point.
> > Each backing-store module gets a new parameter, char *bsopts,
> > added to its bs_init.
> >
> > No semantics or even syntax are imposed on the option string, other
> > than that commas are not permitted, because tgtadm communicates to
> > tgtd using a block of key=val,key=val,key=val options, and there's
> > no provision for escaping commas.
> >
> > tgtadm.8 is updated as well
> >
> > Dan Mick (1):
> >    Add bsopts flag
> >
> >   doc/tgtadm.8.xml  |   20 +++++++++++++++++---
> >   scripts/tgt-admin |   13 ++++++++++++-
> >   usr/bs_aio.c      |    2 +-
> >   usr/bs_rbd.c      |    3 ++-
> >   usr/bs_rdwr.c     |    2 +-
> >   usr/bs_sg.c       |    2 +-
> >   usr/bs_sheepdog.c |    2 +-
> >   usr/bs_ssc.c      |    2 +-
> >   usr/spc.c         |    3 ++-
> >   usr/target.c      |   12 +++++++++---
> >   usr/tgtadm.c      |   18 +++++++++++++-----
> >   usr/tgtd.h        |    2 +-
> >   12 files changed, 61 insertions(+), 20 deletions(-)

I got the following rejects. The patch is against the old version of
rbd code?

fujita@rose:~/git/tgt$ patch -p1 < ~/1
patching file doc/tgtadm.8.xml
patching file scripts/tgt-admin
Hunk #1 succeeded at 492 (offset 2 lines).
Hunk #2 succeeded at 544 (offset 2 lines).
Hunk #3 succeeded at 699 (offset 2 lines).
Hunk #4 succeeded at 712 (offset 2 lines).
patching file usr/bs_aio.c
patching file usr/bs_rbd.c
Hunk #1 FAILED at 476.
1 out of 1 hunk FAILED -- saving rejects to file usr/bs_rbd.c.rej
patching file usr/bs_rdwr.c
patching file usr/bs_sg.c
patching file usr/bs_sheepdog.c
Hunk #1 succeeded at 1245 (offset 258 lines).
patching file usr/bs_ssc.c
patching file usr/spc.c
patching file usr/target.c
patching file usr/tgtadm.c
patching file usr/tgtd.h
