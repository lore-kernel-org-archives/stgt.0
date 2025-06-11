Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023105.outbound.protection.outlook.com [40.107.162.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D13221562
	for <stgt@vger.kernel.org>; Wed, 11 Jun 2025 17:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749662991; cv=fail; b=pUYa8ope4oyIcFDHJbL9QTl0wAMrhqH/qXRcssry2bcIeXxy9j5ziVLWL7ocC/1BJi215Smlf+SiYpJgJXearkpDRQoHhuw9p0AvIFQO0fBFw7/fHpOQKCYyG2UH1O2XVm432O4G73xSUzRs/2yP/+YnbXiivc4nNCxnW6UGvPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749662991; c=relaxed/simple;
	bh=H0kcDjCSdgnDYSje6WaHy41A76nm92Bwfd60josfrEk=;
	h=To:From:Subject:Message-ID:Date:Content-Type:MIME-Version; b=IDxhUI/4RjcfZmEJNuokFIiZ4BSdLL2cZhGyT6GXcG1HEJwaRuiBKr1sAP04R5HMa8Qqq2oeQdxlLnM0eKjyYPNg3ZFS7UVVvyim4MsidAx1Xjv+7MYJPmLgz6J9h7ddtP/ui/7BuYe1Gy4oJXdjVmaN62Qtu6l3ts12eUBoPGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kontron.com; spf=pass smtp.mailfrom=kontron.com; dkim=pass (1024-bit key) header.d=mysnt.onmicrosoft.com header.i=@mysnt.onmicrosoft.com header.b=KkWV0ZF3; arc=fail smtp.client-ip=40.107.162.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kontron.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kontron.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mysnt.onmicrosoft.com header.i=@mysnt.onmicrosoft.com header.b="KkWV0ZF3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qg+ZjiVOe9Kb9VJ8Ic25evF++/F6dium7eDhyvqeVTJty+aBCy8gNhlRaXr0E2lsykVElvj3lul8d47BDnvtbEgD+F32WUO4ZCk7TUe6dhFrmWaq8v59+nawQGgArMys1pZc3CKEc6F7Q4x+cCOOZmttBem/Ai4Cs5qmir8CdiMEf8Ww3fS4jF+Hw1pURGxU6xd4feR1NFwmrxP5BsmqPaA/Sk+UG9g4V5H1UZIFRskBZn4frWs2SX4HYqW9DE8qB4PggKN4hhEaoMVGEBrP3EgG7leDfksHAXhw6BDQWK+w8Ow7/+r2FRd/SuwXC7HCORQmN5vbMie6XQsIoICQFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0kcDjCSdgnDYSje6WaHy41A76nm92Bwfd60josfrEk=;
 b=nHfSPL895motB6LEjTMmNKX9+eKSqM4Qi6NzeJ/kjqRQUnpzX0yVOc67f1w96Prqi8nMGDI0lyBlbOIqnrycCT2QQn+WRSLV1yc8153FE4+B6qgECwNQoZm0XNQwrO95IxtyOXs0b1cy9eRTUf8JL0nzOpz55/muDRTLypssQbmZvozjXxuVEJYxaU3Jk0AbD0t4xKexGbPNlOznqywo/m2IA0H0y9pEhbU9Hs9TVRfb95vt+Esyxibzh8x4e3FnA0Bn+F8+lu8UYyTStZhRumtGeL1+InKb7WCBLRs8T68h68uLVx/sRwl1vI8CqlAowr812ix4meatlL1Yf0rAoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.com; dmarc=pass action=none header.from=kontron.com;
 dkim=pass header.d=kontron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0kcDjCSdgnDYSje6WaHy41A76nm92Bwfd60josfrEk=;
 b=KkWV0ZF3/AABctPBrdjkhTOMNSMYFUFdqORyokyIMIt3DN6iyJ+3WevQXLh0BrmEWex2KcgudRURzZJDqDw/TVILDeN1rvEIoGvT8kPnvnDOj3niPUAYJHN5B0FHG4kv+iQRxMqVix6Jc9Z8I4Yr1H+qxdwmbO83o5sEH8OT52Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.com;
Received: from DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:3ef::11)
 by GV1PR10MB5793.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:60::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Wed, 11 Jun
 2025 17:29:43 +0000
