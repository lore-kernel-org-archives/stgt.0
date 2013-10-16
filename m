From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH 0/2] improvemenets of bs_sheepdog.c
Date: Wed, 16 Oct 2013 11:49:40 +0900
Message-ID: <1381891782-13078-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Hi tgt list and sheepdog list,

This patchset improves bs_sheepdog.c of tgtd. One is correcting a treatment of
snapshot VDIs and another one is fixing trivial bug.

Please consider applying them.

Thanks,
Hitoshi

Hitoshi Mitake (2):
  bs_sheepdog.c: mock the behavior of QEMU's sheepdog driver in a
    correct manner
  bs_sheepdog.c: fix segmentation fault caused by deleting logical unit

 usr/bs_sheepdog.c |  118 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 83 insertions(+), 35 deletions(-)

-- 
1.7.10.4

