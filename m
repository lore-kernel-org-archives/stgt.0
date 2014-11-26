From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Little bug in STGT
Date: Wed, 26 Nov 2014 13:51:05 +0900 (JST)
Message-ID: <20141126.135105.1568838937885770687.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.1411251809010.24756@cube>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1411251809010.24756@cube>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: borg@uu3.net
Cc: stgt@vger.kernel.org, yamada.hideki@lab.ntt.co.jp, konishi.ryusuke@lab.ntt.co.jp

Hi,

On Tue, 25 Nov 2014 18:13:27 +0100 (CET)
borg@uu3.net wrote:

> Sorry for writing directly, but this tiny typo is not
> worth the effort of subscribing.
> It prevents a deletion of entry from iqn_acl.

Thanks a lot! Applied.

You can post anything to the mailing list without subscribing.

> Regards,
> Borg
> 
> 
> diff --git a/usr/mgmt.c b/usr/mgmt.c
> index 1eae0c9..3587f4b 100644
> --- a/usr/mgmt.c
> +++ b/usr/mgmt.c
> @@ -152,7 +152,7 @@ static tgtadm_err target_mgmt(int lld_no, struct
> mgmt_task *
> mtask)
>  p = strstr(mtask->req_buf, "initiator-name=");
>  if (p) {
>         p += strlen("initiator-name=");
> -       adm_err = iqn_acl_del(req->tid, p + strlen("initiator-name="));
> +       adm_err = iqn_acl_del(req->tid, p);
>         if (adm_err != TGTADM_SUCCESS) {
>                 eprintf("Failed to unbind by name: %s\n", p);
>                 break;
> 