Received: from DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::142d:c1aa:6bc9:ca4]) by DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::142d:c1aa:6bc9:ca4%5]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 17:29:43 +0000
To: stgt@vger.kernel.org
From: Gilles BULOZ <gilles.buloz@kontron.com>
Subject: tgt : handling of missing session logout from initiator
Organization: Kontron Modular Computers SA
Message-ID: <7715d5af-f8da-069a-7a13-4a7312f8f6a1@kontron.com>
Date: Wed, 11 Jun 2025 19:29:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: OS6P279CA0174.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:38::16) To DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:3ef::11)
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR10MB6252:EE_|GV1PR10MB5793:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f4813c3-5e4d-4c65-97f8-08dda90d8d4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2VmaHNxOStLaER2eWVTVk5WY1BUNFM0a1luRWQ0N1c4eG96S1dCRTNSWDN1?=
 =?utf-8?B?dU4wZUt2a0ZkT0JCNnZTUWZ6ZUZGNHp4VThxRThNNmJKNmZXMHg3MUNKdmJV?=
 =?utf-8?B?Y1JWSnFwL2IwOWdoc0FDSkJvckpLVk1ReUdSM0hNZUZrYTJKaTJUWWpFUXIv?=
 =?utf-8?B?c1BEOWJENzNSKzdrUWpEck9oSzMrT3RFVjBBYjNkb0MvVkRTSGxoa25UdjZh?=
 =?utf-8?B?M3NaQWVPbTlTT2N3VzcwODdnVDk3TjB6eWsxSUhhOE52dUJjUVpiM29hOEZo?=
 =?utf-8?B?bno1YVlMM3NsZmxWL1VNRzBaQkg1YVh2U20rUWpHaS85OEJoMDRFMTdaa0Nm?=
 =?utf-8?B?N1RQYzRNaFF0Sk5VcHpFK0pmeVlhTGkxeFBLNmxXaVBCTXQ0UTlGWitzREZV?=
 =?utf-8?B?RHJGZG5uV25lNER6dnE4b1I5VlRmcys4aUptMlBpd242VlNXV1phU09GSmUv?=
 =?utf-8?B?V0k4cy96cjdOMVVCZmt6NVQ5eVFNWmNzb1ZzSWJsSHptQkFkUFJ0RkFmNE1G?=
 =?utf-8?B?N0kwR0IvdnkxSEcwa3ZJMk5VSDJTSUF2UEFiUkh5TC9zdERkN1R4L1lHa2Fh?=
 =?utf-8?B?MjJpQ21nK2lBa2FPbWhRc2VJMTJMNHFPL1I3bUtVSGNKTTdYMmQvMEtaR0E2?=
 =?utf-8?B?akFiMDZoU0tLZnU2VlpwWjdBdE5XR3ZsOVJnbGRaVUErc2VKcDJ2RWR1ekJN?=
 =?utf-8?B?VGI3QVZ6eC9hOGc2b25RY1hldWFoZ0twWElMOUZBRkN0eTVsUUdqUVNuMEhB?=
 =?utf-8?B?SDhnSEpROWhrcC9vZjBvVHY0R2RBNTh1clF1VGhXeTlYbkljZWxJR2lCc0lG?=
 =?utf-8?B?dCs3UVhRNFZsUVpLZzVNajllRGlzVzBmeDN2SStiRk0vdncwNkQvUGtXTlpp?=
 =?utf-8?B?OWVGREZ4Qy84RWduYWZtTlQ4V3dmbFBaeTFSeW0zd3pTQ0NFTlFMOVJuT0tT?=
 =?utf-8?B?SnB5VzBaMTE2SkZITDVxakJaME1mdkg5ZmhoTnhoWERVWUZUSTZtTUNtenVX?=
 =?utf-8?B?MHhGMzRLNUxWbzh6V1M1QWdrUEt5SThGQndqZDh5R2pwdVFVMkhXeCszYWlO?=
 =?utf-8?B?bnhRS2ZxczY4WHRvYzlla0I3YWFPVEIrN3l2R0tlbTZYbFI4a0V3L2tqS0lZ?=
 =?utf-8?B?UmNSWHAzVG51bDFXQTJvYnJTM3ErM3VOa1NIMk1sNU9xYzZGUGdwSm90NEll?=
 =?utf-8?B?RHNKdzgrYVJ2Tk5oUUx3R252U0xxWUZFUDNtb2hhMDBaajB3djYwM2tZenBp?=
 =?utf-8?B?SW9RWUVoTVYxOVc1dkZQMlZZcnNUYjJLOUNjbkcxZFZQQ3ZaMmpubldtN1hR?=
 =?utf-8?B?VFpBenAzY2hzeGhwREhjdFc2Mis3MHZPUW9pZGc1V0dCY3VhNnV1RmxZNWxx?=
 =?utf-8?B?aW1FaDBmNDA2SUFicC9nS0lxenNROEtlYkZCanlpaWw0MXVNUnhhTkhJTzlx?=
 =?utf-8?B?enNsVTJaZWN1Q1Bzamp0NDdabzBXdWNRNDZJMEpDR0djT1BuVmxqSThGMlBT?=
 =?utf-8?B?L0l4dSs3RFZocXZMVUVib2tXam04dEdnOEVjZk5tRDdveDYwdlJDd2tLL1Vt?=
 =?utf-8?B?TVNGMktlZVEyQkw4alhadzlkUHpvbm93VU5lV1ZCc3FTakxoa0xGd0l0eDBC?=
 =?utf-8?B?S2krY0FCRmlKOGVkRU8xbUhRRkhEOWJNL0R3TGlwQWloUFhyeTNvNEswbmVH?=
 =?utf-8?B?djlFdFQyVlRhekNnVmFsVzBUcVNWV1BaUXk3eFV5QnFKR3BUU0NuOWF5UDBh?=
 =?utf-8?B?NkdTMzR2RnN3c3VETzI1RmNvVTlENy96MEhsOHBFV1FsdlNHdTJyL2JWN3Nt?=
 =?utf-8?B?TXI2Sm1nY2VTSk42R0NVa2dBZHd0RllteTVsSnRSV3I0MWdlS0JIWmloWnR0?=
 =?utf-8?B?ay9aQzVFbTdtVytBbDBITk51Vk5mZk1tN1RySWZaeFNRL0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTNRd3hPRXUvSE5IRXdkZU5GNzJHWC9ZZkdSZytFNjN0YzFCUHV6N0EzeHBL?=
 =?utf-8?B?dmtvTW5zZmwzcjBwOUIzNnhzeWxkc2lBQzAvczN5WE5sd2xCdFptUXhhVkts?=
 =?utf-8?B?MGh3UVNBN3dlZGROYy9teDltNGJaek9HaExYckhpakRtcFZlU0J2SXd6WE9I?=
 =?utf-8?B?N3FFaUJLdW5LQTVSdVFSeU55N1JYNk5HcXlpcWpyWHZlYUtKQjhQYzJpdGNB?=
 =?utf-8?B?MUwxekQ3ZVl6c2JTZFVUNnRFbGhQeG5HY3d1MGFVWEF2emVTcW9EV0xhUTVa?=
 =?utf-8?B?K055ZEtlbU45ektrUkFFalM4bWVodVUwYlhyQTAwbVJGeGRxVVdFbVZQSXZK?=
 =?utf-8?B?MEFERzRPMERTTzBGY0ZhYlVMMGtKMVYvZE9LVzFMcVdYb1cvM21DaGJWell1?=
 =?utf-8?B?RXRTTXpmWjdZVHJCUWR5MFZWRFZaZ2xuTzNSRERBUWk2UXJyTUtzYmdBSFZy?=
 =?utf-8?B?M2YvQ3NvbWRsSmNJejA2MnE4NGNPajJrcE53bWRsK3hjOHNtZ1F2UENVNHh4?=
 =?utf-8?B?NExjL2l5dUhicHBYMHRnZ2FGWkxTcTB2NkVBNTZtYXpEZUFldHBUb1pTK0Jj?=
 =?utf-8?B?QWxpdWx4QXk3NDVjL3JEUkFQUktqUXMxQ0VBZXdkaklCVWZxZlFhVytmdUQ0?=
 =?utf-8?B?SlFBTExaTDg0NEdrbTB0QmxLRkg3cXNQTzZ4ZzJ1dk5aM2dvUGlJVXBJam5x?=
 =?utf-8?B?TUlGZDVXYVdnaEdRK3l2QWp2ajV2OWE5VHphMWxYK29KYldPUVhDTy9yZkFX?=
 =?utf-8?B?bmd0V1BDMDczSGUvaWk2MTJRc1hIY0QrUlZKTlhkR2hTTU1kV1l3cFBCMEhq?=
 =?utf-8?B?NDY4SDk0TlJhMmU2azNQVWlDQ0lmQXFOcXNtT2d4UGsxaStOMzkxS3hQNmkr?=
 =?utf-8?B?YlVnZlpjMU1ZaldHRGVncW53ZVpxMmROcUczemtaS2RvaE16NENma2MzanB0?=
 =?utf-8?B?Z0ZjaXl2SFIxYWFXVldQdTdyWUpwWnJBYlpUbTNvNGRycm1ZTklUQmVWSytI?=
 =?utf-8?B?N0ZEckF3dUlFckpiczR3TURvVTAvSHduUVpEc3VOd3A2bWRueEZJSllJbnAz?=
 =?utf-8?B?UjNOWmN6VWlaMk1SWGRrYVJBR1hpd1R4MmdxMjYvZFU0c1JrTFFIMHI3YktF?=
 =?utf-8?B?SEJqSWpJVThTUDlMOVFkYTR4OHJsSkxVVk5heDUvMlNqMTV0ei9zam0wcjM3?=
 =?utf-8?B?SmNQdHlFU2hTVXh2aXgwYnI4Q3l3cHdFOFVJdXBRSkt5Ync1YzZqdTREUUpk?=
 =?utf-8?B?eDkrdG1VdkxuODRTa1ZLNG5tSFdyemVNc0FFWG9hK1dHQ0ZXemNpSmtVSVBY?=
 =?utf-8?B?R09iZ0RNY3ZlOElBWHVRUzNiZGJXWTZyZ2FhMEpFbEg3dzFZZGNqTUNEemxC?=
 =?utf-8?B?NDh5QzI2OEsybDZHZkQ1K3JXQ2hRNHVZTXI1ODk0MWZFWFN6UW5DUjVNSDlt?=
 =?utf-8?B?WFZRSXFaejlIdjdhWnkweldTakppSEVpNnpYZk5ld2pkNHN3bG1UallVdXpE?=
 =?utf-8?B?T3p6cml2WmpnallnaGJicVJ5MklCT0JONjUrbWI2T3NtSUJMejI2MUxkdHRS?=
 =?utf-8?B?am1NL21OTXFXM0hlZDdVcEZzRHk2OVh4dlppYVZJNXd5NVVkQzJ4aHhidlhL?=
 =?utf-8?B?LzhjSkMrK3lkT3JMTE9xaUFueDFPN3ZNd0JiNWgvY2pmVDhZWldBUzJlejJ4?=
 =?utf-8?B?SmpFT3kxb1k3alV4RUdBTmFVU0dsL0JOdHFsZEZyZWxMSkpURzhFRHdZU0p6?=
 =?utf-8?B?cEVianNlaVNQenpJYTZrWHgvVU40TDJ6cEhlSVVQbjFXUm4zbm9vZ0N4Z1o4?=
 =?utf-8?B?aFU1RGQ5QzVJYk53aUlLRDFMVEdCS0RjOG1yVWNQZGR6V21xcitaR2Npck5n?=
 =?utf-8?B?NmRhRExzaVFweGFzL0JYeDlXb24wK2JDQ096VmF6SjUrc2RMa0l4Z3F2NzNM?=
 =?utf-8?B?c3gvaTAzY0IxalBnQ1RNcUdCOE1UWW1vQjNhS2ZhRHhtTmROZjNGUWJ1S3JS?=
 =?utf-8?B?WGFPRmlqdS9Fek9kSUdDaHZsSWlxdzBxMmRkZTQ1VVZpZWt4UWM2N0pFcmtn?=
 =?utf-8?B?eERPMnBnRGJWZWlSNWhiNjJ6bzBSRVVJUnlwbWZnc2k2T0VyOWpETmdKbkli?=
 =?utf-8?B?M09mVzltV3hsV3VINEdveHpZVzk5QkdpbGZxbHZBOVRDcFZueUhlbFgzclR4?=
 =?utf-8?B?dVE9PQ==?=
