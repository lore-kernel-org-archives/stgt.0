From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Memory leak of NOP-IN tasks in iscsi_tcp
Date: Thu, 14 Jul 2016 20:20:51 +0900 (JST)
Message-ID: <20160714.202051.1568838937885776348.fujita.tomonori@lab.ntt.co.jp>
References: <1468279415325.97995@acronis.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1468279415325.97995@acronis.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Anton.Kovalenko@acronis.com
Cc: stgt@vger.kernel.org

On Mon, 11 Jul 2016 23:23:35 +0000
Anton Kovalenko <Anton.Kovalenko@acronis.com> wrote:

> We've found a memory leak in tgtd recently (leaking a struct iscsi_task each nop_interval seconds).
> The problem seems to have been there since the nop_interval was introduced.
> 
> My attempt at fixing it was submitted as a pull request, available at https://github.com/fujita/tgt/pull/21
> The approach taken might be far from the best one possible, but the problem is severe enough to justify 
> doing something to solve it, even if imperfect. 

Looks good. Thanks a lot!

