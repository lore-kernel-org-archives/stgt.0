From: Turbo Fredriksson <turbo@bayour.com>
Subject: Delay between 'delete' and 'deleted'
Date: Wed, 19 Feb 2014 22:45:27 +0100
Message-ID: <C62618AF-7714-4E83-84E7-4C51A0341676@bayour.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

I've added support for STGT to ZFS On Linux (ZoL), and I notice that there seems to be a ... 'delay'
between issuing the delete of a TID and until it's actually deleted.

I've used 'tgtadm --lld iscsi --op show --mode target --tid TID' in a do/while loop, but even if
(when) it returns '!0' (which seems to indicate that it couldn't be found, ZoL still reports
'dataset busy'.

Having a 'usleep(500000)' in appropriate place will solve the problem. If the system is idle, then
a much lower usleep can be used, but half a second seems to work up to load level ~3 (haven't been
able to load the system more than that).


Is there a clear/safe way of being sure that a target have been removed?



Unfortunately, I can't reproduce this by using a file in the filesystem (since Linux will catch
this):

----- s n i p ------
#!/bin/sh

dd if=/dev/zero of=/tmp/stgt.test1 count=1

tgtadm --lld iscsi --op new --mode target      --tid 1 -T iqn.2012-11.com.bayour:test1
tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1 -b /tmp/stgt.test1

tgtadm --lld iscsi --op delete --mode target --tid 1 &
rm /tmp/stgt.test1
echo "=> $?"
----- s n i p ------

Will result in:

----- s n i p ------
DebianZFS-Wheezy-SCST2:~# test_stgt.sh
1+0 records in
1+0 records out
512 bytes (512 B) copied, 4.2732e-05 s, 12.0 MB/s
=> 0
----- s n i p ------

-- 
I love deadlines. I love the whooshing noise they
make as they go by.
- Douglas Adams