X-OriginatorOrg: kontron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f4813c3-5e4d-4c65-97f8-08dda90d8d4a
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 17:29:42.9107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtQRV0G9mxha3C93vwueqV0p+3W2vBe8PGnmStso2+sYebEOxzzvMl2fD6b25n5ieAV4WXD0nGr7dC2RwP/tTVQrSEakNf2u0EsjQo1gE3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR10MB5793

Sorry for overhead, but I'm unable to find any answer to this question.

I use a diskless board that is booted from a PXE server and is mounting its
rootfs from an iSCSI target on this server running tgtd. OS is Fedora 41.

The problem is that on diskless shutdown/reboot, the rootfs is cleanly unmounted
but no session logout is sent to the server. So at next diskles boot, another
session is created but the old one is still there. As a workaround I can manually
delete these old sessions by running something like this on the server :
tgtadm --op delete --mode conn --tid x --sid y --cid z
I've found another workaround for that that is to run a logout from a script that
is run by the diskless board near the end of its shutdown.

But the issue is still there is the diskless is brutally reset or power-cycled
(occurs very often in the embedded world) because of no session logout.

I'm wondering why a session from the same initiator to the same target could not
automatically delete older sessions.

Also I'm wondering if there's some sort of timeout to enable to have old
sessions automatically deleted if the connection to the initiator is broken.

Should I really care about these old sessions or do with them ? The problem is
see with them is that stopping tgtd from a command or shutting down the server
hangs for ~40s seconds because of these old sessions.

Thanks for your answers

Gilles Buloz
Kontron Modular Computers

