From: Dong Wu <archer.wudong@gmail.com>
Subject: tgtadm: this logical unit is still active
Date: Fri, 24 Apr 2015 18:02:53 +0800
Message-ID: <CAAL-TMd-D_BEsfbHv-sicGX3mkBfKXWXq6RWnJQ9=QuhvrKY2A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=Izn9RyS9r/E3r68EBZLDeWCkjTWxS6BI0iNsaVmk1w8=;
        b=CWSYjH5iZZX86Khcb4vV0hF5cSpv1oXE/SiL//2DQ1l2Tax79Gx2LIryecwUd9TxpK
         L4cNEgfMptOez7d34VR1uBrLMey5Y0lDXrldVUnShiyW3P38TJM43ErFRQIEGUeSc09C
         gsym0p+vuIUpl2DJLdTYFvxfP2fpEfX1IVAFbSsrlhXtgNFnSukwEIqFqjQ840Uao1xW
         XE8zc7/NhfO32LfxoAh605hHPGDu4NfS01RVGAAvfnm1jJCL4XF0Fo9PZlRFKfbOiClh
         jjv8LDM9vYKKn1IjxG8njVT48tBjlnM2jxSVx9JmfNpZEGr3ZqRR2c/xN56S74kLp94M
         2D+Q==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

hi all,

I use aio as tgt backing store, when io_submit fail in aio, then I
delete that lun and got an error
'tgtadm: this logical unit is still active'.

Is this a bug?

here is reproducing method.

1.create target and lun
# tgtadm --lld iscsi --mode target --op new --tid=1000
--targetname=iqn.tgt.test.1
# tgtadm --lld iscsi --mode logicalunit --op new --tid=1000 --lun 1
--backing-store=/dev/vdb --bstype aio
# tgtadm --lld iscsi --mode target --op bind --tid=1000 --initiator-address ALL

2.use open-iscsi to connect the target
# iscsiadm -m discovery -t st -p 10.184.17.14:3260
# iscsiadm -m node -T iqn.tgt.test.1 -p 10.184.17.14:3260 -l


# iscsiadm -m session -P3
iSCSI Transport Class version 2.0-870
version 2.0-873
Target: iqn.tgt.test.1
    Current Portal: 10.184.17.14:3260,1
    Persistent Portal: 10.184.17.14:3260,1
        **********
        Interface:
        **********
        Iface Name: default
        Iface Transport: tcp
        Iface Initiatorname: iqn.1993-08.org.debian:01:743f99353c6
        Iface IPaddress: 10.184.17.14
        Iface HWaddress: <empty>
        Iface Netdev: <empty>
        SID: 3
        iSCSI Connection State: LOGGED IN
        iSCSI Session State: LOGGED_IN
        Internal iscsid Session State: NO CHANGE
        *********
        Timeouts:
        *********
        Recovery Timeout: 120
        Target Reset Timeout: 30
        LUN Reset Timeout: 30
        Abort Timeout: 15
        *****
        CHAP:
        *****
        username: <empty>
        password: ********
        username_in: <empty>
        password_in: ********
        ************************
        Negotiated iSCSI params:
        ************************
        HeaderDigest: None
        DataDigest: None
        MaxRecvDataSegmentLength: 262144
        MaxXmitDataSegmentLength: 8192
        FirstBurstLength: 65536
        MaxBurstLength: 262144
        ImmediateData: Yes
        InitialR2T: Yes
        MaxOutstandingR2T: 1
        ************************
        Attached SCSI devices:
        ************************
        Host Number: 4    State: running
        scsi4 Channel 00 Id 0 Lun: 0
        scsi4 Channel 00 Id 0 Lun: 1
            Attached scsi disk sda        State: running


3.simulate io_submit fail condition
1) here is the code slice of bs_aio.c

143         nsuccess = io_submit(info->ctx, nsubmit, info->piocb_arr);
144         if (unlikely(nsuccess < 0)) {
145                 if (nsuccess == -EAGAIN) {
146                         eprintf("delayed submit %d cmds to tgt:%d
lun:%"PRId64 "\n",
147                                 nsubmit, info->lu->tgt->tid, info->lu->lun);
148                         nsuccess = 0; /* leave the dev pending
with all cmds */
149                 }
150                 else {
151                         eprintf("failed to submit %d cmds to
tgt:%d lun:%"PRId64
152                                 ", err: %d\n",
153                                 nsubmit, info->lu->tgt->tid,
154                                 info->lu->lun, -nsuccess);
155                         return nsuccess;
156                 }
157         }

2) then use gdb to debug the tgt, and break at bs_aio.c:143
# gdb -p 8891
(gdb) b bs_aio.c:143
Breakpoint 1 at 0x41b7c4: file bs_aio.c, line 143.
(gdb) c
Continuing.

