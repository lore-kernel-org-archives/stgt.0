From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tgtadm delete without lld specified?
Date: Sun, 20 Apr 2014 21:20:00 +0900 (JST)
Message-ID: <20140420.212000.1305564732068189294.fujita.tomonori@lab.ntt.co.jp>
References: <534F14D9.8090507@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <534F14D9.8090507@suse.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lduncan@suse.com
Cc: stgt@vger.kernel.org

On Wed, 16 Apr 2014 16:40:09 -0700
Lee Duncan <lduncan@suse.com> wrote:

> I am debugging a problem on SUSE 11 SP3, with tgt 0.9.10.
> 
> I am creating two iSCSI targets using targets.conf. Neither target
> specifies a low-level driver, and there is no default-driver specified
> either.
> 
> The targets looks something like this:
> 
> <target iqn....t1>
>     backing-store /dev/some-device
>     vendor_id someid
>     product_id volume-num1
> </target>
> 
> I create two of these targets, t1, and t2, then I using open-iscsi to
> login to the first target, t1, then logout.
> 
> Then I run "tgt-admin --delete "iqn...t1". As you know, this just runs
> "tgtadm --op delete --mode target --tid=<tid-of-t1>". No low-level
> driver is specified.
> 
> Then I try to login to the second target, t2, using open-iscsi, and
> the login hangs. This is because tgtd has died.
> 
> Further analysis shows that tgtd dies because when it tries to look up
> the iscsi target structure for t2, the t1 entry is still around. And
> when the code tries to get the name of this no-longer-existing target,
> it gets NULL and tries to compare that with the iqn name being
> added. This makes strcmp() very unhappy.

Surely, sounds a bug. The latest code still has this bug?


> I find that if I manually specify the lld either on the command line
> of "tgtadm", or in one of the config files, then this problem goes
> away.
> 
> It looks like when I don't specify any LLD the upper-level code
> defaults to low-lever-driver zero! This seems like a bug to me.
> 
> Shouldn't the "tgtadm" command enforce specifying the low-level
> driver?

I guess that tgtadm command should use 'iscsi' by default if the
low-level driver is not specified.
