From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] Use ULLONG_MAX when checking for strtoull overflow
Date: Thu, 02 Jun 2016 11:11:15 +0900 (JST)
Message-ID: <20160602.111115.1898388363586166986.tomof@acm.org>
References: <1464081304-21761-1-git-send-email-apollon@skroutz.gr>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1464081304-21761-1-git-send-email-apollon@skroutz.gr>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: apollon@skroutz.gr
Cc: stgt@vger.kernel.org, stsp@users.sourceforge.net, ryan.harper@canonical.com, apoikos@debian.org

On Tue, 24 May 2016 12:15:04 +0300
Apollon Oikonomopoulos <apollon@skroutz.gr> wrote:

> From: Apollon Oikonomopoulos <apoikos@debian.org>
> 
> According to strtoull(3):
> 
>  [...] Precisely the same holds for strtoull() (with ULLONG_MAX instead
>  of ULONG_MAX).
> 
> Since we are using strtoull(3) and not strtoul(3), the check should be
> made against ULLONG_MAX. Note that at least on amd64 ULONG_MAX and
> ULLONG_MAX are the same, but this is not guaranteed to be the case for
> other architectures as well.
> 
> Signed-off-by: Apollon Oikonomopoulos <apoikos@debian.org>
> ---
>  usr/util.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks!
