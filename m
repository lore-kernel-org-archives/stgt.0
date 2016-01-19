From: Harald Dunkel <harald.dunkel@aixigo.de>
Subject: tgtd core dump
Date: Tue, 19 Jan 2016 16:10:42 +0100
Message-ID: <569E51F2.5030804@aixigo.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi folks,

trying to remove the (one and only) user bound to an inactive
target I got a core dump:

root@nasl003a:/var/log# grep tgt /var/log/messages
Jan 18 14:13:23 nasl003a kernel: [1641317.827328] tgtd calls setitimer() with new_value NULL pointer. Misfeature support will be removed
Jan 18 15:59:46 nasl003a kernel: [ 6314.997713] tgtd calls setitimer() with new_value NULL pointer. Misfeature support will be removed
Jan 18 16:03:22 nasl003a kernel: [  145.200454] tgtd calls setitimer() with new_value NULL pointer. Misfeature support will be removed
Jan 18 16:34:04 nasl003a kernel: [ 1343.776813] tgtd calls setitimer() with new_value NULL pointer. Misfeature support will be removed
Jan 18 16:36:11 nasl003a kernel: [   56.800251] tgtd calls setitimer() with new_value NULL pointer. Misfeature support will be removed
Jan 19 09:32:52 nasl003a kernel: [58493.238022] tgtd calls setitimer() with new_value NULL pointer. Misfeature support will be removed
Jan 19 10:49:51 nasl003a kernel: [63114.805104] tgtd[13697]: segfault at 8 ip 00000000004258d0 sp 00007ffe95eb62f0 error 4 in tgtd[400000+4d000]

tgtd was gone after that.

I did not run an unbound first, so shame on me, but I wonder
if this is a known problem? I was hoping to go productive
with a new iscsi server next weekend. Now I am a little
bit concerned that there might be more core dumps.

Version is 1.0.62, built on Debian 8.


Every helpful and reassuring comment is highly appreciated
Harri
