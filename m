From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH] iser: fix local conn params being reset to default
Date: Wed, 29 Oct 2014 07:51:59 +0200
Message-ID: <5450807F.7020200@mellanox.com>
References: <1414510866-14770-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1414510866-14770-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roi Dayan <roid@mellanox.com>
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org

On 10/28/2014 5:41 PM, Roi Dayan wrote:
> Instead of reseting the params to default if they pass it
> we should reset to max if they pass it.

who are they? can you remind me what are the local params?

Or.

>
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>   usr/iscsi/iser_text.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/usr/iscsi/iser_text.c b/usr/iscsi/iser_text.c
> index 8180dbc..b8c5136 100644
> --- a/usr/iscsi/iser_text.c
> +++ b/usr/iscsi/iser_text.c
> @@ -342,8 +342,8 @@ static int iser_login_check_params(struct iscsi_connection *iscsi_conn,
>   		if (p[i].state == KEY_STATE_START && p[i].val != session_keys[i].def) {
>   			if (iscsi_conn->state == STATE_LOGIN) {
>   				if (i >= ISCSI_PARAM_FIRST_LOCAL) {
> -					if (p[i].val > session_keys[i].def)
> -						p[i].val = session_keys[i].def;
> +					if (p[i].val > session_keys[i].max)
> +						p[i].val = session_keys[i].max;
>   					p[i].state = KEY_STATE_DONE;
>   					continue;
>   				}
