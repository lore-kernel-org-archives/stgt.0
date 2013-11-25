From: Eric Millbrandt <eric.millbrandt@cacheio.com>
Subject: Re: iser problems
Date: Mon, 25 Nov 2013 13:18:59 -0500
Message-ID: <52939493.5060807@cacheio.com>
References: <B5A712BD-9DBC-44A1-836F-E9A6289D0269@me.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="TcrEkM8CtGm3U00BlnCkWuudsuqSlbt2M"
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <B5A712BD-9DBC-44A1-836F-E9A6289D0269@me.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: =?ISO-8859-1?Q?Popovics_L=E1szl=F3?= <cuttie@me.com>, stgt@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TcrEkM8CtGm3U00BlnCkWuudsuqSlbt2M
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/25/2013 05:35 AM, Popovics L=E1szl=F3 wrote:
> Dear stgt list,
>
> I would like to ask, that, is there any information about that, tgtd ca=
n run in multiple instances ?
> When we tried to run a second instance, it give an error message becaus=
e rdma listening port is occupied.
>
> We would like to test multiple tgt instance because we have a feeling a=
bout that, rdma connecion number is limited for one instance, and we reac=
hed this limit.
Pass these command-line arguments to tgtd when launching multiple
instances (replace XXX with an open port number).

tgtd --control-port XXX --iscsi portal=3D0.0.0.0:XXX --iser port=3DXXX

Make sure you specify a unique port number for each tgtd instance.

Eric


--TcrEkM8CtGm3U00BlnCkWuudsuqSlbt2M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSk5STAAoJEEGoGVjD4GfI6j0P/R9ZxNPI76KXODmvTqWo1OVG
XvSgJFA6cW+reTtr7Cdbk7zRbckJQiDaLBSrdanqbyHtKxllifEBZkDbzMheyv8+
y44DuTlaT4kDUxN6qBlL/73714v73gX1ZGd8LtnkZnYGv0fdxYTkogIHLBp4CU4Y
l6Bn4GCPLr6eo2zLTCoz3eEzAiSn7xlZUSCK+BjjDwmZFIvdIt8Q5DaUptDUcuzy
PUSEmIUwopC441acsGiuRYHexsS0vjZask65ji4EKwSKH7qGmzyTLmmGem8lKirh
YZPANvnjH3zaHMuZ2vnWifPbkruEHhWBkueEz2rSxumTa6291NHIBSJSRsxAIh19
YOigkLk30drqh/Rk9xm7Bk/o3Jxua8Xjt9YPn0upUQALyKc9Oymat8mYDwJsDmx7
p3samGfyNNZoa1CkEiYwAVZUwxahiAbDf/bSpZWDvPVzFDjZlWTzb8VssLT5i6ws
cvyxbd+HWMdyWoLmeTs7XjzlKUfWyEG26DrbmgZmxuWHXZhZyw4PBWA3HsODJcy2
TXG2FmIhmFSYAq3il1DGhRRpZbcgG6UkKpipLRjuDtDf4FAT0CK4QSKMzsOhdCEc
pAwgucj+RJIcgoYCKhc7H3AejgBnkjccjIm5oQukL6m6HGk5+fqWKNR612rnfVz0
c47575tas3KRVNHg2pnd
=1OaK
-----END PGP SIGNATURE-----

--TcrEkM8CtGm3U00BlnCkWuudsuqSlbt2M--
