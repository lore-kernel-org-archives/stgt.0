From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] sheepdog: reject snapshot as a LUN to avoid
 deleting working VDI
Date: Sat, 15 Oct 2016 21:14:21 +0900 (JST)
Message-ID: <20161015.211421.1568838937885763116.fujita.tomonori@lab.ntt.co.jp>
References: <1476360178-7452-1-git-send-email-menjo.takashi@lab.ntt.co.jp>
        <CAE1WaK+Y-OVuo3P8uvyHAXJuvv2e7L+D1PEO_v0Ar=eEiHBebA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAE1WaK+Y-OVuo3P8uvyHAXJuvv2e7L+D1PEO_v0Ar=eEiHBebA@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@gmail.com, menjo.takashi@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, ishizaki.teruaki@lab.ntt.co.jp

On Fri, 14 Oct 2016 14:20:48 +0900
Hitoshi Mitake <mitake.hitoshi@gmail.com> wrote:

> On Thu, Oct 13, 2016 at 9:02 PM, Takashi Menjo
> <menjo.takashi@lab.ntt.co.jp> wrote:
>> This commit lets the sheepdog driver reject forms of filename below.
>> This is to avoid unintended deletion of working VDI when a snapshot is
>> given as a LUN.
>>
>>  * unix:<path_of_unix_domain_socket>:<vdi>:<tag>
>>  * unix:<path_of_unix_domain_socket>:<vdi>:<snapid>
>>  * tcp:<host>:<port>:<vdi>:<tag>
>>  * tcp:<host>:<port>:<vdi>:<snapid>
>>
>> In the case that a snapshot is given as a LUN by any of them above, the
>> sheepdog driver attempts to delete it then create a new writable VDI when
>> some data is being written to it. The deletion request contains name and
>> VDI ID of the snapshot. However, sheep daemon uses its name but ignores
>> VDI ID and, what is worse, the request contains neither snapshot ID nor
>> tag. So sheep daemon receiving the request interprets it as deletion of
>> working VDI, not snapshot. If there is working VDI with the same name,
>> it will be deleted unintentionally.
>>
>> I decided not to fix the sheepdog driver to send snapshot ID or tag but
>> to let it reject snapshot as a LUN because, even if I fix it, creating
>> a new writable VDI will be failed when working VDI exists. If you want
>> workaround, use "dog vdi clone" command to create a new writable VDI from
>> snapshot then give the new VDI as a LUN.
>>
>> Cc: Teruaki Ishizaki <ishizaki.teruaki@lab.ntt.co.jp>
>> Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
>> Signed-off-by: Takashi Menjo <menjo.takashi@lab.ntt.co.jp>
>> ---
>>  usr/bs_sheepdog.c | 112 +-----------------------------------------------------
>>  1 file changed, 2 insertions(+), 110 deletions(-)
> 
> Acked-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Applied, thanks guys.

