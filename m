From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tgtadm/tgtd management issue: buffer size truncated sometimes
Date: Tue, 28 Jan 2014 16:03:49 +0900 (JST)
Message-ID: <20140128.160349.1568838937885773618.fujita.tomonori@lab.ntt.co.jp>
References: <C6A6622D-F621-4889-AE5C-A7F603B84105@evasive.ru>
	<20140128.004219.1568838937885776146.fujita.tomonori@lab.ntt.co.jp>
	<52E75093.8050607@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <52E75093.8050607@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ogerlitz@mellanox.com
Cc: artyom@evasive.ru, stgt@vger.kernel.org, agrover@redhat.com

On Tue, 28 Jan 2014 08:39:15 +0200
Or Gerlitz <ogerlitz@mellanox.com> wrote:

> On 27/01/2014 17:42, FUJITA Tomonori wrote:
>> Thanks a lot for the investigation. The following fixes the problem?
>>
>> Note that tgtd uses a stream to store what tgtd sends to tgtadm. The
>> buffer of the stream is managed glibc (internally allocated via
>> malloc). That's a limit about how many targets you can see via tgtadm.
> 
> Hi Tomo,
> 
> Just to clarify, this isn't a fix to regression, right?

Yeah, it isn't. The bug has been there since 2006 or so.
