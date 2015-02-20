From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Fix libs for current systemd linker name
Date: Sat, 21 Feb 2015 07:29:00 +0900 (JST)
Message-ID: <20150221.072900.1568838937885782391.fujita.tomonori@lab.ntt.co.jp>
References: <1423605328-25931-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1423605328-25931-1-git-send-email-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: agrover@redhat.com
Cc: stgt@vger.kernel.org

On Tue, 10 Feb 2015 13:55:28 -0800
Andy Grover <agrover@redhat.com> wrote:

> Systemd versions since 210 (Feb 2014) have merged libsystemd-daemon into
> libsystemd.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  usr/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks a lot!
