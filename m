From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 0/6] sheepdog driver cleanup
Date: Tue,  6 Sep 2016 16:37:23 +0900
Message-ID: <1473147449-29377-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=4pqVetdqnonOEifhItKSTn7n3svsbjxswNy1IHhnUv4=;
        b=B/giXwlOzzXgbx6ISMcqJKdj5YWNfl/2I9a5vXZiZtzuLP4hIIofucO4djOVEWBduk
         3ZuMkSfnOUJXQrOQVzB9mzYxQqOa0f8QwTNi/FU8+GmVuAFvZ5EShEuKtcibuybimzCh
         L6u601gcox9rEPfUoBrg/vcm9338S/EDs/Xnfyut4QWfy/BxUXSsTlxolSHPwJc0U+Z9
         /yMxk/D/dAejK/udWlAeng371HKh/JliENh7GvdX9UWtkiyk6C2ch0iXSbXHDA+IWKX4
         UTCpCrJT900+eTZQjHvzJT2aVc2TWMYDl5JUZf8nP0yphJ7X++DCzf4mjGKwYm040o3i
         3uCw==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

This patchset does some cleaning of the sheepdog driver related to the
iSCSI multipath functionality.

Hitoshi Mitake (6):
  sheepdog: prevent double locking during inode reload
  sheepdog: serialize overwrapping request
  sheepdog: pass a correct flag to reload_inode()
  sheepdog: handle a case of snapshot -> failover
  sheepdog: don't let ai have min and max dirty data indexes
  sheepdog: handle an inconsistent state of metadata

 usr/bs_sheepdog.c | 182 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 153 insertions(+), 29 deletions(-)

-- 
2.7.4
