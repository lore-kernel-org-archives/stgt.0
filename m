From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tgtd buffer overflow and command injection vulnerabilities
Date: Sat, 14 Jun 2014 22:29:01 +0900 (JST)
Message-ID: <20140614.222901.1568838937885774892.fujita.tomonori@lab.ntt.co.jp>
References: <CFBCA7D8.12705%jason.hullinger@hp.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CFBCA7D8.12705%jason.hullinger@hp.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jason.hullinger@hp.com
Cc: stgt@vger.kernel.org

Sorry about the delay,

On Tue, 10 Jun 2014 19:17:35 +0000
"Hullinger, Jason (Cloud Services)" <jason.hullinger@hp.com> wrote:

> The function call_program in the tgtd daemon includes a callback function
> that will run arbitrary commands. Additionally, it does not check that the

Yeah, the feature is intentional:

http://www.spinics.net/lists/linux-stgt/msg02065.html

No security about tgtadm. A user who can use tgtadm has the root
permission. He can do whatever he want to on the machine. He doesn't
need to use a security hole in tgtd and tgtadm.

Of course, we care about security about iscsi and isns ports.
