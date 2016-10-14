From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: Re: [PATCH v2] sheepdog: reject snapshot as a LUN to avoid deleting
 working VDI
Date: Fri, 14 Oct 2016 14:20:48 +0900
Message-ID: <CAE1WaK+Y-OVuo3P8uvyHAXJuvv2e7L+D1PEO_v0Ar=eEiHBebA@mail.gmail.com>
References: <1476360178-7452-1-git-send-email-menjo.takashi@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Phxa8MBtlhmr8AlLpHLRMzgQHdDzDoqgOrWTsu6/8JU=;
        b=qVjSSf1KWQ7/Ei9DKaveG/EuALlAYrFsp1oMx8GWv9tvGwpg1jQRrGQbNG7QM+epRB
         uWQbRYlYS00JKzA6kIjIzP/CdbCJCsO9a3WBufTxiWddWq3hbeHLBT7NUj6amxVfZ+w1
         DpuECp9r0IWLv4gULr2RAsXbGhG15Gh54cIkArt8i7fy5ZQdVRwkcp3MJZeYLhdi5o+h
         PXtCdM2FGJn4rXJJVsItxFaa7qTjqGO4L8SPNEOU/KHBDr2p/9Pn1iBdhdbgmcL7pXJc
         eoBzieCi6Y7A8+slAaOVyELH4+X4sSwWxG86EekZW9SXaYRVZSoiUHsd56wftCIRe3pY
         CCrg==
In-Reply-To: <1476360178-7452-1-git-send-email-menjo.takashi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
Cc: stgt <stgt@vger.kernel.org>, Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>

On Thu, Oct 13, 2016 at 9:02 PM, Takashi Menjo
<menjo.takashi@lab.ntt.co.jp> wrote:
> This commit lets the sheepdog driver reject forms of filename below.
> This is to avoid unintended deletion of working VDI when a snapshot is
> given as a LUN.
>
>  * unix:<path_of_unix_domain_socket>:<vdi>:<tag>
>  * unix:<path_of_unix_domain_socket>:<vdi>:<snapid>
>  * tcp:<host>:<port>:<vdi>:<tag>
>  * tcp:<host>:<port>:<vdi>:<snapid>
>
> In the case that a snapshot is given as a LUN by any of them above, the
> sheepdog driver attempts to delete it then create a new writable VDI when
> some data is being written to it. The deletion request contains name and
> VDI ID of the snapshot. However, sheep daemon uses its name but ignores
> VDI ID and, what is worse, the request contains neither snapshot ID nor
> tag. So sheep daemon receiving the request interprets it as deletion of
> working VDI, not snapshot. If there is working VDI with the same name,
> it will be deleted unintentionally.
>
> I decided not to fix the sheepdog driver to send snapshot ID or tag but
> to let it reject snapshot as a LUN because, even if I fix it, creating
> a new writable VDI will be failed when working VDI exists. If you want
> workaround, use "dog vdi clone" command to create a new writable VDI from
> snapshot then give the new VDI as a LUN.
>
> Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
> Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> Signed-off-by: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c | 112 +-----------------------------------------------------
>  1 file changed, 2 insertions(+), 110 deletions(-)

Acked-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Thanks,
Hitoshi

