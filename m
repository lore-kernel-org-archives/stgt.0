From: Michael Ablassmeier <abi@grinser.de>
Subject: Re: [PATCH] VTL: Data block may return twice
Date: Sat, 9 Jan 2021 10:41:10 +0100
Message-ID: <20210109094110.hamvyhaxguqgqslw@lrrr.dead-link.org>
References: <20210108220259.thrrvjfzxf6otczn@lrrr.dead-link.org>
Reply-To: Michael Ablassmeier <abi@grinser.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tjqd5xsdklgxo7dr"
Return-path: <stgt-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20210108220259.thrrvjfzxf6otczn@lrrr.dead-link.org>
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org


--tjqd5xsdklgxo7dr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi,

see attached patch, makes the bacula btape test be
successful, hope it makes sense.

On Fri, Jan 08, 2021 at 11:02:59PM +0100, Michael Ablassmeier wrote:
>   bs_ssc.c
>   346  if (!length) {
>   347   if (h->blk_type == BLK_FILEMARK)
>   348       goto skip_and_out;                                                                                                                                                       
> 
> which in turn calls 
> 
>   361 skip_and_out:
>   362    ret = skip_next_header(cmd->dev); 
> 
> basically moving the position inside the VTL to the wrong place,
> ..making the third read from the tape to return data from the
> same block again :)
> 
> bye,
>     - michael

--tjqd5xsdklgxo7dr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="eod_read.diff"

diff --git a/usr/bs_ssc.c b/usr/bs_ssc.c
index 5119163..ad47417 100644
--- a/usr/bs_ssc.c
+++ b/usr/bs_ssc.c
@@ -322,16 +322,17 @@ static int resp_var_read(struct scsi_cmd *cmd, uint8_t *buf, uint32_t length,
 
 		put_unaligned_be32(val, info);
 
-		if (h->blk_type == BLK_EOD)
-			sense_data_build(cmd, 0x40 | BLANK_CHECK,
-					 NO_ADDITIONAL_SENSE);
-		else if (h->blk_type == BLK_FILEMARK)
+		if (h->blk_type == BLK_EOD) {
+			sense_data_build(cmd, NO_SENSE, ASC_END_OF_DATA);
+			return SAM_STAT_CHECK_CONDITION;
+		} else if (h->blk_type == BLK_FILEMARK) {
 			ssc_sense_data_build(cmd, NO_SENSE | SENSE_FILEMARK,
 					     ASC_MARK, info, sizeof(info));
-		else
+		} else {
 			ssc_sense_data_build(cmd, NO_SENSE | 0x20,
 					     NO_ADDITIONAL_SENSE,
 					     info, sizeof(info));
+		}
 
 		if (length > h->blk_sz)
 			scsi_set_in_resid_by_actual(cmd, length - h->blk_sz);

--tjqd5xsdklgxo7dr--
