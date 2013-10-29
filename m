From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_rbd.c: accept and parse bsopts
Date: Tue, 29 Oct 2013 09:17:24 +0900 (JST)
Message-ID: <20131029.091724.1898388363586168453.fujita.tomonori@lab.ntt.co.jp>
References: <1383005974-16499-1-git-send-email-dan.mick@inktank.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1383005974-16499-1-git-send-email-dan.mick@inktank.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dan.mick@inktank.com
Cc: stgt@vger.kernel.org

On Mon, 28 Oct 2013 17:19:34 -0700
Dan Mick <dan.mick@inktank.com> wrote:

> Options are supplied as one string, "key1=val1;key2=val2;" etc.
> 
> Legal options:
>     conf=<conffile>
>     id=<clientid>
> 
> For example, --bsopts "conf=/usr/local/ceph/ceph.conf;id=stgt"
> (quoting is necessary to protect ; from the shell)
> 
> Unknown options are skipped.
> 
> Signed-off-by: Dan Mick <dan.mick@inktank.com>
> ---
>  usr/bs_rbd.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 80 insertions(+), 6 deletions(-)

Applied.
