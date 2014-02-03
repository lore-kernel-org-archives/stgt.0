From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] iser: Fix discovery over iser on non default port
Date: Tue, 04 Feb 2014 06:07:55 +0900 (JST)
Message-ID: <20140204.060755.1568838937885756493.fujita.tomonori@lab.ntt.co.jp>
References: <1391443057-21148-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1391443057-21148-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: stgt@vger.kernel.org

On Mon,  3 Feb 2014 17:57:37 +0200
Roi Dayan <roid@mellanox.com> wrote:

> Build the target list with the socket port instead of
> using ISCSI_LISTEN_PORT.
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  usr/iscsi/iser_text.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)

Applied, thanks.
