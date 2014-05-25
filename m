From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] systemd notification support
Date: Sun, 25 May 2014 20:18:02 +0900
Message-ID: <20140525201621G.fujita.tomonori@lab.ntt.co.jp>
References: <1400640207-2743-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<537D140A.3000705@redhat.com>
	<20140521220023.GA22673@marvin.ws.skroutz.gr>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20140521220023.GA22673@marvin.ws.skroutz.gr>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: apoikos@debian.org
Cc: agrover@redhat.com, fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org

On Thu, 22 May 2014 01:00:24 +0300
Apollon Oikonomopoulos <apoikos@debian.org> wrote:

> > It would be great if tgt could use the same service file(s) on all
> > systemd-enabled distros, and these could be included with tgtd.
> 
> I totally agree. Seeing that our service files are similar[1] (with the 
> exception of us forcing all targets cleared during shutdown), I don't 
> think that's something impossible to achieve.

Integrating nicely with systemd sounds great. Looking forward to
the further patches ;)
