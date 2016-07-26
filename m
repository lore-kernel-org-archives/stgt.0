From: Anton Kovalenko <anton.kovalenko@acronis.com>
Subject: Re: fix stgt crash in conn_close
Date: Tue, 26 Jul 2016 11:02:06 +0300
Message-ID: <87mvl4zv29.fsf@desktop-ng.home.sw4me.com>
References: <CAKbOEttnmAh6Jn5sGSBFjOdjEQvB-aSYYdtjWb9PSzz5KzkoKg@mail.gmail.com>
	<87zip6yx2s.fsf@desktop-ng.home.sw4me.com>
	<87shuyyw5m.fsf@desktop-ng.home.sw4me.com>
	<CAKbOEtvX_NBVVRvh1Ev1=-xdbq3sPa9rfxrZCWQqD0i=43Mu7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


Hi,

fx chen <chenfx2014@gmail.com> writes:

> we also consiger you idea，in iscsi_free_task, do task unlinking from
> session->cmd_list(list_del(&task->c_hlist) )，but we must know，such as
> ISCSI_OP_NOOP_OUT, ISCSI_OP_SCSI_TMFUNC,  ISCSI_OP_LOGOUT type task,
> they don‘t add to session->cmd_list,   To solve the problem， we offer
> patch<v2-0001-iscsi-fix-segfault-at-conn_close>。

When a task is freshly allocated by iscsi_alloc_task, it has an empty
c_hlist (see INIT_LIST_HEAD in iscsi_alloc_task), that will remain the
same until iscsi_free_task if the task is never linked to a cmd_list.

Therefore doing nothing with an empty c_hlist is enough (even list_del
on an empty c_hlist would do no harm). That would skip ISCSI tasks which
are not SCSI commands, exactly because they never get added to cmd_list.

There are also two cases where c_hlist has prev == next == NULL, one of
them when a task is allocated directly with iscsi_tcp_alloc_task (it
happens for NOOP-IN "pings", and such a task should never be
iscsi_free_task'ed), another one when a task used to be on a cmd_list,
and then list_del was called (list_del sets prev == next == NULL).

So I believe it's enough to check for NULL pointers and for an empty
list, doing list_del if neither of these conditions is true.

> in addition：after we carefully consideration： you below patch  still
> may happen some task unlinking from session->cmd_list， when  there is
> only one task in session->cmd_list，now task->c_hlist.next and
> task->c_hlist.prev  is equal， according to you patch logic， this task
> will not do list_del。

Thank you for the heads up!

Yep, now I use list_empty to check for list emptiness (it compares
&c_hlist with c_hlist->head internally). Attaching the patch below.

Are there any reasons for checking opcode then?


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Unlink-task-from-c_hlist-before-free-if-needed.patch

From 0c105acd248693530f31c97ab20e33ba760e42e9 Mon Sep 17 00:00:00 2001
From: Anton Kovalenko <anton.kovalenko@acronis.com>
Date: Tue, 26 Jul 2016 10:46:35 +0300
Subject: [PATCH] Unlink task from c_hlist before free if needed

---
 usr/iscsi/iscsid.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/usr/iscsi/iscsid.c b/usr/iscsi/iscsid.c
index 75faae5..044819e 100644
--- a/usr/iscsi/iscsid.c
+++ b/usr/iscsi/iscsid.c
@@ -1227,6 +1227,11 @@ void iscsi_free_task(struct iscsi_task *task)
 
 	list_del(&task->c_siblings);
 
+	if (task->c_hlist.prev && task->c_hlist.next
+	    && !list_empty(&task->c_hlist)) {
+		list_del(&task->c_hlist);
+	}
+
 	conn->tp->free_data_buf(conn, scsi_get_in_buffer(&task->scmd));
 	conn->tp->free_data_buf(conn, scsi_get_out_buffer(&task->scmd));
 
-- 
2.8.1


--=-=-=
Content-Type: text/plain


-- 
Regards, Anton Kovalenko | +7(916)345-34-02 | Elektrostal' MO, Russia

--=-=-=--
