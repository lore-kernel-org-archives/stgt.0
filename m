From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] Fix compiler error in tgtd.c call_program
Date: Sun, 04 Jun 2017 08:30:12 +0900 (JST)
Message-ID: <20170604.083012.1545942096518956291.tomof@acm.org>
References: <20170603213359.16089-1-agrover@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20170603213359.16089-1-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: agrover@redhat.com
Cc: stgt@vger.kernel.org

On Sat,  3 Jun 2017 14:33:59 -0700
Andy Grover <agrover@redhat.com> wrote:

> Using a newer version of gcc, we see an error:
> 
> tgtd.c:313:14: error: comparison between pointer and zero character
>  constant [-Werror=pointer-compare]
>    while (pos != '\0')
>               ^~
> tgtd.c:313:10: note: did you mean to dereference the pointer?
>    while (pos != '\0')
>           ^
> I think gcc is right, so deref pos.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  usr/tgtd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good, applied. Thanks!
