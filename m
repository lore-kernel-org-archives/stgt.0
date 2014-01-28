From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: tgtadm/tgtd management issue: buffer size truncated sometimes
Date: Tue, 28 Jan 2014 08:39:15 +0200
Message-ID: <52E75093.8050607@mellanox.com>
References: <52A65E29-5717-4DEA-BDD4-CB9700D218E0@evasive.ru>	<20140124.192139.1568838937885768572.fujita.tomonori@lab.ntt.co.jp>	<C6A6622D-F621-4889-AE5C-A7F603B84105@evasive.ru> <20140128.004219.1568838937885776146.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20140128.004219.1568838937885776146.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, artyom@evasive.ru
Cc: stgt@vger.kernel.org, Andy Grover <agrover@redhat.com>

On 27/01/2014 17:42, FUJITA Tomonori wrote:
> Thanks a lot for the investigation. The following fixes the problem?
>
> Note that tgtd uses a stream to store what tgtd sends to tgtadm. The
> buffer of the stream is managed glibc (internally allocated via
> malloc). That's a limit about how many targets you can see via tgtadm.

Hi Tomo,

Just to clarify, this isn't a fix to regression, right?

Or.
