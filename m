From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] various update for sheepdog driver
Date: Sun, 06 Jul 2014 23:28:27 +0900 (JST)
Message-ID: <20140706.232827.1568838937885768742.fujita.tomonori@lab.ntt.co.jp>
References: <1404657032-17629-1-git-send-email-mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1404657032-17629-1-git-send-email-mitake.hitoshi@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@gmail.com
Cc: stgt@vger.kernel.org, sheepdog@lists.wpkg.org

On Sun,  6 Jul 2014 23:30:29 +0900
Hitoshi Mitake <mitake.hitoshi@gmail.com> wrote:

> This patchset contain some update for sheepdog driver. The most
> important one is the first patch. With this patch, iSCSI target with
> sheepdog virtual disk can enable caching feature of sheepdog.
> 
> Others are mainly for documenting purpose.
> 
> Hitoshi Mitake (3):
>   sheepdog: turn on cache flag of write request
>   sheepdog: update layout of inode object header
>   sheepdog: add documentation
> 
>  doc/README.sheepdog | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  usr/bs_sheepdog.c   |  29 +++++++++++++--
>  2 files changed, 126 insertions(+), 3 deletions(-)
>  create mode 100644 doc/README.sheepdog

Applied, thanks.
