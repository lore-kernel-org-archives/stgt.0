From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v4 RFC 0/5] tgtd: offload iSCSI PDU send/recv to worker threads
Date: Fri, 14 Feb 2014 20:21:28 +0900
Message-ID: <1392376893-26106-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Current tgtd sends and receives iSCSI PDUs in its main event
loop. This design can cause bottleneck when many iSCSI clients connect
to single tgtd process. For example, we need multiple tgtd processes
for utilizing fast network like 10 GbE because typical single
processor core isn't fast enough for processing a bunch of requests.

This patchset lets tgtd offload send/recv iSCSI PDUs and digest checking to
worker threads. The basic strategy of this change is like below:
1. decompose iscsi_[rt]x_handler()
2. re-implement single threaded version of iscsi_tcp_event_handler()
3. implement multi-threaded version of iscsi_tcp_event_handler()

This patch also adds a new option "-T" to specify a number of threads which
send/recieve PDUs. When 1 is passed with the option, the above single threaded
version will be used, because the multi-threaded version incurs overhead which
comes from frequent communication between threads in some case. If users don't
want to use the multi-threaded version, they don't have to use it.

Below is a summary of our performance evaluation:
- 4 physical hosts connected with 10Gbps ethernet
- 1 tgtd process provides 1 logical unit
- 16 VMs read 4GB iso file by dd command in parallel
-- average time required to complete the dd command of 16 VMs is a score
--- original tgtd: 93.718 second
--- changed tgtd (with -T 16): 57.449 second

The above scores show that this patchset can improve performance of parallel
access of initiators. This patchset is not so heavily tested yet. I'd like to
hear your opinion about the design.

Hitoshi Mitake (5):
  tgtd: add helper functions for checking iostate of iscsi connections
  tgtd: decompose iscsi_[rt]x_handler()
  tgtd: add a new option "-T" for specifying a number of threads which
    send/recv iSCSI PDUs
  tgtd: implement a deferred event modification mechanism
  tgtd: offload iSCSI PDU send/recv to worker threads

 usr/iscsi/iscsi_tcp.c |  405 +++++++++++++++++++++++++++++++++++++++++++++++--
 usr/iscsi/iscsid.c    |  101 ++++++++----
 usr/iscsi/iscsid.h    |   11 +-
 usr/tgtd.c            |   10 +-
 usr/tgtd.h            |    1 +
 5 files changed, 483 insertions(+), 45 deletions(-)

-- 
1.7.10.4
