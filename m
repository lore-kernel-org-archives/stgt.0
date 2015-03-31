From: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [Patch] Added systemd service
Date: Tue, 31 Mar 2015 18:11:28 +0300
Message-ID: <CAGqmi74fGasr4AYqSF=r_SF29A7yho38S8f2jiJpJ6BDkABZ3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b5d6592bc007f05129705ca
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=KCakS5fJG3Q3NuQL3GUBwq6JDqScnUMzwaXqjWPkBx8=;
        b=b5vYjR3hzDWVMoaoOWf0B0lwo+odgTSxs0+6FUysHc9EzzT3p5im8U5p4Lb3Mo1kuv
         ljh+EnLEMqG1+jaXcJ7upfN3eMpc4rlP1DgRiMxbMqvYPL4yAlPdExnuGVSNi3RFLPBk
         qTNnfqyFnqr6KPST+He9ivPzwDWiTWrIUc7Zb1qW4SlD13bOwr7wMM1hZ0/GYiubHL0x
         p+gpXvlRS96frwr10mnyllsl7H8qrEJ0jqpchEBxKeleKUHRfSP4N3sQu2TNI5ecYEl6
         boXmft2qXVm+3bD4CuvFDMNmNv8iH7/BXcTsNhFslslWrtjQwJfIHcdvGKtkUoezwCR4
         seWA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org

--047d7b5d6592bc007f05129705ca
Content-Type: text/plain; charset=UTF-8

This is my simple implementation of systemd service for tgtd.
I've tested it on my server and it working good enough, i think it can
be useful not only in upstream but and for Debian and Ubuntu packages.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 scripts/tgtd.service | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 scripts/tgtd.service
diff --git a/scripts/tgtd.service b/scripts/tgtd.service
new file mode 100644
index 0000000..f31da96
--- /dev/null
+++ b/scripts/tgtd.service
@@ -0,0 +1,31 @@
+[Unit]
+Description=iSCSI target framework daemon
+Documentation=man: tgtd(8)
+After=network.target
+
+# On systems without virtual consoles, don't start any getty. Note
+# that serial gettys are covered by serial-getty@.service, not this
+# unit.
+ConditionPathExists=/etc/tgt/targets.conf
+
+[Service]
+Type=forking
+Environment=TGTD_CONFIG=/etc/tgt/targets.conf
+
+ExecStart=/usr/sbin/tgtd
+ExecStartPost=/usr/sbin/tgtadm --op update --mode sys --name State -v offline
+ExecStartPost=/usr/sbin/tgtadm --op update --mode sys --name State -v ready
+ExecStartPost=/usr/sbin/tgt-admin -e -c ${TGTD_CONFIG}
+
+ExecReload=/usr/sbin/tgt-admin --update ALL -f -c ${TGTD_CONFIG}
+
+ExecStop=/usr/sbin/tgtadm --op update --mode sys --name State -v offline
+ExecStop=/usr/sbin/tgt-admin --offline ALL
+ExecStop=/usr/sbin/tgt-admin --update ALL -c /dev/null -f
+ExecStop=/usr/sbin/tgtadm  --op delete --mode system
+
+# Exit code: 107 tgtd not running
+
+
+[Install]
+WantedBy=multi-user.target
-- 
2.1.4

--047d7b5d6592bc007f05129705ca
Content-Type: text/x-patch; charset=US-ASCII; name="0001-Added-systemd-service.patch"
Content-Disposition: attachment; filename="0001-Added-systemd-service.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i7xfvis10

