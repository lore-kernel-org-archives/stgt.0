From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: New to working with stgt
Date: Fri, 24 Jan 2014 14:19:24 +0900 (JST)
Message-ID: <20140124.141924.1568838937885762668.fujita.tomonori@lab.ntt.co.jp>
References: <52E067C7.8010701@resolutech.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <52E067C7.8010701@resolutech.net>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: sgraf@resolutech.net
Cc: stgt@vger.kernel.org

Hi,

On Wed, 22 Jan 2014 19:52:23 -0500
Steven Graf <sgraf@resolutech.net> wrote:

> I am new to the list and I have recently just started working with the
> stgt framework.  I've been grokking the code and the documentation, but
> I'd appreciate any insight or advice you may be able to lend.  My
> objective is to use the rbd backend, but have a user-space driver that
> speaks native SCSI (block device).  I am looking at the existing

I'm lost here, user-space driver speaking native SCSI? What SCSI
transport protocol you use?

> implementation that uses iSCSI, and I have that all working with my Ceph
> back-end, but for performance reasons I'd like to eliminate the overhead
> of the network (currently I have everything going over localhost, which
> is good for a PoC, but insufficient for our big data tasks).
