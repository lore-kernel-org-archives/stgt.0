From: Cedric Milesi <cedric.milesi@hp.com>
Subject: [PATCH] added support for bsoflags parameter
Date: Tue,  6 May 2014 17:31:04 +0200
Message-ID: <1399390264-6806-1-git-send-email-cedric.milesi@hp.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, =?UTF-8?q?C=C3=A9dric=20Milesi?= <cedric.milesi@hp.com>

=46rom: C=C3=A9dric Milesi <cedric.milesi@hp.com>

	This patch will allow one to use bsoflags with tgt-admin.

---
Signed-off-by: C=C3=A9dric Milesi <cedric.milesi@hp.com>
---
 scripts/tgt-admin | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/scripts/tgt-admin b/scripts/tgt-admin
index 5486507..7130a3d 100755
--- a/scripts/tgt-admin
+++ b/scripts/tgt-admin
@@ -493,6 +493,7 @@ sub add_backing_direct {
 		my $device_type;
 		my $bs_type;
 		my $bsopts;
+		my $bsoflags;
 		my $block_size;
 		my %luns;
 		my @added_luns;
@@ -548,6 +549,10 @@ sub add_backing_direct {
 							$bsopts =3D $result;
 							$params_added{$store_option} =3D 1;
 						}
+						if ($store_option eq "bsoflags") {
+							$bsoflags =3D $result;
+							$params_added{$store_option} =3D 1;
+						}
 						if ($store_option eq "block-size") {
 							$block_size =3D $result;
 							$params_added{$store_option} =3D 1;
@@ -704,6 +709,11 @@ sub add_backing_direct {
 				check_if_hash_array($$target_options_ref{"bsopts"}, "bsopts");
 				$bsopts =3D $$target_options_ref{"bsopts"};
 			}
+			# bsoflags
+			if ($params_added{"bsoflags"} ne 1) {
+				check_if_hash_array($$target_options_ref{"bsoflags"}, "bsoflags");
+				$bsoflags =3D $$target_options_ref{"bsoflags"};
+			}
 		} else {
 			print "If you got here, this means your config file is not supporte=
d.\n";
 			print "Please report it to stgt mailing list and attach your config=
 files.\n";
@@ -713,8 +723,9 @@ sub add_backing_direct {
 		if (length $device_type) { $device_type =3D "--device-type $device_t=
ype" };
 		if (length $bs_type) { $bs_type =3D "--bstype $bs_type" };
 		if (length $bsopts) { $bsopts =3D "--bsopts $bsopts" };
+		if (length $bsoflags) { $bsoflags =3D "--bsoflags $bsoflags" };
 		if (length $block_size) { $block_size =3D "--blocksize $block_size" =
};
-		execute("tgtadm -C $control_port --lld $driver --op new --mode logic=
alunit --tid $next_tid --lun $lun -b $backing_store $device_type $bs_ty=
pe $bsopts $block_size");
+		execute("tgtadm -C $control_port --lld $driver --op new --mode logic=
alunit --tid $next_tid --lun $lun -b $backing_store $device_type $bs_ty=
pe $bsopts $bsoflags $block_size");
=20
 		# Commands should be executed in order
 		my @execute_last;
--=20
1.8.3.2
