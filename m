From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: Re: [PATCH] sheepdog: fix data format for sheepdog request and response
Date: Tue, 9 Dec 2014 22:51:42 +0900
Message-ID: <CAE1WaK+RwHJf2_xtkATNV0J1kt-_aOy4mOxsju_kpC8n6kKodg@mail.gmail.com>
References: <1417679438-6118-1-git-send-email-ishizaki.teruaki@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=yrZ/01fqPCRtC1yv5XofATH6Dnco7qy1q6OCPrbIb4k=;
        b=wjLfHos6CoZ7QZu1llf9eX2YgFltImrCuZLNrxqQfGlnXwAxbk9HCo73ydvCjilFzx
         BC9NVSgqOZ6iEYi7Bd0BboAJyLss7Mr0BEK0aoA7M0VRvMXW18z7/86WbL4sv9QUJs2h
         NkdrmkjzeciQMkGkm+P46f90AGIclnuImQPbpvI72dnAQUhtAOOn0TXWVVw68kXlnIoX
         pZc4FKjNdnnjf6SW//QyuUDKaLbgCKWCUuzvJWyGG8gSMi1OmTLAKvYhFnSD/u/M+9zW
         TmuPQY3TT90R17S9dqj/obPmWWHhMj3tomTVktMsOsKUMEIjYwV396+V+6BswaFv9f8V
         BDCw==
In-Reply-To: <1417679438-6118-1-git-send-email-ishizaki.teruaki@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
Cc: stgt <stgt@vger.kernel.org>

On Thu, Dec 4, 2014 at 4:50 PM, Teruaki Ishizaki
<ishizaki.teruaki@lab.ntt.co.jp> wrote:
> Data format of sheepdog backing store is different from that of Sheepdog.
> This patch fixes data format of sheepdog request and response.
>
> Signed-off-by: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |   29 ++++++++++++++++++++---------
>  1 files changed, 20 insertions(+), 9 deletions(-)

Looks good to me.
Reviewed-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Thanks,
Hitoshi

>
> diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
> index 2941803..7c155fe 100644
> --- a/usr/bs_sheepdog.c
> +++ b/usr/bs_sheepdog.c
> @@ -157,9 +157,13 @@ struct sheepdog_obj_req {
>         uint32_t data_length;
>         uint64_t oid;
>         uint64_t cow_oid;
> -       uint32_t copies;
> +       uint8_t copies;
> +       uint8_t copy_policy;
> +       uint8_t ec_index;
> +       uint8_t reserved;
>         uint32_t rsvd;
> -       uint64_t offset;
> +       uint32_t offset;
> +       uint32_t pad;
>  };
>
>  struct sheepdog_obj_rsp {
> @@ -170,7 +174,8 @@ struct sheepdog_obj_rsp {
>         uint32_t id;
>         uint32_t data_length;
>         uint32_t result;
> -       uint32_t copies;
> +       uint8_t copies;
> +       uint8_t reserved[3];
>         uint32_t pad[6];
>  };
>
> @@ -186,7 +191,10 @@ struct sheepdog_vdi_req {
>         uint32_t data_length;
>         uint64_t vdi_size;
>         uint32_t vdi_id;
> -       uint32_t copies;
> +       uint8_t copies;
> +       uint8_t copy_policy;
> +       uint8_t ec_index;
> +       uint8_t reserved;
>         uint32_t snapid;
>         uint32_t type;
>         uint32_t pad[2];
> @@ -202,7 +210,10 @@ struct sheepdog_vdi_rsp {
>         uint32_t result;
>         uint32_t rsvd;
>         uint32_t vdi_id;
> -       uint32_t pad[5];
> +       uint32_t attr_id;
> +       uint8_t copies;
> +       uint8_t reserved[3];
> +       uint32_t pad[3];
>  };
>
>  /*
> @@ -639,7 +650,7 @@ static int find_vdi_name(struct sheepdog_access_info *ai, char *filename,
>                          uint32_t snapid, char *tag, uint32_t *vid,
>                          int for_snapshot);
>  static int read_object(struct sheepdog_access_info *ai, char *buf, uint64_t oid,
> -                      int copies, unsigned int datalen, uint64_t offset,
> +                      int copies, unsigned int datalen, uint32_t offset,
>                        int *need_reload);
>
>  static int reload_inode(struct sheepdog_access_info *ai, int is_snapshot)
> @@ -679,7 +690,7 @@ static int reload_inode(struct sheepdog_access_info *ai, int is_snapshot)
>
>  static int read_write_object(struct sheepdog_access_info *ai, char *buf,
>                              uint64_t oid, int copies,
> -                            unsigned int datalen, uint64_t offset,
> +                            unsigned int datalen, uint32_t offset,
>                              int write, int create, uint64_t old_oid,
>                              uint16_t flags, int *need_reload)
>  {
> @@ -738,7 +749,7 @@ static int read_write_object(struct sheepdog_access_info *ai, char *buf,
>
>  static int read_object(struct sheepdog_access_info *ai, char *buf,
>                        uint64_t oid, int copies,
> -                      unsigned int datalen, uint64_t offset, int *need_reload)
> +                      unsigned int datalen, uint32_t offset, int *need_reload)
>  {
>         return read_write_object(ai, buf, oid, copies, datalen, offset,
>                                  0, 0, 0, 0, need_reload);
> @@ -746,7 +757,7 @@ static int read_object(struct sheepdog_access_info *ai, char *buf,
>
>  static int write_object(struct sheepdog_access_info *ai, char *buf,
>                         uint64_t oid, int copies,
> -                       unsigned int datalen, uint64_t offset, int create,
> +                       unsigned int datalen, uint32_t offset, int create,
>                         uint64_t old_oid, uint16_t flags, int *need_reload)
>  {
>         return read_write_object(ai, buf, oid, copies, datalen, offset, 1,
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
