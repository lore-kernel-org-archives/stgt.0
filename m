From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Fix segfault if device_type set to pt but bstype not
 sg or bsg
Date: Sat, 22 Mar 2014 20:57:26 +0900
Message-ID: <20140322205213U.fujita.tomonori@lab.ntt.co.jp>
References: <1395165722-25402-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1395165722-25402-1-git-send-email-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: agrover@redhat.com
Cc: stgt@vger.kernel.org

On Tue, 18 Mar 2014 11:02:02 -0700
Andy Grover <agrover@redhat.com> wrote:

> If bstype not set to sg or bsg, it will default to rdwr, and we will
> call target_cmd_perform instead of target_cmd_perform_passthrough when
> accessing the device, which crashes tgtd. There's an existing check for
> setting bstype without setting dev_type, but also add a check the other
> way, setting dev_type without setting bstype to a valid value for pt.
> 
> Add an error message to the existing check, as well.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  usr/target.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Applied, thanks a lot!