RnJvbSAxYjA4ZGY4ODEyYjdlOGU1MGE3NmViYzdhYjgxZDVhNGI5Yjc3OTAzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUaW1vZmV5IFRpdG92ZXRzIDxuZWZlbGltNGFnQGdtYWlsLmNv
bT4KRGF0ZTogVHVlLCAzMSBNYXIgMjAxNSAxODowNjo1MCArMDMwMApTdWJqZWN0OiBbUEFUQ0hd
IEFkZGVkIHN5c3RlbWQgc2VydmljZQoKU2lnbmVkLW9mZi1ieTogVGltb2ZleSBUaXRvdmV0cyA8
bmVmZWxpbTRhZ0BnbWFpbC5jb20+Ci0tLQogc2NyaXB0cy90Z3RkLnNlcnZpY2UgfCAzMSArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMzEgaW5zZXJ0aW9u
cygrKQogY3JlYXRlIG1vZGUgMTAwNjQ0IHNjcmlwdHMvdGd0ZC5zZXJ2aWNlCgpkaWZmIC0tZ2l0
IGEvc2NyaXB0cy90Z3RkLnNlcnZpY2UgYi9zY3JpcHRzL3RndGQuc2VydmljZQpuZXcgZmlsZSBt
b2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi5mMzFkYTk2Ci0tLSAvZGV2L251bGwKKysrIGIvc2Ny
aXB0cy90Z3RkLnNlcnZpY2UKQEAgLTAsMCArMSwzMSBAQAorW1VuaXRdCitEZXNjcmlwdGlvbj1p
U0NTSSB0YXJnZXQgZnJhbWV3b3JrIGRhZW1vbgorRG9jdW1lbnRhdGlvbj1tYW46IHRndGQoOCkK
K0FmdGVyPW5ldHdvcmsudGFyZ2V0CisKKyMgT24gc3lzdGVtcyB3aXRob3V0IHZpcnR1YWwgY29u
c29sZXMsIGRvbid0IHN0YXJ0IGFueSBnZXR0eS4gTm90ZQorIyB0aGF0IHNlcmlhbCBnZXR0eXMg
YXJlIGNvdmVyZWQgYnkgc2VyaWFsLWdldHR5QC5zZXJ2aWNlLCBub3QgdGhpcworIyB1bml0Lgor
Q29uZGl0aW9uUGF0aEV4aXN0cz0vZXRjL3RndC90YXJnZXRzLmNvbmYKKworW1NlcnZpY2VdCitU
eXBlPWZvcmtpbmcKK0Vudmlyb25tZW50PVRHVERfQ09ORklHPS9ldGMvdGd0L3RhcmdldHMuY29u
ZgorCitFeGVjU3RhcnQ9L3Vzci9zYmluL3RndGQKK0V4ZWNTdGFydFBvc3Q9L3Vzci9zYmluL3Rn
dGFkbSAtLW9wIHVwZGF0ZSAtLW1vZGUgc3lzIC0tbmFtZSBTdGF0ZSAtdiBvZmZsaW5lCitFeGVj
U3RhcnRQb3N0PS91c3Ivc2Jpbi90Z3RhZG0gLS1vcCB1cGRhdGUgLS1tb2RlIHN5cyAtLW5hbWUg
U3RhdGUgLXYgcmVhZHkKK0V4ZWNTdGFydFBvc3Q9L3Vzci9zYmluL3RndC1hZG1pbiAtZSAtYyAk
e1RHVERfQ09ORklHfQorCitFeGVjUmVsb2FkPS91c3Ivc2Jpbi90Z3QtYWRtaW4gLS11cGRhdGUg
QUxMIC1mIC1jICR7VEdURF9DT05GSUd9CisKK0V4ZWNTdG9wPS91c3Ivc2Jpbi90Z3RhZG0gLS1v
cCB1cGRhdGUgLS1tb2RlIHN5cyAtLW5hbWUgU3RhdGUgLXYgb2ZmbGluZQorRXhlY1N0b3A9L3Vz
ci9zYmluL3RndC1hZG1pbiAtLW9mZmxpbmUgQUxMCitFeGVjU3RvcD0vdXNyL3NiaW4vdGd0LWFk
bWluIC0tdXBkYXRlIEFMTCAtYyAvZGV2L251bGwgLWYKK0V4ZWNTdG9wPS91c3Ivc2Jpbi90Z3Rh
ZG0gIC0tb3AgZGVsZXRlIC0tbW9kZSBzeXN0ZW0KKworIyBFeGl0IGNvZGU6IDEwNyB0Z3RkIG5v
dCBydW5uaW5nCisKKworW0luc3RhbGxdCitXYW50ZWRCeT1tdWx0aS11c2VyLnRhcmdldAotLSAK
Mi4xLjQKCg==
--047d7b5d6592bc007f05129705ca--
