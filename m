From: Marcel (Felix) Giannelia <info@skeena.net>
Subject: segfault on digest error
Date: Sun, 29 Mar 2015 00:45:35 -0700
Message-ID: <20150329004535.1193fb73@innuk.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/GO1DxSk9U.+b7Mg_EC7IAOJ"
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org

--MP_/GO1DxSk9U.+b7Mg_EC7IAOJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It seems that certain kinds of corrupted incoming packets will cause tgtd to crash with a segfault:

Feb 16 11:54:01 hostname kernel: tgtd[21178]: segfault at fffffffffffffff0 ip 00000000004086b0 sp 00007fff3ca9eaf0 error 4 in tgtd[400000+3e000]
Feb 16 11:54:01 hostname tgtd: iscsi_rx_handler(2107) rx hdr digest error 0xe5e46fae calc 0xd8d8e323
Feb 16 11:54:01 hostname tgtd: conn_close(101) connection closed, 0x1d28568 23
Feb 16 11:54:01 hostname tgtd: conn_close(107) sesson 0x1d281b0 1
Feb 16 11:54:01 hostname tgtd: conn_close(165) Forcing release of rx task 0x1da52c0 9d0c0000

Output from abrt for this crash attached. (Sorry if there isn't enough info in there to track this down -- I might be able to re-create the crash later with more trace info, but have little free time lately.)

This was with the latest scsi-target-utils package available for CentOS 6.6.

Some background that may be helpful in reproducing this:

I was able to reproduce this crash several times, and the root cause of the corrupted packets is a bug in either VMWare ESXi 5.1 or Windows Server 2012. We have a Windows Server 2012 virtual machine that connects to an iSCSI volume served by tgtd on a physical Linux (CentOS) machine. Windows uses this volume as its backup target, and backups were failing partway through, often causing the Windows machine to spontaneously reboot, and tgtd was logging a lot of rx digest errors whenever any significant amount of data was transferred.

All three problems -- data corruption on the wire, the Windows initiator crashing Windows, and tgtd segfaulting -- were solved by disabling TCP and IP checksum offloads in the virtual NIC driver in Windows. VMware uses a specialised set of rules to determine when offloaded checksums are calculated, and sometimes does not calculate TCP checksums until well after the packet has left the source machine; I strongly suspect a bug in this mechanism was messing up the iSCSI packets.

Still, tgtd should not be crashing with a segfault on receiving bad data; it should (at worst) force the connection closed but otherwise remain in a good state.

~Felix.
--MP_/GO1DxSk9U.+b7Mg_EC7IAOJ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=abrt_log.txt

abrt_version:   2.0.8
cgroup:
cmdline:        tgtd
executable:     /usr/sbin/tgtd
kernel:         2.6.32-504.8.1.el6.x86_64
last_occurrence: 1424116441
pid:            21178
pwd:            /
time:           Mon 16 Feb 2015 11:54:01 AM PST
uid:            0
username:       root

limits:
:Limit                     Soft Limit           Hard Limit           Units
:Max cpu time              unlimited            unlimited            seconds
:Max file size             unlimited            unlimited            bytes
:Max data size             unlimited            unlimited            bytes
:Max stack size            10485760             unlimited            bytes
:Max core file size        0                    unlimited            bytes
:Max resident set          unlimited            unlimited            bytes
:Max processes             7809                 7809                 processes
:Max open files            1048576              1048576              files
:Max locked memory         65536                65536                bytes
:Max address space         unlimited            unlimited            bytes
:Max file locks            unlimited            unlimited            locks
:Max pending signals       7809                 7809                 signals
:Max msgqueue size         819200               819200               bytes
:Max nice priority         0                    0
:Max realtime priority     0                    0
:Max realtime timeout      unlimited            unlimited            us

maps:
:00400000-0043e000 r-xp 00000000 09:7d 404567                             /usr/sbin/tgtd
:0063e000-0064b000 rw-p 0003e000 09:7d 404567                             /usr/sbin/tgtd
:0064b000-0064c000 rw-p 00000000 00:00 0
:0084a000-0084c000 rw-p 0004a000 09:7d 404567                             /usr/sbin/tgtd
:01ce5000-01d06000 rw-p 00000000 00:00 0
:01d06000-01e70000 rw-p 00000000 00:00 0
:3339800000-3339801000 r-xp 00000000 09:7d 262198                         /lib64/libaio.so.1.0.1
:3339801000-3339a00000 ---p 00001000 09:7d 262198                         /lib64/libaio.so.1.0.1
:3339a00000-3339a01000 rw-p 00000000 09:7d 262198                         /lib64/libaio.so.1.0.1
:3af1800000-3af1820000 r-xp 00000000 09:7d 262224                         /lib64/ld-2.12.so
:3af1a1f000-3af1a20000 r--p 0001f000 09:7d 262224                         /lib64/ld-2.12.so
:3af1a20000-3af1a21000 rw-p 00020000 09:7d 262224                         /lib64/ld-2.12.so
:3af1a21000-3af1a22000 rw-p 00000000 00:00 0
:3af1c00000-3af1d8a000 r-xp 00000000 09:7d 262266                         /lib64/libc-2.12.so
:3af1d8a000-3af1f8a000 ---p 0018a000 09:7d 262266                         /lib64/libc-2.12.so
:3af1f8a000-3af1f8e000 r--p 0018a000 09:7d 262266                         /lib64/libc-2.12.so
:3af1f8e000-3af1f8f000 rw-p 0018e000 09:7d 262266                         /lib64/libc-2.12.so
:3af1f8f000-3af1f94000 rw-p 00000000 00:00 0
:3af2000000-3af2017000 r-xp 00000000 09:7d 262349                         /lib64/libpthread-2.12.so
:3af2017000-3af2217000 ---p 00017000 09:7d 262349                         /lib64/libpthread-2.12.so
:3af2217000-3af2218000 r--p 00017000 09:7d 262349                         /lib64/libpthread-2.12.so
:3af2218000-3af2219000 rw-p 00018000 09:7d 262349                         /lib64/libpthread-2.12.so
:3af2219000-3af221d000 rw-p 00000000 00:00 0
:3af2400000-3af2402000 r-xp 00000000 09:7d 268170                         /lib64/libdl-2.12.so
:3af2402000-3af2602000 ---p 00002000 09:7d 268170                         /lib64/libdl-2.12.so
:3af2602000-3af2603000 r--p 00002000 09:7d 268170                         /lib64/libdl-2.12.so
:3af2603000-3af2604000 rw-p 00003000 09:7d 268170                         /lib64/libdl-2.12.so
:3af2800000-3af2813000 r-xp 00000000 09:7d 266353                         /usr/lib64/librdmacm.so.1.0.0
:3af2813000-3af2a13000 ---p 00013000 09:7d 266353                         /usr/lib64/librdmacm.so.1.0.0
:3af2a13000-3af2a14000 rw-p 00013000 09:7d 266353                         /usr/lib64/librdmacm.so.1.0.0
:3af2a14000-3af2a15000 rw-p 00000000 00:00 0
:3af2c00000-3af2c11000 r-xp 00000000 09:7d 267025                         /usr/lib64/libibverbs.so.1.0.0
:3af2c11000-3af2e11000 ---p 00011000 09:7d 267025                         /usr/lib64/libibverbs.so.1.0.0
:3af2e11000-3af2e12000 rw-p 00011000 09:7d 267025                         /usr/lib64/libibverbs.so.1.0.0
:3af3000000-3af3083000 r-xp 00000000 09:7d 262405                         /lib64/libm-2.12.so
:3af3083000-3af3282000 ---p 00083000 09:7d 262405                         /lib64/libm-2.12.so
:3af3282000-3af3283000 r--p 00082000 09:7d 262405                         /lib64/libm-2.12.so
:3af3283000-3af3284000 rw-p 00083000 09:7d 262405                         /lib64/libm-2.12.so
:3af4c00000-3af4c16000 r-xp 00000000 09:7d 262531                         /lib64/libgcc_s-4.4.7-20120601.so.1
:3af4c16000-3af4e15000 ---p 00016000 09:7d 262531                         /lib64/libgcc_s-4.4.7-20120601.so.1
:3af4e15000-3af4e16000 rw-p 00015000 09:7d 262531                         /lib64/libgcc_s-4.4.7-20120601.so.1
:3af8000000-3af804d000 r-xp 00000000 09:7d 266144                         /lib64/libnl.so.1.1.4
:3af804d000-3af824c000 ---p 0004d000 09:7d 266144                         /lib64/libnl.so.1.1.4
:3af824c000-3af8252000 rw-p 0004c000 09:7d 266144                         /lib64/libnl.so.1.1.4
:7fd0af2b2000-7fd0af2b3000 ---p 00000000 00:00 0
:7fd0af2b3000-7fd0afcb3000 rw-p 00000000 00:00 0
:7fd0afcb3000-7fd0afcb4000 ---p 00000000 00:00 0
:7fd0afcb4000-7fd0b06b4000 rw-p 00000000 00:00 0
:7fd0b06b4000-7fd0b06b5000 ---p 00000000 00:00 0
:7fd0b06b5000-7fd0b10b5000 rw-p 00000000 00:00 0
:7fd0b10b5000-7fd0b10b6000 ---p 00000000 00:00 0
:7fd0b10b6000-7fd0b1ab6000 rw-p 00000000 00:00 0
:7fd0b1ab6000-7fd0b1ab7000 ---p 00000000 00:00 0
:7fd0b1ab7000-7fd0b24b7000 rw-p 00000000 00:00 0
:7fd0b24b7000-7fd0b24b8000 ---p 00000000 00:00 0
:7fd0b24b8000-7fd0b2eb8000 rw-p 00000000 00:00 0
:7fd0b2eb8000-7fd0b2eb9000 ---p 00000000 00:00 0
:7fd0b2eb9000-7fd0b38b9000 rw-p 00000000 00:00 0
:7fd0b38b9000-7fd0b38ba000 ---p 00000000 00:00 0
:7fd0b38ba000-7fd0b42ba000 rw-p 00000000 00:00 0
:7fd0b42ba000-7fd0b42bb000 ---p 00000000 00:00 0
:7fd0b42bb000-7fd0b4cbb000 rw-p 00000000 00:00 0
:7fd0b4cbb000-7fd0b4cbc000 ---p 00000000 00:00 0
:7fd0b4cbc000-7fd0b56bc000 rw-p 00000000 00:00 0
:7fd0b56bc000-7fd0b56bd000 ---p 00000000 00:00 0
:7fd0b56bd000-7fd0b60bd000 rw-p 00000000 00:00 0
:7fd0b60bd000-7fd0b60be000 ---p 00000000 00:00 0
:7fd0b60be000-7fd0b6abe000 rw-p 00000000 00:00 0
:7fd0b6abe000-7fd0b6abf000 ---p 00000000 00:00 0
:7fd0b6abf000-7fd0b74bf000 rw-p 00000000 00:00 0
:7fd0b74bf000-7fd0b74c0000 ---p 00000000 00:00 0
:7fd0b74c0000-7fd0b7ec0000 rw-p 00000000 00:00 0
:7fd0b7ec0000-7fd0b7ec1000 ---p 00000000 00:00 0
:7fd0b7ec1000-7fd0b88c1000 rw-p 00000000 00:00 0
:7fd0b88c1000-7fd0b88c2000 ---p 00000000 00:00 0
:7fd0b88c2000-7fd0b92c2000 rw-p 00000000 00:00 0
:7fd0b92c2000-7fd0b92c3000 ---p 00000000 00:00 0
:7fd0b92c3000-7fd0b9cc3000 rw-p 00000000 00:00 0
:7fd0b9cc3000-7fd0b9cc4000 ---p 00000000 00:00 0
:7fd0b9cc4000-7fd0ba6c4000 rw-p 00000000 00:00 0
:7fd0ba6c4000-7fd0ba6c5000 ---p 00000000 00:00 0
:7fd0ba6c5000-7fd0bb0c5000 rw-p 00000000 00:00 0
:7fd0bb0c5000-7fd0bb0c6000 ---p 00000000 00:00 0
:7fd0bb0c6000-7fd0bbac6000 rw-p 00000000 00:00 0
:7fd0bbac6000-7fd0bbac7000 ---p 00000000 00:00 0
:7fd0bbac7000-7fd0bc4c7000 rw-p 00000000 00:00 0
:7fd0bc4c7000-7fd0bc4c8000 ---p 00000000 00:00 0
:7fd0bc4c8000-7fd0bcec8000 rw-p 00000000 00:00 0
:7fd0bcec8000-7fd0bcec9000 ---p 00000000 00:00 0
:7fd0bcec9000-7fd0bd8c9000 rw-p 00000000 00:00 0
:7fd0bd8c9000-7fd0bd8ca000 ---p 00000000 00:00 0
:7fd0bd8ca000-7fd0be2ca000 rw-p 00000000 00:00 0
:7fd0be2ca000-7fd0be2cb000 ---p 00000000 00:00 0
:7fd0be2cb000-7fd0beccb000 rw-p 00000000 00:00 0
:7fd0beccb000-7fd0beccc000 ---p 00000000 00:00 0
:7fd0beccc000-7fd0bf6cc000 rw-p 00000000 00:00 0
:7fd0bf6cc000-7fd0bf6cd000 ---p 00000000 00:00 0
:7fd0bf6cd000-7fd0c00cd000 rw-p 00000000 00:00 0
:7fd0c00cd000-7fd0c00ce000 ---p 00000000 00:00 0
:7fd0c00ce000-7fd0c0ace000 rw-p 00000000 00:00 0
:7fd0c0ace000-7fd0c0acf000 ---p 00000000 00:00 0
:7fd0c0acf000-7fd0c14cf000 rw-p 00000000 00:00 0
:7fd0c14cf000-7fd0c14d0000 ---p 00000000 00:00 0
:7fd0c14d0000-7fd0c1ed0000 rw-p 00000000 00:00 0
:7fd0c1ed0000-7fd0c1ed1000 ---p 00000000 00:00 0
:7fd0c1ed1000-7fd0c28d1000 rw-p 00000000 00:00 0
:7fd0c28d1000-7fd0c28d2000 ---p 00000000 00:00 0
:7fd0c28d2000-7fd0c32d2000 rw-p 00000000 00:00 0
:7fd0c32d2000-7fd0c32d3000 ---p 00000000 00:00 0
:7fd0c32d3000-7fd0c3cd3000 rw-p 00000000 00:00 0
:7fd0c3cd3000-7fd0c3cd4000 ---p 00000000 00:00 0
:7fd0c3cd4000-7fd0c46d4000 rw-p 00000000 00:00 0
:7fd0c46d4000-7fd0c46d5000 ---p 00000000 00:00 0
:7fd0c46d5000-7fd0c50d5000 rw-p 00000000 00:00 0
:7fd0c50d5000-7fd0c50d6000 ---p 00000000 00:00 0
:7fd0c50d6000-7fd0c5ad6000 rw-p 00000000 00:00 0
:7fd0c5ad6000-7fd0c5ad7000 ---p 00000000 00:00 0
:7fd0c5ad7000-7fd0c64d7000 rw-p 00000000 00:00 0
:7fd0c64d7000-7fd0c64d8000 ---p 00000000 00:00 0
:7fd0c64d8000-7fd0c6ed8000 rw-p 00000000 00:00 0
:7fd0c6ed8000-7fd0c6ed9000 ---p 00000000 00:00 0
:7fd0c6ed9000-7fd0c78d9000 rw-p 00000000 00:00 0
:7fd0c78d9000-7fd0c78da000 ---p 00000000 00:00 0
:7fd0c78da000-7fd0c82da000 rw-p 00000000 00:00 0
:7fd0c82da000-7fd0c82db000 ---p 00000000 00:00 0
:7fd0c82db000-7fd0c8cdb000 rw-p 00000000 00:00 0
:7fd0c8cdb000-7fd0c8cdc000 ---p 00000000 00:00 0
:7fd0c8cdc000-7fd0c96dc000 rw-p 00000000 00:00 0
:7fd0c96dc000-7fd0c96dd000 ---p 00000000 00:00 0
:7fd0c96dd000-7fd0ca0dd000 rw-p 00000000 00:00 0
:7fd0ca0dd000-7fd0ca0de000 ---p 00000000 00:00 0
:7fd0ca0de000-7fd0caade000 rw-p 00000000 00:00 0
:7fd0caade000-7fd0caadf000 ---p 00000000 00:00 0
:7fd0caadf000-7fd0cb4df000 rw-p 00000000 00:00 0
:7fd0cb4df000-7fd0cb4e0000 ---p 00000000 00:00 0
:7fd0cb4e0000-7fd0cbee0000 rw-p 00000000 00:00 0
:7fd0cbee0000-7fd0cbee1000 ---p 00000000 00:00 0
:7fd0cbee1000-7fd0cc8e1000 rw-p 00000000 00:00 0
:7fd0cc8e1000-7fd0cc8e2000 ---p 00000000 00:00 0
:7fd0cc8e2000-7fd0cd2e2000 rw-p 00000000 00:00 0
:7fd0cd2e2000-7fd0cd2e3000 ---p 00000000 00:00 0
:7fd0cd2e3000-7fd0cdce3000 rw-p 00000000 00:00 0
:7fd0cdce3000-7fd0cdce4000 ---p 00000000 00:00 0
:7fd0cdce4000-7fd0ce6e4000 rw-p 00000000 00:00 0
:7fd0ce6e4000-7fd0ce6e5000 ---p 00000000 00:00 0
:7fd0ce6e5000-7fd0cf0e5000 rw-p 00000000 00:00 0
:7fd0cf0e5000-7fd0cf0e6000 ---p 00000000 00:00 0
:7fd0cf0e6000-7fd0cfae6000 rw-p 00000000 00:00 0
:7fd0cfae6000-7fd0cfae7000 ---p 00000000 00:00 0
:7fd0cfae7000-7fd0d04e7000 rw-p 00000000 00:00 0
:7fd0d04e7000-7fd0d04e8000 ---p 00000000 00:00 0
:7fd0d04e8000-7fd0d0ee8000 rw-p 00000000 00:00 0
:7fd0d0ee8000-7fd0d0ee9000 ---p 00000000 00:00 0
:7fd0d0ee9000-7fd0d18e9000 rw-p 00000000 00:00 0
:7fd0d18e9000-7fd0d18ea000 ---p 00000000 00:00 0
:7fd0d18ea000-7fd0d22ea000 rw-p 00000000 00:00 0
:7fd0d22ea000-7fd0d22eb000 ---p 00000000 00:00 0
:7fd0d22eb000-7fd0d2ceb000 rw-p 00000000 00:00 0
:7fd0d2ceb000-7fd0d2cec000 ---p 00000000 00:00 0
:7fd0d2cec000-7fd0d36ec000 rw-p 00000000 00:00 0
:7fd0d36ec000-7fd0d36ed000 ---p 00000000 00:00 0
:7fd0d36ed000-7fd0d40ed000 rw-p 00000000 00:00 0
:7fd0d40ed000-7fd0d40ee000 ---p 00000000 00:00 0
:7fd0d40ee000-7fd0d4aee000 rw-p 00000000 00:00 0
:7fd0d4aee000-7fd0d4aef000 ---p 00000000 00:00 0
:7fd0d4aef000-7fd0d54ef000 rw-p 00000000 00:00 0
:7fd0d54ef000-7fd0d54f0000 ---p 00000000 00:00 0
:7fd0d54f0000-7fd0d5ef0000 rw-p 00000000 00:00 0
:7fd0d5ef0000-7fd0d5ef1000 ---p 00000000 00:00 0
:7fd0d5ef1000-7fd0d68f1000 rw-p 00000000 00:00 0
:7fd0d68f1000-7fd0d68f2000 ---p 00000000 00:00 0
:7fd0d68f2000-7fd0d72f2000 rw-p 00000000 00:00 0
:7fd0d72f2000-7fd0d72f3000 ---p 00000000 00:00 0
:7fd0d72f3000-7fd0d7cf3000 rw-p 00000000 00:00 0
:7fd0d7cf3000-7fd0d7cf4000 ---p 00000000 00:00 0
:7fd0d7cf4000-7fd0d86f4000 rw-p 00000000 00:00 0
:7fd0d86f4000-7fd0d86f5000 ---p 00000000 00:00 0
:7fd0d86f5000-7fd0d90f5000 rw-p 00000000 00:00 0
:7fd0d90f5000-7fd0d90f6000 ---p 00000000 00:00 0
:7fd0d90f6000-7fd0d9af6000 rw-p 00000000 00:00 0
:7fd0d9af6000-7fd0d9af7000 ---p 00000000 00:00 0
:7fd0d9af7000-7fd0da4f7000 rw-p 00000000 00:00 0
:7fd0da4f7000-7fd0da4f8000 ---p 00000000 00:00 0
:7fd0da4f8000-7fd0daef8000 rw-p 00000000 00:00 0
:7fd0daef8000-7fd0daef9000 ---p 00000000 00:00 0
:7fd0daef9000-7fd0db8f9000 rw-p 00000000 00:00 0
:7fd0db8f9000-7fd0db8fa000 ---p 00000000 00:00 0
:7fd0db8fa000-7fd0dc2fa000 rw-p 00000000 00:00 0
:7fd0dc2fa000-7fd0dc2fb000 ---p 00000000 00:00 0
:7fd0dc2fb000-7fd0dccfb000 rw-p 00000000 00:00 0
:7fd0dccfb000-7fd0dccfc000 ---p 00000000 00:00 0
:7fd0dccfc000-7fd0dd6fc000 rw-p 00000000 00:00 0
:7fd0dd6fc000-7fd0dd6fd000 ---p 00000000 00:00 0
:7fd0dd6fd000-7fd0de0fd000 rw-p 00000000 00:00 0
:7fd0de0fd000-7fd0de0fe000 ---p 00000000 00:00 0
:7fd0de0fe000-7fd0deafe000 rw-p 00000000 00:00 0
:7fd0deafe000-7fd0deaff000 ---p 00000000 00:00 0
:7fd0deaff000-7fd0df4ff000 rw-p 00000000 00:00 0
:7fd0df4ff000-7fd0df500000 ---p 00000000 00:00 0
:7fd0df500000-7fd0dff00000 rw-p 00000000 00:00 0
:7fd0dff00000-7fd0dff01000 ---p 00000000 00:00 0
:7fd0dff01000-7fd0e0901000 rw-p 00000000 00:00 0
:7fd0e0901000-7fd0e0902000 ---p 00000000 00:00 0
:7fd0e0902000-7fd0e1302000 rw-p 00000000 00:00 0
:7fd0e1302000-7fd0e1303000 ---p 00000000 00:00 0
:7fd0e1303000-7fd0e1d03000 rw-p 00000000 00:00 0
:7fd0e1d03000-7fd0e1d04000 ---p 00000000 00:00 0
:7fd0e1d04000-7fd0e2704000 rw-p 00000000 00:00 0
:7fd0e2704000-7fd0e2705000 ---p 00000000 00:00 0
:7fd0e2705000-7fd0e3105000 rw-p 00000000 00:00 0
:7fd0e3105000-7fd0e3106000 ---p 00000000 00:00 0
:7fd0e3106000-7fd0e3b06000 rw-p 00000000 00:00 0
:7fd0e3b06000-7fd0e3b07000 ---p 00000000 00:00 0
:7fd0e3b07000-7fd0e4507000 rw-p 00000000 00:00 0
:7fd0e4507000-7fd0e4508000 ---p 00000000 00:00 0
:7fd0e4508000-7fd0e4f08000 rw-p 00000000 00:00 0
:7fd0e4f08000-7fd0e4f09000 ---p 00000000 00:00 0
:7fd0e4f09000-7fd0e5909000 rw-p 00000000 00:00 0
:7fd0e5909000-7fd0e590a000 ---p 00000000 00:00 0
:7fd0e590a000-7fd0e630a000 rw-p 00000000 00:00 0
:7fd0e630a000-7fd0e630b000 ---p 00000000 00:00 0
:7fd0e630b000-7fd0e6d0b000 rw-p 00000000 00:00 0
:7fd0e6d0b000-7fd0e6d0c000 ---p 00000000 00:00 0
:7fd0e6d0c000-7fd0e770c000 rw-p 00000000 00:00 0
:7fd0e770c000-7fd0e770d000 ---p 00000000 00:00 0
:7fd0e770d000-7fd0e810d000 rw-p 00000000 00:00 0
:7fd0e810d000-7fd0e810e000 ---p 00000000 00:00 0
:7fd0e810e000-7fd0e8b0e000 rw-p 00000000 00:00 0
:7fd0e8b0e000-7fd0e8b0f000 ---p 00000000 00:00 0
:7fd0e8b0f000-7fd0e950f000 rw-p 00000000 00:00 0
:7fd0e950f000-7fd0e9510000 ---p 00000000 00:00 0
:7fd0e9510000-7fd0e9f10000 rw-p 00000000 00:00 0
:7fd0e9f10000-7fd0e9f11000 ---p 00000000 00:00 0
:7fd0e9f11000-7fd0ea911000 rw-p 00000000 00:00 0
:7fd0ea911000-7fd0ea912000 ---p 00000000 00:00 0
:7fd0ea912000-7fd0eb312000 rw-p 00000000 00:00 0
:7fd0eb312000-7fd0eb313000 ---p 00000000 00:00 0
:7fd0eb313000-7fd0ebd13000 rw-p 00000000 00:00 0
:7fd0ebd13000-7fd0ebd14000 ---p 00000000 00:00 0
:7fd0ebd14000-7fd0ec714000 rw-p 00000000 00:00 0
:7fd0ec714000-7fd0ec715000 ---p 00000000 00:00 0
:7fd0ec715000-7fd0ed115000 rw-p 00000000 00:00 0
:7fd0ed115000-7fd0ed116000 ---p 00000000 00:00 0
:7fd0ed116000-7fd0edb16000 rw-p 00000000 00:00 0
:7fd0edb16000-7fd0edb17000 ---p 00000000 00:00 0
:7fd0edb17000-7fd0ee517000 rw-p 00000000 00:00 0
:7fd0ee517000-7fd0ee518000 ---p 00000000 00:00 0
:7fd0ee518000-7fd0eef18000 rw-p 00000000 00:00 0
:7fd0eef18000-7fd0eef19000 ---p 00000000 00:00 0
:7fd0eef19000-7fd0ef919000 rw-p 00000000 00:00 0
:7fd0ef919000-7fd0ef91a000 ---p 00000000 00:00 0
:7fd0ef91a000-7fd0f031a000 rw-p 00000000 00:00 0
:7fd0f031a000-7fd0f031b000 ---p 00000000 00:00 0
:7fd0f031b000-7fd0f0d1b000 rw-p 00000000 00:00 0
:7fd0f0d1b000-7fd0f0d1c000 ---p 00000000 00:00 0
:7fd0f0d1c000-7fd0f171c000 rw-p 00000000 00:00 0
:7fd0f171c000-7fd0f171d000 ---p 00000000 00:00 0
:7fd0f171d000-7fd0f211d000 rw-p 00000000 00:00 0
:7fd0f211d000-7fd0f211e000 ---p 00000000 00:00 0
:7fd0f211e000-7fd0f2b1e000 rw-p 00000000 00:00 0
:7fd0f2b1e000-7fd0f2b1f000 ---p 00000000 00:00 0
:7fd0f2b1f000-7fd0f351f000 rw-p 00000000 00:00 0
:7fd0f351f000-7fd0f3520000 ---p 00000000 00:00 0
:7fd0f3520000-7fd0f3f20000 rw-p 00000000 00:00 0
:7fd0f3f20000-7fd0f3f21000 ---p 00000000 00:00 0
:7fd0f3f21000-7fd0f4921000 rw-p 00000000 00:00 0
:7fd0f4921000-7fd0f4922000 ---p 00000000 00:00 0
:7fd0f4922000-7fd0f5322000 rw-p 00000000 00:00 0
:7fd0f5322000-7fd0f5323000 ---p 00000000 00:00 0
:7fd0f5323000-7fd0f5d23000 rw-p 00000000 00:00 0
:7fd0f5d23000-7fd0f5d24000 ---p 00000000 00:00 0
:7fd0f5d24000-7fd0f6724000 rw-p 00000000 00:00 0
:7fd0f6724000-7fd0f6725000 ---p 00000000 00:00 0
:7fd0f6725000-7fd0f7125000 rw-p 00000000 00:00 0
:7fd0f7125000-7fd0f7126000 ---p 00000000 00:00 0
:7fd0f7126000-7fd0f7b26000 rw-p 00000000 00:00 0
:7fd0f7b26000-7fd0f7b27000 ---p 00000000 00:00 0
:7fd0f7b27000-7fd0f8527000 rw-p 00000000 00:00 0
:7fd0f8527000-7fd0f8528000 ---p 00000000 00:00 0
:7fd0f8528000-7fd0f8f28000 rw-p 00000000 00:00 0
:7fd0f8f28000-7fd0f8f29000 ---p 00000000 00:00 0
:7fd0f8f29000-7fd0f9929000 rw-p 00000000 00:00 0
:7fd0f9929000-7fd0f992a000 ---p 00000000 00:00 0
:7fd0f992a000-7fd0fa32a000 rw-p 00000000 00:00 0
:7fd0fa32a000-7fd0fa32b000 ---p 00000000 00:00 0
:7fd0fa32b000-7fd0fad2b000 rw-p 00000000 00:00 0
:7fd0fad2b000-7fd0fad2c000 ---p 00000000 00:00 0
:7fd0fad2c000-7fd0fb72c000 rw-p 00000000 00:00 0
:7fd0fb72c000-7fd0fb72d000 ---p 00000000 00:00 0
:7fd0fb72d000-7fd0fc12d000 rw-p 00000000 00:00 0
:7fd0fc12d000-7fd0fc12e000 ---p 00000000 00:00 0
:7fd0fc12e000-7fd0fcb2e000 rw-p 00000000 00:00 0
:7fd0fcb2e000-7fd0fcb2f000 ---p 00000000 00:00 0
:7fd0fcb2f000-7fd0fd52f000 rw-p 00000000 00:00 0
:7fd0fd52f000-7fd0fd530000 ---p 00000000 00:00 0
:7fd0fd530000-7fd0fdf30000 rw-p 00000000 00:00 0
:7fd0fdf30000-7fd0fdf31000 ---p 00000000 00:00 0
:7fd0fdf31000-7fd0fe931000 rw-p 00000000 00:00 0
:7fd0fe931000-7fd0fe932000 ---p 00000000 00:00 0
:7fd0fe932000-7fd0ff332000 rw-p 00000000 00:00 0
:7fd0ff332000-7fd0ff333000 ---p 00000000 00:00 0
:7fd0ff333000-7fd0ffd33000 rw-p 00000000 00:00 0
:7fd0ffd33000-7fd0ffd34000 ---p 00000000 00:00 0
:7fd0ffd34000-7fd100734000 rw-p 00000000 00:00 0
:7fd100734000-7fd100735000 ---p 00000000 00:00 0
:7fd100735000-7fd101135000 rw-p 00000000 00:00 0
:7fd101135000-7fd101136000 ---p 00000000 00:00 0
:7fd101136000-7fd101b36000 rw-p 00000000 00:00 0
:7fd101b36000-7fd101b37000 ---p 00000000 00:00 0
:7fd101b37000-7fd102537000 rw-p 00000000 00:00 0
:7fd102537000-7fd102538000 ---p 00000000 00:00 0
:7fd102538000-7fd102f38000 rw-p 00000000 00:00 0
:7fd102f38000-7fd102f39000 ---p 00000000 00:00 0
:7fd102f39000-7fd103939000 rw-p 00000000 00:00 0
:7fd103939000-7fd10393a000 ---p 00000000 00:00 0
:7fd10393a000-7fd10433a000 rw-p 00000000 00:00 0
:7fd10433a000-7fd10433b000 ---p 00000000 00:00 0
:7fd10433b000-7fd104d3b000 rw-p 00000000 00:00 0
:7fd104d3b000-7fd104d3c000 ---p 00000000 00:00 0
:7fd104d3c000-7fd10573c000 rw-p 00000000 00:00 0
:7fd10573c000-7fd10573d000 ---p 00000000 00:00 0
:7fd10573d000-7fd10613d000 rw-p 00000000 00:00 0
:7fd10613d000-7fd10613e000 ---p 00000000 00:00 0
:7fd10613e000-7fd106b3e000 rw-p 00000000 00:00 0
:7fd106b3e000-7fd106b3f000 ---p 00000000 00:00 0
:7fd106b3f000-7fd10753f000 rw-p 00000000 00:00 0
:7fd10753f000-7fd107540000 ---p 00000000 00:00 0
:7fd107540000-7fd107f40000 rw-p 00000000 00:00 0
:7fd107f40000-7fd107f41000 ---p 00000000 00:00 0
:7fd107f41000-7fd108941000 rw-p 00000000 00:00 0
:7fd108941000-7fd108942000 ---p 00000000 00:00 0
:7fd108942000-7fd109342000 rw-p 00000000 00:00 0
:7fd109342000-7fd109347000 rw-p 00000000 00:00 0
:7fd10934b000-7fd10934c000 rw-s 00000000 00:04 262146                     /SYSV00000000 (deleted)
:7fd10934c000-7fd109350000 rw-s 00000000 00:04 229377                     /SYSV00000000 (deleted)
:7fd109350000-7fd109351000 rw-s 00000000 00:04 196608                     /SYSV00000000 (deleted)
:7fd109351000-7fd109352000 rw-p 00000000 00:00 0
:7fff3ca8f000-7fff3caa4000 rw-p 00000000 00:00 0                          [stack]
:7fff3cbff000-7fff3cc00000 r-xp 00000000 00:00 0                          [vdso]
:ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]

