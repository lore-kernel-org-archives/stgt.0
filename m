From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] Add support for gluster backing store
Date: Sun, 16 Mar 2014 22:41:00 +0900
Message-ID: <20140316223630T.fujita.tomonori@lab.ntt.co.jp>
References: <1394832590-12397-1-git-send-email-dlambrig@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1394832590-12397-1-git-send-email-dlambrig@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dlambrig@redhat.com
Cc: stgt@vger.kernel.org

On Fri, 14 Mar 2014 17:29:50 -0400
Dan Lambright <dlambrig@redhat.com> wrote:

> Gluster is a distributed file system (www.gluster.org). The
> backing store gives block access protocols such as iSCSI
> access to data within gluster.
> 
> Gluster data resides on volumes which are physically located
> on servers. A "LUN" is represented by a file within
> a volume. To specify which file to use:
> 
> --bstype=glfs
> --backing-store="volume@hostname:filename"
> 
> Optionally, logs may be specified. See README.glfs
> 
> All I/Os are synchronous.  This is based off the rdrw and
> rbd backend storage drivers.
> 
> Signed-off-by: Dan Lambright <dlambrig@redhat.com>
> 
> Fix stylistic errors
> ---
>  Makefile        |   1 +
>  doc/README.glfs |  50 +++++
>  usr/Makefile    |   7 +
>  usr/bs_glfs.c   | 558 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 616 insertions(+)
>  create mode 100644 doc/README.glfs
>  create mode 100644 usr/bs_glfs.c

Applied, thanks a lot!
