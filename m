From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bs_sheepdog.c: fix up buffer overrun issues with unix
 domain socket
Date: Tue, 03 Dec 2013 16:42:02 +0900 (JST)
Message-ID: <20131203.164202.1568838937885781894.fujita.tomonori@lab.ntt.co.jp>
References: <1386034122-8854-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1386034122-8854-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: konishi.ryusuke@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, mitake.hitoshi@lab.ntt.co.jp

On Tue,  3 Dec 2013 10:28:42 +0900
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> The current sheepdog driver still has two buffer overrun issues due to
> unsafe strncpy uses for the pathname buffer of unix domain socket:
> 
> 1) The size of "sun_path" string buffer of "sockaddr_un" structure is
>    108 bytes, however, UNIX_PATH_MAX macro is locally defined as 109.
>    So, the following strncpy use at connect_to_sdog_unix function
>    still can be filled without a terminating null byte.
> 
>       strncpy(un.sun_path, path, UNIX_PATH_MAX - 1);
> 
> 2) The following use of strncpy at sd_open function also has a buffer
>    overrun issue because the size of ai->uds_path is the same as
>    UNIX_PATH_MAX.
> 
>       strncpy(ai->uds_path, result, UNIX_PATH_MAX);
> 
> Moreover, the local definition of UNIX_PATH_MAX, which gives the
> buffer size of unix domain socket pathname, is confusing.  It is
> traditionally used to define the size of "sun_path" string buffer of
> "sockaddr_un", which is 108 bytes including a terminating null byte,
> but this local macro sets it to 109 bytes.
> 
> This patch fixes up these issues.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
> ---
>  usr/bs_sheepdog.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.
