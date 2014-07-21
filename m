From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: STGT fork for "broken disk emulation"
Date: Mon, 21 Jul 2014 14:52:30 -0700
Message-ID: <CAN05THRgcZUb=6Z3_YVuYShPUPveW4V7aanFCfU-ceYehwpRkQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=HZQAW8EngriseA68JK15HuBTHDNCcJhAY0vMWJXts2c=;
        b=d7WzWyKdf1C99EPWXEhrnpAjk/SjuMwkWtH1xOb5tVFnYyIB+IPCRPz05SXMvpkeWx
         7oJEZUX8FWxWSb6N3rmzuEtTDDPv6PacHTn0AIA2qxTHcSurl6wope2DYuVY1FoPVigr
         slm0aTdI+ThKPkk0wAE1PVkBzk5BrCCp/MKZh4/YTMAWwf9HhbvbtpSpvgnRsvQK69e5
         lRz+ZkP6JCi+mxeq1iinFpGo5MPo5I2iu0EFiIw4qez0hgyS/Jl8mnbZ8GawZ+YV6bfL
         ny/eXKLJ2HAkqCI1GJ2/TFE+vfvvpKLQEM+b/60x+0h1HnI6C8YZfSlAb9JfVu8QatOK
         6A4w==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt <stgt@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

List,

I have created a temporary work version of TGTD at:
https://github.com/rsahlberg/flaky-stgt

This is not a production TGTD or a version that any normal users should use,
instead I had an idea to try to add features to make it possible to create an
iSCSI device that is broken and misbehaves in controllable ways.

For example, imagine a scsi disk that is "good" right now but after a
certain stage in a scripted test the disk goes bad and start failing
all WRITE commands.
Just like a disk that suddenly has run out of reallocation space.


The only people I see that could find this type of feature useful
would be, I guess,
filesystem developers, SCSI initiator midlayer developers or perhaps
people writing
code that talks directly to the disk and want to test that their error
recovery paths
work.
I see no use or benefit from these features to normal users.


Right now it is a bit in flux, and I also need to see if I can find
buy-in and convince
filesystem and block device driver developer folks that this could
actually be useful to them.

Later on would come the question, should I refactor the code and
should we push this into STGT mainline?
I personally think that this usecase I am aiming for is so special
case, and is only
features that are useful or relevant to an almost infinitely small set
of filesystem and block device driver developers that it would not
make much sense.
But if the TGTD community would rather have this built-in to official TGTD I am
more than happy to rework the patches once things stabilize and submit.

This is not a hostile fork. this is a temporary work/scratch space
while I experiment
on "broken disk emulation" and while I try to see if there is interest
in the devlopment community of this as a test tool.


If anyone of you think this could be useful, please feel to try it out
or let your
filesystem developer friends know that "could you use a scsi disk that
is 'busted' in controllable ways for your testing?"


best regards
ronnie sahlberg
