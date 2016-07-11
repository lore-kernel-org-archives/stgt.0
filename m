From: Anton Kovalenko <Anton.Kovalenko@acronis.com>
Subject: Memory leak of NOP-IN tasks in iscsi_tcp
Date: Mon, 11 Jul 2016 23:23:35 +0000
Message-ID: <1468279415325.97995@acronis.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <stgt-owner@vger.kernel.org>
Content-Language: ru-RU
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

Hi,

We've found a memory leak in tgtd recently (leaking a struct iscsi_task each nop_interval seconds).
The problem seems to have been there since the nop_interval was introduced.

My attempt at fixing it was submitted as a pull request, available at https://github.com/fujita/tgt/pull/21
The approach taken might be far from the best one possible, but the problem is severe enough to justify 
doing something to solve it, even if imperfect. 

Please consider accepting the pull request, or propose an alternative approach that has some chance of being accepted.

-- 
Best Regards, Anton Kovalenko