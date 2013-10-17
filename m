From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v3 0/3] various improvements of bs_sheepdog.c
Date: Thu, 17 Oct 2013 16:38:31 +0900
Message-ID: <1381995514-8816-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Hi tgt list and sheepdog list,

This patchset improves bs_sheepdog.c of tgtd.
1. correcting a treatment of snapshot VDIs
2. removing segfault which can happen during logical unit deletion
3. validating address of sheep process before logical unit creation

Please consider applying them.

Thanks,
Hitoshi

v3: return error when --backing-store is invalid form (the 3rd patch)

Hitoshi Mitake (3):
  bs_sheepdog.c: mock the behavior of QEMU's sheepdog driver in a
    correct manner
  bs_sheepdog.c: fix segmentation fault caused by deleting logical unit
  bs_sheepdog.c: test connection when new logical unit is created

 usr/bs_sheepdog.c |  139 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 109 insertions(+), 30 deletions(-)

-- 
1.7.10.4

