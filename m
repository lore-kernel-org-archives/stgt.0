From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v3] tgtd: refresh ready fds of event loop after event
 deletion
Date: Wed, 26 Feb 2014 14:22:21 +0900
Message-ID: <20140226141945U.fujita.tomonori@lab.ntt.co.jp>
References: <1393391602-6801-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1393391602-6801-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, mitake.hitoshi@gmail.com

On Wed, 26 Feb 2014 14:13:22 +0900
Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp> wrote:

> Current main event loop (event_loop()) of tgtd has a possibility of
> segmentation fault. The problem is caused by the below sequence:
> 
> 1. Event A, B are ready so epoll_wait(2) returns.
> 2. The handler of the event A is called. In the event handler, the
>    event B is deleted with tgt_event_del()
> 3. event_loop() tries to call the handler of the event B. It causes
>    segfault because the event struct is already removed and freed.
> 
> For avoid this problem, this patch adds a new global variable
> event_need_refresh. If the value of this variable is 1, event_loop()
> calls epoll_wait(2) again for refreshing ready fd list. This patch
> also lets tgt_event_del() to turn on the flag in its tail.
> 
> For example, we can produce segfault of tgtd under heavy load. Below
> is a backtrace obtained from the core file:
>  (gdb) bt
>  #0  0x0000000000000000 in ?? ()
>  #1  0x0000000000411419 in event_loop () at tgtd.c:414
>  #2  0x0000000000411b65 in main (argc=<value optimized out>, argv=<value optimized out>) at tgtd.c:591
> 
> To be honest, I still don't find an event handler which calls
> tgt_event_del() for other fds. But with this modification, the above
> segfault is avoided. The change seems to be effective.

As you pointed out off-line, making a connection closed via tgtadm
might be the case. Anyway, I think that the handler API should allow
removing other handlers from a handler. Merged, thanks a lot!

> +int event_need_refresh;
> +

static?

>  void tgt_event_del(int fd)
>  {
>  	struct event_data *tev;
> @@ -229,6 +231,8 @@ void tgt_event_del(int fd)
>  
>  	list_del(&tev->e_list);
>  	free(tev);
> +
> +	event_need_refresh = 1;
>  }
>  
>  int tgt_event_modify(int fd, int events)
> @@ -426,6 +430,11 @@ retry:
>  		for (i = 0; i < nevent; i++) {
>  			tev = (struct event_data *) events[i].data.ptr;
>  			tev->handler(tev->fd, events[i].events, tev->data);
> +
> +			if (event_need_refresh) {
> +				event_need_refresh = 0;
> +				goto retry;
> +			}
>  		}
>  	}
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
