From: Dipen Modi <Dipen_Modi@symantec.com>
Subject: segfault in tgtd version 1.0.24 CentOS 6.6
Date: Mon, 6 Jul 2015 14:59:21 -0700
Message-ID: <EFF6E8AF0F7A1C40A5B60B3E46AF7103A6013EF138@TUS1XCHEVSPIN31.SYMC.SYMANTEC.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

Hi,
I have a CentOS 6.6 box (2.6.32-504.16.2.el6.x86_64) with scsi-target-utils-1.0.24-16.el6.x86_64. Under heavy load, I'm seeing tgtd segfault with this stack trace:

#0  0x00000000004086b0 in iscsi_data_out_rx_start (conn=0x22e8358) at iscsi/iscsid.c:1538
#1  iscsi_task_rx_start (conn=0x22e8358) at iscsi/iscsid.c:1743
#2  iscsi_rx_handler (conn=0x22e8358) at iscsi/iscsid.c:2000
#3  0x000000000040e538 in iscsi_tcp_event_handler (fd=<value optimized out>, events=5, data=0x22e8358) at iscsi/iscsi_tcp.c:158
#4  0x000000000041a319 in event_loop () at tgtd.c:411
#5  0x000000000041a9ca in main (argc=<value optimized out>, argv=<value optimized out>) at tgtd.c:583

I searched mailing list archives and found a similar issue on mailing list mirror back from 2011:
http://www.spinics.net/lists/linux-stgt/msg02653.html

But there was no conclusion. So Is this still a known issue? If not, which version is it fixed in?

Thanks,
Dipen
