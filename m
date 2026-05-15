Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021086.outbound.protection.outlook.com [52.101.70.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D2C23EA83
	for <stgt@vger.kernel.org>; Fri, 15 May 2026 12:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778849304; cv=fail; b=OOkXAnJQdlyNF6kQuRKcUzjDyejRww2Eg6H11Pxi+OAB69f4ToM+SAAWCqcDQ2wpULm7B7JfhBgo8WJE0Rh79vLAZ6hNoHPnsTLyoNI6iOPvpSMKCsO/r3GmP+ObKyBEABZIEwWSAZxLUVn0jEiDbbuNt2LC5lDtNeOt3AE7rfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778849304; c=relaxed/simple;
	bh=9Fs5qksEt0f28vndiZD30lUHpmaYG9zrRCDHlFTcot4=;
	h=Message-ID:Date:To:From:Subject:Content-Type:MIME-Version; b=Omrxxn1wP83saSkzR4j+sw18K5bM4Pc2+cQewNlvPetEauHBtJumyq1x1z7op0mf0o/zzGVHFBgzyjuWE7/4FxXOSD0AmifRCAkpc+ts5/eXWkL5TS0dSe5H5SQwOqp9mt6PMGJVlg9r+XZlRMLfvEtRJSQ82wpvlIOeP7+60RM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=unibo.it; spf=pass smtp.mailfrom=unibo.it; dkim=pass (2048-bit key) header.d=unibo.it header.i=@unibo.it header.b=GlAhOsdr; arc=fail smtp.client-ip=52.101.70.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unibo.it header.i=@unibo.it header.b="GlAhOsdr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQ/tKm+Pxr1dYWev+fhhJ78Sh7anaXa5doX7Kktbr3EFu1Ix7t5NQkB3EQZQtu0yU5o4Jds+jqxZdmvKLfwM141/3jNd/FgD4jRLcq/QqkCT03OUtb5D6OhqcCzsDrPivdOyIL2G+cppy6sbsG42uwo1UNrVfwrqwT3WFVcnHssIc5KPqwIlUVk4dI/3xdsmAhTN0zeHYoZ/tmPVwwRiOQBrXKbD3TycmDjaw6drIm3UO+q8SfVVGTRgU+N7g4D8ZongrnuHzW9yI5hu5CUQ35YK4dzygQwkskOKn/M0ea7V7dCjqHoLBHE6TbDZOZjJz9aBerB/Qhi5EcfOJ8nUzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lViZOEe5v5Ac30E7OnDwGvWjtKLiKsYzG2UjA92YUag=;
 b=kBrgntJt9ohcHhXUyy8N92OTuoDBM2U3i0GS3Dd41IMlAfLod1F+9TV64ttgH9ERHdl2ILrCA6Ejq2BA122uFUKOkQchmJqp0eoMhSNjZhHHizTfdslKfKL8pV498pBHMGgn6eJew9KEGZCIZjBTimj076KYqC/cKjrcMmJlUPocCPoxJ4GRuqX4wM7lwYJe9ewV5vg0ULtG1stXmpKZgqOqYXSI6mOrzbJx6h2IMnPVTbvVfJDz0rV95OisaCVhBOt9fN9hRqBmqehr5RagA3qPMvVYfIe0rdjyyz5dmKhtvNQ0GT+B0UZkJ3TycsAUUYjkw5ySk4QdfAkbhNP4Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=unibo.it; dmarc=pass action=none header.from=unibo.it;
 dkim=pass header.d=unibo.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unibo.it; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lViZOEe5v5Ac30E7OnDwGvWjtKLiKsYzG2UjA92YUag=;
 b=GlAhOsdrMgJWdkdCNog0agYUA1Gw8gfdY3N4m0jYohmvEkDW9O2dKf+cc2/UqwTkzjCDgw07DdR1A+2Wb43sRvQMxpgMm/xeDrWxYrLiXMq5rYTFvcmXC5edLs7kCuLsckydGkWtQ/QJK5XSwKlZgO1IS874gbLkm9iE8/mK5X0pqTRrGkhNEMNlaNMc2epRybvZih63JBnjGWvfr1/AYv+/2rclZ9d05k5iKMC+1tGirCMGuqDw8hV0Dwqpp/kDYTcoaBCKOemshqo83cJb5QKpZI38Q4WXPOJvVgBpP0ZMdjHnOAdPkjujqpCNNpDfwJSsnEtdP63+IYdOjlmlJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=unibo.it;
Received: from PAWPR01MB11608.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:509::18) by PAXPR01MB9002.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:2b7::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 12:48:19 +0000
Received: from PAWPR01MB11608.eurprd01.prod.exchangelabs.com
 ([fe80::4866:81b0:d3ab:2b93]) by
 PAWPR01MB11608.eurprd01.prod.exchangelabs.com ([fe80::4866:81b0:d3ab:2b93%4])
 with mapi id 15.21.0025.016; Fri, 15 May 2026 12:48:19 +0000
