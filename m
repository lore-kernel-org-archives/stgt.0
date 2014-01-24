From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] Fix bs_rbd.c slurp_to_semi() not consuming
 terminating semicolon
Date: Fri, 24 Jan 2014 14:13:11 +0900 (JST)
Message-ID: <20140124.141311.1305564732068171074.fujita.tomonori@lab.ntt.co.jp>
References: <1390356859-7557-1-git-send-email-thomas@belton.co.nz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1390356859-7557-1-git-send-email-thomas@belton.co.nz>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: thomas@belton.co.nz, dan.mick@inktank.com
Cc: stgt@vger.kernel.org

CC'ed to Dan, the author of rbd support.

On Wed, 22 Jan 2014 15:14:18 +1300
Thomas Matysik <thomas@belton.co.nz> wrote:

> slurp_to_semi() would not consume the terminating semicolon on a
> option specified in --bsopts, so any options other than the first
> would be ignored as invalid.
> 
> Signed-off-by: Thomas Matysik <thomas@belton.co.nz>
> ---
>  usr/bs_rbd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/usr/bs_rbd.c b/usr/bs_rbd.c
> index 3ea9d36..f797fd5 100644
> --- a/usr/bs_rbd.c
> +++ b/usr/bs_rbd.c
> @@ -480,6 +480,9 @@ static char *slurp_to_semi(char **p)
>  	strncpy(ret, *p, len);
>  	ret[len] = '\0';
>  	*p = end;
> +	// Jump past the semicolon, if we stopped at one
> +	if (**p == ';')
> +		*p = end + 1;
>  	return ret;
>  }
>  
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
