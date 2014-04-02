From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: 1.0.46 released
Date: Wed, 2 Apr 2014 11:02:56 +0900
Message-ID: <20140402105611T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

The highlight is that one critical bug (leads to tgt crash) was fixed
and gluster backing store support was added.

Have fun!

=
Andy Grover (1):
      Fix segfault if device_type set to pt but bstype not sg or bsg

Dan Lambright (1):
      Add support for gluster backing store

Dennis Cullison (1):
      spc: Support NAA IEEE Registered Extended field in VPD page 0x83

FUJITA Tomonori (1):
      tgt 1.0.46

Ryusuke Konishi (3):
      tgtd: fix leak of task_in_scsi flag
      iscsi: fix leak of task for delayed management request
      iscsi: fix segfault at iscsi_scsi_cmd_done()
