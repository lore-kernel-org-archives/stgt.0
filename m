From: Anton Kovalenko <anton.kovalenko@acronis.com>
Subject: Re: fix stgt crash in conn_close
Date: Mon, 25 Jul 2016 10:51:39 +0300
Message-ID: <87zip6yx2s.fsf@desktop-ng.home.sw4me.com>
References: <CAKbOEttnmAh6Jn5sGSBFjOdjEQvB-aSYYdtjWb9PSzz5KzkoKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


fx chen writes:

> hello!
> we found tgtd happen core dump and fix it。

[...]

Hi,

I believe we've hit the same problem recently (a free'd command hanging
on a session's cmd_list), and I have the same suspicion about conn_close.

I'm attaching my own version of a preliminary fix, that avoids examining
the entire cmd_list on each task deallocation.

I make use of the fact that a task's c_hlist during iscsi_free_task is
one of the following:

* an empty list head (task->c_hlist->next == task->c_hlist), if a task
  was allocated by iscsi_alloc_task and c_hlist was INIT_LIST_HEAD'ed
  and never touched
  
* a pair of null pointers for next and prev, if a task has been
  list_del'ed from a cmd_list (or allocated by raw iscsi_tcp_alloc_task,
  with all fields memset to 0 -- happens to "ping" NOOP-INs).

* a valid non-empty member of a cmd_list chain, in all other cases
  (prev!=next captures this condition perfectly).

Therefore when we have c_hlist->prev!=c_hlist->next in iscsi_free_task,
we can list_del safely, removing the task from whatever cmd_list it was
on.

Do you see any problem with my version of a fix? (see attachment)

P.S.
I believe it would be better to learn _where exactly_ does conn_close
call iscsi_free_task instead of iscsi_free_cmd_task, and why it happens,
and fix it more "precisely" in that place. 

However, having a crude, overprotective fix is better than not having
any. And as crude fixes go, I'd prefer the one which doesn't walk
cmd_list on a task deallocation.



--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=task_chlist_cleanup_on_free.patch

diff --git a/usr/iscsi/iscsid.c b/usr/iscsi/iscsid.c
index b7ee0ad..dbb80a7 100644
--- a/usr/iscsi/iscsid.c
+++ b/usr/iscsi/iscsid.c
@@ -1225,6 +1225,12 @@ void iscsi_free_task(struct iscsi_task *task)
 
 	list_del(&task->c_siblings);
 
+	if (task->c_hlist.next != task->c_hlist.prev) {
+		eprintf("task on c_hlist: %p %p %p\n",
+			task, task->c_hlist.prev, task->c_hlist.next);
+		list_del(&task->c_hlist);
+	}
+
 	conn->tp->free_data_buf(conn, scsi_get_in_buffer(&task->scmd));
 	conn->tp->free_data_buf(conn, scsi_get_out_buffer(&task->scmd));
 

--=-=-=
Content-Type: text/plain


-- 
Regards, Anton Kovalenko | +7(916)345-34-02 | Elektrostal' MO, Russia

--=-=-=--
