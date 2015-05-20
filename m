From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH internal-review 0/2] Discovery mode session iser fixes
Date: Wed, 20 May 2015 20:27:48 +0900 (JST)
Message-ID: <20150520.202748.1568838937885774437.fujita.tomonori@lab.ntt.co.jp>
References: <1432111556-20535-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1432111556-20535-1-git-send-email-sagig@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: sagig@mellanox.com
Cc: stgt@vger.kernel.org, roid@mellanox.com

On Wed, 20 May 2015 11:45:54 +0300
Sagi Grimberg <sagig@mellanox.com> wrote:

> This small set is fixing discovery mode NULL dereference
> and tasks leak in iser. These were found when testing against
> FreeBSD iser initiator (https://github.com/sagigrimberg/iser-freebsd).
> 
> Sagi Grimberg (2):
>   iser: Clear tasks free list when closing the connection
>   iser: Fix wrong access to the session discovery mode
> 
>  usr/iscsi/iser.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Applied, thanks!
