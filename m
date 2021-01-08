From: Michael Ablassmeier <abi@grinser.de>
Subject: RFC: Fault injection
Date: Fri, 8 Jan 2021 15:12:06 +0100
Message-ID: <20210108141206.hhiamqwn3tbk3kxl@lrrr.dead-link.org>
Reply-To: Michael Ablassmeier <abi@grinser.de>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
Content-Disposition: inline
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

hi,

im searching for a way to be able to easily simulate faulty tape drives
for CI/Testing purposes. The VTL emulation in TGT seems to have all the
functionality required for my purpose and so i went on and implemented a
proof of concept.

The POC uses the VTL Tapes MAM header to store information about which
errnous behavior should be simulated in case the tape is written.
Different tapes can as such simulate different fault behaviors.

See following description for more details:

 https://github.com/abbbi/tgt/blob/fault_injection/doc/README.ssc-fault-injection

Is there any interest in getting such a feature into TGT's VTL
emulation? Full diff here:

 https://github.com/fujita/tgt/compare/master...abbbi:fault_injection

As the MAM header is probably not the best way for storing the
information, would it be a good solution to store a special file
alongside to the VTL file, including more meta information related to
this feature?

bye,
    - michael
