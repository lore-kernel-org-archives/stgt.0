From: fx chen <chenfx2014@gmail.com>
Subject: Re: fix stgt crash in conn_close
Date: Tue, 26 Jul 2016 17:46:19 +0800
Message-ID: <CAKbOEtt2jEa021ejM2Wfvq4TKcfWqjbCrR36+UYQQD7Wms1q8Q@mail.gmail.com>
References: <CAKbOEttnmAh6Jn5sGSBFjOdjEQvB-aSYYdtjWb9PSzz5KzkoKg@mail.gmail.com>
 <87zip6yx2s.fsf@desktop-ng.home.sw4me.com> <87shuyyw5m.fsf@desktop-ng.home.sw4me.com>
 <CAKbOEtvX_NBVVRvh1Ev1=-xdbq3sPa9rfxrZCWQqD0i=43Mu7Q@mail.gmail.com> <87mvl4zv29.fsf@desktop-ng.home.sw4me.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1133314adf8ad5053886c576
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to;
        bh=FULEAMPgqE36NG1V+1BgxTUKGHbb1mQhOFL1H0MbjjI=;
        b=jSOVD9YyxbGv0d2l4RTavn6IO7dEykm3xNNgZ4TGWKI1jZhhS3ESwHbpmPo9NJuz6D
         e2SryI40pArCo6c+gOKIHhAAL/B0OpnFxlpjHHJlJ7XWAF1D75I94CdqpijoBMDGhKgg
         cELzyxqrxq8BLSjhgPh0pFrxOiYPwFywxXpxGYN7kQ1KZccYxKIGekjcExeaHxLcSYpy
         mD8kXpLA8TvDip9hjKGBbHcGQQ3Jt0IovNFvtIx0Gxp5AN6mniX6uOLGQAckuVXXbIiE
         30i7Is4Ew5eRxwOdiFLiRrVwYQx1GlL/MLNRtcglb3IsVYtAjIe6QWGxhmcpdqJuffBp
         QY4Q==
In-Reply-To: <87mvl4zv29.fsf@desktop-ng.home.sw4me.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org

--001a1133314adf8ad5053886c576
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>Yep, now I use list_empty to check for list emptiness (it compares
>&c_hlist with c_hlist->head internally). Attaching the patch below.

>Are there any reasons for checking opcode then?

hi  Anton Kovalenko

we check task opcode in iscsi_free_task, if task opcode is
ISCSI_OP_SCSI_CMD, we do list list_del(&task->c_hlist);  because we
suppose iscsi_free_task is a generic interface to release task=EF=BC=8Cthea=
se
task include ISCSI_OP_SCSI_CMD=EF=BC=8CISCSI_OP_NOOP_OUT, ISCSI_OP_SCSI_TMF=
UNC
and so on=EF=BC=8C but only ISCSI_OP_SCSI_CMD task is added to
adsession->cmd_list,  so=EF=BC=8C in iscsi_free_task=EF=BC=8C we check
ISCSI_OP_SCSI_CMD opcode and list_del, This logic is reasonable=EF=BC=8C

But carefully consider your modify=EF=BC=8CLogically it is not easy to
understand=EF=BC=8Conly fix current bug(Currently, I'm not sure whether sti=
ll
potential problems such modifications ),
Iwe carefully consider the logical=EF=BC=8Cwhy  do below  task->c_hlist.pre=
v
task->c_hlist.prev check in iscsi_free_task
+ if (task->c_hlist.prev && task->c_hlist.next
+    && !list_empty(&task->c_hlist)) {
+ list_del(&task->c_hlist);
+ }
+
Similarly=EF=BC=8Cbesides task->c_hlist=EF=BC=8C task have task->c_siblings=
, Why not
do below task->c_siblings relate check?
+ if (task->c_siblings.prev && task->c_siblings.next
+    && !list_empty(&task->c_siblings)) {
+ list_del(&task->c_siblings);
+ }
+
Similarly=EF=BC=8Cbesides task->c_hlist=EF=BC=8C task have task->c_list, Wh=
y not do
below task->c_list relate check?
+ if (task->c_list.prev && task->c_list.next
+    && !list_empty(&task->c_list)) {
+ list_del(&task->c_list);
+ }
+

Please think about our proposal=EF=BC=81thank you

2016-07-26 16:02 GMT+08:00 Anton Kovalenko <anton.kovalenko@acronis.com>:
>
> Hi,
>
> fx chen <chenfx2014@gmail.com> writes:
>
>> we also consiger you idea=EF=BC=8Cin iscsi_free_task, do task unlinking =
from
>> session->cmd_list(list_del(&task->c_hlist) )=EF=BC=8Cbut we must know=EF=
=BC=8Csuch as
>> ISCSI_OP_NOOP_OUT, ISCSI_OP_SCSI_TMFUNC,  ISCSI_OP_LOGOUT type task,
>> they don=E2=80=98t add to session->cmd_list,   To solve the problem=EF=
=BC=8C we offer
>> patch<v2-0001-iscsi-fix-segfault-at-conn_close>=E3=80=82
>
> When a task is freshly allocated by iscsi_alloc_task, it has an empty
> c_hlist (see INIT_LIST_HEAD in iscsi_alloc_task), that will remain the
> same until iscsi_free_task if the task is never linked to a cmd_list.
>
> Therefore doing nothing with an empty c_hlist is enough (even list_del
> on an empty c_hlist would do no harm). That would skip ISCSI tasks which
> are not SCSI commands, exactly because they never get added to cmd_list.
>
> There are also two cases where c_hlist has prev =3D=3D next =3D=3D NULL, =
one of
> them when a task is allocated directly with iscsi_tcp_alloc_task (it
> happens for NOOP-IN "pings", and such a task should never be
> iscsi_free_task'ed), another one when a task used to be on a cmd_list,
> and then list_del was called (list_del sets prev =3D=3D next =3D=3D NULL)=
.
>
> So I believe it's enough to check for NULL pointers and for an empty
> list, doing list_del if neither of these conditions is true.
>
>> in addition=EF=BC=9Aafter we carefully consideration=EF=BC=9A you below =
patch  still
>> may happen some task unlinking from session->cmd_list=EF=BC=8C when  the=
re is
>> only one task in session->cmd_list=EF=BC=8Cnow task->c_hlist.next and
>> task->c_hlist.prev  is equal=EF=BC=8C according to you patch logic=EF=BC=
=8C this task
>> will not do list_del=E3=80=82
>
> Thank you for the heads up!
>
> Yep, now I use list_empty to check for list emptiness (it compares
> &c_hlist with c_hlist->head internally). Attaching the patch below.
>
> Are there any reasons for checking opcode then?
>
>
>
> --
> Regards, Anton Kovalenko | +7(916)345-34-02 | Elektrostal' MO, Russia
>

--001a1133314adf8ad5053886c576
Content-Type: application/octet-stream; 
	name="v2-0001-iscsi-fix-segfault-at-conn_close.patch"
Content-Disposition: attachment; 
	filename="v2-0001-iscsi-fix-segfault-at-conn_close.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ir3a1ep01

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
--001a1133314adf8ad5053886c576--
