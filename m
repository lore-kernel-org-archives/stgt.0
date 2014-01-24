From: Artyom Pervukhin <artyom@evasive.ru>
Subject: Re: tgtadm/tgtd management issue: buffer size truncated sometimes
Date: Fri, 24 Jan 2014 12:51:13 +0400
Message-ID: <52A65E29-5717-4DEA-BDD4-CB9700D218E0@evasive.ru>
References: <96DAABF5-8A43-4969-8708-5751A053FBEE@evasive.ru> <20140124.141152.1568838937885768338.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20140124.141152.1568838937885768338.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: stgt@vger.kernel.org


On 24 Jan 2014, at 09:11, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.j=
p> wrote:

> Hi,
>=20
> On Thu, 23 Jan 2014 16:51:17 +0400
> Artyom Pervukhin <artyom@evasive.ru> wrote:
>=20
>> I cannot find any information regarding practical limits on amount
>> of iSCSI targets supported by tgtd. Trying to use tgtd with many
>> targets (hundreds of, say 400-500), I've experienced some issues in
>> its management interface (tgtadm <-> tgtd).
>=20
> We use int for the target number. Except for that, there is no limit.
>=20
>=20
>> Each target has only one disk attached, the greater target count is,
>> the higher probability of experiencing the bug. Sometimes command
>> showing all targets returns incomplete output, as if it was randomly
>> stripped.
>>=20
>> # tgtadm -C 0 --op show --mode target | grep -c ^Target             =
                                                                       =
              =20
>> 301
>> # tgtadm -C 0 --op show --mode target | grep -c ^Target             =
                                                                       =
              =20
>> 300
>>=20
>> # tgtadm -C 0 --op show --mode target | wc -c                       =
                                                                       =
              =20
>> 317914
>> # tgtadm -C 0 --op show --mode target | wc -c                       =
                                                                       =
              =20
>> 316690
>> # tgtadm -C 0 --op show --mode target | wc -c                       =
                                                                       =
              =20
>> 317914
>> # tgtadm -C 0 --op show --mode target | wc -c                       =
                                                                       =
              =20
>> 310695
>>=20
>> The closest description to this bug I've managed to find is this thr=
ead: http://lists.wpkg.org/pipermail/stgt/2012-July/005324.html (op had=
 the same symptoms).
>>=20
>> I was able to reproduce this bug on tgt 1.0.4 (Debian Squeeze), 1.0.=
17 (Debian Wheezy), 1.0.43 (latest so far). Tested on linux kernels 2.6=
=2E32, 3.2.0 (both amd64).
>>=20
>=20
> Hmm, I think that the bug on the thread was fixed. I set up 600
> targets with the latest code and doesn't hit such issue.
>=20
> root@rose:~# tgtadm --op show --mode target|grep -c ^Target
> 600
> root@rose:~# tgtadm --op show --mode target|grep -c ^Target
> 600
> root@rose:~# tgtadm --op show --mode target|wc -c
> 688313
> root@rose:~# tgtadm --op show --mode target|wc -c


Can you please specify what linux distribution and libraries version ar=
e you using?

I=92m able to reproduce this bug on current tgt codebase (17222f2b00d29=
368da214e2d59cbc9e00f53606b) built on  Debian wheezy amd64. Bug frequen=
cy increases with number of targets:


1000 targets (all loaded, as `tgtadm -C 0 --op show --mode target --tid=
 1000` shows target settings):

root@sandbox:~ # for i in $(seq 100) ; do tgtadm -C 0 --op show --mode =
target | grep -c ^Target ; done | sort | uniq -c                       =
                             =20
    100 978
root@sandbox:~ # for i in $(seq 100) ; do tgtadm -C 0 --op show --mode =
target | wc -c ; done | sort | uniq -c                                 =
                            =20
    100 1033140


600 targets:

root@sandbox:~ # for i in $(seq 100) ; do tgtadm -C 0 --op show --mode =
target | grep -c ^Target ; done | sort | uniq -c                       =
                             =20
    100 587
root@sandbox:~ # for i in $(seq 100) ; do tgtadm -C 0 --op show --mode =
target | wc -c ; done | sort | uniq -c                                 =
                            =20
    100 619821


400 targets:

root@sandbox:~ # for i in $(seq 100) ; do tgtadm -C 0 --op show --mode =
target | grep -c ^Target ; done | sort | uniq -c                       =
                             =20
     16 391
     26 395
      1 396
      1 397
      1 398
     53 399
      2 400
root@sandbox:~ # for i in $(seq 100) ; do tgtadm -C 0 --op show --mode =
target | wc -c ; done | sort | uniq -c                                 =
                            =20
     20 413161
      1 416201
     33 416876
      1 417721
      1 418776
      1 419156
     42 421436
      1 422660


300 targets:

root@sandbox:~ # for i in $(seq 100) ; do tgtadm -C 0 --op show --mode =
target | grep -c ^Target ; done | sort | uniq -c                       =
                             =20
      1 294
      4 299
     95 300
root@sandbox:~ # for i in $(seq 100) ; do tgtadm -C 0 --op show --mode =
target | wc -c ; done | sort | uniq -c                                 =
                            =20
      1 313441
      1 313821
      3 315636
     95 316860
