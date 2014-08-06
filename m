From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: bs_rbd not listed as backing store with 1.0.49
Date: Wed, 6 Aug 2014 13:22:28 -0700
Message-ID: <CAN05THSvF4w2emCQ5LbVQRnmrbqaPNKco+6iv65fGnRoJ-Dk0Q@mail.gmail.com>
References: <DF44185F-07DB-4138-AFE2-BCE24DD777F4@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=WnasUnwkPZGNqalidy3uVcw9uzFHPTHY7yNJiUn50Ac=;
        b=a7EADMOsNo3mr6DZCMK5i9SwLamdTsMFwGD3iqrsmcn2g6bpO5h5otlBzzk+Bz36VP
         I4QArOenPyoBB179CCawWYx/AypyYyth8z9SrlmapzWKT1yCTxbh157RkO8iPDz4raN3
         nT5yiUJR0I5ZT3o37fKeQSHSGj4iW3okc/QQoWxpc3O4B0NPA2DJBjOd+Y+anEhneeGm
         sZSkG2vEJL35h4cBGT6TlfH6LGv5lvApXaNB68WMsu7KQx9i4g8XP1DB1rqrA0xuREMO
         mXbAxgS9FCnA7kq6PgMcSynUMkuYNrnvrwE6Lsiwk/lJytpgRgutzpwfaR0WsS6KQEzW
         RS/g==
In-Reply-To: <DF44185F-07DB-4138-AFE2-BCE24DD777F4@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jim Lozanovski <jimlozanovski@gmail.com>
Cc: stgt <stgt@vger.kernel.org>

RBD is built as a module and it looks like your build did build it :
cc -shared -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2
-fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC
-DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\"
bs_rbd.c -o bs_rbd.so -lrados -lrbd

make install should have copied this into /lib/tgt/backing-store but
that did not seem to have happened.
Check if usr/Makefile does the right thing or not.


