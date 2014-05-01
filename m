From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: 1.0.47 released
Date: Thu, 1 May 2014 17:31:31 +0900
Message-ID: <20140501172208W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hello,

Here's a new release.

=
Andy Grover (4):
      Fix race on thread shutdown causing deadlock
      Remove startup_lock
      Replace if()/goto with while()
      Remove unneeded pthread_cond_broadcast

FUJITA Tomonori (1):
      tgt 1.0.47

Roi Dayan (2):
      iser: fix a warning about container_of being redefined
      Update debian build to use local docbook-xsl for generating docs
