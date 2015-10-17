From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Handle access of a target that has been removed
Date: Sat, 17 Oct 2015 21:57:37 +0900 (JST)
Message-ID: <20151017.215737.1568838937885765085.fujita.tomonori@lab.ntt.co.jp>
References: <561D4909.8040006@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <561D4909.8040006@suse.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lduncan@suse.com
Cc: stgt@vger.kernel.org

On Tue, 13 Oct 2015 11:10:17 -0700
Lee Duncan <lduncan@suse.com> wrote:

> Hello:
> 
> I recently got a report of a tgtd core dump from our opencloud
> group. The stack trace showed that a strcmp against a NULL was causing
> the failure:
> 
> ----------------------------------------------------------------
> Program terminated with signal 11, Segmentation fault.
> (gdb) bt
> #0  0x00007fa701817576 in __strcmp_sse42 () from /lib64/libc.so.6
> #1  0x0000000000408012 in target_find_by_name (
>     name=0x6ac16f "iqn.2010-10.org.openstack:volume-e812c705-80bc-4064-a84c-5559cda8b1ca") at iscsi/target.c:216
> #2  0x0000000000406042 in login_start (conn=0x6abea8) at iscsi/iscsid.c:478
> #3  0x0000000000406e77 in cmnd_exec_login (conn=<optimized out>)
>     at iscsi/iscsid.c:654
> #4  cmnd_execute (conn=<optimized out>) at iscsi/iscsid.c:914
> #5  iscsi_rx_handler (conn=0x6abea8) at iscsi/iscsid.c:2064
> #6  0x0000000000409e98 in iscsi_tcp_event_handler (fd=<optimized out>, 
>     events=1, data=0x63a480 <target_list>) at iscsi/iscsi_tcp.c:158
> #7  0x0000000000418f1e in event_loop () at tgtd.c:272
> #8  0x0000000000419405 in main (argc=1, argv=<optimized out>) at tgtd.c:438
> ----------------------------------------------------------------
> 
> It looks like target_find_by_name() uses tgt_targetname(), but doesn't
> account for the fact that it can return a NULL when the target being
> looked up does not (now) exist:

Thanks for the patch. But I'm confused why this happens. target with
the same tid as iscsi_target must exist?

> ----------------------------------------------------------------
> char *tgt_targetname(int tid)            
> {               
>         struct target *target;      
>                         
>         target = target_lookup(tid);
>         if (!target)
>                 return NULL;
>         
>         return target->name;
> }                                   
> ----------------------------------------------------------------
> 
> I propose the following patch to address this:
> 
> --- 
> diff --git a/usr/iscsi/target.c b/usr/iscsi/target.c
> index 7afd7fd0ba87..b0a36e7de7b4 100644
> --- a/usr/iscsi/target.c
> +++ b/usr/iscsi/target.c
> @@ -369,9 +369,11 @@ void target_list_build(struct iscsi_connection *conn, char *addr, char *name)
>  struct iscsi_target *target_find_by_name(const char *name)
>  {
>         struct iscsi_target *target;
> +       char *tname;
>  
>         list_for_each_entry(target, &iscsi_targets_list, tlist) {
> -               if (!strcmp(tgt_targetname(target->tid), name))
> +               tname = tgt_targetname(target->tid);
> +               if (tname && !strcmp(tname, name))
>                         return target;
>         }
>  
> 
> -- 
> Lee Duncan
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
