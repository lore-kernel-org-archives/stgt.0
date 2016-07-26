From: fx chen <chenfx2014@gmail.com>
Subject: Re: fix stgt crash in conn_close
Date: Tue, 26 Jul 2016 14:38:42 +0800
Message-ID: <CAKbOEtvX_NBVVRvh1Ev1=-xdbq3sPa9rfxrZCWQqD0i=43Mu7Q@mail.gmail.com>
References: <CAKbOEttnmAh6Jn5sGSBFjOdjEQvB-aSYYdtjWb9PSzz5KzkoKg@mail.gmail.com>
 <87zip6yx2s.fsf@desktop-ng.home.sw4me.com> <87shuyyw5m.fsf@desktop-ng.home.sw4me.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1147766ae2f7e70538842600
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to;
        bh=FNVGoZajiugcGfIrFpCSZQj38tn/7QHOf7lud6phnGw=;
        b=sT82krpiylR5HPXi0RZCeVj9DbfoH7RrWemaqdlas+vjM3d2LXWzC4jU0rUssTiP1y
         kI/oxo0JeuOnpFOcRlQrCkZsL2h54mXWbAFLm1XpkhXoBEnFOf2RVUFA7NcdGJCsmzpZ
         0JsjeqqUAoTkyECejyGy98zOerCtPqys9nCeKuoc0J1gbye/M+kyfm0lrKR0DW1TyvNQ
         KpYK3bYdA3XExsHbRNi8ar/M3hauI5ZXDj++sMP4s4HodRXuzb9zjdhc1Q2g8+0coOXX
         nYKBhvL0xD19rLQj8KVY2Ovpd45gJ0nlAcptUO4ovIgfYnoAay37GZDJSH0Qtp2jnSfi
         lx1Q==
In-Reply-To: <87shuyyw5m.fsf@desktop-ng.home.sw4me.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org

--001a1147766ae2f7e70538842600
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>
>> hello!
>> we found tgtd happen core dump and fix it=E3=80=82

[...]

>On a second though, I think a conditional list_del(&task->c_hlist) in
>iscsi_free_task is good enough,

Hi  Anton Kovalenko:
we also consiger you idea=EF=BC=8Cin iscsi_free_task, do task unlinking fro=
m
session->cmd_list(list_del(&task->c_hlist) )=EF=BC=8Cbut we must know=EF=BC=
=8Csuch as
ISCSI_OP_NOOP_OUT, ISCSI_OP_SCSI_TMFUNC,  ISCSI_OP_LOGOUT type task,
they don=E2=80=98t add to session->cmd_list,   To solve the problem=EF=BC=
=8C we offer
patch<v2-0001-iscsi-fix-segfault-at-conn_close>=E3=80=82

in addition=EF=BC=9Aafter we carefully consideration=EF=BC=9A you below pat=
ch  still
may happen some task unlinking from session->cmd_list=EF=BC=8C when  there =
is
only one task in session->cmd_list=EF=BC=8Cnow task->c_hlist.next and
task->c_hlist.prev  is equal=EF=BC=8C according to you patch logic=EF=BC=8C=
 this task
will not do list_del=E3=80=82
diff --git a/usr/iscsi/iscsid.c b/usr/iscsi/iscsid.c
index b7ee0ad..dbb80a7 100644
--- a/usr/iscsi/iscsid.c
+++ b/usr/iscsi/iscsid.c
@@ -1225,6 +1225,12 @@ void iscsi_free_task(struct iscsi_task *task)

  list_del(&task->c_siblings);

+ if (task->c_hlist.next !=3D task->c_hlist.prev) {
+ eprintf("task on c_hlist: %p %p %p\n",
+ task, task->c_hlist.prev, task->c_hlist.next);
+ list_del(&task->c_hlist);
+ }
+
  conn->tp->free_data_buf(conn, scsi_get_in_buffer(&task->scmd));
  conn->tp->free_data_buf(conn, scsi_get_out_buffer(&task->scmd));

