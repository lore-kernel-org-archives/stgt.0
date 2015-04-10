From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/3] tgtd.c: allow oom adjust failures for non-root
 users
Date: Fri, 10 Apr 2015 16:21:34 +0900 (JST)
Message-ID: <20150410.162134.1568838937885785413.fujita.tomonori@lab.ntt.co.jp>
References: <1428432034-28682-1-git-send-email-ronniesahlberg@gmail.com>
	<1428432034-28682-2-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1428432034-28682-2-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org

On Tue,  7 Apr 2015 11:40:32 -0700
Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:

> If run as non-root, allow failure to adjust the oom settings for
> the process without aborting.
> 
> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> ---
>  usr/tgtd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Is there use cases for allowing non root users to run tgtd?

Anyway, I guess that it's not a bad thing. Applied the whole patchset.
