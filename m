From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: 1.0.42 released
Date: Mon, 2 Dec 2013 06:50:58 +0900
Message-ID: <20131202062233B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

Here's a new release.

=
FUJITA Tomonori (2):
      use NR_SCSI_OPCODES definition
      tgt 1.0.42

Hitoshi Mitake (1):
      bs_sheepdog.c: fix an unsafe strncpy() call

Roi Dayan (1):
      Fix AIO backing store not being registered

Ronnie Sahlberg (2):
      Add an array that describes which opcodes are supported
      REPORT SUPPORTED OPCODES: Only return opcodes supported by the backend.

Ryusuke Konishi (3):
      tgtadm: add missing outgoing option to the help of unbind operation
      bs_sheepdog.c: fix gcc warning at sd_open()
      bs_sheepdog.c: fix length modifier of eprintf in read_write_object()
