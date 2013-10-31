From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: Re: [PATCH] tgtd: protect socket for management IPC with lockf(3)
Date: Thu, 31 Oct 2013 10:31:35 +0900
Message-ID: <CAE1WaK+18Yx6tK_HROORmHHF4K3+mxPcw5ZK6QybA0UQFhz+RA@mail.gmail.com>
References: <1383013275-8969-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=/svjPBvatazIDqxoccuaMiuoLqXyGlwe38HLsqx9f/c=;
        b=xIqcuauA71cWxGUaCqL2IrqPXWozZKMbED8iciJOFQhKwbrDmo4bdG9CzVB81e/J51
         fYPnan0/5fFc1wWHPurimh3yEExviASRdcqjvqL+0vCvZnALPe66nzvrB1msu398zSGi
         kde2jz7LfvFtCRfU+t5jj0wIqhsKSl7vWHRL2emhvdrMiOf1POPEBg7uWeQS0io6+m00
         xh9u72uW5+bpxtyFaqzkKwxxrG5OIVLErXVOrJE95BqbSCiWHlgJV9SjpZYS3ByIQ5eJ
         DDOz0E965tYH0wooA0Cyn1WIPaSRAX4CUQGYE5wNJUCkJPwuaOpTCbIMATGs84BFNNo2
         yHVA==
In-Reply-To: <1383013275-8969-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Cc: stgt <stgt@vger.kernel.org>

On Tue, Oct 29, 2013 at 11:21 AM, Hitoshi Mitake
<mitake.hitoshi@lab.ntt.co.jp> wrote:
> If two or more tgtds are launched with same control port (a number
> specified with -C option), tgtadm cannot communicate with tgtds
> because the latest tgtd cominates the socket. This behavior is
> confusing.
>
> This patch lets tgtd lock the socket with lockf(3). With this change,
> tgtd will exits when the socket of its control port is already locked.
>
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/mgmt.c |   36 +++++++++++++++++++++++++++++-------
>  usr/tgtd.c |    6 +++---
>  2 files changed, 32 insertions(+), 10 deletions(-)

ping?

>
> diff --git a/usr/mgmt.c b/usr/mgmt.c
> index c0bf7be..e795555 100644
> --- a/usr/mgmt.c
> +++ b/usr/mgmt.c
> @@ -62,8 +62,9 @@ struct mgmt_task {
>
>  #define MAX_MGT_BUFSIZE        (8*1024) /* limit incoming mgmt request data size */
>
> -static int ipc_fd;
> +static int ipc_fd, ipc_lock_fd;
>  char mgmt_path[256];
> +char mgmt_lock_path[256];
>
>  static struct mgmt_task *mtask_alloc(void);
>  static void mtask_free(struct mgmt_task *mtask);
> @@ -760,13 +761,30 @@ out:
>  int ipc_init(void)
>  {
>         extern short control_port;
> -       int fd, err;
> +       int fd = 0, err;
>         struct sockaddr_un addr;
>
> +       sprintf(mgmt_lock_path, "%s.%d.lock", TGT_IPC_NAMESPACE, control_port);
> +       ipc_lock_fd = open(mgmt_lock_path, O_WRONLY | O_CREAT,
> +                          S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
> +       if (ipc_lock_fd < 0) {
> +               eprintf("failed to open lock file for management IPC\n");
> +               return -1;
> +       }
> +
> +       if (lockf(ipc_lock_fd, F_TLOCK, 1) < 0) {
> +               if (errno == EACCES || errno == EAGAIN)
> +                       eprintf("another tgtd is using %s\n", mgmt_lock_path);
> +               else
> +                       eprintf("unable to get lock of management IPC: %s"\
> +                               " (errno: %m)\n", mgmt_lock_path);
> +               goto close_lock_fd;
> +       }
> +
>         fd = socket(AF_LOCAL, SOCK_STREAM, 0);
>         if (fd < 0) {
>                 eprintf("can't open a socket, %m\n");
> -               return -1;
> +               goto close_lock_fd;
>         }
>
>         sprintf(mgmt_path, "%s.%d", TGT_IPC_NAMESPACE, control_port);
> @@ -778,24 +796,27 @@ int ipc_init(void)
>         err = bind(fd, (struct sockaddr *) &addr, sizeof(addr));
>         if (err) {
>                 eprintf("can't bind a socket, %m\n");
> -               goto out;
> +               goto close_ipc_fd;
>         }
>
>         err = listen(fd, 32);
>         if (err) {
>                 eprintf("can't listen a socket, %m\n");
> -               goto out;
> +               goto close_ipc_fd;
>         }
>
>         err = tgt_event_add(fd, EPOLLIN, mgmt_event_handler, NULL);
>         if (err)
> -               goto out;
> +               goto close_ipc_fd;
>
>         ipc_fd = fd;
>
>         return 0;
> -out:
> +
> +close_ipc_fd:
>         close(fd);
> +close_lock_fd:
> +       close(ipc_lock_fd);
>         return -1;
>  }
>
> @@ -803,4 +824,5 @@ void ipc_exit(void)
>  {
>         tgt_event_del(ipc_fd);
>         close(ipc_fd);
> +       close(ipc_lock_fd);
>  }
> diff --git a/usr/tgtd.c b/usr/tgtd.c
> index f985510..64eff32 100644
> --- a/usr/tgtd.c
> +++ b/usr/tgtd.c
> @@ -577,11 +577,11 @@ int main(int argc, char **argv)
>
>         spare_args = optind < argc ? argv[optind] : NULL;
>
> -       err = ipc_init();
> -       if (err)
> +       if (is_daemon && daemon(0, 0))
>                 exit(1);
>
> -       if (is_daemon && daemon(0, 0))
> +       err = ipc_init();
> +       if (err)
>                 exit(1);
>
>         err = log_init(program_name, LOG_SPACE_SIZE, is_daemon, is_debug);
> --
> 1.7.10.4
>
