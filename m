From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] tgtadm: add missing outgoing option to the help of
 unbind operation
Date: Thu, 7 Nov 2013 16:07:49 +0900
Message-ID: <20131107153957W.fujita.tomonori@lab.ntt.co.jp>
References: <1383674359-11389-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1383674359-11389-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org

On Wed,  6 Nov 2013 02:59:19 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> The help message of bind operation explains that --outgoing option is
> used for an outgoing account:
> 
> --lld <driver> --mode account --op bind --tid <id> --user <name> [--outgoing]
>       add the specific account having <name> to
>       the specific target with <id>.
>       <user> could be <IncomingUser> or <OutgoingUser>.
>       If you use --outgoing option, the account will
>       be added as an outgoing account.
> 
> However, the help message of unbind operation lacks the --outgoing
> option even though it is mandatory to delete outgoing account:
> 
> --lld <driver> --mode account --op unbind --tid <id> --user <name>
>       delete the specific account having <name> from specific
>       target.
> 
> Thus, users will see the following error since they don't know the
> --outgoing option is needed:
> 
>   "tgtadm: can't find the account"
> 
> This fixes the issue by adding description of the outgoing option also
> to the help message of unbind operation.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/tgtadm.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Applied, thanks!
