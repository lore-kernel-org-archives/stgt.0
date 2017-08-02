From: FUJITA Tomonori <tomof@acm.org>
Subject: 1.0.72 released
Date: Wed, 02 Aug 2017 10:35:42 +0900 (JST)
Message-ID: <20170802.103542.1305564732068189721.tomof@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

Here's 1.0.72 release, including fixes for GCC7.

=
Andy Grover (2):
      Fix header warning with GCC 7 for major()
      Remove incorrect size specifier in spc_lu_init

FUJITA Tomonori (2):
      smc: fix snprintf warnings with gcc7
      tgt 1.0.72
