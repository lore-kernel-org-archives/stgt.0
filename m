From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: 1.0.41 released
Date: Fri, 1 Nov 2013 10:09:49 +0900
Message-ID: <20131101094425D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

Enjoy the new release!

=
Andy Grover (3):
      Fix redefinition of _GNU_SOURCE
      Fix make install when no modules
      De-modularize aio

Dan Mick (9):
      usr/Makefile: fix typo in bs_aio so filename
      bs_rbd.c: store active_rbd info in addition to struct scsi_lu
      bs_rbd.c: carry cluster connection along with rbd/lu
      tgt-admin: avoid zsh-specific syntax in system() call
      tgt-admin: abort check_device() early if -e returns false
      tgt-admin: avoid in-use and backing_store existence tests for rbd
      Add bsopts flag
      bs_rbd.c: accept and parse bsopts
      README.rbd: add documentation for the rbd --bsopts parameters

FUJITA Tomonori (1):
      tgt 1.0.41

Hitoshi Mitake (8):
      bs_sheepdog.c: partial update of inode object for optimizing COW
      bs_sheepdog.c: use multithread for scsi command submission
      bs_sheepdog.c: support reconnection for updating sheepdog
      bs_sheepdog.c: support various VDI options in --backing-store option
      bs_sheepdog.c: mock the behavior of QEMU's sheepdog driver in a correct manner
      bs_sheepdog.c: fix segmentation fault caused by deleting logical unit
      bs_sheepdog.c: test connection when new logical unit is created
      tgtd: protect socket for management IPC with lockf(3)

Ryusuke Konishi (3):
      bs_sheepdog.c: fix pthread rwlock leak in sd_io()
      bs_sheepdog.c: fix memory leak issues in sd_open()
      bs_sheepdog.c: fix error handling issue in bs_sheepdog_request()
