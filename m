From: Ryan Harper <ryan.harper@canonical.com>
Subject: [PATCH] fix errno use after strtoull
Date: Thu, 21 Apr 2016 11:22:40 -0500
Message-ID: <20160421162240.GA15513@foudres>
Reply-To: Ryan Harper <ryan.harper@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Return-path: <stgt-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org
Cc: Stas Sergeev <stsp@users.sourceforge.net>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

As described in this bug:

https://bugs.launchpad.net/ubuntu/+source/tgt/+bug/1547060

Patch comes from an outstanding pull request from Stas Sergeev here:

https://github.com/fujita/tgt/pull/18/

I've tested this patch and verified that it resolves the issue with use=20
of parameters with numbers in our Ubuntu package.  I've also filed
a similar bug in Debian here:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D822160

Please consider accepting the patch.

--=20
Ryan Harper
Canonical, Ltd.

=3D=3D

=46rom 3f3991ee3345f9728928711f6be7a0020568faf6 Mon Sep 17 00:00:00 2001
=46rom: Stas Sergeev <stsp@users.sourceforge.net>
Date: Thu, 18 Feb 2016 18:35:23 +0300
Subject: [PATCH] fix errno check

errno can only be checked if the return value indicates an error.
The result of this bug is the following:

 ./tgtd -d 1
-d argument value '1' invalid
Try `tgtd --help' for more information.

As can be seen, it rejects the valid parameter because errno just
happens to be non-zero.
---
 usr/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/util.h b/usr/util.h
index 0e34c35..019ff1c 100644
--- a/usr/util.h
+++ b/usr/util.h
@@ -148,7 +148,7 @@ struct signalfd_siginfo {
 	unsigned long long ull_val;     		\
 	ull_val =3D strtoull(str, &ptr, 0);       	\
 	val =3D (typeof(val)) ull_val;    		\
-	if (errno || ptr =3D=3D str)			\
+	if (ull_val =3D=3D ULONG_MAX || ptr =3D=3D str)		\
 		ret =3D EINVAL;   			\
 	else if (val !=3D ull_val)			\
 		ret =3D ERANGE;   			\

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJXGP5QAAoJEJoxTsX0cKCs9k8IAIwSauCe55tpYrMqbHqJ8FT6
19y0SGCx5kJ2cq8SrIWV+wPWH53F+Tjfst3oxbOqwGKl0aJi4sGNOvianwbviDmo
wG/fFJRa7dhGsW/GppE68vVfkncb7YpWQLPafY06zjBD0SF+9RaMpZYesBR/4qaw
Az+FzbJJXUV+w6k7DkwqZ594suwmsf3YLg0uvAQziDHHE7NBDQYjWPZgf0jjfsST
oDln+CcUnuGXA8r6MuQj5gtJKnz9KG97t4CKqrLi1Q23JEHCemz7bQLCC7qLU8rf
aQKkzjl4a00Z+DQnrSF65faEdqLuSxwZLzQK3prGyPkRdPDo5Egvn/2aV9KtBQI=
=yyvj
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
