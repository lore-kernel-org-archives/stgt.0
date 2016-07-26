From: Anton Kovalenko <anton.kovalenko@acronis.com>
Subject: Re: fix stgt crash in conn_close
Date: Tue, 26 Jul 2016 15:21:44 +0300
Message-ID: <87invszj1j.fsf@desktop-ng.home.sw4me.com>
References: <CAKbOEttnmAh6Jn5sGSBFjOdjEQvB-aSYYdtjWb9PSzz5KzkoKg@mail.gmail.com>
	<87zip6yx2s.fsf@desktop-ng.home.sw4me.com>
	<87shuyyw5m.fsf@desktop-ng.home.sw4me.com>
	<CAKbOEtvX_NBVVRvh1Ev1=-xdbq3sPa9rfxrZCWQqD0i=43Mu7Q@mail.gmail.com>
	<87mvl4zv29.fsf@desktop-ng.home.sw4me.com>
	<CAKbOEtt2jEa021ejM2Wfvq4TKcfWqjbCrR36+UYQQD7Wms1q8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: stgt@vger.kernel.org

Hi,

fx chen <chenfx2014@gmail.com> writes:

> But carefully consider your modify=EF=BC=8CLogically it is not easy t=
o
> understand=EF=BC=8Conly fix current bug(Currently, I'm not sure wheth=
er still
> potential problems such modifications ),

Yep, I like your last version of the fix more than mine. Moving c_hlist
unlinking completely into iscsi_free_task is more logical than doing it
there "just in case" AND leaving it in iscsi_free_cmd_task.

As of c_siblings and c_list chains, they are supposed to be managed
correctly, so I'd better avoid adding an over-protective check.  As of
c_siblings, its life cycle is simple and it's obviously correct (for an=
y
task, link when allocated, unlink when freed), as of c_list, I'm not so
sure, but that's no reason to patch iscsi_free_task ahead of time.

It would be great if you'd get time to test with a following fragment i=
n
iscsi_free_task:

if (task->c_list.prev &&
    task->c_list.next && !list_empty(&task->c_list)) {
    abort("Freeing a task with non-empty c_list");
}



>=20
> Iwe carefully consider the logical=EF=BC=8Cwhy do below task->c_hlist=
=2Eprev
> task->c_hlist.prev check in iscsi_free_task + if (task->c_hlist.prev
> && task->c_hlist.next + && !list_empty(&task->c_hlist)) { +
> list_del(&task->c_hlist); + } + Similarly=EF=BC=8Cbesides task->c_hli=
st=EF=BC=8C
> task have task->c_siblings, Why not do below task->c_siblings relate
> check?  + if (task->c_siblings.prev && task->c_siblings.next + &&
> !list_empty(&task->c_siblings)) { + list_del(&task->c_siblings); + } =
+
> Similarly=EF=BC=8Cbesides task->c_hlist=EF=BC=8C task have task->c_li=
st, Why not do
> below task->c_list relate check?  + if (task->c_list.prev &&
> task->c_list.next + && !list_empty(&task->c_list)) { +
> list_del(&task->c_list); + } +

--=20
Regards, Anton Kovalenko | +7(916)345-34-02 | Elektrostal' MO, Russia
