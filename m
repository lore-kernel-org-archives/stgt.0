From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: "tgtadm --mode system --show" doesn't show global 'outgoing'
 users if there are no global incoming users
Date: Fri, 22 Aug 2014 19:33:11 +0900 (JST)
Message-ID: <20140822.193311.1545942096518960826.fujita.tomonori@lab.ntt.co.jp>
References: <53EDAB16.7010505@gmail.com>
	<20140822.192317.1898388363586166083.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20140822.192317.1898388363586166083.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: phillip.brown.j@gmail.com
Cc: stgt@vger.kernel.org

On Fri, 22 Aug 2014 19:23:17 +0900 (JST)
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Hi,
> 
> On Fri, 15 Aug 2014 16:39:18 +1000
> Phillip Brown <phillip.brown.j@gmail.com> wrote:
> 
>> Problem seems to be with this 'if' statement in targets.c:system_show
>> function
>> 
>> --------->> if (global_target.account.nr_inaccount) {
>>                                int i, aid;
>>                                concat_printf(b, _TAB1 "%s\n", "Account information:\n");
>>                                for (i = 0; i < global_target.account.nr_inaccount; i++) {
>>                                                aid = global_target.account.in_aids[i];
>>                                                concat_printf(b, _TAB1 "%s\n",
>>            __account_lookup_id(aid)->user);
>>                                }
>>                                if (global_target.account.out_aid) {
>>                                                aid = global_target.account.out_aid;
>>                                                concat_printf(b, _TAB1 "%s (outgoing)\n",
>>            __account_lookup_id(aid)->user);
>>                                }
>>                }
>> 
>> Does there really need to be that test?
> 
> Probably, I wrote the above code but can't recall why. Looks like we
> can remove the above 'if'. Can you send a patch?

Now I recalled.

With one-way CHAP authentication, a target authenticate initiators
(in account). The opposite is not supported. So if an out account
always needs in account(s).
