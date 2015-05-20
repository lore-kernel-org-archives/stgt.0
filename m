From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH internal-review 0/2] Discovery mode session iser fixes
Date: Wed, 20 May 2015 11:45:54 +0300
Message-ID: <1432111556-20535-1-git-send-email-sagig@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

This small set is fixing discovery mode NULL dereference
and tasks leak in iser. These were found when testing against
FreeBSD iser initiator (https://github.com/sagigrimberg/iser-freebsd).

Sagi Grimberg (2):
  iser: Clear tasks free list when closing the connection
  iser: Fix wrong access to the session discovery mode

 usr/iscsi/iser.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

-- 
1.8.4.3
