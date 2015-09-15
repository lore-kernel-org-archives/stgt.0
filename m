From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Add WRITE_ATOMIC_16 support
Date: Tue, 15 Sep 2015 18:54:32 +0900 (JST)
Message-ID: <20150915.185432.653026525707333816.fujita.tomonori@lab.ntt.co.jp>
References: <1441824235-7724-1-git-send-email-ronniesahlberg@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1441824235-7724-1-git-send-email-ronniesahlberg@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org

On Wed,  9 Sep 2015 11:43:54 -0700
Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:

> Please find attached a patch that adds support for the new opcode
> WRITE_ATOMIC_16 to the bs_rdwr backend.
> 
> I try to make it as atomic as possible by using mmap and mlock to ensure that
> both the write buffer and the file region we are writing to will be all
> present and locked down in memory before I just memcpy() the data.
> At that stage it is then assumed that the memcpy() will never fail short.

But it's still possible that the data written to the underlying file
system in 'non-atomic' manner in the case of linux kernel crash or
such?