2016-07-25 16:11 GMT+08:00 Anton Kovalenko <anton.kovalenko@acronis.com>:
> Anton Kovalenko <anton.kovalenko@acronis.com> writes:
>
>>
>>> hello!
>>> we found tgtd happen core dump and fix it=E3=80=82
>
> [...]
>
>> I'm attaching my own version of a preliminary fix, that avoids examining
>> the entire cmd_list on each task deallocation.
>
> On a second though, I think a conditional list_del(&task->c_hlist) in
> iscsi_free_task is good enough, but then we'd probably get rid of the
> *unconditional* list_del in iscsi_free_cmd_task, making iscsi_free_task
> responsible for task unlinking from c_hlist (it *is* responsible for
> unlinking from c_siblings anyway).
>
> What bothers me now is that a task removed from cmdlist, being a SCSI
> command, is probably not supposed to be freed without calling
> target_cmd_done (or is it?). I'm unsure if it might cause a resource
> leak of some kind.
>
>
> --
> Regards, Anton Kovalenko | +7(916)345-34-02 | Elektrostal' MO, Russia
>
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--001a1147766ae2f7e70538842600
Content-Type: application/octet-stream; 
	name="v2-0001-iscsi-fix-segfault-at-conn_close.patch"
Content-Disposition: attachment; 
	filename="v2-0001-iscsi-fix-segfault-at-conn_close.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ir33cj4g0