3) and open another shell, use dd  to read this iscsi device, here dd
will hang because it trigger gdb breakpoints.
# dd if=/dev/sda of=/dev/null bs=4k count=1 iflag=direct

4) switch to the gdb shell, I just set nsubmit=-1 to simulate io_submit fail,
this operation repeated several times.

(gdb) b bs_aio.c:143
Breakpoint 1 at 0x41b7c4: file bs_aio.c, line 143.
(gdb) c
Continuing.

Breakpoint 1, bs_aio_submit_dev_batch (info=0x73b908) at bs_aio.c:143
143        nsuccess = io_submit(info->ctx, nsubmit, info->piocb_arr);
(gdb) p nsubmit
$2 = 1
(gdb) set nsubmit=-1
(gdb) n
144        if (unlikely(nsuccess < 0)) {
(gdb) p nsuccess
$4 = -22
(gdb) n
145            if (nsuccess == -EAGAIN) {
(gdb) n
151                eprintf("failed to submit %d cmds to tgt:%d lun:%"PRId64
(gdb) c
Continuing.

Breakpoint 1, bs_aio_submit_dev_batch (info=0x73b908) at bs_aio.c:143
143        nsuccess = io_submit(info->ctx, nsubmit, info->piocb_arr);
(gdb) p nsubmit
$5 = 2
(gdb) set nsubmit=-1
(gdb) n
144        if (unlikely(nsuccess < 0)) {
(gdb) p nsuccess
$6 = -22
(gdb) c
Continuing.

Breakpoint 1, bs_aio_submit_dev_batch (info=0x73b908) at bs_aio.c:143
143        nsuccess = io_submit(info->ctx, nsubmit, info->piocb_arr);
(gdb) p nsubmit
$7 = 3
(gdb) set nsubmit=-1
(gdb) n
144        if (unlikely(nsuccess < 0)) {
(gdb) p nsuccess
$8 = -22
(gdb) c
Continuing.

Breakpoint 1, bs_aio_submit_dev_batch (info=0x73b908) at bs_aio.c:143
143        nsuccess = io_submit(info->ctx, nsubmit, info->piocb_arr);
(gdb) p nsubmit
$9 = 4
(gdb) set nsubmit=-1
(gdb) n
144        if (unlikely(nsuccess < 0)) {
(gdb) p nsuccess
$10 = -22
(gdb) c
Continuing.

Breakpoint 1, bs_aio_submit_dev_batch (info=0x73b908) at bs_aio.c:143
143        nsuccess = io_submit(info->ctx, nsubmit, info->piocb_arr);
(gdb) p nsubmit
$11 = 5
(gdb) set nsubmit=-1
(gdb) p nsubmit
$12 = -1
(gdb) n
144        if (unlikely(nsuccess < 0)) {
(gdb) p nsuccess
$13 = -22
(gdb) c
Continuing.

Breakpoint 1, bs_aio_submit_dev_batch (info=0x73b908) at bs_aio.c:143
143        nsuccess = io_submit(info->ctx, nsubmit, info->piocb_arr);
(gdb) set nsubmit=-1
(gdb) n
144        if (unlikely(nsuccess < 0)) {
(gdb) p nsuccess
$14 = -22
(gdb) c
Continuing.

5) after simulate io_submit several times, the dd process fail.
# dd if=/dev/sda of=/dev/null bs=4k count=1 iflag=direct
dd: reading `/dev/sda': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 130.426 s, 0.0 kB/s

6) then I delete the lun, and get an error.
# tgtadm --lld iscsi --mode logicalunit --op delete --tid=1000 --lun=1
tgtadm: this logical unit is still active

7) here is some delete lun logic in target.c:tgt_device_destroy.
 737         if (!list_empty(&lu->cmd_queue.queue) || lu->cmd_queue.active_cmd)
 738                 return TGTADM_LUN_ACTIVE;

8) I use gdb to debug tgt again, this time break at target.c:731, here
is some debug info.
(gdb) b target.c:731
Breakpoint 2 at 0x421a7d: file target.c, line 731.
(gdb) c
Continuing.

Breakpoint 2, tgt_device_destroy (tid=1000, lun=1, force=0) at target.c:731
731        lu = __device_lookup(tid, lun, &target);
(gdb) n
732        if (!lu) {
(gdb) n
737        if (!list_empty(&lu->cmd_queue.queue) || lu->cmd_queue.active_cmd)
(gdb) p lu->cmd_queue.queue
$15 = {next = 0x739bb0, prev = 0x739bb0}
(gdb) p lu->cmd_queue.active_cmd
$16 = 6
(gdb) c
Continuing.

9) according to above information, I guess that when io_submit fail,
it goes to the fault operation but does not minus
lu->cmd_queue.active_cmd, and this cause "the logical unit is still
active" error when I delete this lun.

So, Is it a bug or just tgt normal logic?
