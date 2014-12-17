From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sheepdog: support for variable object size
Date: Wed, 17 Dec 2014 10:16:28 +0900 (JST)
Message-ID: <20141217.101628.1898388363586161489.fujita.tomonori@lab.ntt.co.jp>
References: <1418727699-23585-1-git-send-email-ishizaki.teruaki@lab.ntt.co.jp>
	<87bnn3w046.wl%mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <87bnn3w046.wl%mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@lab.ntt.co.jp
Cc: ishizaki.teruaki@lab.ntt.co.jp, stgt@vger.kernel.org

On Wed, 17 Dec 2014 10:12:09 +0900
Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp> wrote:

> At Tue, 16 Dec 2014 20:01:39 +0900,
> Teruaki Ishizaki wrote:
>> 
>> Previously, Sheepdog VDI's object size was fixed to 4MB.
>> This patch enables to handle variable object size of Sheepdog VDI.
>> 
>> Signed-off-by: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
>> ---
>>  usr/bs_sheepdog.c |   14 ++++++++------
>>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> Looks good to me.
> Reviewed-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Applied, thanks guys!
