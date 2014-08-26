From: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>
Subject: Re: poor rbd performance - more data
Date: Tue, 26 Aug 2014 17:02:27 -0400
Message-ID: <CAGbvivJ4JM-g14gMZFdLXT5mkPwzFN1x=w7SjrRtEfr-71nnvQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

I did some additional testing today comparing performance of
open-iscsi + tgt/rbd vs tgt/ramdisk to verify where the performance
bottleneck seems to occur.

With a simple RAM disk iscsi target, I could push up to about
1GB/second for both read and write operations.  Running the same tests
(using fio) against an RBD based iscsi target, I only could get up to
about 400MB/sec for both read and write (write was slightly slower).

Running yet another test with fio, using the rbd ioengine, I can
generate 1GB/sec for reads and about 800MB/sec for writes.

tgtd/ramdisk:   1GB/sec 1GB/sec (read/write)
tgtd/rbd:       400MB/sec 388 MB/sec
librados:     1GB/sec 800MB/sec

All of these tests were against a tgtd with 512 threads.

The fio job parameters are as follows, I only varied the ioengine, rw,
and filename settings depending on what was being tested.

[default]
rw=randread
size=10g
bs=1m
ioengine=libaio
direct=1
numjobs=1
filename=/dev/sdb
runtime=600
write_bw_log=iscsiread
iodepth=256
iodepth_batch=256


So, open-iscsi is certainly capable of better speed, and librados can
get better speed, so the bottleneck appears to be either in tgtd or in
the context switch between the iscsi initiator and tgtd.

I wanted to share this with the devs here, I'll keep looking for other
areas of improvement.

thanks,
   Wyllys
