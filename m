From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] Reject target names with invalid characters
Date: Thu, 04 Aug 2016 21:57:33 +0900 (JST)
Message-ID: <20160804.215733.1545942096518944533.tomof@acm.org>
References: <1470305952-16492-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1470305952-16492-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org

On Thu,  4 Aug 2016 13:19:12 +0300
Roi Dayan <roid@mellanox.com> wrote:

> Reject target names that do not consist on chars described in
> RFC 7143 section 4.2.7 iSCSI Name Encoding.
> 
> A user could create target names with invalid characters which could
> break initiators. e.g. creating target with chars that are not allowed
> in a file name and using Linux open-iscsi initiator which create folders
> based the target names.
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  usr/target.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied, thanks!