>
> diff --git a/usr/bs_sheepdog.c b/usr/bs_sheepdog.c
> index fc91ad1..f702c12 100644
> --- a/usr/bs_sheepdog.c
> +++ b/usr/bs_sheepdog.c
> @@ -273,9 +273,6 @@ struct sheepdog_access_info {
>         /* unix domain socket */
>         char uds_path[UNIX_PATH_MAX];
>
> -       /* if the opened VDI is a snapshot, write commands cannot be issued */
> -       int is_snapshot;
> -
>         /*
>          * maximum length of fd_list_head: nr_iothreads + 1
>          * (+ 1 is for main thread)
> @@ -1129,8 +1126,6 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
>         uint32_t vid = 0;
>         char *orig_filename;
>
> -       uint32_t snapid = -1;
> -       char tag[SD_MAX_VDI_TAG_LEN + 1];
>         char vdi_name[SD_MAX_VDI_LEN + 1];
>         char *saveptr = NULL, *result;
>         enum {
> @@ -1139,11 +1134,9 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
>                 EXPECT_HOST,
>                 EXPECT_PORT,
>                 EXPECT_VDI,
> -               EXPECT_TAG_OR_SNAP,
>                 EXPECT_NOTHING,
>         } parse_state = EXPECT_PROTO;
>
> -       memset(tag, 0, sizeof(tag));
>         memset(vdi_name, 0, sizeof(vdi_name));
>
>         orig_filename = strdup(filename);
> @@ -1156,11 +1149,7 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
>          * expected form of filename:
>          *
>          * unix:<path_of_unix_domain_socket>:<vdi>
> -        * unix:<path_of_unix_domain_socket>:<vdi>:<tag>
> -        * unix:<path_of_unix_domain_socket>:<vdi>:<snapid>
>          * tcp:<host>:<port>:<vdi>
> -        * tcp:<host>:<port>:<vdi>:<tag>
> -        * tcp:<host>:<port>:<vdi>:<snapid>
>          */
>
>         result = strtok_r(filename, ":", &saveptr);
> @@ -1205,21 +1194,6 @@ static int sd_open(struct sheepdog_access_info *ai, char *filename, int flags)
>                         break;
>                 case EXPECT_VDI:
>                         strncpy(vdi_name, result, SD_MAX_VDI_LEN);
> -                       parse_state = EXPECT_TAG_OR_SNAP;
> -                       break;
> -               case EXPECT_TAG_OR_SNAP:
> -                       len = strlen(result);
> -                       for (i = 0; i < len; i++) {
> -                               if (!isdigit(result[i])) {
> -                                       /* result is a tag */
> -                                       strncpy(tag, result,
> -                                               SD_MAX_VDI_TAG_LEN);
> -                                       goto trans_to_expect_nothing;
> -                               }
> -                       }
> -
> -                       snapid = atoi(result);
> -trans_to_expect_nothing:
>                         parse_state = EXPECT_NOTHING;
>                         break;
>                 case EXPECT_NOTHING:
> @@ -1235,8 +1209,7 @@ trans_to_expect_nothing:
>                 }
>         } while ((result = strtok_r(NULL, ":", &saveptr)) != NULL);
>
> -       if (parse_state != EXPECT_NOTHING &&
> -           parse_state != EXPECT_TAG_OR_SNAP) {
> +       if (parse_state != EXPECT_NOTHING) {
>                 eprintf("invalid VDI path of sheepdog: %s (state: %d)\n",
>                         orig_filename, parse_state);
>                 ret = -1;
> @@ -1269,15 +1242,8 @@ trans_to_expect_nothing:
>
>         close(fd);              /* we don't need this connection */
>
> -       if (snapid == -1)
> -               dprintf("tag: %s\n", tag);
> -       else
> -               dprintf("snapid: %d\n", snapid);
> -
>         dprintf("VDI name: %s\n", vdi_name);
> -       ai->is_snapshot = !(snapid == -1) || strlen(tag);
> -       ret = find_vdi_name(ai, vdi_name, snapid == -1 ? 0 : snapid, tag, &vid,
> -                           ai->is_snapshot);
> +       ret = find_vdi_name(ai, vdi_name, 0, "", &vid, 0);
>         if (ret)
>                 goto out;
>
> @@ -1326,69 +1292,6 @@ static void set_medium_error(int *result, uint8_t *key, uint16_t *asc)
>         *asc = ASC_READ_ERROR;
>  }
>
> -static int create_branch(struct sheepdog_access_info *ai)
> -{
> -       struct sheepdog_vdi_req hdr;
> -       struct sheepdog_vdi_rsp *rsp = (struct sheepdog_vdi_rsp *)&hdr;
> -       unsigned int wlen = 0, rlen;
> -       int ret, need_reload = 0;
> -
> -       ret = pthread_rwlock_wrlock(&ai->inode_lock);
> -       if (ret) {
> -               eprintf("failed to get inode lock %s\n", strerror(ret));
> -               return -1;
> -       }
> -
> -       if (!ai->is_snapshot)
> -               /* check again the snapshot flag to avoid race condition */
> -               goto out;
> -
> -       memset(&hdr, 0, sizeof(hdr));
> -       hdr.opcode = SD_OP_DEL_VDI;
> -       hdr.vdi_id = ai->inode.vdi_id;
> -       hdr.flags = SD_FLAG_CMD_WRITE;
> -       wlen = SD_MAX_VDI_LEN;
> -       rlen = 0;
> -       hdr.data_length = wlen;
> -
> -       ret = do_req(ai, (struct sheepdog_req *)&hdr, ai->inode.name,
> -                    &wlen, &rlen);
> -       if (ret) {
> -               eprintf("deleting snapshot VDI for creating branch failed\n");
> -               goto out;
> -       }
> -
> -       memset(&hdr, 0, sizeof(hdr));
> -       hdr.opcode = SD_OP_NEW_VDI;
> -       hdr.vdi_id = ai->inode.vdi_id;
> -
> -       hdr.flags = SD_FLAG_CMD_WRITE;
> -       wlen = SD_MAX_VDI_LEN;
> -       rlen = 0;
> -       hdr.data_length = wlen;
> -       hdr.vdi_size = ai->inode.vdi_size;
> -       ret = do_req(ai, (struct sheepdog_req *)&hdr, ai->inode.name,
> -                    &wlen, &rlen);
> -       if (ret) {
> -               eprintf("creating new VDI for creating branch failed\n");
> -               goto out;
> -       }
> -
> -       ret = read_object(ai, (char *)&ai->inode, vid_to_vdi_oid(rsp->vdi_id),
> -                         ai->inode.nr_copies, SD_INODE_SIZE, 0, &need_reload);
> -       if (ret) {
> -               eprintf("reloading new inode object failed");
> -               goto out;
> -       }
> -
> -       ai->is_snapshot = 0;
> -       dprintf("creating branch from snapshot, new VDI ID: %x\n", rsp->vdi_id);
> -out:
> -       pthread_rwlock_unlock(&ai->inode_lock);
> -
> -       return ret;
> -}
> -
>  struct inflight_thread {
>         unsigned long min_idx, max_idx;
>         struct list_head list;
> @@ -1453,17 +1356,6 @@ static void bs_sheepdog_request(struct scsi_cmd *cmd)
>         case WRITE_10:
>         case WRITE_12:
>         case WRITE_16:
> -               if (ai->is_snapshot) {
> -                       ret = create_branch(ai);
> -                       if (ret) {
> -                               eprintf("creating writable VDI from"\
> -                                       " snapshot failed\n");
> -                               set_medium_error(&result, &key, &asc);
> -
> -                               break;
> -                       }
> -               }
> -
>                 length = scsi_get_out_length(cmd);
>
>                 myself.min_idx = cmd->offset / object_size;
> --
> 2.7.4
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
