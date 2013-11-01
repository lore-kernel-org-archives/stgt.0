From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: fix memory leak issues in sd_open()
Date: Fri, 1 Nov 2013 09:46:16 +0900
Message-ID: <20131101091948R.fujita.tomonori@lab.ntt.co.jp>
References: <1383208594-639-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1383208594-639-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: mitake.hitoshi@lab.ntt.co.jp, stgt@vger.kernel.org, sheepdog@lists.wpkg.org

On Thu, 31 Oct 2013 17:36:34 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> This fixes memory leak issues in sd_open function which were brought
> by the patch titled "bs_sheepdog.c: support various VDI options in
> --backing-store option" (commit:
> f282f83c036e298f316ef64d1e51aff3f57b9eaf).
> 
> The current sd_open function doesn't free locally allocated string
> "orig_filename" nor restores "filename" argument temporarily broken
> for parsing VDI options when unknown protocol was specified or tcp
> port number was malformed.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Applied.
