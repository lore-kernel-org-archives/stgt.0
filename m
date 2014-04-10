From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Update debian build to use local docbook-xsl for
 generating docs
Date: Fri, 11 Apr 2014 05:10:45 +0900 (JST)
Message-ID: <20140411.051045.1568838937885789964.fujita.tomonori@lab.ntt.co.jp>
References: <1397141342-5259-1-git-send-email-roid@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1397141342-5259-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: roid@mellanox.com
Cc: stgt@vger.kernel.org

On Thu, 10 Apr 2014 17:49:02 +0300
Roi Dayan <roid@mellanox.com> wrote:

> Building debian package procedure generates a lot of errors generating
> the docs and takes forever to finish.
> This patch will change the procedure to use local available docbook-xsl.
> Added build dependency for docbook-xsl and updated debian build script to
> set it as build dependency.
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> ---
>  scripts/deb/control                                |    2 +-
>  ...001-Use-local-docbook-for-generating-docs.patch |   70 ++++++++++++++++++++
>  2 files changed, 71 insertions(+), 1 deletions(-)
>  create mode 100644 scripts/deb/patches/0001-Use-local-docbook-for-generating-docs.patch

Sounds reasonable. Applied, thanks.
