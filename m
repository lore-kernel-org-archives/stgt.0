From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: iscsi: Move two messages to be logged as debug and not as
 errors
Date: Wed, 26 Feb 2014 17:15:19 +0900 (JST)
Message-ID: <20140226.171519.1568838937885769634.fujita.tomonori@lab.ntt.co.jp>
References: <1393332838-12900-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1393332838-12900-1-git-send-email-ogerlitz@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ogerlitz@mellanox.com
Cc: stgt@vger.kernel.org, Dennis.Cullison@Teradata.com

On Tue, 25 Feb 2014 14:53:58 +0200
Or Gerlitz <ogerlitz@mellanox.com> wrote:

> Move two messages which are printed when connections are close from error
> to debug level.
> 
> Without this change, a message currently gets logged every time an automatic
> discovery process runs on the initiator node when using the discovery database.
> When using multiple Control Ports, there are a lot of messages getting logged.
> These essentially flood the /var/log/messages file on the initiator.
> 
> Signed-off-by: Dennis Cullison <Dennis.Cullison@Teradata.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> ---
>  usr/iscsi/conn.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.