Message-ID: <2f47530d-aade-4e91-83aa-3f05c12ab7cb@unibo.it>
Date: Fri, 15 May 2026 14:48:17 +0200
User-Agent: Mozilla Thunderbird
To: stgt@vger.kernel.org
Content-Language: en-US, it-IT
From: Diego Zuccato <diego.zuccato@unibo.it>
Subject: Virtual tape library and PBS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MI1P293CA0025.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::11) To PAWPR01MB11608.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:509::18)
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAWPR01MB11608:EE_|PAXPR01MB9002:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e2f8d94-dfc4-40ba-00df-08deb2803d6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|786006|18002099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	TrApdQli/E3cUwyiUxlOzYkrRMR1CKBEcNlRIY32Zsia5ElClIMzMyrlyoh8o+M83vAkHTKBctd1vq/+OUqImG7c+xh3txTJ9t6lZVRue9VXOJ7cUQFi98awDIIS2Hvk6Ijjl8ZK4Agy75LsMKKwiXsDqobJnvZKudYfUVLN5/jyxjkuRtmQ/jThaMKyuYDKA/mbk7bCdOFjR/uR0L9mac6TkJ+3S8lxCmXBD1vlec9zI1fIFgWPa38X1Tf9RRMHEyPCQmrQF/eQ1/MZtxD8piZSIvOq6INwGjmFmFJbj9W9bYvkSYn0Ovo5DKefBGnSM20wUkulYGWZCBknqRUFZvI0pngJ84L1RwXNh4w46EzojwnmEVjbVC499+2y6mhn78h6dyF04S5DuZddeAW+v+h5/Whtk2c8cLBiThmXWuJUf+/tdGoOZYLlGggUZ6pl7cPS4pRFyp291L3LYsv6S83Q64ZLObLbwYL1DSiwb45i+byxQ1pjPqdt5R7A/66v/sfslKS22xzAxgCJdhihFNTEhvLTpcDlgKNFXGWbgpEURx2VpsGOPcYy8e2Ij72YZrvUn8aGlFySdTHTGlm6AiIaSWWOlwBbU+UHZ4LCPGQjCLzhsDmVuwNC+mXBG62nowaocsMio0BinF3W3oKQxtcpkpTG0DhKqxWxQogyl5Hg3jGMQA3sRlAh9HW8t586
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR01MB11608.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(786006)(18002099003)(56012099003)(11063799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y25sMEJ6U1gxajZFV3RkUHppODhabVVyc1JCMEVwZFNkZ3lnakNCdGtuNWo1?=
 =?utf-8?B?cDlzNVZINlpldjE4NnVTUlllL01tUlZ1emptcTZ2NFJpeEs0azQrVUloV1NG?=
 =?utf-8?B?Z1BiNnp2U0g2cmY4Z1J0d2RoeE5uN0daU3lWR0xHNzFXNWRWNGNkMERxbkdB?=
 =?utf-8?B?SFBFNGhBeTN2TXN1M2xZaDJtNVVlSk5Fb2Z5eS9mazVqdmJDNmRPTnhjSlZq?=
 =?utf-8?B?MmpLbXRrMVh4eUt3T05xOTl1TjQvUFJCV3BLZnlVaFpSL2xpc1MwKzZ1NjBz?=
 =?utf-8?B?SUxwbnVIcTBXczJYK1c0czhXMjl2MDNpMTVhSzhxS1FtNmZKdkFqNzZLZTNs?=
 =?utf-8?B?dzlNTGJhOUdyUHBwY29VcXhlWVU1U0dOcHYwMkRFblRZNEc0UFZWeW02aGZS?=
 =?utf-8?B?NHZOS2tiNHNGRHBVc2diYUFTTmZ2TTFGT25WTHNBMmtxVFdSc0N6bFBUOGJ2?=
 =?utf-8?B?T0hhYzJtVTg3cUNjSDNWVldrdnkxaVRrNmQ4Y1pxOTdTZGZ0UnY5WUNpRjJZ?=
 =?utf-8?B?WDRMTmJ2aVJIa3NmSmR3R0MvMlVmQzRFaENCM3RoTlpFQTU2TFVnOHAzQXJs?=
 =?utf-8?B?OVE1R2d3ZjN0aEFHcSsyK0tEZ1VwTmlHdmtOQnhVNm5wanQzZEV3NC9zRlhL?=
 =?utf-8?B?bjJLOE1pelU4UWhNMDljMElZRDErYkR0NS9TbmxYTnFrUFVSTmNJeVVYdTlK?=
 =?utf-8?B?c1JZR3J1ZjN2R1hOUzhaaml1YkdvWW1jTktxTDJ2em5oUnVHcTVTVWxpZC9k?=
 =?utf-8?B?ZkxCNW5TTzM2cFV4VzBrWnl2czdYTEpJMGZmVmNMQjgxUUNLRlpLUmxMczgr?=
 =?utf-8?B?aU15R2hReVpuWnREU1FqcTZBZUhNOGFwUDI5OUF5bEd0WFZiOWxOS2pwWWZw?=
 =?utf-8?B?aE9vRWRIN2p5N1V4K3cvd1N2eWtJNVRXNGRjWXBmNnJsdzB5Ni9INVhEY3R2?=
 =?utf-8?B?K3RXTkxIZGVRODVFWlY3eTRGNllkNHQyUFZ3eVE4dmhGbm8ra3l6d1gwRVFG?=
 =?utf-8?B?bVdydjkzVGVyZGtYam1tOEtVMXZ2U0Q3bG1GTGs3OFpsOTdhaHVzR0t0WGJK?=
 =?utf-8?B?NDFUUGVvVnRpYi9TdHVhc25mcUZVcjJMVVR1VS9oSm5MVUFFc2dEQWJGTVZS?=
 =?utf-8?B?b1JnVUl0dHJFZ3NlcUx0Mnl1dWpvMUovdEZoT0t6NmYxaCtISStmd3gxWGNv?=
 =?utf-8?B?ekk2VFZDdklkZkVTVVdJU1A1YjQ2VjdWeVlUd2h2NFZncEppaURoc1JiY1RY?=
 =?utf-8?B?UFNHclF5RmxwL3pudWZTVzAxQU03bktpM0NBRFR0L2lmRlMzNjRibnBPOTRu?=
 =?utf-8?B?Qkl5UzVHdUpTTi9NblJrNk45dWJsdHRQby9jT01WWW5lUmZLcUN6RjhXRG5S?=
 =?utf-8?B?UXIxajA5NGdEUUhPWlpsRTRaT1J1T20zZVAzeVhSZUFHYS85R2lBS1RKa1Zo?=
 =?utf-8?B?dDRUSzNUcDFmRklYNTROaUVFbDE5THJodTlXZ24yMjZIR2tzQzhnTm1MTkRR?=
 =?utf-8?B?UTc0S3phREtlNHh0OUxvQzY0RVlVTkduc1VOSzZ4c1hxMUVTeWJzKzJsSWFN?=
 =?utf-8?B?VW0wRThPR01PQ2xqN0YvTExoczluTlpzb1l5aDc1cUFTek1zRXZMWHJjTUg0?=
 =?utf-8?B?M2xXUVlFMEZjWm5IWDB0L2gwODRkajF1Nmk1VklCRFU4dFBpWXNLU0xVMG1o?=
 =?utf-8?B?aXEvSXY2bVJkWVlURWh1UzhtV1lldy9GcUdIYW9OVGQ5VlNwY3JCYWEzZHN6?=
 =?utf-8?B?b2RSWHRWK2lvaGwrc3pGbmVKV3drMGJRSy9DV2l2STh6ZXpEc2JYRStBOHlo?=
 =?utf-8?B?dW9tbUpvN01LcXVBYzZpcVZSL2pKaG5jbmFVSHF1d2pQaDVxNWhIaHE3YjZB?=
 =?utf-8?B?QjdZRVpndkhxVzlZcFh4TnpDSExZb3RLNGJOc0kxOGlKNjluOEhzSGNjTS96?=
 =?utf-8?B?WW1OMHFiMmlTT1FVVUtRVk44U0t5U2ZDaTluMGlGRGdGSTFDNU04SWkzTVNt?=
 =?utf-8?B?UHZydVIzMlNKZ0FkaDdQOGQ0SjB1a0VOb2NERzl3SUQ1YWMvb0oyZFpEbzZx?=
 =?utf-8?B?WDlRRjF0d01JRHZQTHJzR05xK05XeE5iNWplM2Urb25YUFZucXdjMjFSclJW?=
 =?utf-8?B?ckpleXAreE9wSGxaWmJDZE5lbVNCd1MySlphNUFEVnUrbGJnZlVyTXY3VXpk?=
 =?utf-8?B?Mk1URHZMbjJ2NjVrRzVreXI3NXhSVGhvNVBDdjFYMmtHNU1YVFovYSt6UW5v?=
 =?utf-8?B?aFNMcHlZMmFJa3B5Wk1YaGhzSEU2QnFyMXZ0NWRVRnNUL3RQODk1Um9sczlN?=
 =?utf-8?B?ZHdScHpVUW1yRHNEWm5Bc1NDelJURkRYSk10SlZBdDUvNHhqV28vQT09?=
X-OriginatorOrg: unibo.it
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2f8d94-dfc4-40ba-00df-08deb2803d6f
X-MS-Exchange-CrossTenant-AuthSource: PAWPR01MB11608.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 12:48:19.0538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e99647dc-1b08-454a-bf8c-699181b389ab
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJ+NQGjEX1gsOV7gbv7ZqSzIpKKZFG4l0aOD1Z2GI8XuNg4U3uAxNEgMhG62zJeLx7YSbMe2NomrlTaTaxRnGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR01MB9002

Hello all.

I've configured a virtual tape library to store backups from 
ProxmoxBackupServer in raw hdds (treating each HDD as a tape cartridge).

Too bad when I tried to scan the vtapes PBS reported an error: seems the 
answer to READ_ELEMENT_STATUS is too short.

Looking at the code, it seems the logic in the switch should be changed 
slightly, especially in the first case statement.

I think this could be a suitable patch (I'll test monday morning):
-8<--
index bbc7b7f..fae389b 100644
--- a/usr/smc.c
+++ b/usr/smc.c
@@ -302,6 +302,7 @@ static int smc_read_element_status(int host_no, 
struct scsi_cmd *cmd)
         uint8_t dvcid;
         int alloc_len;
         uint16_t count = 0;
+       uint16_t total_count = 0;
         int first = 0;          /* First valid slot location */
         int len = 8;
         int elementSize;
@@ -349,18 +350,21 @@ static int smc_read_element_status(int host_no, 
struct scsi_cmd *cmd)
                                                   ELEMENT_MEDIUM_TRANSPORT,
                                                   &first, req_start_elem,
                                                   dvcid, voltag);
-               len = count * elementSize;
-               count += build_element_descriptors(&data[len], &smc->slots,
+               len += count * elementSize;
+               total_count+=count;
+               count = build_element_descriptors(&data[len], &smc->slots,
                                                    ELEMENT_STORAGE,
                                                    &first, req_start_elem,
                                                    dvcid, voltag);
                 len += count * elementSize;
-               count += build_element_descriptors(&data[len], &smc->slots,
+               total_count+=count;
+               count = build_element_descriptors(&data[len], &smc->slots,
                                                    ELEMENT_MAP,
                                                    &first, req_start_elem,
                                                    dvcid, voltag);
                 len += count * elementSize;
-               count += build_element_descriptors(&data[len], &smc->slots,
+               total_count+=count;
+               count = build_element_descriptors(&data[len], &smc->slots,
                                                    ELEMENT_DATA_TRANSFER,
                                                    &first, req_start_elem,
                                                    dvcid, voltag);
@@ -394,8 +398,11 @@ static int smc_read_element_status(int host_no, 
struct scsi_cmd *cmd)
                 break;
         }

+       len += count * elementSize;
+       total_count+=count;
+
         /* Lastly, fill in data header */
-       len = element_status_data_hdr(data, dvcid, voltag, first, count);
+       element_status_data_hdr(data, dvcid, voltag, first, total_count);
         memcpy(scsi_get_in_buffer(cmd), data, min(len, alloc_len));
         scsi_set_in_resid_by_actual(cmd, len);
         free(data);
-8<--

Since I've never worked on tgt code before, I could easily be completely 
off. Does it seem reasonable?
IIUC, the case ELEMENT_ANY must "accumulate" all the 
build_element_descriptors() calls in data, but old code overwrote 
previous contents with later calls.

-- 
Diego Zuccato
DIFA - Dip. di Fisica e Astronomia
Servizi Informatici
Alma Mater Studiorum - Università di Bologna
V.le Berti-Pichat 6/2 - 40127 Bologna - Italy
tel.: +39 051 20 95786

