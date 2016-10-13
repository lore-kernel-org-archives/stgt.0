From: "Takashi Menjo" <menjo.takashi@lab.ntt.co.jp>
Subject: RE: [PATCH] sheepdog: reject snapshot as a LUN to avoid deleting working VDI
Date: Thu, 13 Oct 2016 18:51:02 +0900
Message-ID: <001901d22537$4f1e23d0$ed5a6b70$@lab.ntt.co.jp>
References: <1476348544-7600-1-git-send-email-menjo.takashi@lab.ntt.co.jp> <20161013.181513.1568838937885757326.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20161013.181513.1568838937885757326.fujita.tomonori@lab.ntt.co.jp>
Content-Language: ja
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org
Cc: ishizaki.teruaki@lab.ntt.co.jp, mitake.hitoshi@lab.ntt.co.jp, 'FUJITA Tomonori' <fujita.tomonori@lab.ntt.co.jp>

Dear Tomonori,

> Hmm, why my Signed-off-by is here?
> 
> Anyway, I'll wait for an ACK from one of the guys listed above.

I'm very sorry but it seems I made a mistake when copy-and-paste addresses
from other commit log. I'll fix the commit log then resend the patch as v2.

Best regards,
Takashi


> -----Original Message-----
> From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
> Sent: Thursday, October 13, 2016 6:15 PM
> To: menjo.takashi@lab.ntt.co.jp
> Cc: stgt@vger.kernel.org; ishizaki.teruaki@lab.ntt.co.jp;
> mitake.hitoshi@lab.ntt.co.jp
> Subject: Re: [PATCH] sheepdog: reject snapshot as a LUN to avoid deleting
> working VDI
> 
> On Thu, 13 Oct 2016 17:49:04 +0900
> Takashi Menjo <menjo.takashi@lab.ntt.co.jp> wrote:
> 
> > This commit lets the sheepdog driver reject forms of filename below.
> > This is to avoid unintended deletion of working VDI when a snapshot is
> > given as a LUN.
> >
> >  * unix:<path_of_unix_domain_socket>:<vdi>:<tag>
> >  * unix:<path_of_unix_domain_socket>:<vdi>:<snapid>
> >  * tcp:<host>:<port>:<vdi>:<tag>
> >  * tcp:<host>:<port>:<vdi>:<snapid>
> >
> > In the case that a snapshot is given as a LUN by any of them above, the
> > sheepdog driver attempts to delete it then create a new writable VDI
when
> > some data is being written to it. The deletion request contains name and
> > VDI ID of the snapshot. However, sheep daemon uses its name but ignores
> > VDI ID and, what is worse, the request contains neither snapshot ID nor
> > tag. So sheep daemon receiving the request interprets it as deletion of
> > working VDI, not snapshot. If there is working VDI with the same name,
> > it will be deleted unintentionally.
> >
> > I decided not to fix the sheepdog driver to send snapshot ID or tag but
> > to let it reject snapshot as a LUN because, even if I fix it, creating
> > a new writable VDI will be failed when working VDI exists. If you want
> > workaround, use "dog vdi clone" command to create a new writable VDI
from
> > snapshot then give the new VDI as a LUN.
> >
> > Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
> > Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> > Signed-off-by: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Hmm, why my Signed-off-by is here?
> 
> Anyway, I'll wait for an ACK from one of the guys listed above.
> 



