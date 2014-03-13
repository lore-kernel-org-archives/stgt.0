From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH V1] spc: Support NAA IEEE Registered Extended field in
 VPD page 0x83
Date: Fri, 14 Mar 2014 05:38:35 +0900 (JST)
Message-ID: <20140314.053835.1568838937885766575.fujita.tomonori@lab.ntt.co.jp>
References: <1394703637-13010-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1394703637-13010-1-git-send-email-ogerlitz@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ogerlitz@mellanox.com
Cc: stgt@vger.kernel.org, oren@mellanox.com, Dennis.Cullison@Teradata.com

On Thu, 13 Mar 2014 11:40:37 +0200
Or Gerlitz <ogerlitz@mellanox.com> wrote:

> From: Dennis Cullison <Dennis.Cullison@Teradata.com>
> 
> Enables support for the NAA IEEE Registered Extended field in the
> inquiry VPD page 0x83. This field is used by multi-pathing
> software for device persistency.
> 
> Signed-off-by: Dennis Cullison <Dennis.Cullison@Teradata.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> ---
> 
> changes from V0:
>  - fixed the patch to work when a long is 32 bits by using uint64_t type
>  - added some comments within the code as asked by Tomo
> 
>  usr/spc.c |   32 +++++++++++++++++++++++++++++++-
>  1 files changed, 31 insertions(+), 1 deletions(-)

Applied, thanks!
