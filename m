From: Artyom Pervukhin <artyom@evasive.ru>
Subject: Re: tgtadm/tgtd management issue: buffer size truncated sometimes
Date: Mon, 27 Jan 2014 18:44:42 +0400
Message-ID: <C6A6622D-F621-4889-AE5C-A7F603B84105@evasive.ru>
References: <96DAABF5-8A43-4969-8708-5751A053FBEE@evasive.ru> <20140124.141152.1568838937885768338.fujita.tomonori@lab.ntt.co.jp> <52A65E29-5717-4DEA-BDD4-CB9700D218E0@evasive.ru> <20140124.192139.1568838937885768572.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20140124.192139.1568838937885768572.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org


On 24 Jan 2014, at 14:21, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.j=
p> wrote:

> On Fri, 24 Jan 2014 12:51:13 +0400
> Artyom Pervukhin <artyom@evasive.ru> wrote:
>=20
>> Can you please specify what linux distribution and libraries version
>> are you using?
>=20
> Debian squeeze amd64.
>=20
>> I=A2m able to reproduce this bug on current tgt codebase (17222f2b00=
d29368da214e2d59cbc9e00f53606b) built on  Debian wheezy amd64. Bug freq=
uency increases with number of targets:
>>=20
>>=20
>> 1000 targets (all loaded, as `tgtadm -C 0 --op show --mode target --=
tid 1000` shows target settings):
>>=20
>> root@sandbox:~ # for i in $(seq 100) ; do tgtadm -C 0 --op show --mo=
de target | grep -c ^Target ; done | sort | uniq -c                    =
                                =20
>>    100 978
>> root@sandbox:~ # for i in $(seq 100) ; do tgtadm -C 0 --op show --mo=
de target | wc -c ; done | sort | uniq -c                              =
                               =20
>>    100 1033140
>=20
> I can reproduce the same problem with 1000.
>=20
> root@rose:~# for i in $(seq 100); do tgtadm --op show --mode target|g=
rep -c ^Target;done|sort|uniq -c
>     97 1000
>      1 972
>      1 995
>      1 997
>=20
> Strangely, looks like I can get the correct result without 'grep':
>=20
> root@rose:~# for i in $(seq 100); do tgtadm --op show --mode target|p=
ython -c "import sys; print len([line for line in sys.stdin if \"Target=
\" in line])";done|sort|uniq -c
>    100 1000
>=20
>=20

I've done some additional stracing on the tgtd's side this time, please=
 see below:

Testing 300 targets:

command:

root@sandbox:~ # tgtadm -C 0 --op show --mode target

(command shows full output)

tgtd writes:

write(10, "\0\0\0\0\305\325\4\0", 8)    =3D 8
write(10, "Target 1: iqn.2014-01:d1\n    Sys"..., 316861) =3D 224000
write(10, "       State: ready\n    I_T nexu"..., 92861) =3D 92861

command:

root@sandbox:~ # tgtadm -C 0 --op show --mode target | wc -c           =
                                                                       =
                             =20
316860

tgtd writes stays the same as above.



Testing 900 targets:

root@sandbox:~ # tgtadm -C 0 --op show --mode target

(command shows incomplete output)

tgtd writes:

write(10, "\0\0\0\0u\205\16\0", 8)      =3D 8
write(10, "Target 1: iqn.2014-01:d1\n    Sys"..., 951661) =3D 256000
write(10, "a: No\n            Prevent remova"..., 695661) =3D 176000
write(10, " Removable media: No\n           "..., 519661) =3D 176000
write(10, "T nexus information:\n    LUN inf"..., 343661) =3D 176000
write(10, "  Backing store path: None\n     "..., 167661) =3D 167661

command:

root@sandbox:~ # tgtadm -C 0 --op show --mode target | wc -c           =
                                                                       =
                             =20
929621

tgtd writes:

write(10, "\0\0\0\0u\205\16\0", 8)      =3D 8
write(10, "Target 1: iqn.2014-01:d1\n    Sys"..., 951661) =3D 944000
write(10, "t removal: No\n            Readon"..., 7661) =3D -1 EPIPE (B=
roken pipe)
--- SIGPIPE (Broken pipe) @ 0 (0) ---



Seeing this, I assumed the bug is on tgtadm's side.

I've written a small program which sends exactly the same command as tg=
tadm does to tgtd's socket, then reads response back, dumping it to std=
out (sorry it's in Go, my C ain't good: http://play.golang.org/p/EcFTbo=
CncF).

Dumping output like this I have no problem receiving full targets list:

root@sandbox:~ # for i in $(seq 1000) ; do ./dump | wc -c ; done | sort=
 | uniq -c                                                             =
                            =20
   1000 951660
root@sandbox:~ # for i in $(seq 1000) ; do ./dump | grep -c ^Target ; d=
one | sort | uniq -c                                                   =
                            =20
   1000 900


Whereas tgtadm shows incomplete output:

root@sandbox:~ # for i in $(seq 1000) ; do tgtadm -C 0 --op show --mode=
 target | wc -c ; done | sort | uniq -c                                =
                             =20
   1000 929621
root@sandbox:~ # for i in $(seq 1000) ; do tgtadm -C 0 --op show --mode=
 target | grep -c ^Target ; done | sort | uniq -c                      =
                             =20
   1000 880

