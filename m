From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 2/2] Remove incorrect size specifier in spc_lu_init
Date: Thu, 27 Jul 2017 12:16:19 -0700
Message-ID: <8ccb226c-e048-467e-425b-ecc7d9ce31f0@redhat.com>
References: <20170718205258.6246-1-agrover@redhat.com>
 <20170718205258.6246-3-agrover@redhat.com>
 <20170727.161159.1898388363586161513.tomof@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20170727.161159.1898388363586161513.tomof@acm.org>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: FUJITA Tomonori <tomof@acm.org>
Cc: stgt@vger.kernel.org

On 07/27/2017 12:11 AM, FUJITA Tomonori wrote:
> Sorry about the delay,
> 
> On Tue, 18 Jul 2017 13:52:58 -0700
> Andy Grover <agrover@redhat.com> wrote:
> 
>> The vendor_id field is only 9 bytes, so GCC 7 complains when a size
>> specifier of 16 is given.
>>
>> Signed-off-by: Andy Grover <agrover@redhat.com>
>> ---
>>   usr/spc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/usr/spc.c b/usr/spc.c
>> index cdb8a2a..82a6ec9 100644
>> --- a/usr/spc.c
>> +++ b/usr/spc.c
>> @@ -2069,7 +2069,7 @@ int spc_lu_init(struct scsi_lu *lu)
>>   	lu->attrs.sense_format = 0;
>>   
>>   	snprintf(lu->attrs.vendor_id, sizeof(lu->attrs.vendor_id),
>> -		 "%-16s", VENDOR_ID);
>> +		 "%-s", VENDOR_ID);
>>   	snprintf(lu->attrs.product_rev, sizeof(lu->attrs.product_rev),
> 
> snprintf() writes a trailing null. the size of lu->attrs.vendor_id is
> exactly 16 bytes. Seems that snprintf on some platforms writes only 15
> bytes of the string at a maximum.
> What we need here is writing 16 bytes of the string at a maximum
> (without a trailing null). Seems that no way to tell snprintf not to
> write a tailing null... A helper function like the following might
> help?
> 
> Thought?
> 
> diff --git a/usr/spc.c b/usr/spc.c
> index cdb8a2a..b6a77e6 100644
> --- a/usr/spc.c
> +++ b/usr/spc.c
> @@ -2068,7 +2068,7 @@ int spc_lu_init(struct scsi_lu *lu)
>   	lu->attrs.swp = 0;
>   	lu->attrs.sense_format = 0;
>   
> -	snprintf(lu->attrs.vendor_id, sizeof(lu->attrs.vendor_id),
> +	scsi_sprintf(lu->attrs.vendor_id, sizeof(lu->attrs.vendor_id),
>   		 "%-16s", VENDOR_ID);
>   	snprintf(lu->attrs.product_rev, sizeof(lu->attrs.product_rev),
>   		 "%s", "0001");

Well I think there are two cases. First is the above case, where we're 
just filling in our own private fixed width data field. In this case 
this line is fine except the minimum width specifier (16) is larger than 
the actual sizeof(lu->attrs.vendor_id), which is 9. One was added to 
VENDOR_ID_LEN for the field to ensure there was space to null-terminate 
the string, so this is one spot where I think snprintf is fine, once the 
"16" is removed.

But for all other cases, especially those in smc.c, yes I think we need 
scsi_snprintf(), for properly writing fixed width, NOT null-terminated, 
left-aligned and maybe padded with spaces fields, which are common in SCSI.

Regards -- Andy

> diff --git a/usr/util.h b/usr/util.h
> index 256bdb8..191d76e 100644
> --- a/usr/util.h
> +++ b/usr/util.h
> @@ -240,4 +240,18 @@ static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
>   		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
>   }
>   
> +static inline int scsi_sprintf(char *str, size_t size, const char *format, ...)
> +{
> +	va_list args;
> +	char buf[size + 1];
> +	int n;
> +
> +	memset(buf, 0, sizeof(buf));
> +	va_start(args, format);
> +	n = snprintf(buf, size, format, args);
> +	va_end(args);
> +	memcpy(str, buf, size);
> +	return n;
> +}
> +
>   #endif
> 
