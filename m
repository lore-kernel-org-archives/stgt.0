From: =?utf-8?Q?Popovics_L=C3=A1szl=C3=B3?= <cuttie@me.com>
Subject: Re: iser problems
Date: Tue, 26 Nov 2013 12:40:47 +0100
Message-ID: <4748B178-12B5-4608-94E1-718E16804159@me.com>
References: <B5A712BD-9DBC-44A1-836F-E9A6289D0269@me.com> <52939493.5060807@cacheio.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <52939493.5060807@cacheio.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Eric Millbrandt <eric.millbrandt@cacheio.com>, stgt@vger.kernel.org

Thanks for the answer. Now it is working.
I had two important information which useful for every one who facing t=
his problem.

iser port and portal port (XXX) must be same.
selinux can produce problems when port is not 3260.

Best regards,

	Laszlo

2013.11.25. d=C3=A1tummal, 19:18 id=C5=91pontban Eric Millbrandt <eric.=
millbrandt@cacheio.com> =C3=ADrta:

> On 11/25/2013 05:35 AM, Popovics L=C3=A1szl=C3=B3 wrote:
>> Dear stgt list,
>>=20
>> I would like to ask, that, is there any information about that, tgtd=
 can run in multiple instances ?
>> When we tried to run a second instance, it give an error message bec=
ause rdma listening port is occupied.
>>=20
>> We would like to test multiple tgt instance because we have a feelin=
g about that, rdma connecion number is limited for one instance, and we=
 reached this limit.
> Pass these command-line arguments to tgtd when launching multiple
> instances (replace XXX with an open port number).
>=20
> tgtd --control-port XXX --iscsi portal=3D0.0.0.0:XXX --iser port=3DXX=
X
>=20
> Make sure you specify a unique port number for each tgtd instance.
>=20
> Eric
>=20
