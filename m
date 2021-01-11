From: Michael Ablassmeier <abi@grinser.de>
Subject: [PATCH] set access flag in storage element descriptor
Date: Mon, 11 Jan 2021 16:00:39 +0100
Message-ID: <20210111150039.tqfosbfu27ddsbbf@lrrr.dead-link.org>
Reply-To: Michael Ablassmeier <abi@grinser.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="u4js77q2e4vckgp3"
Return-path: <stgt-owner@vger.kernel.org>
Content-Disposition: inline
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org


--u4js77q2e4vckgp3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi,

the storage element descriptor has an access parameter value which most
storage vendors[0] and also mhvtl[1] do implement:

 >  Indicates that the medium transport element cannot access the
 >  media at the storage location [..]

TGT's smc unfortunately does not handle at all and only sets information
wether if slot is filled or not. I have seen that commercial products
care about the access flag in some way and if missing, will show an
empty slot, even if filled.

Attached patch sets access bit if slot is filled.

[0] https://support.spectralogic.com/documentation/default-source/user-guides/12-8-t-seriesscsidevguide.pdf?sfvrsn=79ecf946_6
(Page 80)
[1] https://github.com/markh794/mhvtl/blob/master/usr/smc.c#L512

bye,
    - michael

--u4js77q2e4vckgp3
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="access_flag.diff"

diff --git a/usr/smc.c b/usr/smc.c
index bbc7b7f..7a9dec8 100644
--- a/usr/smc.c
+++ b/usr/smc.c
@@ -146,7 +146,7 @@ static int add_element_descriptor(uint8_t *data, struct slot *s,
 	int i;	/* data[] index */
 
 	*(uint16_t *)(data) = __cpu_to_be16(s->slot_addr);
-	data[2] = s->status;
+	data[2] = s->status | 0x8;
 	data[3] = 0;	/* Reserved */
 	data[4] = (s->asc >> 8) & 0xff;	/* Additional Sense Code */
 	data[5] = s->asc & 0xff;	/* Additional Sense Code Qualifier */

--u4js77q2e4vckgp3--
