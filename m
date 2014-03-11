From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: spc: Support NAA IEEE Registered Extended field in VPD page 0x83
Date: Tue, 11 Mar 2014 08:14:05 +0200
Message-ID: <531EA9AD.2050400@mellanox.com>
References: <1393332853-12965-1-git-send-email-ogerlitz@mellanox.com> <20140308.214054.1305564732068200109.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20140308.214054.1305564732068200109.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Dennis.Cullison@Teradata.com
Cc: stgt@vger.kernel.org

On 08/03/2014 14:40, FUJITA Tomonori wrote:
>> @@ -160,6 +166,24 @@ static void update_vpd_83(struct scsi_lu *lu, void *id)
>> >  
>> >  	put_unaligned_be64(lu->attrs.numeric_id, data);
>> >  	data[0] |= NAA_LOCAL << 4;
>> >+
>> >+	data += NAA_DESG_LEN;
>> >+	data[0] = INQ_CODE_BIN;
>> >+	data[1] = DESG_NAA;
>> >+	data[3] = NAA_DESG_LEN_EXTD;
>> >+	data += DESG_HDR_LEN;
>> >+	while (*id_str) {
>> >+		subs[0] = *id_str++;
>> >+		c = a >> 60;
>> >+		a <<= 4;
>> >+		b <<= 4;
>> >+		b |= c;
>> >+		a |= strtoul(subs, NULL, 16);
> Can you please add comments to explan what the above code is supposed
> to do? Also the code works on architecture where long is 32bits?
>
>

sure, Dennis will look into this, he said this is going to take few more 
days, so we'll let you know.

Or.
