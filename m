From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Bug: "could not open backing-store directory:
 /usr/lib/tgt/backing-store" message at startup
Date: Sat, 14 Nov 2015 21:46:59 +0900 (JST)
Message-ID: <20151114.214659.1568838937885775323.fujita.tomonori@lab.ntt.co.jp>
References: <56463BCF.6020001@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <56463BCF.6020001@suse.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lduncan@suse.com
Cc: stgt@vger.kernel.org

Hi,

On Fri, 13 Nov 2015 20:36:47 +0100
Lee Duncan <lduncan@suse.com> wrote:

> It seems like the "right" way to fix it would be change this code to not
> consider this case an error -- perhaps just a debugging message?

Sounds reasonable to me. Can you send a patch?

Thanks,
