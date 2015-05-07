From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: 1.0.58 released
Date: Thu, 07 May 2015 20:25:01 +0900 (JST)
Message-ID: <20150507.202501.1568838937885759993.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Sorry about the delay on the announcement.

=
Dong Wu (1):
      bs_aio: fix failure handling

FUJITA Tomonori (1):
      tgt 1.0.58

Hitoshi Mitake (1):
      sheepdog: fine grained locking in write path

Roi Dayan (2):
      mgmt: Create ipc socket parent dir if does not exists
      iser: Fix memory leak of addrinfo struct

Ronnie Sahlberg (4):
      tgtd.c: allow oom adjust failures for non-root users
      mgmt: change ipc socket address
      mgmt.c: check that the connecting user is the same as the user tgtd runs as
      Allow overriding the IPC socket path via TGT_IPC_SOCKET