open_fds:
:0:/dev/null
:pos:   0
:flags: 0100002
:1:/dev/null
:pos:   0
:flags: 0100002
:2:/dev/null
:pos:   0
:flags: 0100002
:3:[eventpoll]
:pos:   0
:flags: 02
:4:socket:[78669]
:pos:   0
:flags: 04002
:5:socket:[78670]
:pos:   0
:flags: 04002
:6:socket:[78671]
:pos:   0
:flags: 02
:7:socket:[78679]
:pos:   0
:flags: 02
:8:[timerfd]
:pos:   0
:flags: 04002
:9:[signalfd]
:pos:   0
:flags: 04002
:10:socket:[81686]
:pos:   0
:flags: 04002
:11:/iscsi/iscsidisk1.iscsi_raw
:pos:   0
:flags: 0100002
:12:/iscsi/iscsidisk2.iscsi_raw
:pos:   0
:flags: 0100002
:13:socket:[84548]
:pos:   0
:flags: 04002
:14:/iscsi/iscsidisk3.iscsi_raw
:pos:   0
:flags: 0100002
:15:/iscsi/iscsidisk4.iscsi_raw
:pos:   0
:flags: 0100002
:16:/iscsi/iscsidisk5.iscsi_raw
:pos:   0
:flags: 0100002
:17:/iscsi/iscsidisk6.iscsi_raw
:pos:   0
:flags: 0100002
:18:/iscsi/iscsidisk7.iscsi_raw
:pos:   0
:flags: 0100002
:19:/iscsi/iscsidisk8.iscsi_raw
:pos:   0
:flags: 0100002
:20:socket:[81704]
:pos:   0
:flags: 04002


--MP_/GO1DxSk9U.+b7Mg_EC7IAOJ--
