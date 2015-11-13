From: Lee Duncan <lduncan@suse.com>
Subject: Bug: "could not open backing-store directory:
 /usr/lib/tgt/backing-store" message at startup
Date: Fri, 13 Nov 2015 20:36:47 +0100
Message-ID: <56463BCF.6020001@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hello:

I have found a small problem recently when tgtd is configured for no
back-end support modules.

The Makefile in usr has these lines:

> install: $(PROGRAMS) $(MODULES)
> 	install -d -m 755 $(DESTDIR)$(sbindir)
> 	install -m 755 $(PROGRAMS) $(DESTDIR)$(sbindir)
> ifneq ($(MODULES),)
> 	install -d -m 755 $(DESTDIR)$(libdir)/backing-store
> 	install -m 755 $(MODULES) $(DESTDIR)$(libdir)/backing-store
> endif
> 

So if no modules are defined, that the backing-store directory will
never get created. Which makes sense I suppose -- it will never be
needed, since it is only used for modules.

But then the code in usr/bs.c seems to consider it an error when the
directory does not exist:

> static int bs_init_signalfd(void)
> {
> 	sigset_t mask;
> 	int ret;
> 	DIR *dir;
> 
> 	dir = opendir(BSDIR);
> 	if (dir == NULL) {
> 		eprintf("could not open backing-store module directory %s\n",
> 			BSDIR);
> 	} else {
> ...
> }

causing an error message each time tgtd starts, and this shows up on the
systemd status output, which is not good.

This seems like more of an informational message in this case, since the
bs_init_signalfd() function does not return a failure code in this case.

It seems like the "right" way to fix it would be change this code to not
consider this case an error -- perhaps just a debugging message?

Another simple solution would be to change the Makefile so that the
backing-store directory always gets created, and only the installation
of MODULES becomes conditional on having MODULES.

I can supply a patch for either case. Which would you prefer?
-- 
Lee Duncan
