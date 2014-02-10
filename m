From: Dan Mick <dan.mick@inktank.com>
Subject: Re: [PATCH 1/2] Fix bs_rbd.c slurp_to_semi() not consuming terminating
 semicolon
Date: Mon, 10 Feb 2014 14:12:06 -0800
Message-ID: <52F94EB6.3030701@inktank.com>
References: <1390356859-7557-1-git-send-email-thomas@belton.co.nz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1390356859-7557-1-git-send-email-thomas@belton.co.nz>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Thomas Matysik <thomas@belton.co.nz>, stgt@vger.kernel.org

Reviewed-by: Dan Mick <dan.mick@inktank.com>

On 01/21/2014 06:14 PM, Thomas Matysik wrote:
> slurp_to_semi() would not consume the terminating semicolon on a
> option specified in --bsopts, so any options other than the first
> would be ignored as invalid.
>
> Signed-off-by: Thomas Matysik <thomas@belton.co.nz>
> ---
>   usr/bs_rbd.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/usr/bs_rbd.c b/usr/bs_rbd.c
> index 3ea9d36..f797fd5 100644
> --- a/usr/bs_rbd.c
> +++ b/usr/bs_rbd.c
> @@ -480,6 +480,9 @@ static char *slurp_to_semi(char **p)
>   	strncpy(ret, *p, len);
>   	ret[len] = '\0';
>   	*p = end;
> +	// Jump past the semicolon, if we stopped at one
> +	if (**p == ';')
> +		*p = end + 1;
>   	return ret;
>   }
>
>
