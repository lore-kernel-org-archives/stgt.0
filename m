From: FUJITA Tomonori <tomof@acm.org>
Subject: 1.0.68 released
Date: Sun, 02 Oct 2016 06:33:49 +0900 (JST)
Message-ID: <20161002.063349.1305564732068181015.tomof@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

Here's 1.0.68 release.

=
FUJITA Tomonori (1):
      tgt 1.0.68

Hitoshi Mitake (6):
      sheepdog: prevent double locking during inode reload
      sheepdog: serialize overwrapping request
      sheepdog: pass a correct flag to reload_inode()
      sheepdog: handle a case of snapshot -> failover
      sheepdog: don't let ai have min and max dirty data indexes
      sheepdog: handle an inconsistent state of metadata
