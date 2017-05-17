From: Benedikt Fraunhofer <fraunhofer@traced.net>
Subject: undeletable targets with connections fixed with last commits?
Date: Wed, 17 May 2017 16:30:38 +0200
Message-ID: <CAD_6HTExuEA8-xPp30KoyL-qpe2h+CovoCUY+F1xtj58btaLyQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=mFCSRbedcI9hPN79Hcq/1DyxSADEWlJwzWjz4Rt7uco=;
        b=lg/COfaazaClU+44LbR/jxxQVulJHdsR3BxKj/mBkdlDGUovtTpOgWK6NAhGv43pwN
         8EV9odmJoLhykjDIOaabJjTbwIJkDY+fvXXL3Zi/O0PCo3g36ZKejfm7Er9kMGO2+gDf
         IdPGlmdzp3UE+/orzEMfH1JXoRQPiGFknvL8imzEeOItcGSX6kiwZK/3eRlrANoGdDQM
         olj6EJvDADD7MzerOL2lirQuYYU8hbJbT36i7UyOQoN5KHPlBh83CitUZ8mCdXstKkrl
         SK5wRF5ph875LIXNbwL7J8Q33SSmMZLaYr7T9iAgBRXk6vLENe95vwniBVnLGaulYQpC
         j/hA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hello List!

do the last commits

Avoid session* dangling reference on forced target destroy.
and
Avoid dangling session reference in login_security_done

address the problem of targets that just won't go away?

We're running 1.0.63 and quite often have the problem that we can't
delete targets and stgt think's there are connections while the
connection has already been shut down.
Also, those connections seem to pile up. We've some targets with >100
Connections to it while the initiator itself sees only one.

:# tgt-admin -v --force --delete iqn.2016-01.net.g:xbbs-szq8:iscsi
# Removing target: iqn.2016-01.net.g:xbbs-szq8:iscsi
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1016 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1012 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 10 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 436 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1017 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1013 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 530 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 435 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1014 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 554 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1019 --cid 1
tgtadm -C 0 --mode target --op delete --tid=27
tgtadm: this target is still active
Command:
        tgtadm -C 0 --mode target --op delete --tid=27
        exited with code: 22.

## trying with force one connection to go away

:# tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1016 --cid 1 --force
:# tgt-admin -v --force --delete iqn.2016-01.net.g:xbbs-szq8:iscsi
# Removing target: iqn.2016-01.net.g:xbbs-szq8:iscsi
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 10 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 554 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1013 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1016 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1019 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1012 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1014 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 435 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1017 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 530 --cid 1
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 436 --cid 1
tgtadm -C 0 --mode target --op delete --tid=27
tgtadm: this target is still active
Command:
        tgtadm -C 0 --mode target --op delete --tid=27
        exited with code: 22.

##connection still there

Offlineing the target, removing initiators (unbind) doesn't change anything.

Thx in advance
  Benedikt
