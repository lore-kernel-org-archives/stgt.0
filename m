From: Norm Mackey <norman.mackey@agiloft.com>
Subject: Cannot connect to stock or newest tgtd from Centos 6.6
Date: Fri, 20 Feb 2015 22:19:22 +0000
Message-ID: <BN3PR0601MB1011C68F6CAA4C41086F491CEC2A0@BN3PR0601MB1011.namprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

Hello:

I have been unable to debug this problem, so far.

Any attempt to connect to tgtd from a Centos 6.6 system with its included infiniband drivers fails. 

Server is 

The most obvious symptom of this is that when the initiator contacts the target, tgtd requests 1GB of shared memory, which fails:

In response to initiatior:
[root@e5node05 iscsi]# iscsiadm -m discovery -t sendtargets -p 192.168.170.188:3260 -I iser

[root@e5san01 etc]# tgtd -f
tgtd: work_timer_start(146) use timer_fd based scheduler
tgtd: bs_init_signalfd(267) could not open backing-store module directory /usr/lib/tgt/backing-store
tgtd: bs_init(386) use signalfd notification
tgtd: iser_alloc_pool(571) shmget rdma pool sz:1073741824 failed
tgtd: iser_cm_conn_established(1613) conn:0x12db840 cm_id:0x12beac0, 192.168.170.85 -> 192.168.170.188, established
tgtd: iser_cm_disconnected(1633) conn:0x12db840 cm_id:0x12beac0 event:10, RDMA_CM_EVENT_DISCONNECTED
tgtd: iser_conn_close(1292) conn:0x12db840 cm_id:0x0x12beac0 state: CLOSE, refcnt:394
tgtd: iser_cm_timewait_exit(1648) conn:0x12db840 refcnt:1 cm_id:0x12beac0
tgtd: iser_cm_timewait_exit(1666) conn:0x12db840 refcnt:1 cm_id:0x12beac0 (after cleanup)

This happens with the stock tgtd 1.0.24, or the newest 1,0,55 tgtd (this listed above).

Any help would be greatly appreciated!

/etc/tgt/targets.conf:
[root@e5san01 etc]# cat /etc/tgt/targets.conf
<target iqn.2015-02.entwiz.com:target00>
    backing-store /iscsi_disks/disk01.img
    driver iser
</target>

target modules:
ib_iser                42254  0
iscsi_tcp               9891  0
be2iscsi              105183  0
iscsi_boot_sysfs        9458  1 be2iscsi
libiscsi_tcp           15964  4 cxgb4i,cxgb3i,iscsi_tcp,libcxgbi
libiscsi               48300  8 bnx2i,cxgb4i,cxgb3i,ib_iser,iscsi_tcp,be2iscsi,libcxgbi,libiscsi_tcp
scsi_transport_iscsi    99144  8 bnx2i,ib_iser,iscsi_tcp,be2iscsi,libcxgbi,libiscsi
ib_ipoib               81126  0
rdma_ucm               15500  0
ib_ucm                 12121  0
ib_uverbs              39106  6 rdma_ucm,ib_ucm
ib_umad                11802  8
rdma_cm                36322  2 ib_iser,rdma_ucm
ib_cm                  36996  3 ib_ipoib,ib_ucm,rdma_cm
iw_cm                   8516  1 rdma_cm
ib_sa                  24060  4 ib_ipoib,rdma_ucm,rdma_cm,ib_cm
ib_mthca              127327  1
ib_mad                 39811  4 ib_umad,ib_cm,ib_sa,ib_mthca
ib_core                81443  13 ib_iser,iw_cxgb3,ib_ipoib,rdma_ucm,ib_ucm,ib_uverbs,ib_umad,rdma_cm,ib_cm,iw_cm,ib_sa,ib_mthca,ib_mad
ib_addr                 8304  3 rdma_ucm,rdma_cm,ib_core
ipv6                  334740  40 cnic,ip6t_REJECT,nf_conntrack_ipv6,nf_defrag_ipv6,ib_ipoib,ib_addr

initiator modules:
[root@e5node05 iscsi]# lsmod|grep -E "ib_|rdma|scsi"
be2iscsi              105183  0
iscsi_boot_sysfs        9458  1 be2iscsi
iscsi_tcp               9891  0
libiscsi_tcp           15964  4 cxgb4i,cxgb3i,libcxgbi,iscsi_tcp
scsi_transport_sas     35588  2 mpt3sas,mpt2sas
ib_iser                42254  0
libiscsi               48300  8 be2iscsi,bnx2i,cxgb4i,cxgb3i,libcxgbi,iscsi_tcp,libiscsi_tcp,ib_iser
scsi_transport_iscsi    99144  8 be2iscsi,bnx2i,libcxgbi,iscsi_tcp,ib_iser,libiscsi
ib_ipoib               81126  0
rdma_ucm               15500  0
ib_ucm                 12121  0
ib_uverbs              39106  6 rdma_ucm,ib_ucm
ib_umad                11802  4
rdma_cm                36322  2 ib_iser,rdma_ucm
ib_cm                  36996  3 ib_ipoib,ib_ucm,rdma_cm
iw_cm                   8516  1 rdma_cm
ib_sa                  24060  4 ib_ipoib,rdma_ucm,rdma_cm,ib_cm
ib_mthca              127327  1
ib_mad                 39811  4 ib_umad,ib_cm,ib_sa,ib_mthca
ib_core                81443  13 iw_cxgb3,ib_iser,ib_ipoib,rdma_ucm,ib_ucm,ib_uverbs,ib_umad,rdma_cm,ib_cm,iw_cm,ib_sa,ib_mthca,ib_mad
ib_addr                 8304  3 rdma_ucm,rdma_cm,ib_core
ipv6                  334740  552 cnic,ip6t_REJECT,nf_conntrack_ipv6,nf_defrag_ipv6,ib_ipoib,ib_addr

SAN RAM: [root@e5san01 ~]# free -g
             total       used       free     shared    buffers     cached
Mem:            62          2         60          0          0          0
-/+ buffers/cache:          1         61
Swap:            1          0          1

Please, any help on this would be greatly apopreciated!
