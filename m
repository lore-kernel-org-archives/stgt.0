From: Anton Kovalenko <anton.kovalenko@acronis.com>
Subject: Multiple abort_task_set()s for one scsi_cmd
Date: Tue, 26 Jul 2016 21:25:38 +0300
Message-ID: <87bn1kz271.fsf@desktop-ng.home.sw4me.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org


Hi all,

If tgtd has got a long-running SCSI command passed to a bs_ driver
(cmd_processed), and it receives ABORT TASK SET tm function more than
once, how should it be handled correctly?

We've run into this problem in an unusual situation that may be itself
impossible to handle in a sensible way: basically we've got several aio
operations running forever. The problem is compounded by each ABORT TASK
SET task management function, which itself takes forever to
complete, because it selects those SCSI commands to be aborted.

Therefore if we have, say, 8 writes that happen to run forever, after
several hours we'd have 2000 abort_task_set tasks as well.

BUT it seems that a long-running SCSI command might cause similar
problem if ABORT TASK SET arrives more than once during its
execution. Consider the following stream of events:

(1) arrives a long-running command that eventually completes or fails
(2) arrives an ABORT TASK SET #1
(3) arrives an ABORT TASK SET #2
(4) The SCSI command completes.

A single scsi_cmd has a single "mreq" pointer, and when it completes,
tgtd will decrement a "busy" counter for a single ABORT TASK SET only. I
believe that with the current tgtd code, "mreq" will be overwritten when
the comman is selected for the second ABORT TASK SET, hence the first
ABORT TASK SET won't complete forever. Perhaps it should be fixed somehow.

Now I'm unsure what's the right way to handle it according to the
specs. Should ABORT TASK SET's be chained into a linked list, if there
may be many of them waiting for a single SCSI command? Or should it be
assumed that the second ABORT TASK SET doesn't consider commands that
are already selected to be aborted by the first ABORT TASK SET?

It would be great to get any ideas on this topic.

-- 
Regards, Anton Kovalenko | +7(916)345-34-02 | Elektrostal' MO, Russia
