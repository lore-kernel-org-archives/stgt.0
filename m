From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH] Add WRITE_ATOMIC_16 support
Date: Wed, 16 Sep 2015 12:49:14 -0700
Message-ID: <CAN05THQU-N5Twu4Oi5BsxTa+3XaaAkwcotJNZmzu7mJkSDQxAA@mail.gmail.com>
References: <1441824235-7724-1-git-send-email-ronniesahlberg@gmail.com>
	<20150915.185432.653026525707333816.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=yKfxiGFfcVrPqBGWY0sXEIgEPtof8RKLuHqTB1t2y/s=;
        b=X4mE0mn6uRtfj4Nvlvchjtzo/JljKFnWyWQGRyLEgGk1/+1ongCBZl+agHI44twgp1
         pf2P5ENKfA1RpzL+0aeLWiRzE+sM/31AHzQq2fBJdF519g54Hr2YFn+C3R3bzDhhj8Sv
         KTsJabpESAgKJL1/7szJUMD8ze/2f3jy/DxXMZkrQ9HLPbRI0YYmatSkjZli4SZwqLUa
         NhDwclAvZ7dTvdeYjku/TWM3y9Jb3X7NBWIxvc2VZ8Y49NP/SNUHUcc+tqeme/tzz3bO
         A3/4bbcCxPYlleKH7ZdR+4l2BjhgjS21i1Mt8A1lkTFiiobD2+EGRVFhBgNOj35pzjrr
         XQYQ==
In-Reply-To: <20150915.185432.653026525707333816.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt <stgt@vger.kernel.org>

On Tue, Sep 15, 2015 at 2:54 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Wed,  9 Sep 2015 11:43:54 -0700
> Ronnie Sahlberg <ronniesahlberg@gmail.com> wrote:
>
>> Please find attached a patch that adds support for the new opcode
>> WRITE_ATOMIC_16 to the bs_rdwr backend.
>>
>> I try to make it as atomic as possible by using mmap and mlock to ensure that
>> both the write buffer and the file region we are writing to will be all
>> present and locked down in memory before I just memcpy() the data.
>> At that stage it is then assumed that the memcpy() will never fail short.
>
> But it's still possible that the data written to the underlying file
> system in 'non-atomic' manner in the case of linux kernel crash or
> such?

True.
If there is a kernel panic between when we issue msync() and until the
kernel has fully destaged all the data, the write will not be atomic
and we will end up with a short write :-(

That should be rare-ish though so we should be able to live with it?
If not, since the backing file is supposed to be a plain posix file,
do you have any suggestions or pointers on how I can make the
atomicity
stronger, I have tried to think about it but since filesystems is not
my strongest side I can not come up with anything better right now.


regards
ronnie sahlberg
