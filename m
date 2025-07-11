Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021134.outbound.protection.outlook.com [52.101.70.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D806A2D0C6B
	for <stgt@vger.kernel.org>; Fri, 11 Jul 2025 12:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.134
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752238537; cv=fail; b=qHzjE9IqYnDIUTdKe4ozkUK7zPHEZSrmQsqNX9QT1+8SulS/sfjCkBklN7VmbfvhTt/Zj6bB641WHGsooqHYSOCgOc+wHPh90nnPAsVbv9V0FG9Oakt/NpSY7bSkyZllnz17ylRFjJj6L/l+Ar6tLFQjfmkca19Wylv2hQKArg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752238537; c=relaxed/simple;
	bh=qwWNBUtEkeLg/ojaMooIAqwAJ+WVuLcu9fpR2lI0OBQ=;
	h=Subject:From:To:References:Message-ID:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=SDlJ97L5T6dQzCa6QvrICUPnVityGXw9RGer1G6dG4jD04c2xgMnWY7+CxJIBeN39PuddNaYOkRVtFiZ4JK5PEes06BA6F7jNI6dDHEZfgPWjUx5BZ/STaixhX5dKj4uFqZBI+zFr1omagZu6b1DcmP+86i35rMWuFEvHDR/z58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kontron.com; spf=pass smtp.mailfrom=kontron.com; dkim=pass (1024-bit key) header.d=mysnt.onmicrosoft.com header.i=@mysnt.onmicrosoft.com header.b=DkvatUFE; arc=fail smtp.client-ip=52.101.70.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kontron.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kontron.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mysnt.onmicrosoft.com header.i=@mysnt.onmicrosoft.com header.b="DkvatUFE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MB1IYIkkhQ9EyFTa2HsXHsIaYsJPa7KXeN3dJ5mkycouTly9m+BZGnEhJfJXXH6yy+S1NAOTlBZNYdZ7jRCDRQvE5I21ENUqIW6twIrG6070RqPl4XVefOi/8BH8uP6J2CWfcEFP66AqlKdcDuD+S3jvWOq1y2JPLz7aOpkEad5ddObjbrQNDSNO0vdIAn1P3WSMGvDgqFBN3HvXZhynclh+SUQ/3VnV39XE+EiNTdQ2RMExpUKJ4O6ECEoE27HBSnxY/kARyoxzK2JO7W97gS8L7KbNTStzuZchPild65GCOCUpXqaG9CsLzj2wvqNWec6JNvvlW5uM3LlG5beNCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwWNBUtEkeLg/ojaMooIAqwAJ+WVuLcu9fpR2lI0OBQ=;
 b=FMn/pusB6jT2iY61DIZMKJm/1vmcr6O5S4yn/ojU1J9OdYn5qtjHg4Q6DpN/7JRKhz+lHcreIX/MYTBZYOVqjNkgVhqQkaDQHAt9YBcugW61rSTxzXG1Mz8OwpXNi+aFqBT0fvW8J87dzOh9rd5NYFWXgDFUBI2aljc0tWwExLd6F5iyM/VOuOjy3dQiKLZ+9LSpvqJPqoJHAmJXUcVbbEIopSpO3DCffNzNUUOkJ8KDuY3R4U5k/hj7gyE5UwUwheAE7BNQ6yrGD7B40a7Fpp6TL2ZIKViNtNTc6IhTpdB1pSgBjqyhTNBEcz5H0C370cTW88sU4LDVvbwQSycgAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.com; dmarc=pass action=none header.from=kontron.com;
 dkim=pass header.d=kontron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwWNBUtEkeLg/ojaMooIAqwAJ+WVuLcu9fpR2lI0OBQ=;
 b=DkvatUFEdTNWaR6fdCK1iuUz6sbPzY9Sg6MC/UCbWtjhTmLX8kSByCladbpyvqq0Dv7IO6gjHFALLaD/DeotFq/s4uHkI9GEMPWzaxhJKUj8Yp/sXGNWuS0QtFWyLlVEsew8ivW4ePu89tQ7gYn3QvNGwUmdcA/g6PQgopPfPfY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.com;
Received: from DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:3ef::11)
 by AM0PR10MB3522.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:153::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Fri, 11 Jul
 2025 12:55:31 +0000
