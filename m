From: Dan Mick <dan.mick@inktank.com>
Subject: [PATCH v2] add --bsopts flag, pass to bs_init()
Date: Mon, 28 Oct 2013 11:17:27 -0700
Message-ID: <1382984248-7631-1-git-send-email-dan.mick@inktank.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Dan Mick <dan.mick@inktank.com>

[ Identical to the prior version, just rebased onto current master ]

This patch implements the generic mechanism of passing backing-store-
specific options to the backing store module's bs_init entry point.
Each backing-store module gets a new parameter, char *bsopts, 
added to its bs_init.

No semantics or even syntax are imposed on the option string, other
than that commas are not permitted, because tgtadm communicates to
tgtd using a block of key=val,key=val,key=val options, and there's
no provision for escaping commas.

tgtadm.8 is updated as well

Dan Mick (1):
  Add bsopts flag

 doc/tgtadm.8.xml  |   20 +++++++++++++++++---
 scripts/tgt-admin |   13 ++++++++++++-
 usr/bs_aio.c      |    2 +-
 usr/bs_rbd.c      |    3 ++-
 usr/bs_rdwr.c     |    2 +-
 usr/bs_sg.c       |    2 +-
 usr/bs_sheepdog.c |    2 +-
 usr/bs_ssc.c      |    2 +-
 usr/spc.c         |    3 ++-
 usr/target.c      |   12 +++++++++---
 usr/tgtadm.c      |   18 +++++++++++++-----
 usr/tgtd.h        |    2 +-
 12 files changed, 61 insertions(+), 20 deletions(-)

-- 
1.7.10.4
