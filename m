From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] trivial: support cscope in Makefile and gitignore
Date: Mon, 25 Nov 2013 04:29:57 +0900
Message-ID: <20131125040152Z.fujita.tomonori@lab.ntt.co.jp>
References: <1383013732-9345-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
	<87zjotyj3t.wl%mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <87zjotyj3t.wl%mitake.hitoshi@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@gmail.com
Cc: mitake.hitoshi@lab.ntt.co.jp, stgt@vger.kernel.org

On Sun, 24 Nov 2013 23:23:02 +0900
Hitoshi Mitake <mitake.hitoshi@gmail.com> wrote:

> At Tue, 29 Oct 2013 11:28:52 +0900,
> Hitoshi Mitake wrote:
> > 
> > After applying this patch, "make cscope" can generate cscope files for
> > tag jump. The generated files are ignored by the .gitignore file.
> > 
> > Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> > ---
> >  .gitignore |    3 ++-
> >  Makefile   |    5 +++++
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> ping? This is a trivial one, but would be useful for tgt developers.

Can you fix the following warning?

/home/fujita/git/tgt/.git/rebase-apply/patch:21: new blank line at
EOF.
+
warning: 1 line adds whitespace errors.

I don't fancy to add a particular source code tool stuff for Makefile
much though (I don't use cscope).
