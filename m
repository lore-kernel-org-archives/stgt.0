From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Patch for adding virsecretuuid & cephx_key ids to --bsopts
Date: Wed, 18 Jun 2014 00:30:51 +0900 (JST)
Message-ID: <20140618.003051.1898388363586164151.fujita.tomonori@lab.ntt.co.jp>
References: <53A0394A.6090208@liquidweb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <53A0394A.6090208@liquidweb.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ssullivan@liquidweb.com, dan.mick@inktank.com
Cc: stgt@vger.kernel.org

Added Dan to To:

On Tue, 17 Jun 2014 08:49:14 -0400
Scott Sullivan <ssullivan@liquidweb.com> wrote:

> Hello,
> 
> Below is a patch that adds two new params to --bsopts for RBD backing
> stores (virsecretuuid & cephx_key). This was very useful for me, since
> it is nice to be able to give the required authentication detail in
> the same place as the id. I have tested and both options work, as well
> as the error condition if both options are given (made them conflict).
> 
> I have verified the patch passes scripts/checkpatch.pl style
> guidelines. Is there any interest in applying this patch? Im using
> this internally with success; for us at least this is a desirable
> thing to have.
> 
> 
> From 5359b581c5e7bf434979becaefc53a711ef88432 Mon Sep 17 00:00:00 2001
> From: Scott Sullivan <ssullivan@liquidweb.com>
> Date: Tue, 17 Jun 2014 08:16:09 -0400
> Subject: [PATCH] bsopts: Add virsecretuuid && cephx_key
> 
> Allow passing either a libvirt secret UUID, or a cephx_key to
> --bsopts. Options are
> conflicting, so error if both options given. This allows one to do
> this:
> 
> --bsopts="conf=/etc/ceph/ceph.conf;id=cephx_user;virsecretuuid=$MY_LIBVIRT_SECRET_UUID"
> -OR-
> --bsopts="conf=/etc/ceph/ceph.conf;id=cephx_user;cephx_key=$MY_KEY"
> 
> Signed-off-by: Scott Sullivan <ssullivan@liquidweb.com>
> ---
>  usr/bs_rbd.c | 64
>  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/usr/bs_rbd.c b/usr/bs_rbd.c
> index 3a052ed..86857b9 100644
> --- a/usr/bs_rbd.c
> +++ b/usr/bs_rbd.c
> @@ -517,6 +517,9 @@ static tgtadm_err bs_rbd_init(struct scsi_lu *lu,
> char *bsopts)
>      struct active_rbd *rbd = RBDP(lu);
>      char *confname = NULL;
>      char *clientid = NULL;
> +    char *virsecretuuid = NULL;
> +    char *given_cephx_key = NULL;
> +    char disc_cephx_key[256];
>      char *clustername = NULL;
>      char clientid_full[128];
>      char *ignore = NULL;
> @@ -532,6 +535,10 @@ static tgtadm_err bs_rbd_init(struct scsi_lu *lu,
> char *bsopts)
>              clientid = slurp_value(&bsopts);
>          else if (is_opt("cluster", bsopts))
>              clustername = slurp_value(&bsopts);
> +        else if (is_opt("virsecretuuid", bsopts))
> +            virsecretuuid = slurp_value(&bsopts);
> +        else if (is_opt("cephx_key", bsopts))
> +            given_cephx_key = slurp_value(&bsopts);
>          else {
>              ignore = slurp_to_semi(&bsopts);
>              eprintf("bs_rbd: ignoring unknown option \"%s\"\n",
> @@ -547,6 +554,41 @@ static tgtadm_err bs_rbd_init(struct scsi_lu *lu,
> char *bsopts)
>          eprintf("bs_rbd_init: confname %s\n", confname);
>      if (clustername)
>          eprintf("bs_rbd_init: clustername %s\n", clustername);
> +    if (virsecretuuid)
> +        eprintf("bs_rbd_init: virsecretuuid %s\n", virsecretuuid);
> +    if (given_cephx_key)
> + eprintf("bs_rbd_init: given_cephx_key %s\n", given_cephx_key);
> +
> +    /* virsecretuuid && given_cephx_key are conflicting options. */
> +    if (virsecretuuid && given_cephx_key) {
> + eprintf("Conflicting options virsecretuuid=[%s] cephx_key=[%s]",
> +            virsecretuuid, given_cephx_key);
> +        goto fail;
> +    }
> +
> +    /* Get stored key from secret uuid. */
> +    if (virsecretuuid) {
> + char libvir_uuid_file_path_buf[256] = "/etc/libvirt/secrets/";
> +        strcat(libvir_uuid_file_path_buf, virsecretuuid);
> +        strcat(libvir_uuid_file_path_buf, ".base64");
> +
> +        FILE *fp;
> +        fp = fopen(libvir_uuid_file_path_buf , "r");
> +        if (fp == NULL) {
> +            eprintf("bs_rbd_init: Unable to read %s\n",
> +                libvir_uuid_file_path_buf);
> +            goto fail;
> +        }
> +        if (fgets(disc_cephx_key, 256, fp) == NULL) {
> +            eprintf("bs_rbd_init: Unable to read %s\n",
> +                libvir_uuid_file_path_buf);
> +            goto fail;
> +        }
> +        fclose(fp);
> +        strtok(disc_cephx_key, "\n");
> +
> +        eprintf("bs_rbd_init: disc_cephx_key %s\n", disc_cephx_key);
> +    }
> 
>      eprintf("bs_rbd_init bsopts=%s\n", bsopts);
>      /*
> @@ -570,6 +612,7 @@ static tgtadm_err bs_rbd_init(struct scsi_lu *lu,
> char *bsopts)
>          eprintf("bs_rbd_init: rados_create: %d\n", rados_ret);
>          return ret;
>      }
> +
>      /*
>       * Read config from environment, then conf file(s) which may
>       * be set by conf=
> @@ -584,6 +627,23 @@ static tgtadm_err bs_rbd_init(struct scsi_lu *lu,
> char *bsopts)
>          eprintf("bs_rbd_init: rados_conf_read_file: %d\n", rados_ret);
>          goto fail;
>      }
> +
> +    /* Set given key */
> +    if (virsecretuuid) {
> + if (rados_conf_set(rbd->cluster, "key", disc_cephx_key) < 0) {
> +            eprintf("bs_rbd_init: failed to set cephx_key: %s\n",
> +                disc_cephx_key);
> +            goto fail;
> +        }
> +    }
> +    if (given_cephx_key) {
> + if (rados_conf_set(rbd->cluster, "key", given_cephx_key) < 0) {
> +            eprintf("bs_rbd_init: failed to set cephx_key: %s\n",
> +                given_cephx_key);
> +            goto fail;
> +        }
> +    }
> +
>      rados_ret = rados_connect(rbd->cluster);
>      if (rados_ret < 0) {
>          eprintf("bs_rbd_init: rados_connect: %d\n", rados_ret);
> @@ -595,6 +655,10 @@ fail:
>          free(confname);
>      if (clientid)
>          free(clientid);
> +    if (virsecretuuid)
> +        free(virsecretuuid);
> +    if (given_cephx_key)
> +        free(given_cephx_key);
> 
>      return ret;
>  }
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
