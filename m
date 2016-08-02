From: FUJITA Tomonori <tomof@acm.org>
Subject: 1.0.66 released
Date: Tue, 02 Aug 2016 12:30:05 +0900 (JST)
Message-ID: <20160802.123005.1305564732068170243.tomof@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org
Cc: tomof@acm.org

Hi,

Here's version 1.0.66 release; several critical fixes included.

Thanks!
 
=
Anton Kovalenko (2):
      Fix iscsi-tcp unsolicited NOP-IN (ping) task leak
      Call tgt_event_del before closing the eventfd

Chen Fangxian (1):
      iscsi: fix segfault at conn_close

FUJITA Tomonori (1):
      tgt 1.0.66

Roi Dayan (3):
      iser: fix segfault when not passing options to iser param
      tgt-setup-lun: fix error when blocksize not given
      Fix accepting invalid block size

gecegezen (1):
      Update tgt-setup-lun for AF 4K disks.

