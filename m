From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: 1.0.43 released
Date: Tue, 7 Jan 2014 22:00:31 +0900
Message-ID: <20140107212714C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

Here's a new release. Ryusuke Konishi, thanks so much for lots of bug
fixes!

=
FUJITA Tomonori (1):
      tgt 1.0.43

Hitoshi Mitake (1):
      trivial: support cscope in Makefile and gitignore

Ryusuke Konishi (11):
      bs_sheepdog.c: fix up buffer overrun issues with unix domain socket
      bs_sheepdog.c: ensure that vdi names and tag names are null-terminated
      tgtd: fix memory leaks at it_nexus_create()
      tgtd: fix segmentation fault in tgt_device_destroy()
      util.h: correct range check of str_to_int_gt() and str_to_int_lt()
      Fix buffer overrun issue of lld name
      iscsi/conn.c: fix a typo s/sesson/session/
      bs_sheepdog.c: fix a descriptor leak in connect_to_sdog_tcp()
      tgtd: fix memory access overrun on array of pthread_t type data
      bs_sheepdog.c: add missing initialization of request header
      bs_sheepdog.c: add missing initialization of read data length
