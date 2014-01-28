From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] iser: Add Discovery support
Date: Tue, 28 Jan 2014 19:41:18 +0900
Message-ID: <20140128190640J.fujita.tomonori@lab.ntt.co.jp>
References: <1390900679-30187-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1390900679-30187-1-git-send-email-ogerlitz@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ogerlitz@mellanox.com
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org, roid@mellanox.com, oren@mellanox.com, nezhinsky@gmail.com

On Tue, 28 Jan 2014 11:17:59 +0200
Or Gerlitz <ogerlitz@mellanox.com> wrote:

> Add support to handle TEXT PDU, such as SendTargets which are used i
> for running iscsi discovery over iser. 
> 
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Alexander Nezhinsky <nezhinsky@gmail.com>
> ---
>  usr/iscsi/iser.c      |    4 ++++
>  usr/iscsi/iser_text.c |   40 +++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 43 insertions(+), 1 deletions(-)

Applied, thanks.
