From: Apollon Oikonomopoulos <apoikos@debian.org>
Subject: Re: [PATCH] systemd notification support
Date: Thu, 22 May 2014 01:00:24 +0300
Message-ID: <20140521220023.GA22673@marvin.ws.skroutz.gr>
References: <1400640207-2743-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <537D140A.3000705@redhat.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <537D140A.3000705@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Grover <agrover@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stgt@vger.kernel.org

Hi Andy,

On 14:00 Wed 21 May     , Andy Grover wrote:
> Hi Apollon,
> 
> Fedora tgtd pkg maintainer here.
> 
> Better systemd integration seems like a good way to go. BTW I feel deep
> shame about the systemd service file that Fedora is currently using
> (attached), especially the sleep. Does this or another change perhaps result
> in a better way to integrate tgt with systemd?

The sleep statement is precisely what I wanted to get rid of when I was 
writing our own service file[1]. I've currently set it to an 
aggressive-but-works-for-me value of 0.2 seconds but I really don't like 
it at all.

When the service type is set to `notify', systemd will wait for the main 
process specified by ExecStart to send a readiness notification before 
proceeding with any ExecStartPost directives and so it seems to be the 
"correct" way to solve the race. Since the modifications required to use 
sd_notify(3) are really minor and the interface very simple, I think 
it's worth enabling it.

A working alternative would be to bind the IPC unix socket in systemd 
and pass it down to tgtd using socket activation and sd_listen_fds(3), 
but this requires more extensive patching of tgtd and is IMHO a bit of 
an ugly workaround, because the IPC interface is meant to be internal to 
tgt.

> Do we need two service files or something?

Without readiness notification, systemd assumes that the service is 
ready as soon as the process has been spawned (and could really make no 
other assumption in a reliable manner). This means that having two 
services with a dependency wouldn't solve the race either. Apart from 
the issue at hand, the two services idea has occurred to me as well, but 
I see no real advantage in e.g. being able to stop just the targets 
without stopping tgtd. Do you have a specific use-case in mind?

> 
> It would be great if tgt could use the same service file(s) on all
> systemd-enabled distros, and these could be included with tgtd.

I totally agree. Seeing that our service files are similar[1] (with the 
exception of us forcing all targets cleared during shutdown), I don't 
think that's something impossible to achieve.

Regards,
Apollon

[1] http://anonscm.debian.org/gitweb/?p=collab-maint/tgt.git;a=blob;f=debian/tgt.service;h=00232c4fd308d68288c75d23af515984aca394bf;hb=HEAD
