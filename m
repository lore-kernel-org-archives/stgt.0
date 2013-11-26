From: Roi Dayan <roid@mellanox.com>
Subject: RE: iser problems
Date: Tue, 26 Nov 2013 13:08:49 +0000
Message-ID: <0EDDC5059DB4EF40B6A1F123199EED53884F48F1@MTLDAG01.mtl.com>
References: <B5A712BD-9DBC-44A1-836F-E9A6289D0269@me.com>
 <52939493.5060807@cacheio.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <52939493.5060807@cacheio.com>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Eric Millbrandt <eric.millbrandt@cacheio.com>, =?iso-8859-1?Q?Popovics_L=E1szl=F3?= <cuttie@me.com>, "stgt@vger.kernel.org" <stgt@vger.kernel.org>

Hi,

I want to add that the control-port doesn't have to match the iscsi por=
tal and iser port.
Though it is convenient.
It has to match against tgtdadm commands to specify which tgtd process =
to control.
Can be any number.

Thanks,
Roi

-----Original Message-----
=46rom: stgt-owner@vger.kernel.org [mailto:stgt-owner@vger.kernel.org] =
On Behalf Of Eric Millbrandt
Sent: Monday, November 25, 2013 8:21 PM
To: Popovics L=E1szl=F3; stgt@vger.kernel.org
Subject: Re: iser problems

On 11/25/2013 05:35 AM, Popovics L=E1szl=F3 wrote:
> Dear stgt list,
>
> I would like to ask, that, is there any information about that, tgtd =
can run in multiple instances ?
> When we tried to run a second instance, it give an error message beca=
use rdma listening port is occupied.
>
> We would like to test multiple tgt instance because we have a feeling=
 about that, rdma connecion number is limited for one instance, and we =
reached this limit.
Pass these command-line arguments to tgtd when launching multiple insta=
nces (replace XXX with an open port number).

tgtd --control-port XXX --iscsi portal=3D0.0.0.0:XXX --iser port=3DXXX

Make sure you specify a unique port number for each tgtd instance.

Eric
