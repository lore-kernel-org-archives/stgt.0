From: Roi Dayan <roid@mellanox.com>
Subject: RE: [PATCH] iser: fix local conn params being reset to default
Date: Wed, 29 Oct 2014 07:49:16 +0000
Message-ID: <1ff1b4256acf4eaf99193be5a1a5c141@AM3PR05MB433.eurprd05.prod.outlook.com>
References: <1414510866-14770-1-git-send-email-roid@mellanox.com>
 <5450807F.7020200@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "stgt@vger.kernel.org" <stgt@vger.kernel.org>

"they" is referred to the user. I'll make it more informative next time.



-----Original Message-----
From: Roi Dayan 
Sent: Wednesday, October 29, 2014 8:37 AM
To: Or Gerlitz
Cc: fujita.tomonori@lab.ntt.co.jp; stgt@vger.kernel.org
Subject: RE: [PATCH] iser: fix local conn params being reset to default

Local params:

MaxXmitDataSegmentLength
MaxQueueCmd





-----Original Message-----
From: Or Gerlitz
Sent: Wednesday, October 29, 2014 7:52 AM
To: Roi Dayan
Cc: fujita.tomonori@lab.ntt.co.jp; stgt@vger.kernel.org
Subject: Re: [PATCH] iser: fix local conn params being reset to default

On 10/28/2014 5:41 PM, Roi Dayan wrote:
> Instead of reseting the params to default if they pass it we should 
> reset to max if they pass it.

who are they? can you remind me what are the local params?

Or.

>
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>   usr/iscsi/iser_text.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/usr/iscsi/iser_text.c b/usr/iscsi/iser_text.c index
> 8180dbc..b8c5136 100644
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