RnJvbSBjMGQzZjE0OTgxMjI0MzBhMTY2YWEzMDRlNGU1ODEzOWVmZWM3ODhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDaGVuIEZhbmd4aWFuIDxjaGVuZmFuZ3hpYW5AY21zcy5jaGlu
YW1vYmlsZS5jb20+CkRhdGU6IFR1ZSwgMjYgSnVsIDIwMTYgMTE6MzM6MzkgKzA4MDAKU3ViamVj
dDogW1BBVENIIHYyXSBpc2NzaTogZml4IHNlZ2ZhdWx0IGF0IGNvbm5fY2xvc2UKClJlbW92ZSBz
b21lIGlzY3NpIHRhc2sgZnJvbSBjb25uLT5zZXNzaW9uLT5jbWRfbGlzdCBiZWZvcmUgZnJlZSBp
dCwKb3RoZXJ3aXNlIGl0IG1heSBjYXVzZSB0Z3RkIHByb2Nlc3MgY3Jhc2guIEJlbG93IGlzIGEg
YmFja3RyYWNlIGluZm86CgogUHJvZ3JhbSB0ZXJtaW5hdGVkIHdpdGggc2lnbmFsIDExLCBTZWdt
ZW50YXRpb24gZmF1bHQuCiAjMCAgMHgwMDAwMDAwMDAwNDBhMjU5IGluIF9fbGlzdF9kZWwgKHBy
ZXY9MHg3Y2QzOGMwLCBuZXh0PTB4NWFmZjM0MCkgYXQgLi9saXN0Lmg6ODMKIDgzICBwcmV2LT5u
ZXh0ID0gbmV4dDsKIChnZGIpIGJ0CiAjMCAgMHgwMDAwMDAwMDAwNDBhMjU5IGluIF9fbGlzdF9k
ZWwgKHByZXY9MHg3Y2QzOGMwLCBuZXh0PTB4NWFmZjM0MCkgYXQgLi9saXN0Lmg6ODMKICMxICAw
eDAwMDAwMDAwMDA0MGEyOTYgaW4gbGlzdF9kZWwgKGVudHJ5PTB4NjIzZDA4MCkgYXQgLi9saXN0
Lmg6ODgKICMyICAweDAwMDAwMDAwMDA0MGVkZDYgaW4gaXNjc2lfZnJlZV9jbWRfdGFzayAodGFz
az0weDYyM2QwMTApIGF0IGlzY3NpL2lzY3NpZC5jOjEyNTQKICMzICAweDAwMDAwMDAwMDA0MGVl
NmEgaW4gaXNjc2lfc2NzaV9jbWRfZG9uZSAobmlkPTMzNTYsIHJlc3VsdD0wLCBzY21kPTB4NjIz
ZDBlMCkgYXQgaXNjc2kvaXNjc2lkLmM6MTI2OQogIzQgIDB4MDAwMDAwMDAwMDQzMmRjMCBpbiB0
YXJnZXRfY21kX2lvX2RvbmUgKGNtZD0weDYyM2QwZTAsIHJlc3VsdD0wKSBhdCB0YXJnZXQuYzox
MjM2CiAjNSAgMHgwMDAwMDAwMDAwNDViZTM5IGluIGJzX3NpZ19yZXF1ZXN0X2RvbmUgKGZkPTEw
LCBldmVudHM9MSwgZGF0YT0weDApIGF0IGJzLmM6MjEwCiAjNiAgMHgwMDAwMDAwMDAwNDI4ZmYy
IGluIGV2ZW50X2xvb3AgKCkgYXQgdGd0ZC5jOjQzMgogIzcgIDB4MDAwMDAwMDAwMDQyOWZjYSBp
biBtYWluIChhcmdjPTMsIGFyZ3Y9MHg3ZmZmZmNlYzI1ZjgpIGF0IHRndGQuYzo2MjQKClNpZ25l
ZC1vZmYtYnk6IE1lbmcgTGluZ2t1biA8bWVuZ2xpbmdrdW5AY21zcy5jaGluYW1vYmlsZS5jb20+
ClNpZ25lZC1vZmYtYnk6IFdhbmcgWmhlbmd5b25nIDx3YW5nemhlbmd5b25nQGNtc3MuY2hpbmFt
b2JpbGUuY29tPgpSZXZpZXdlZC1ieTogV2FuZyBEb25neHUgPHdhbmdkb25neHVAY21zcy5jaGlu
YW1vYmlsZS5jb20+ClNpZ25lZC1vZmYtYnk6IENoZW4gRmFuZ3hpYW4gPGNoZW5mYW5neGlhbkBj
bXNzLmNoaW5hbW9iaWxlLmNvbT4KLS0tCiB1c3IvaXNjc2kvaXNjc2lkLmMgfCA0ICsrKy0KIHVz
ci9pc2NzaS9pc2NzaWQuaCB8IDIgKysKIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvdXNyL2lzY3NpL2lzY3NpZC5jIGIvdXNyL2lz
Y3NpL2lzY3NpZC5jCmluZGV4IDc1ZmFhZTUuLjEwNmVjNjUgMTAwNjQ0Ci0tLSBhL3Vzci9pc2Nz
aS9pc2NzaWQuYworKysgYi91c3IvaXNjc2kvaXNjc2lkLmMKQEAgLTEyMjcsNiArMTIyNyw5IEBA
IHZvaWQgaXNjc2lfZnJlZV90YXNrKHN0cnVjdCBpc2NzaV90YXNrICp0YXNrKQogCiAJbGlzdF9k
ZWwoJnRhc2stPmNfc2libGluZ3MpOwogCisJaWYgKHRhc2tfb3Bjb2RlKHRhc2spID09IElTQ1NJ
X09QX1NDU0lfQ01EKQorCQlsaXN0X2RlbCgmdGFzay0+Y19obGlzdCk7CisKIAljb25uLT50cC0+
ZnJlZV9kYXRhX2J1Zihjb25uLCBzY3NpX2dldF9pbl9idWZmZXIoJnRhc2stPnNjbWQpKTsKIAlj
b25uLT50cC0+ZnJlZV9kYXRhX2J1Zihjb25uLCBzY3NpX2dldF9vdXRfYnVmZmVyKCZ0YXNrLT5z
Y21kKSk7CiAKQEAgLTEyNTEsNyArMTI1NCw2IEBAIHZvaWQgaXNjc2lfZnJlZV9jbWRfdGFzayhz
dHJ1Y3QgaXNjc2lfdGFzayAqdGFzaykKIHsKIAl0YXJnZXRfY21kX2RvbmUoJnRhc2stPnNjbWQp
OwogCi0JbGlzdF9kZWwoJnRhc2stPmNfaGxpc3QpOwogCWlzY3NpX2ZyZWVfdGFzayh0YXNrKTsK
IH0KIApkaWZmIC0tZ2l0IGEvdXNyL2lzY3NpL2lzY3NpZC5oIGIvdXNyL2lzY3NpL2lzY3NpZC5o
CmluZGV4IGM3ZjY4MDEuLmI0ZjA0MzkgMTAwNjQ0Ci0tLSBhL3Vzci9pc2NzaS9pc2NzaWQuaAor
KysgYi91c3IvaXNjc2kvaXNjc2lkLmgKQEAgLTYwLDYgKzYwLDggQEAKIAogI2RlZmluZSBzaWRf
dG9fdHNpaChzaWQpICgoc2lkKSA+PiA0OCkKIAorI2RlZmluZSB0YXNrX29wY29kZSh0YXNrKSAo
KHRhc2spLT5yZXEub3Bjb2RlICYgSVNDU0lfT1BDT0RFX01BU0spCisKIHN0cnVjdCBpc2NzaV9w
ZHUgewogCXN0cnVjdCBpc2NzaV9oZHIgYmhzOwogCXZvaWQgKmFoczsKLS0gCjEuOC4zLjEKCg==
--001a1147766ae2f7e70538842600--
