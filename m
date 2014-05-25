From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: Re: how to configure a drbd tgtd kvm cluster to make sure one machine
 doesn't eat up all the IO and hangs other nodes
Date: Sun, 25 May 2014 19:17:56 +0200
Message-ID: <538225C4.1000400@powercraft.nl>
References: <5381ECAE.60708@powercraft.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <5381ECAE.60708@powercraft.nl>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: stgt@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 25/05/14 15:14, Jelle de Jong wrote:
> I got a drbd cluster with tgtd managed by pacemaker as my iscsi
> target
>=20
> I then got three kvm host servers connected with open-iscsi to
> this target.
>=20
> All servers use an dual nic 1G LACP (mode 4 bonding) connection to
> a cisco switch.
>=20
> On the servers the iscsi disk is managed by lvm.
>=20
> I use the bellow for all the disks in the drbd cluster servers and
> on for all the disks on the kvm hosts (so also the iscsi disks).
>=20
> echo deadline > /sys/block/sdi/queue/scheduler echo 0 >
> /sys/block/sdi/queue/iosched/front_merges echo 150 >
> /sys/block/sdi/queue/iosched/read_expire echo 1500 >
> /sys/block/sdi/queue/iosched/write_expire
>=20
> My first problem is that if i run dd[1] on one of the KVM host,
> all the kvm guests on the other machines drop dead because they
> cant get any IO any more.
>=20
> My second problem is that if I run a heavy IO job[2] inside a KVM=20
> guest it can take all the IO and the KVM guest on an other KVM
> host can't get any IO any more
>=20
> [1] ionice -c 3 dd oflag=3Ddirect bs=3D4M
> if=3D/dev/lvm2-vol/kvm07-snapshot of=3D/dev/lvm3-vol/kvm07-disk
>=20
> [2] nice -n 19 ionice -c2 -n7 pvmove /dev/vdb /dev/vdc
>=20
> Now my guess is this is because, there is no IO scheduling between
> the KVM host, they do IO scheduling on there own server but just
> pass the load to open-iscsi and tgtd. However if multiple server
> are connected to tgtd it seems to be that one server can take it
> all and the other connections just have to wait.... (till a heavy
> dd job that takes hours runs out...)
>=20
> So how should I configure my cluster and tgtd so an heavy IO jobs
> just doesn=92t get all the IO and the other request get handled as
> well? Is this an impossibility?

As an update, I tried the noop and cfg scheduling for the isci disks
on the kvm host (with deadline on the drbd tgtd iscsi cluster), lots
of test with ionice and kernel params like the cfg quantum,
slice_idle, back_seek_max, nothing worked.

iostat -dkx /dev/sdi 5 showed a big file queue

echo 1 > /sys/block/sdi/device/queue_depth

I set the queue_depth to 1 and the other kvm guests get a bit of IO
again and stay working, set the queue_depth to 2 and they starve again.=
=2E..

Kind regards,

Jelle de Jong
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iJwEAQECAAYFAlOCJcAACgkQ1WclBW9j5HluKgP7BZmHEovdiPtfl05zW44t2dxV
zi+wgYvqxBl9Q1uW/VDu/u1DUTvUf/T4rEhyfGgCo3gC+0hCzk5Iin1Cz2gFQIii
fXl5U+q82MvbF2LFMHy/LLC+0JIUTLoXGfDQDOEFEpe8k5oBzoXeQHIHPQs8dUwi
7GXrqIq1Z2kvJAwShFk=3D
=3DlGzS
-----END PGP SIGNATURE-----
