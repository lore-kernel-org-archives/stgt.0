From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] tgtd: protect socket for management IPC with lockf(3)
Date: Fri, 1 Nov 2013 10:04:41 +0900
Message-ID: <20131101093942T.fujita.tomonori@lab.ntt.co.jp>
References: <1383013275-8969-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1383013275-8969-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, mitake.hitoshi@gmail.com

On Tue, 29 Oct 2013 11:21:15 +0900
Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp> wrote:

> If two or more tgtds are launched with same control port (a number
> specified with -C option), tgtadm cannot communicate with tgtds
> because the latest tgtd cominates the socket. This behavior is
> confusing.
> 
> This patch lets tgtd lock the socket with lockf(3). With this change,
> tgtd will exits when the socket of its control port is already locked.
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/mgmt.c |   36 +++++++++++++++++++++++++++++-------
>  usr/tgtd.c |    6 +++---
>  2 files changed, 32 insertions(+), 10 deletions(-)

Make sense. Applied.
