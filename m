From: Zhu Lingshan <LSZhu@suse.com>
Subject: Missing tgtd symbols in "perf top"
Date: Fri, 30 Jan 2015 11:14:37 +0800
Message-ID: <54CAF71D.4030606@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: stgt@vger.kernel.org
Cc: fUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Hi experts!
I am facing a symbols problem when run perf (a software can analyze 
performance of a program) today.
I executed command line "perf record -p 6625 -g" to collect the report 
of  tgtd (pid is 6625). Then I use "perf report -g" to read it.
When I zoom into tgtd DSO, I found the symbol name on the top is 
missing, only  address shown. But other symbols are fine.

tgt version :  tgt-1.0.44-2.70.x86_64
perf version: perf-3.12.28-33.33.x86_64
OS: SUSE Linux Enterprise Server 12

The scene:

Samples: 5K of event 'cpu-clock', Event count (approx.): 1435000000, 
DSO: tgtd
+  43.99%  tgtd  [.] 0x0000000000012ac0
+  11.32%  tgtd  [.] iscsi_rx_handler
+   9.90%  tgtd  [.] iscsi_tx_handler
+   4.48%  tgtd  [.] scsi_cmd_perform
+   3.87%  tgtd  [.] iscsi_scsi_cmd_execute
+   2.39%  tgtd  [.] it_nexus_lookup
+   2.21%  tgtd  [.] target_cmd_queue
+   2.09%  tgtd  [.] tgt_event_modify
+   1.88%  tgtd  [.] target_cmd_perform
+   1.88%  tgtd  [.] bs_thread_cmd_submit
+   1.85%  tgtd  [.] is_bs_support_opcode

I have tried to use readelf and nm, did not find it. Hope can get some 
help and suggestion from experts!

Thanks for your help.
BR
Zhu Lingshan
