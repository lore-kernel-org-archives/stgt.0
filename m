From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tgtd: abort_task_set, abort_cmd and other warnings?
Date: Mon, 21 Apr 2014 07:04:00 +0900 (JST)
Message-ID: <20140421.070400.1568838937885780568.fujita.tomonori@lab.ntt.co.jp>
References: <535421B6.70004@powercraft.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <535421B6.70004@powercraft.nl>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jelledejong@powercraft.nl
Cc: stgt@vger.kernel.org

On Sun, 20 Apr 2014 21:36:22 +0200
Jelle de Jong <jelledejong@powercraft.nl> wrote:

> What do these errors/warnings mean?
> 
> http://paste.debian.net/94724/

There is a bug about closing a connection with task abort. It was
fixed in 1.0.46 (hopefully).
