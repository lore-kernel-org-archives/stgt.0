From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Add WRITE_ATOMIC_16 support
Date: Wed, 23 Sep 2015 12:16:16 +0900 (JST)
Message-ID: <20150923.121616.1568838937885768056.fujita.tomonori@lab.ntt.co.jp>
References: <1441824235-7724-1-git-send-email-ronniesahlberg@gmail.com>
	<20150915.185432.653026525707333816.fujita.tomonori@lab.ntt.co.jp>
	<CAN05THQU-N5Twu4Oi5BsxTa+3XaaAkwcotJNZmzu7mJkSDQxAA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAN05THQU-N5Twu4Oi5BsxTa+3XaaAkwcotJNZmzu7mJkSDQxAA@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ronniesahlberg@gmail.com
Cc: stgt@vger.kernel.org

On Wed, 16 Sep 2015 12:49:14 -0700
ronnie sahlberg <ronniesahlberg@gmail.com> wrote:

> On Tue, Sep 15, 2015 at 2:54 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
>> On Wed,  9 Sep 2015 11:43:54 -0700
>> Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:
>>
>>> Please find attached a patch that adds support for the new opcode
>>> WRITE_ATOMIC_16 to the bs_rdwr backend.
>>>
>>> I try to make it as atomic as possible by using mmap and mlock to ensure that
>>> both the write buffer and the file region we are writing to will be all
>>> present and locked down in memory before I just memcpy() the data.
>>> At that stage it is then assumed that the memcpy() will never fail short.
>>
>> But it's still possible that the data written to the underlying file
>> system in 'non-atomic' manner in the case of linux kernel crash or
>> such?
> 
> True.
> If there is a kernel panic between when we issue msync() and until the
> kernel has fully destaged all the data, the write will not be atomic
> and we will end up with a short write :-(
> 
> That should be rare-ish though so we should be able to live with it?
> If not, since the backing file is supposed to be a plain posix file,
> do you have any suggestions or pointers on how I can make the
> atomicity
> stronger, I have tried to think about it but since filesystems is not
> my strongest side I can not come up with anything better right now.

Btrfs doesn't guarantee this yet? EXT3's data=journal is still broken?
