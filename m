From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] Enable tgt-admin to bring up Gluster backing stores
Date: Wed, 06 Apr 2016 05:49:27 +0900 (JST)
Message-ID: <20160406.054927.1305564732068158670.tomof@acm.org>
References: <1459809134-17751-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1459809134-17751-1-git-send-email-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: agrover@redhat.com
Cc: stgt@vger.kernel.org, nathan@bravenet.com

On Mon,  4 Apr 2016 15:32:14 -0700
Andy Grover <agrover@redhat.com> wrote:

> As reported in:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1323356
> 
> tgt-admin needs a small change to properly bring up Gluster glfs
> backing stores, which do not have an associated local block device.
> 
> Reported-by: Nathan Coulson <nathan@bravenet.com>
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  scripts/tgt-admin | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks!
