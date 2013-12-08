From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] trivial: support cscope in Makefile and gitignore
Date: Sun, 8 Dec 2013 21:06:53 +0900
Message-ID: <20131208203752X.fujita.tomonori@lab.ntt.co.jp>
References: <1386490038-28488-1-git-send-email-mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1386490038-28488-1-git-send-email-mitake.hitoshi@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@gmail.com
Cc: stgt@vger.kernel.org, mitake.hitoshi@lab.ntt.co.jp

On Sun,  8 Dec 2013 17:07:18 +0900
Hitoshi Mitake <mitake.hitoshi@gmail.com> wrote:

> From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> 
> After applying this patch, "make cscope" can generate cscope files for
> tag jump. The generated files are ignored by the .gitignore file.
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  .gitignore | 3 ++-
>  Makefile   | 4 ++++
>  2 files changed, 6 insertions(+), 1 deletion(-)

Applied.