On Tue, Aug 5, 2014 at 7:08 PM, Jim Lozanovski <jimlozanovski@gmail.com> wrote:
> Hi List,
>
> Compiling 1.0.49 with CEPH_RBD support does not provide a RBD backing store:
>
> # tgtadm --version
> 1.0.49
>
> # tgtadm --lld iscsi --mode system --op show
> System:
>    State: ready
>    debug: off
> LLDs:
>    iser: error
>    iscsi: ready
> Backing stores:
>    rdwr (bsoflags sync:direct)
>    ssc
>    null
>    bsg
>    sg
>    sheepdog
> Device types:
>    passthrough
>    tape
>    changer
>    controller
>    osd
>    cd/dvd
>    disk
> iSNS:
>    iSNS=Off
>    iSNSServerIP=
>    iSNSServerPort=3205
>    iSNSAccessControl=Off
>
> System is CentOS release 6.5 (Final) kernel 2.6.32-431.20.3.el6.x86_64.
>
> Compilation output:
>
> # git clone https://github.com/fujita/tgt
> # cd tgt
> # make CEPH_RBD=1
> make -C usr
> make[1]: Entering directory `/root/tgt/usr'
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/conn.c -o iscsi/conn.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/param.c -o iscsi/param.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/session.c -o iscsi/session.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/iscsid.c -o iscsi/iscsid.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/target.c -o iscsi/target.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/chap.c -o iscsi/chap.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/sha1.c -o iscsi/sha1.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/md5.c -o iscsi/md5.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/transport.c -o iscsi/transport.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/iscsi_tcp.c -o iscsi/iscsi_tcp.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" iscsi/isns.c -o iscsi/isns.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" tgtd.c -o tgtd.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" mgmt.c -o mgmt.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" target.c -o target.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" scsi.c -o scsi.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" log.c -o log.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" driver.c -o driver.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" util.c -o util.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" work.c -o work.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" concat_buf.c -o concat_buf.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" parser.c -o parser.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" spc.c -o spc.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" sbc.c -o sbc.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" mmc.c -o mmc.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" osd.c -o osd.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" scc.c -o scc.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" smc.c -o smc.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" ssc.c -o ssc.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" libssc.c -o libssc.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" bs_rdwr.c -o bs_rdwr.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" bs_ssc.c -o bs_ssc.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" bs_null.c -o bs_null.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" bs_sg.c -o bs_sg.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" bs.c -o bs.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" libcrc32c.c -o libcrc32c.o
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" bs_sheepdog.c -o bs_sheepdog.o
> echo cc iscsi/conn.o iscsi/param.o iscsi/session.o iscsi/iscsid.o iscsi/target.o iscsi/chap.o iscsi/sha1.o iscsi/md5.o iscsi/transport.o iscsi/iscsi_tcp.o iscsi/isns.o tgtd.o mgmt.o target.o scsi.o log.o driver.o util.o work.o concat_buf.o parser.o spc.o sbc.o mmc.o osd.o scc.o smc.o ssc.o libssc.o bs_rdwr.o bs_ssc.o bs_null.o bs_sg.o bs.o libcrc32c.o bs_sheepdog.o -o tgtd -lpthread -ldl
> cc iscsi/conn.o iscsi/param.o iscsi/session.o iscsi/iscsid.o iscsi/target.o iscsi/chap.o iscsi/sha1.o iscsi/md5.o iscsi/transport.o iscsi/iscsi_tcp.o iscsi/isns.o tgtd.o mgmt.o target.o scsi.o log.o driver.o util.o work.o concat_buf.o parser.o spc.o sbc.o mmc.o osd.o scc.o smc.o ssc.o libssc.o bs_rdwr.o bs_ssc.o bs_null.o bs_sg.o bs.o libcrc32c.o bs_sheepdog.o -o tgtd -lpthread -ldl
> cc iscsi/conn.o iscsi/param.o iscsi/session.o iscsi/iscsid.o iscsi/target.o iscsi/chap.o iscsi/sha1.o iscsi/md5.o iscsi/transport.o iscsi/iscsi_tcp.o iscsi/isns.o tgtd.o mgmt.o target.o scsi.o log.o driver.o util.o work.o concat_buf.o parser.o spc.o sbc.o mmc.o osd.o scc.o smc.o ssc.o libssc.o bs_rdwr.o bs_ssc.o bs_null.o bs_sg.o bs.o libcrc32c.o bs_sheepdog.o -o tgtd -Wl,-E,-rpath=/usr/lib/tgt -lpthread -ldl
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" tgtadm.c -o tgtadm.o
> cc tgtadm.o concat_buf.o -o tgtadm
> cc -c -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" tgtimg.c -o tgtimg.o
> cc tgtimg.o libssc.o libcrc32c.o -o tgtimg
> cc -shared -DUSE_SIGNALFD -DUSE_TIMERFD -D_GNU_SOURCE -I. -g -O2 -fno-strict-aliasing -Wall -Wstrict-prototypes -fPIC -DTGT_VERSION=\"1.0.49\" -DBSDIR=\"/usr/lib/tgt/backing-store\" bs_rbd.c -o bs_rbd.so -lrados -lrbd
> make[1]: Leaving directory `/root/tgt/usr'
> make -C doc
> make[1]: Entering directory `/root/tgt/doc'
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o manpages/tgtd.8 http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl tgtd.8.xml
> Note: meta source : no *info/productname or alternative            tgtd
> Note: meta source : see http://docbook.sf.net/el/productname       tgtd
> Note: meta source : no refentry/refmeta/refmiscinfo@class=source   tgtd
> Note: meta source : see http://docbook.sf.net/el/refmiscinfo       tgtd
> Note: meta version: no *info/productnumber or alternative          tgtd
> Note: meta version: see http://docbook.sf.net/el/productnumber     tgtd
> Note: meta version: no refentry/refmeta/refmiscinfo@class=version  tgtd
> Note: meta version: see http://docbook.sf.net/el/refmiscinfo       tgtd
> Warn: meta source : no fallback for source, so inserted a fixme    tgtd
> Note: meta manual : no titled ancestor of refentry                 tgtd
> Note: meta manual : no refentry/refmeta/refmiscinfo@class=manual   tgtd
> Note: meta manual : see http://docbook.sf.net/el/refmiscinfo       tgtd
> Warn: meta manual : no fallback for manual, so inserted a fixme    tgtd
> Warn: meta author : no refentry/info/author                        tgtd
> Note: meta author : see http://docbook.sf.net/el/author            tgtd
> Warn: meta author : no author data, so inserted a fixme            tgtd
> Note: Writing tgtd.8
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o manpages/tgtadm.8 http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl tgtadm.8.xml
> Note: meta source : no *info/productname or alternative            tgtadm
> Note: meta source : see http://docbook.sf.net/el/productname       tgtadm
> Note: meta source : no refentry/refmeta/refmiscinfo@class=source   tgtadm
> Note: meta source : see http://docbook.sf.net/el/refmiscinfo       tgtadm
> Note: meta version: no *info/productnumber or alternative          tgtadm
> Note: meta version: see http://docbook.sf.net/el/productnumber     tgtadm
> Note: meta version: no refentry/refmeta/refmiscinfo@class=version  tgtadm
> Note: meta version: see http://docbook.sf.net/el/refmiscinfo       tgtadm
> Warn: meta source : no fallback for source, so inserted a fixme    tgtadm
> Note: meta manual : no titled ancestor of refentry                 tgtadm
> Note: meta manual : no refentry/refmeta/refmiscinfo@class=manual   tgtadm
> Note: meta manual : see http://docbook.sf.net/el/refmiscinfo       tgtadm
> Warn: meta manual : no fallback for manual, so inserted a fixme    tgtadm
> Warn: meta author : no refentry/info/author                        tgtadm
> Note: meta author : see http://docbook.sf.net/el/author            tgtadm
> Warn: meta author : no author data, so inserted a fixme            tgtadm
> Note: Writing tgtadm.8
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o manpages/tgtimg.8 http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl tgtimg.8.xml
> Note: meta source : no *info/productname or alternative            tgtimg
> Note: meta source : see http://docbook.sf.net/el/productname       tgtimg
> Note: meta source : no refentry/refmeta/refmiscinfo@class=source   tgtimg
> Note: meta source : see http://docbook.sf.net/el/refmiscinfo       tgtimg
> Note: meta version: no *info/productnumber or alternative          tgtimg
> Note: meta version: see http://docbook.sf.net/el/productnumber     tgtimg
> Note: meta version: no refentry/refmeta/refmiscinfo@class=version  tgtimg
> Note: meta version: see http://docbook.sf.net/el/refmiscinfo       tgtimg
> Warn: meta source : no fallback for source, so inserted a fixme    tgtimg
> Note: meta manual : no titled ancestor of refentry                 tgtimg
> Note: meta manual : no refentry/refmeta/refmiscinfo@class=manual   tgtimg
> Note: meta manual : see http://docbook.sf.net/el/refmiscinfo       tgtimg
> Warn: meta manual : no fallback for manual, so inserted a fixme    tgtimg
> Warn: meta author : no refentry/info/author                        tgtimg
> Note: meta author : see http://docbook.sf.net/el/author            tgtimg
> Warn: meta author : no author data, so inserted a fixme            tgtimg
> Note: Writing tgtimg.8
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o manpages/tgt-admin.8 http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl tgt-admin.8.xml
> Note: meta source : no *info/productname or alternative            tgt-admin
> Note: meta source : see http://docbook.sf.net/el/productname       tgt-admin
> Note: meta source : no refentry/refmeta/refmiscinfo@class=source   tgt-admin
> Note: meta source : see http://docbook.sf.net/el/refmiscinfo       tgt-admin
> Note: meta version: no *info/productnumber or alternative          tgt-admin
> Note: meta version: see http://docbook.sf.net/el/productnumber     tgt-admin
> Note: meta version: no refentry/refmeta/refmiscinfo@class=version  tgt-admin
> Note: meta version: see http://docbook.sf.net/el/refmiscinfo       tgt-admin
> Warn: meta source : no fallback for source, so inserted a fixme    tgt-admin
> Note: meta manual : no titled ancestor of refentry                 tgt-admin
> Note: meta manual : no refentry/refmeta/refmiscinfo@class=manual   tgt-admin
> Note: meta manual : see http://docbook.sf.net/el/refmiscinfo       tgt-admin
> Warn: meta manual : no fallback for manual, so inserted a fixme    tgt-admin
> Warn: meta author : no refentry/info/author                        tgt-admin
> Note: meta author : see http://docbook.sf.net/el/author            tgt-admin
> Warn: meta author : no author data, so inserted a fixme            tgt-admin
> Note: Writing tgt-admin.8
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o manpages/targets.conf.5 http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl targets.conf.5.xml
> Note: meta source : no *info/productname or alternative            targets.conf
> Note: meta source : see http://docbook.sf.net/el/productname       targets.conf
> Note: meta source : no refentry/refmeta/refmiscinfo@class=source   targets.conf
> Note: meta source : see http://docbook.sf.net/el/refmiscinfo       targets.conf
> Note: meta version: no *info/productnumber or alternative          targets.conf
> Note: meta version: see http://docbook.sf.net/el/productnumber     targets.conf
> Note: meta version: no refentry/refmeta/refmiscinfo@class=version  targets.conf
> Note: meta version: see http://docbook.sf.net/el/refmiscinfo       targets.conf
> Warn: meta source : no fallback for source, so inserted a fixme    targets.conf
> Note: meta manual : no titled ancestor of refentry                 targets.conf
> Note: meta manual : no refentry/refmeta/refmiscinfo@class=manual   targets.conf
> Note: meta manual : see http://docbook.sf.net/el/refmiscinfo       targets.conf
> Warn: meta manual : no fallback for manual, so inserted a fixme    targets.conf
> Warn: meta author : no refentry/info/author                        targets.conf
> Note: meta author : see http://docbook.sf.net/el/author            targets.conf
> Warn: meta author : no author data, so inserted a fixme            targets.conf
> Note: Writing targets.conf.5
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o manpages/tgt-setup-lun.8 http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl tgt-setup-lun.8.xml
> Note: meta source : no *info/productname or alternative            tgt-setup-lun
> Note: meta source : see http://docbook.sf.net/el/productname       tgt-setup-lun
> Note: meta source : no refentry/refmeta/refmiscinfo@class=source   tgt-setup-lun
> Note: meta source : see http://docbook.sf.net/el/refmiscinfo       tgt-setup-lun
> Note: meta version: no *info/productnumber or alternative          tgt-setup-lun
> Note: meta version: see http://docbook.sf.net/el/productnumber     tgt-setup-lun
> Note: meta version: no refentry/refmeta/refmiscinfo@class=version  tgt-setup-lun
> Note: meta version: see http://docbook.sf.net/el/refmiscinfo       tgt-setup-lun
> Warn: meta source : no fallback for source, so inserted a fixme    tgt-setup-lun
> Note: meta manual : no titled ancestor of refentry                 tgt-setup-lun
> Note: meta manual : no refentry/refmeta/refmiscinfo@class=manual   tgt-setup-lun
> Note: meta manual : see http://docbook.sf.net/el/refmiscinfo       tgt-setup-lun
> Warn: meta manual : no fallback for manual, so inserted a fixme    tgt-setup-lun
> Note: Writing tgt-setup-lun.8
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o htmlpages/tgtd.8.html http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl tgtd.8.xml
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o htmlpages/tgtadm.8.html http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl tgtadm.8.xml
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o htmlpages/tgtimg.8.html http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl tgtimg.8.xml
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o htmlpages/tgt-admin.8.html http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl tgt-admin.8.xml
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o htmlpages/targets.conf.5.html http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl targets.conf.5.xml
> test -z "/usr/bin/xsltproc" || /usr/bin/xsltproc -o htmlpages/tgt-setup-lun.8.html http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl tgt-setup-lun.8.xml
> make[1]: Leaving directory `/root/tgt/doc'
> make -C conf
> make[1]: Entering directory `/root/tgt/conf'
> make[1]: Nothing to be done for `all'.
> make[1]: Leaving directory `/root/tgt/conf'
> make -C scripts
> make[1]: Entering directory `/root/tgt/scripts'
> make[1]: Nothing to be done for `all'.
> make[1]: Leaving directory `/root/tgt/scripts'
>
> # make install
> make -C usr install
> make[1]: Entering directory `/root/tgt/usr'
> install -d -m 755 /usr/sbin
> install -m 755 tgtd tgtadm tgtimg /usr/sbin
> make[1]: Leaving directory `/root/tgt/usr'
> make -C doc install
> make[1]: Entering directory `/root/tgt/doc'
> install -d -m 755 /usr/share/man/man8
> install -m 644 manpages/tgtadm.8 manpages/tgt-admin.8 manpages/tgtimg.8 manpages/tgt-setup-lun.8 manpages/tgtd.8 /usr/share/man/man8
> install -d -m 755 /usr/share/doc/tgt
> install -m 644 README.iscsi README.iser README.lu_configuration README.mmc tmf.txt README.rbd /usr/share/doc/tgt
> install -d -m 755 /usr/share/doc/tgt/html
> install -m 644 htmlpages/tgtd.8.html htmlpages/tgtadm.8.html htmlpages/tgtimg.8.html htmlpages/tgt-admin.8.html htmlpages/targets.conf.5.html htmlpages/tgt-setup-lun.8.html /usr/share/doc/tgt/html
> make[1]: Leaving directory `/root/tgt/doc'
> make -C conf install
> make[1]: Entering directory `/root/tgt/conf'
> install -d -m 755 /etc/tgt
> if [ ! -f /etc/tgt/targets.conf ] ; then \
>                install -m 644 targets.conf /etc/tgt ; \
>        fi
> install -d -m 755 /etc/tgt/examples
> for f in targets.conf.example targets.conf.vtl.L700 targets.conf.vtl.MSL2024 ; do \
>                install -m 644 examples/$f /etc/tgt/examples ;\
>        done
> install -d /etc/tgt/conf.d
> make[1]: Leaving directory `/root/tgt/conf'
> make -C scripts install
> make[1]: Entering directory `/root/tgt/scripts'
> install -d -m 755 /usr/sbin
> install -m 755 tgt-setup-lun tgt-admin /usr/sbin
> make[1]: Leaving directory `/root/tgt/scripts'--
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
