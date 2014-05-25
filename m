From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] iser: configurable bufsize and ipv6 support
Date: Sun, 25 May 2014 20:18:02 +0900
Message-ID: <20140525201416N.fujita.tomonori@lab.ntt.co.jp>
References: <1401016226-3404-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1401016226-3404-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org

On Sun, 25 May 2014 14:10:24 +0300
Roi Dayan <roid@mellanox.com> wrote:

> Hi,
> 
> The first patch is to make the rdma buf size configurable
> which will allow to support bigger block sizes if required
> or to allocate less memory if there is no need to support high block sizes.
> i.e. always 1K-4K IOPs.
> 
> The second patch adds support for portals which adds IPv6 support.
> 
> Thanks,
> Roi
> 
> 
> Roi Dayan (2):
>   iser: make membuf size configurable
>   iser: add portals support
> 
>  usr/iscsi/iser.c |  125 ++++++++++++++++++++++++++++++++++++++++++------------
>  usr/iscsi/iser.h |    8 +++
>  2 files changed, 105 insertions(+), 28 deletions(-)

Applied, thanks a lot!
