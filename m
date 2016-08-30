From: Anton Kovalenko <Anton.Kovalenko@acronis.com>
Subject: [PATCH] Disable NOP-IN and adjust state for closed conn
Date: Tue, 30 Aug 2016 17:09:21 +0000
Message-ID: <1472576961463.91961@acronis.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_002_147257696146391961acroniscom_"
Return-path: <stgt-owner@vger.kernel.org>
Content-Language: ru-RU
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

--_002_147257696146391961acroniscom_
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable

I'm attaching the patch fixing one more problem noticed with non-zero nop_i=
nterval:=0A=
=0A=
There is a couple of problems when a connection is closed by=0A=
iscsi_tcp_nop_work_handler, and there are uncompleted scsi commands for=0A=
that connection:=0A=
=0A=
1) usr/iscsi/iscsid.c:iscsi_scsi_cmd_done assumes that a closed connection=
=0A=
has .state =3D=3D STATE_CLOSE. The assumption fails if the connection is=0A=
closed not as a reaction to STATE_CLOSE, but by a raw conn_close call=0A=
outside of rx/tx handlers (like it happens for unanswered NOP-INs).=0A=
This commit takes care to set .state =3D STATE_CLOSE in ep_close callback,=
=0A=
so incomplete scsi commands will be freed on completion.=0A=
=0A=
2) the connection doesn't go away from iscsi_tcp_conn_list until its=0A=
refcount reaches zero (see iscsi_tcp_release). It makes=0A=
iscsi_tcp_nop_work_handler call conn_close for the same connection=0A=
repeatedly, as long as it has incomplete scsi commands (hence non-zero=0A=
refcount). This commit zeroes out nop_interval for closed connections,=0A=
so next iscsi_tcp_nop_work_handler calls won't try to close the=0A=
connection any more.=0A=

--_002_147257696146391961acroniscom_
Content-Type: text/x-patch;
	name="0001-Disable-NOP-IN-and-adjust-state-for-closed-conn.patch"
Content-Description: 0001-Disable-NOP-IN-and-adjust-state-for-closed-conn.patch
Content-Disposition: attachment;
	filename="0001-Disable-NOP-IN-and-adjust-state-for-closed-conn.patch";
	size=1682; creation-date="Tue, 30 Aug 2016 17:07:44 GMT";
	modification-date="Tue, 30 Aug 2016 17:07:44 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhYzFiNzMyYjYxMmZlMmMxODhkY2MyNDQxZTVkZDI0N2QzNDUyODM2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbnRvbiBLb3ZhbGVua28gPGFudG9uLmtvdmFsZW5rb0BhY3Jv
bmlzLmNvbT4KRGF0ZTogVHVlLCAzMCBBdWcgMjAxNiAxOTowMjo1MSArMDMwMApTdWJqZWN0OiBb
UEFUQ0hdIERpc2FibGUgTk9QLUlOIGFuZCBhZGp1c3Qgc3RhdGUgZm9yIGNsb3NlZCBjb25uCgpU
aGVyZSBpcyBhIGNvdXBsZSBvZiBwcm9ibGVtcyB3aGVuIGEgY29ubmVjdGlvbiBpcyBjbG9zZWQg
YnkKaXNjc2lfdGNwX25vcF93b3JrX2hhbmRsZXIsIGFuZCB0aGVyZSBhcmUgdW5jb21wbGV0ZWQg
c2NzaSBjb21tYW5kcyBmb3IKdGhhdCBjb25uZWN0aW9uOgoKMSkgdXNyL2lzY3NpL2lzY3NpZC5j
OmlzY3NpX3Njc2lfY21kX2RvbmUgYXNzdW1lcyB0aGF0IGEgY2xvc2VkIGNvbm5lY3Rpb24KaGFz
IC5zdGF0ZSA9PSBTVEFURV9DTE9TRS4gVGhlIGFzc3VtcHRpb24gZmFpbHMgaWYgdGhlIGNvbm5l
Y3Rpb24gaXMKY2xvc2VkIG5vdCBhcyBhIHJlYWN0aW9uIHRvIFNUQVRFX0NMT1NFLCBidXQgYnkg
YSByYXcgY29ubl9jbG9zZSBjYWxsCm91dHNpZGUgb2YgcngvdHggaGFuZGxlcnMgKGxpa2UgaXQg
aGFwcGVucyBmb3IgdW5hbnN3ZXJlZCBOT1AtSU5zKS4KVGhpcyBjb21taXQgdGFrZXMgY2FyZSB0
byBzZXQgLnN0YXRlID0gU1RBVEVfQ0xPU0UgaW4gZXBfY2xvc2UgY2FsbGJhY2ssCnNvIGluY29t
cGxldGUgc2NzaSBjb21tYW5kcyB3aWxsIGJlIGZyZWVkIG9uIGNvbXBsZXRpb24uCgoyKSB0aGUg
Y29ubmVjdGlvbiBkb2Vzbid0IGdvIGF3YXkgZnJvbSBpc2NzaV90Y3BfY29ubl9saXN0IHVudGls
IGl0cwpyZWZjb3VudCByZWFjaGVzIHplcm8gKHNlZSBpc2NzaV90Y3BfcmVsZWFzZSkuIEl0IG1h
a2VzCmlzY3NpX3RjcF9ub3Bfd29ya19oYW5kbGVyIGNhbGwgY29ubl9jbG9zZSBmb3IgdGhlIHNh
bWUgY29ubmVjdGlvbgpyZXBlYXRlZGx5LCBhcyBsb25nIGFzIGl0IGhhcyBpbmNvbXBsZXRlIHNj
c2kgY29tbWFuZHMgKGhlbmNlIG5vbi16ZXJvCnJlZmNvdW50KS4gVGhpcyBjb21taXQgemVyb2Vz
IG91dCBub3BfaW50ZXJ2YWwgZm9yIGNsb3NlZCBjb25uZWN0aW9ucywKc28gbmV4dCBpc2NzaV90
Y3Bfbm9wX3dvcmtfaGFuZGxlciBjYWxscyB3b24ndCB0cnkgdG8gY2xvc2UgdGhlCmNvbm5lY3Rp
b24gYW55IG1vcmUuCi0tLQogdXNyL2lzY3NpL2lzY3NpX3RjcC5jIHwgMiArKwogMSBmaWxlIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL3Vzci9pc2NzaS9pc2NzaV90Y3Au
YyBiL3Vzci9pc2NzaS9pc2NzaV90Y3AuYwppbmRleCA0Y2MyY2Y0Li41MzZmMjJlIDEwMDY0NAot
LS0gYS91c3IvaXNjc2kvaXNjc2lfdGNwLmMKKysrIGIvdXNyL2lzY3NpL2lzY3NpX3RjcC5jCkBA
IC01MDgsNiArNTA4LDggQEAgc3RhdGljIHNpemVfdCBpc2NzaV90Y3BfY2xvc2Uoc3RydWN0IGlz
Y3NpX2Nvbm5lY3Rpb24gKmNvbm4pCiAJc3RydWN0IGlzY3NpX3RjcF9jb25uZWN0aW9uICp0Y3Bf
Y29ubiA9IFRDUF9DT05OKGNvbm4pOwogCiAJdGd0X2V2ZW50X2RlbCh0Y3BfY29ubi0+ZmQpOwor
CWNvbm4tPnN0YXRlID0gU1RBVEVfQ0xPU0U7CisJdGNwX2Nvbm4tPm5vcF9pbnRlcnZhbCA9IDA7
CiAJcmV0dXJuIDA7CiB9CiAKLS0gCjIuOS4zCgo=

--_002_147257696146391961acroniscom_--
