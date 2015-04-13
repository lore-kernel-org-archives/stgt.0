From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] mgmt: Create ipc socket parent dir if does not exists
Date: Mon, 13 Apr 2015 14:56:21 +0900 (JST)
Message-ID: <20150413.145621.1281009750676940031.fujita.tomonori@lab.ntt.co.jp>
References: <1428851466-22084-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1428851466-22084-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: stgt@vger.kernel.org

On Sun, 12 Apr 2015 18:11:06 +0300
Roi Dayan <roid@mellanox.com> wrote:

> If the parent dir doesn't exists then tgtd will fail to create the
> socket and exit.
> This commit will check if the folder doesn't exists and create it.
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  usr/mgmt.c   | 5 +++++
>  usr/tgtadm.h | 3 ++-
>  2 files changed, 7 insertions(+), 1 deletion(-)

Looks good. Thanks!
