From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Remove unneeded pthread_cond_broadcast
Date: Thu, 1 May 2014 05:56:51 +0900
Message-ID: <20140501054707G.fujita.tomonori@lab.ntt.co.jp>
References: <1398877221-26278-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1398877221-26278-1-git-send-email-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: agrover@redhat.com
Cc: stgt@vger.kernel.org

On Wed, 30 Apr 2014 10:00:21 -0700
Andy Grover <agrover@redhat.com> wrote:

> Previous patchset neglected to remove a now unneeded call.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  usr/bs.c | 2 --
>  1 file changed, 2 deletions(-)

Nice. Yeah, we don't need anymore. Applied, thanks.
