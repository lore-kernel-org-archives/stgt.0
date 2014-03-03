From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: 1.0.45 released
Date: Mon, 3 Mar 2014 23:09:37 +0900
Message-ID: <20140303230631D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Enjoy!

=
FUJITA Tomonori (1):
      tgt 1.0.45

Hitoshi Mitake (2):
      tgtd: refresh ready fds of event loop after event deletion
      tgtd: let event_need_refresh be a static variable

Or Gerlitz (1):
      iscsi: Move two messages to be logged as debug and not as errors

Roi Dayan (1):
      iser: Fix discovery over iser on non default port

Ronnie Sahlberg (1):
      The first byte in CDB USAGE DATA should be the opcode number and not 0xFF

Ryusuke Konishi (2):
      iscsi: fix leak of session->initiator_alias
      tgtd: fix internal error of __inaccount_bind()

Thomas Matysik (2):
      Fix bs_rbd.c slurp_to_semi() not consuming terminating semicolon
      Add "cluster" option to bs_rbd.c to specify cluster name
