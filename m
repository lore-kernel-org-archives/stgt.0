From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 2/2] Remove incorrect size specifier in spc_lu_init
Date: Thu, 27 Jul 2017 16:11:59 +0900 (JST)
Message-ID: <20170727.161159.1898388363586161513.tomof@acm.org>
References: <20170718205258.6246-1-agrover@redhat.com>
        <20170718205258.6246-3-agrover@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20170718205258.6246-3-agrover@redhat.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: agrover@redhat.com
Cc: stgt@vger.kernel.org

Sorry about the delay,

On Tue, 18 Jul 2017 13:52:58 -0700
Andy Grover <agrover@redhat.com> wrote:

> The vendor_id field is only 9 bytes, so GCC 7 complains when a size
> specifier of 16 is given.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  usr/spc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/usr/spc.c b/usr/spc.c
> index cdb8a2a..82a6ec9 100644
> --- a/usr/spc.c
> +++ b/usr/spc.c
> @@ -2069,7 +2069,7 @@ int spc_lu_init(struct scsi_lu *lu)
>  	lu->attrs.sense_format = 0;
>  
>  	snprintf(lu->attrs.vendor_id, sizeof(lu->attrs.vendor_id),
> -		 "%-16s", VENDOR_ID);
> +		 "%-s", VENDOR_ID);
>  	snprintf(lu->attrs.product_rev, sizeof(lu->attrs.product_rev),

snprintf() writes a trailing null. the size of lu->attrs.vendor_id is
exactly 16 bytes. Seems that snprintf on some platforms writes only 15
bytes of the string at a maximum.

What we need here is writing 16 bytes of the string at a maximum
(without a trailing null). Seems that no way to tell snprintf not to
write a tailing null... A helper function like the following might
help?

Thought?

diff --git a/usr/spc.c b/usr/spc.c
index cdb8a2a..b6a77e6 100644
--- a/usr/spc.c
+++ b/usr/spc.c
@@ -2068,7 +2068,7 @@ int spc_lu_init(struct scsi_lu *lu)
 	lu->attrs.swp = 0;
 	lu->attrs.sense_format = 0;
 
-	snprintf(lu->attrs.vendor_id, sizeof(lu->attrs.vendor_id),
+	scsi_sprintf(lu->attrs.vendor_id, sizeof(lu->attrs.vendor_id),
 		 "%-16s", VENDOR_ID);
 	snprintf(lu->attrs.product_rev, sizeof(lu->attrs.product_rev),
 		 "%s", "0001");
diff --git a/usr/util.h b/usr/util.h
index 256bdb8..191d76e 100644
--- a/usr/util.h
+++ b/usr/util.h
@@ -240,4 +240,18 @@ static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
 }
 
+static inline int scsi_sprintf(char *str, size_t size, const char *format, ...)
+{
+	va_list args;
+	char buf[size + 1];
+	int n;
+
+	memset(buf, 0, sizeof(buf));
+	va_start(args, format);
+	n = snprintf(buf, size, format, args);
+	va_end(args);
+	memcpy(str, buf, size);
+	return n;
+}
+
 #endif
