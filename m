From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: how to configure a drbd tgtd kvm cluster to make sure one machine
 doesn't eat up all the IO and hangs other nodes
Date: Sun, 25 May 2014 15:14:22 +0200
Message-ID: <5381ECAE.60708@powercraft.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: stgt@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello everybody,

I got a drbd cluster with tgtd managed by pacemaker as my iscsi target

I then got three kvm host servers connected with open-iscsi to this
target.

All servers use an dual nic 1G LACP (mode 4 bonding) connection to a
cisco switch.

On the servers the iscsi disk is managed by lvm.

I use the bellow for all the disks in the drbd cluster servers and on
for all the disks on the kvm hosts (so also the iscsi disks).

echo deadline > /sys/block/sdi/queue/scheduler
echo 0 > /sys/block/sdi/queue/iosched/front_merges
echo 150 > /sys/block/sdi/queue/iosched/read_expire
echo 1500 > /sys/block/sdi/queue/iosched/write_expire

My first problem is that if i run dd[1] on one of the KVM host, all
the kvm guests on the other machines drop dead because they cant get
any IO any more.

My second problem is that if I run a heavy IO job[2] inside a KVM
guest it can take all the IO and the KVM guest on an other KVM host
can't get any IO any more

[1] ionice -c 3 dd oflag=3Ddirect bs=3D4M if=3D/dev/lvm2-vol/kvm07-snap=
shot
of=3D/dev/lvm3-vol/kvm07-disk

[2] nice -n 19 ionice -c2 -n7 pvmove /dev/vdb /dev/vdc

Now my guess is this is because, there is no IO scheduling between the
KVM host, they do IO scheduling on there own server but just pass the
load to open-iscsi and tgtd. However if multiple server are connected
to tgtd it seems to be that one server can take it all and the other
connections just have to wait.... (till a heavy dd job that takes
hours runs out...)

So how should I configure my cluster and tgtd so an heavy IO jobs just
doesn=92t get all the IO and the other request get handled as well? Is
this an impossibility?

Kind regards,

Jelle de Jong

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iJwEAQECAAYFAlOB7KkACgkQ1WclBW9j5HnZ8gP/faFZk0CHaefPgMlXWHQ8N0YT
7Cv3XFUUTenVYbsAam5KuNMb48QzEMQnNhKeS3LeBELPUBAxMOAh/meXHVxLaDiK
L3ZnhLuxdWOsDCp1hSaIDAekPqhvUdxjfOznqbOfxjLGjXNYdPai1ZZK0AVUog/z
sdDzFWRmTLEPHrTR3HM=3D
=3DzVop
-----END PGP SIGNATURE-----
