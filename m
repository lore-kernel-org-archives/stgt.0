From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 1/2] fix memory leak in session.c
Date: Fri, 03 Jun 2016 07:51:36 +0900 (JST)
Message-ID: <20160603.075136.1305564732068185242.tomof@acm.org>
References: <1464851831-105676-1-git-send-email-li.feng@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1464851831-105676-1-git-send-email-li.feng@oracle.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: li.feng@oracle.com
Cc: stgt@vger.kernel.org, lifeng1519@gmail.com

On Thu,  2 Jun 2016 15:17:10 +0800
Feng Li <li.feng@oracle.com> wrote:

> From: Feng Li <lifeng1519@gmail.com>
> 
> Memory leaks when memory allocation fails.
> 
> Signed-off-by: Feng Li <lifeng1519@gmail.com>
> ---
>  usr/iscsi/session.c | 1 +
>  1 file changed, 1 insertion(+)

Nice catch, thanks!