Received: from DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::142d:c1aa:6bc9:ca4]) by DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::142d:c1aa:6bc9:ca4%3]) with mapi id 15.20.8901.018; Fri, 11 Jul 2025
 12:55:30 +0000
Subject: Re: tgt : handling of missing session logout from initiator
From: Gilles BULOZ <gilles.buloz@kontron.com>
To: stgt@vger.kernel.org
References: <7715d5af-f8da-069a-7a13-4a7312f8f6a1@kontron.com>
Organization: Kontron Modular Computers SA
Message-ID: <4bddceb1-fb09-1a71-a4cf-44665d467d1b@kontron.com>
Date: Fri, 11 Jul 2025 14:55:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <7715d5af-f8da-069a-7a13-4a7312f8f6a1@kontron.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PA7P264CA0342.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:39a::12) To DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:3ef::11)
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR10MB6252:EE_|AM0PR10MB3522:EE_
X-MS-Office365-Filtering-Correlation-Id: 62525dbf-a991-4895-868b-08ddc07a3757
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3JYU1JvTzEySnZRb1dyWUdiUWEyU0R0NWswWjNIb2podUgwZ0JrSnpaN1dT?=
 =?utf-8?B?UGs3eGhSTEpMQTNMYWJycGVTd21Ddkp3RTBOaGdvVnoxdXMyYTlhQkFCOVRF?=
 =?utf-8?B?MGdUcXZTc2oxMndTQXdWV2FQV2RuL3ZFcDVxNjJHNitUYW5YUG9iNVRWbkxa?=
 =?utf-8?B?eFVtVlVRNEcyZlZaVHd4SHdVYkxjbExjUHorQXBsdVZ5MTZYWmFjNkFNRmEy?=
 =?utf-8?B?ODgwZEdHUmlBODhHKzIzWVFwbGpvSCtQKzZQcXpGQnk5QU4wZGZrVUZVZW5q?=
 =?utf-8?B?VHdNRkhFQlV4MzVNNGJKL1FLVDZTNklLZWZuVDl6SWU1cXBLVVAzZGZmTDdD?=
 =?utf-8?B?MDhENGJqUUkwOUxoNkNxQittQ0k1YzVSZU5CcGpXY3FIRS9rbVRRM2RCcU81?=
 =?utf-8?B?enVrNExRMXFLSDZWOGhhMVRnZkVIT0tkZlY3TDNsTW5rYlNUQllKNVZ1MC9V?=
 =?utf-8?B?NU5UN2FIVHgrUzZ5dEZwT3Rtelc3SmF4Vkk2bC80UWdBOVBCNDRNTzJwa1VY?=
 =?utf-8?B?d3krNFZRVUxNVGkwQ3hBcEtYek9nTFdqcDFPNHpMZGhRekE0c1NWeDFmS2FM?=
 =?utf-8?B?dEZ4cWtPK3NNT042QzF0Nm9MK2tncSs0MGdRZUFDN2tEenh4d0htRW1EZUtj?=
 =?utf-8?B?ai8zd1lLQnBzZHJXZjZYV0hRc1hHaWRaeE1ia09tcldLSTQ3Skc2Ykh1NlJ3?=
 =?utf-8?B?TkgvMVdleGFHRTR3ZW5KUmtQM2g1MElsblZ0MGtjTFVPa3VPeTlDWkpia1Jt?=
 =?utf-8?B?RnJMV0JCdXp3WWxBblB4Y3VFMFVLQmJBakJ0K0w4N2pINnlHejBDU2JIdGwy?=
 =?utf-8?B?aWVvTmlEVFh4S2pKTXpxa0dzb3pPbmxoaGdtWlRsM1d5eGNYVFVVZE4xTzZV?=
 =?utf-8?B?aC9PUFJwa0dBWHlTOVEyaXN4dVhJZ3YzWkZyQlowVmx5cUlCUUJGMlBzVUV3?=
 =?utf-8?B?OGozSXhyVGkzT3JJZFlWM2VORXFFNEpLMk5GQ1VGU3dhQ2RIWUFPQzNXRUtF?=
 =?utf-8?B?aVRsTmtzN29QWXJJenF3UENnZFFXaFNNK2x1akNGc3hUTVNJb3FndTUwR0k3?=
 =?utf-8?B?clVyNk11dW5aOVZ5Z3hBT2N2cnJkZHJMR2lTbnQ2M1JwWDNMM2dTeDF3THlT?=
 =?utf-8?B?NjR6RVZLNkhsRkNTR3EyTHFtTVU2MDZreUkrSll3SnBRRVhPWDE0QTZJMlBl?=
 =?utf-8?B?NmNEWlU0alVFcGpPWjV0bHNSRkwxcXJGOGc0S0xEelV3eFlxMk8zci9ycHoz?=
 =?utf-8?B?TlRsZytGWngrcE81cTRXTVROL2lWQ3R0bnhpRG9oUHQybVprVDRGQUJHZzNX?=
 =?utf-8?B?eDh1L3RUaUM3bFV5T1IxaDBJYW52T0tmZmhadW9RbGNDUGVlZ0Q0M1JqdytX?=
 =?utf-8?B?dXBIWDIyVFhsSkFIZDN4cUJ1L3RCaGFiTHYwSTF2OGlWVUZPSTExSGFYaTVT?=
 =?utf-8?B?Z2VIK3ZBeWZIZlZnRStvM3pMTzB5S2k3Vy8vVGY0eW1qb0dodHo4NnpSL1c2?=
 =?utf-8?B?a0xLV2FRY0ZwRXpIYlhyYWhhRDJXVXpMbmFPMEpIaEVIQmZ2VE1XZjVtNjlm?=
 =?utf-8?B?ZERtalI0WXJkM2Y2QVNPaWp5ZmdIdkx6NXd1YzFMUVlyZEdESExWbExuOEd6?=
 =?utf-8?B?K1B3VTNrUkNNeWpsd01ha3Q5ZW1oV0NLU2lPc1haYWJVS29QNXJQNWFwajll?=
 =?utf-8?B?NDVFS2o1MjEvUW1YMmFoRVV1ZThtUWJZS29pWFhWOG5scUlhcW9mL1dRbWhC?=
 =?utf-8?B?RHArZ09uRHhFalMwTTdzVXRoVTNaanpWMithRXlkaFBocUVZM243UzdaSy9h?=
 =?utf-8?B?TGJRb1hjMzdZejdHSW5XSDR5OWtBODdncC9ZSjhxZ0xFa2xGZTZtNGsxbmJl?=
 =?utf-8?B?Mlg3ZDFZUEpSYkxMdUNtek9MQ1NKY01aMG12SUU3ZCt1b21tOG1sOFI5UDNw?=
 =?utf-8?Q?z+ZD8Grk+f4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTVwQzJveFRYVlJjZHFkc3NiSlZwWk5xZHl4QU1WQWQ5VVZDWkxuRnJXMEVi?=
 =?utf-8?B?Mk5jak54Q081TnhETk1HOGJ4a2V0MnErV0Z6WGd1OVo3NDJwV1dhTzBvSmxp?=
 =?utf-8?B?bXFncFE1aXA2Vm9LSVlDTkt3cDZZemlXV0FOWFEvTitid0tZN0d3allxb090?=
 =?utf-8?B?QnM1VHc1aXgycTdrL3AxMFA5aEE1SVE1UURBTU5ad3RIQ2drTDA4ZnYzY1RY?=
 =?utf-8?B?V1NVdGRveDVqdmc1UEZvbmJDUWlvbzZvTy9ITXN5TTYzVEZNRUdObEhOakhG?=
 =?utf-8?B?Q29nK2JZeEYzNDJaVkVPRCtON05QU3dNb0s3TEwwSmtPcXg4VlBFSjVwVjZ2?=
 =?utf-8?B?Z002cHJMQmRhWjFYOEtFMUtIUUZaZTc0VDFRUitaWkl2YW0xbkdZYUF4L2hR?=
 =?utf-8?B?ZStKMXpHaSt3QzZocWRKblg3TGFlYi9PaDRWUGR5K1h5cWpTNWxsZ1pkMCtF?=
 =?utf-8?B?V0pabWo3dHZZOXNpLzVlMlMyYW5FMDBGaWNyQThETE05cFRyR0Jsdm9VWnZB?=
 =?utf-8?B?YVRKRkJGMHEvY0l1NHhtbnlla1FPZUNWNmM4RzMybG1BcjBqbEdOMkNJNzBy?=
 =?utf-8?B?emNNSjhDU0kzN0NnWWNlVGwrWldHWGlCWGJaeXdyMXJzQzJmZWlyVytEanc2?=
 =?utf-8?B?YXBiUVlTUHVZSHkvT1NpOXZHYzd0UFRWTjNQb2UwZkt5V1UxV1ZJV0lIL0J5?=
 =?utf-8?B?cXpMVEw0aStPa0E2OGN5RHNQcmswNTRERlorZUNQTnRRSnkzRUhlb3RZUzNV?=
 =?utf-8?B?eExFc3JWL1RtMXpOWVhrOVJqVDZTdjhNV3BiS2cwbUVXQzV6aXlGTC9Eb0pB?=
 =?utf-8?B?Yzh0UzV4R0VIVlpiRFVBSHBHQ3lpNlJobjV1OWwrL3pNVW9OTVRwbVZIYkZ3?=
 =?utf-8?B?MHpvcXlqeEJjL2tLeTJrb0FmRnNKTytCMnlibm16ek43K21zL1dtYWZzd2JR?=
 =?utf-8?B?ejZQWmx6UEcvV0ExSDE4RjRidDhZWk1kc21IRjRHS0lnRUFyMjVmYkErTnQx?=
 =?utf-8?B?dndwWW9McmtyN2M0Z3dOL254S0dKZVp4Wm05NTVIMDVrUU1UYVhnTU1ENlJU?=
 =?utf-8?B?Z0tiZks1YkVkcXZBNVdEaGcvSVFjTkI4RHlJZ1ZyMXFXWDVMYXdPTXlvdDB5?=
 =?utf-8?B?emJqOVB1bTRwZXFEaTU0SWk5UlIrSEhKMUlYWmlHZmEvWXErVUZSMXRPZ0g3?=
 =?utf-8?B?eFBuK2FlMmtlVEhIWkpLcytxTlNRUXducHFPTmkzKzRobUFqeGxPVlhFVldu?=
 =?utf-8?B?NlhSd1ZqUWxHc3dkdmR2b3BXVmdabDRyYjdKczFacnNWVHJlMW9CZGRUc3ZO?=
 =?utf-8?B?QlNhblhTanJORGdkOUludHZoNmpmOUVlMSsxVTMyS1dvaE9KWWVIbUhuV05s?=
 =?utf-8?B?b1h4b1RnUlpOMzNEa2NJaWx3UG50VDJmVVhHT2lPZmtKSHJLZFhtZElNRk9T?=
 =?utf-8?B?QThSS2kwSlIwUWp2UksweDROQUw5cEV4OWxQNktuejhxOUdMbGdqQXFoUXpS?=
 =?utf-8?B?bzlRYnYzak1GMy9XVWw3UWNsdkIydlc4NEJQSVh5N1UwTkxXQ0o0disvT0RZ?=
 =?utf-8?B?d1pGWkRuQUtyNWFaNWhFU1JpSUdrRTF3QXM1WHhQTkR0ZHVLWEJTUEpsdmJj?=
 =?utf-8?B?cHpvanVRMjl6QlV5czBPMk9acnVtS1JnWjRWbFpMNVF5MldQYnJSenFJbFRm?=
 =?utf-8?B?dWFLYXdOdnB1M2pyelNKck56blVTUWVqakpSSERHSytGUTNpTFkwb2JWV0Vh?=
 =?utf-8?B?VUVaeDNIbmNHem4rWlhCRmMxMXlRVUl3d0JpZDVnWUpSSHpWdzM4OVU5aFRS?=
 =?utf-8?B?V2Zram8rSVp6QVdzbXEwVUJWNUVNYm42TDh0VmNESmx0VTZBYTMyL1g3VFh4?=
 =?utf-8?B?Si9NclI4TFFTenV4WWU5aDRFMlplNW5PYjJiOU03MFplcTIrZUlkd0NTeE03?=
 =?utf-8?B?RGpkSWxaUFVoU1VhcnZZbVZ4ZkhGNW0ydFU1elFxNVhNMVJpWDJ0cFE1WDhH?=
 =?utf-8?B?dGFxdDB0RWVwcnBlc3BmT1d1TW5nQ1JXZHBMSkptVmxBK3IvVjdBWGNDWHZO?=
 =?utf-8?B?Zm9scThYaVJheFd5N2R4akRNUURYL2hOSXBCMGFvYUFGWVg4VnB0TzF1Z29t?=
 =?utf-8?B?Z0lUUlJ6N0c2N3VJcHA4V1RJMWR2a1RnWUh6YXdYWnhRVEp6czNCUTllWG8y?=
 =?utf-8?B?Znc9PQ==?=
