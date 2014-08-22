From: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>
Subject: poor rbd performance
Date: Fri, 22 Aug 2014 08:55:15 -0400
Message-ID: <CAGbvivLncZVGVROR1rEP_=_kRGK7pTBdD9siOXdYJkg-H+bPFw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Im seeing some disappointing performance numbers using the bs_rbd backend
with a Ceph RBD pool backend over a 10GB Ethernet link.

Read operations appear to max out at about 100MB/second, regardless of
block size or amount of data being read and write operations fare much
worse, maxing out somewhere in the 40MB/second range.   Any ideas why this
would be so limited?

I've tested using 'fio' as well as some other perf testing utilities.  On
the same link, talking to the same ceph pool/image, using librados directly
(either through the C or Python bindings), the read performance is 5-8x
faster and write performance is 2-3x faster.

Any suggestions as to how to tune the iSCSI or bs_rbd interface to perform
better?

thanks,
  Wyllys Ingersoll
