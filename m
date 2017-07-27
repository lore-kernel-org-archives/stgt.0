From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 2/2] Remove incorrect size specifier in spc_lu_init
Date: Fri, 28 Jul 2017 07:59:20 +0900 (JST)
Message-ID: <20170728.075920.1545942096518959078.tomof@acm.org>
References: <20170718205258.6246-3-agrover@redhat.com>
        <20170727.161159.1898388363586161513.tomof@acm.org>
        <8ccb226c-e048-467e-425b-ecc7d9ce31f0@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <8ccb226c-e048-467e-425b-ecc7d9ce31f0@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: agrover@redhat.com
Cc: tomof@acm.org, stgt@vger.kernel.org

On Thu, 27 Jul 2017 12:16:19 -0700
Andy Grover <agrover@redhat.com> wrote:

>> diff --git a/usr/spc.c b/usr/spc.c
>> index cdb8a2a..b6a77e6 100644
>> --- a/usr/spc.c
>> +++ b/usr/spc.c
>> @@ -2068,7 +2068,7 @@ int spc_lu_init(struct scsi_lu *lu)
>>   	lu->attrs.swp = 0;
>>   	lu->attrs.sense_format = 0;
>>   -	snprintf(lu->attrs.vendor_id, sizeof(lu->attrs.vendor_id),
>> +	scsi_sprintf(lu->attrs.vendor_id, sizeof(lu->attrs.vendor_id),
>>   		 "%-16s", VENDOR_ID);
>>   	snprintf(lu->attrs.product_rev, sizeof(lu->attrs.product_rev),
>>   		 "%s", "0001");
> 
> Well I think there are two cases. First is the above case, where we're
> just filling in our own private fixed width data field. In this case
> this line is fine except the minimum width specifier (16) is larger
> than the actual sizeof(lu->attrs.vendor_id), which is 9. One was added
> to VENDOR_ID_LEN for the field to ensure there was space to
> null-terminate the string, so this is one spot where I think snprintf
> is fine, once the "16" is removed.

Oops, I overlooked that sizeof(lu->attrs.vendor_id) is 9. We were wise
enough to allocate VENDOR_ID_LEN + 1 here :)

As you said, just removing "16" looks fine.

I've pushed your patches, thanks!


> But for all other cases, especially those in smc.c, yes I think we
> need scsi_snprintf(), for properly writing fixed width, NOT
> null-terminated, left-aligned and maybe padded with spaces fields,
> which are common in SCSI.

I'll look at smc.c again later.