X-OriginatorOrg: kontron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62525dbf-a991-4895-868b-08ddc07a3757
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 12:55:30.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtpxIW39FLOFgP8l/XeVUJKW6ee+loJ8UZKH4OjWxDbonMUHEk367NXJWdlSpjRY1pGmisy0vFOkm0nWaIl09n34hlGc4BhKwKqH1YmaEdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3522

Le 11/06/2025 à 19:29, Gilles BULOZ a écrit :
> Sorry for overhead, but I'm unable to find any answer to this question.
>
> I use a diskless board that is booted from a PXE server and is mounting its
> rootfs from an iSCSI target on this server running tgtd. OS is Fedora 41.
>
> The problem is that on diskless shutdown/reboot, the rootfs is cleanly unmounted
> but no session logout is sent to the server. So at next diskles boot, another
> session is created but the old one is still there. As a workaround I can manually
> delete these old sessions by running something like this on the server :
> tgtadm --op delete --mode conn --tid x --sid y --cid z
> I've found another workaround for that that is to run a logout from a script that
> is run by the diskless board near the end of its shutdown.
>
> But the issue is still there is the diskless is brutally reset or power-cycled
> (occurs very often in the embedded world) because of no session logout.
>
> I'm wondering why a session from the same initiator to the same target could not
> automatically delete older sessions.
>
I'm still wondering that
>
> Also I'm wondering if there's some sort of timeout to enable to have old
> sessions automatically deleted if the connection to the initiator is broken.
>
In fact there's already a timeout set to ~1 hour.
In the worst case, if I do boot/reboot loops and depending of the boot/reboot
speed I end up with ~45 sessions but this seems not to cause any issue.
>
> Should I really care about these old sessions or do with them ? The problem is
> see with them is that stopping tgtd from a command or shutting down the server
> hangs for ~40s seconds because of these old sessions.
>
A workaround for the ~40s delay when stopping tftd is to add "TimeoutStopSec=3"
to /usr/lib/systemd/system/tgtd.service so that systemd only waits for 3 seconds
after the attempt to kill tgtd cleanly before killing it more brutally but
successfully.
>
> Thanks for your answers
>
> Gilles Buloz
> Kontron Modular Computers
>

