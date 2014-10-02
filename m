From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: 1.0.51 released
Date: Thu, 02 Oct 2014 11:37:00 +0900 (JST)
Message-ID: <20141002.113700.1568838937885758660.fujita.tomonori@lab.ntt.co.jp>
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
FUJITA Tomonori (1):
      tgt 1.0.51

Hitoshi Mitake (4):
      sheepdog: refresh invalidated inode in update_inode() path
      sheepdog: set flag for indicating requests are from tgt
      sheepdog: change a method for detecting invalidation of inode
      sheepdog: optimize reloading of inode

Ronnie Sahlberg (2):
      SMC: add a new volume_tag parameter to storage slots
      SMC: add a smc backend template with an opcode whitelist
