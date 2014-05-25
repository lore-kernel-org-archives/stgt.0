From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] systemd notification support
Date: Sun, 25 May 2014 20:18:02 +0900
Message-ID: <20140525201641O.fujita.tomonori@lab.ntt.co.jp>
References: <1400640207-2743-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1400640207-2743-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: apoikos@debian.org
Cc: stgt@vger.kernel.org

On Wed, 21 May 2014 11:43:27 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> From: Apollon Oikonomopoulos <apoikos@debian.org>
> 
> tgtd may take some time to initialize before accepting management
> commands. Since management commands are used to bring the targets up
> during service startup, we have to make sure that tgtd is responsive
> before proceeding. To this end, we add a call to sd_notify(3) right
> before entering the event loop to signal systemd (if applicable) that
> the main process is ready.
> 
> Systemd support with the relevant includes and linker flags is optional,
> controlled by the SD_NOTIFY make flag.
> 
> Signed-off-by: Apollon Oikonomopoulos <apoikos@debian.org>
> ---
>  Makefile     | 1 +
>  usr/Makefile | 8 ++++++++
>  usr/tgtd.c   | 4 ++++
>  usr/tgtd.h   | 4 ++++
>  4 files changed, 17 insertions(+)

Applied, thanks a lot!
