From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] targets.conf manpage should not refer to Wikipedia
Date: Wed, 20 Jan 2016 19:11:50 +0900 (JST)
Message-ID: <20160120.191150.1545942096518973548.fujita.tomonori@lab.ntt.co.jp>
References: <1453224533-10049-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1453224533-10049-1-git-send-email-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: agrover@redhat.com
Cc: stgt@vger.kernel.org

On Tue, 19 Jan 2016 09:28:53 -0800
Andy Grover <agrover@redhat.com> wrote:

> Man pages should not assume the user has network access to reach
> Wikipedia for more information -- if the information is important they
> should just include it directly. In this instance, I don't think
> this info is important enough, and we should just remove the
> reference.
> 
> See https://bugzilla.redhat.com/show_bug.cgi?id=1038326 for the
> original bug report.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  doc/targets.conf.5.xml | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied, thanks.

