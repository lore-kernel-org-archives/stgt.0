From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 0/3] sheepdog driver update for iSCSI multipath
Date: Fri, 26 Sep 2014 15:44:23 +0900
Message-ID: <1411713866-12355-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=DcdRpaiqf3hPbyZvwz+ywDQUepPwVs252tNs+txQS7c=;
        b=okaEnCM3R5+Mrj/Axu56bgsT5v/edDV0J4Wwjh1Z2Zy/iJIirH1bEsrehxjTVZvlBd
         qjCTzqASqy3y2tCV3WPoZHVABsZxGDcDpQl6HrBJMQkoRuYf7DH/MluVr4aUPzSQKCdA
         Hk4N2x9oycSsR5LLR/5ugLa6ccL4xRSBtPKVIabb40DVSxEx2aBF3+7OqgNHW+iA0fCb
         xRzXSSbkdY348lRdF6l6lrEznLqeyn13XTAjbiRNQTmJ97LKMJs7OX+v4ZDpfbAUSAMO
         P72ZF9ZtEju2so8ETSwsD6JtoDPJ9Jhhglk9u/xldO0Z6I3ywRUL3aAlu1oPsn8QInQx
         31PA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

This patchset updates the sheepdog driver. With this change, sheepdog
can support iSCSI multipath correctly with failover path grouping
policy.

Hitoshi Mitake (3):
  sheepdog: refresh invalidated inode in update_inode() path
  sheepdog: set flag for indicating requests are from tgt
  sheepdog: change a method for detecting invalidation of inode

 usr/bs_sheepdog.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

-- 
1.8.3.2
