From: Anton Kovalenko <anton.kovalenko@acronis.com>
Subject: Re: fix stgt crash in conn_close
Date: Mon, 25 Jul 2016 11:11:33 +0300
Message-ID: <87shuyyw5m.fsf@desktop-ng.home.sw4me.com>
References: <CAKbOEttnmAh6Jn5sGSBFjOdjEQvB-aSYYdtjWb9PSzz5KzkoKg@mail.gmail.com>
	<87zip6yx2s.fsf@desktop-ng.home.sw4me.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: stgt@vger.kernel.org

Anton Kovalenko <anton.kovalenko@acronis.com> writes:

>
>> hello!
>> we found tgtd happen core dump and fix it=E3=80=82

[...]

> I'm attaching my own version of a preliminary fix, that avoids examin=
ing
> the entire cmd_list on each task deallocation.

On a second though, I think a conditional list_del(&task->c_hlist) in
iscsi_free_task is good enough, but then we'd probably get rid of the
*unconditional* list_del in iscsi_free_cmd_task, making iscsi_free_task
responsible for task unlinking from c_hlist (it *is* responsible for
unlinking from c_siblings anyway).

What bothers me now is that a task removed from cmdlist, being a SCSI
command, is probably not supposed to be freed without calling
target_cmd_done (or is it?). I'm unsure if it might cause a resource
leak of some kind.


--=20
Regards, Anton Kovalenko | +7(916)345-34-02 | Elektrostal' MO, Russia
