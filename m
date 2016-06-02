From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Resend [PATCH 2/2] convert scsi_cmnd.h macro to normal
 functions
Date: Fri, 03 Jun 2016 07:54:27 +0900 (JST)
Message-ID: <20160603.075427.1545942096518976934.tomof@acm.org>
References: <1464851831-105676-1-git-send-email-li.feng@oracle.com>
	<1464851831-105676-2-git-send-email-li.feng@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1464851831-105676-2-git-send-email-li.feng@oracle.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: li.feng@oracle.com
Cc: stgt@vger.kernel.org, lifeng1519@gmail.com

On Thu,  2 Jun 2016 15:17:11 +0800
Feng Li <li.feng@oracle.com> wrote:

> From: Feng Li <lifeng1519@gmail.com>
> 
> When I read this code, I found it's hard to understand about these macros.
> I hardly find where are the definitions of some functions.
> Therefore, I expand them to normal functions for convience.
> 
> Signed-off-by: Feng Li <lifeng1519@gmail.com>
> ---
>  usr/scsi_cmnd.h | 298 ++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 170 insertions(+), 128 deletions(-)

Sorry, I'm not inclined to apply this.

I agree that it's hard to understand these macros however it has been
working. Also it's unlikely that we would need to change them
frequently. So I want to avoid change the working code just for
readability.
