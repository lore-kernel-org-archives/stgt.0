From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: backing-store modules directory not present is not an error
Date: Thu, 19 Nov 2015 09:43:47 +0900 (JST)
Message-ID: <20151119.094347.1568838937885751814.fujita.tomonori@lab.ntt.co.jp>
References: <56463BCF.6020001@suse.com>
	<20151114.214659.1568838937885775323.fujita.tomonori@lab.ntt.co.jp>
	<56492E47.2010108@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <56492E47.2010108@suse.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lduncan@suse.com
Cc: stgt@vger.kernel.org

On Sun, 15 Nov 2015 17:15:51 -0800
Lee Duncan <lduncan@suse.com> wrote:

> The backing-store modules directory, normally
> /usr/lib/tgt/backing-store, is not created, needed, or used when there
> are no backing store modules. So change the error message printed when
> the directory is not present to a debug message.
> 
> Signed-off-by: Lee Duncan <lduncan@suse.com>

Applied, thanks.
