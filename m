Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129268494
	for <stgt@vger.kernel.org>; Mon,  7 Apr 2025 20:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744057801; cv=fail; b=c5uQPopnvGdxOaBMHtwhK4pjpz7IDUYSAuIB+lprTHyMi2Dkq0q+r1eXcDOurPMAHZLowH5QwLgHMSlRZZ/RZT9DROKsvELItusKEiD/9SPAhqVZCSMkJE1aBgmvfZlhbqy0kNrdJ3zbDwk2hO7r8xnyc1vxalPVDpGThZhfsvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744057801; c=relaxed/simple;
	bh=oW2prsBdy+rZu0q2gZZINQGRZsU6W017ODxhkNGhjg8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DldwBxIdVJSxupFwct1H22Gyrh4zNH9nWbQe8lZT8nl+nUTkNB96jheN0dimX9N2oDGhcV/jv7XsPBIfjbziWLwVPOdTaBnznBdjnTu0vPvRS5H58zRkTpH+QB4mJsjhyEtwnnHcwigyqr2Q/L2ORaNmXPtKF99UuwdeoCsl3jc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tscti.com; spf=pass smtp.mailfrom=tscti.com; dkim=pass (1024-bit key) header.d=tscti.onmicrosoft.com header.i=@tscti.onmicrosoft.com header.b=aTchYvoC; arc=fail smtp.client-ip=40.107.96.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tscti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tscti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tscti.onmicrosoft.com header.i=@tscti.onmicrosoft.com header.b="aTchYvoC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tf2RszaqzPRFopDi1Vhtyv67Wpv1FdNWVzk2WDqkzrHeD3YMyDrstGcm0JnfocOLKqivTbBKO8t2hxEww3JJe3b191TmQ1+wPHmgjAiS4b2ehKXekAaddathPP1Rv1cJCRgLPixzrv8USRg0kUGep7+/a3Sc3qj4Zr3P6mrS/n8YiYhq6/oELyKEi8ZyzHWzZiYqGe3o4MEO+5qUNAzbtADKkWSanbh2tBaQm0oARR6AUq/oO1ZXtvA9ZsLkwpEDQe+6A6+tPcRj3HUykynJl3USC4Yi+lE0PnngZIbBQwrMvK9pDvSZglUqxt+zhZ7aBUx1kuojSfK0Ezv76EJWmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B28QX0iSXb01AqR5ym11eQH/gAKB5mr1LVNNWKYceIQ=;
 b=GUzCoqdD0vOTQkQpyfP/gUupas6kK8rDRYxSblFut5Ej1vNI1kPtW0CLpvv47JgRf74dj+4Q7ImRhfDk2hogrJXmMfFmLBx0S7AbMKefbEuATeCF3fpp8jtNyyyxPZgfARYhM4OotIOluLWx4U3AiFJZYseNScxIf5sECRj2qG3Py4UgLr2orm1RtvhABsodjNzA58yoDcV+tcYCHUU2XmeifWep5WIAZs6H4TcOIw0knmesJ/bJCCE4ERdqKSW1WOYMsu2+DSBRniGMN3N41BGkW5n77lu26A72kekRslfsgZWkjKTj6WXgliW4inPRgV/ne03rM1qM9EKWDK4hbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=tscti.com; dmarc=pass action=none header.from=tscti.com;
 dkim=pass header.d=tscti.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tscti.onmicrosoft.com;
 s=selector2-tscti-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B28QX0iSXb01AqR5ym11eQH/gAKB5mr1LVNNWKYceIQ=;
 b=aTchYvoCaK+VaUdJPzI1ubs+CdjTOcyqq7DiF8BH+89VuOEYSQA0fdRUPN5JhcqUM9olO2w8T5RO+ehPyhuynyC5NU3cwk2vI0YX1CNUOsdiSgHUi1ThAtxshAKn4HN8GDl20ctf5aZ69MYuVZ6vPyIbZWnG3haErBQoP/SYIwU=
Received: from PH7PR04MB8484.namprd04.prod.outlook.com (2603:10b6:510:2a5::14)
 by CH2PR04MB6807.namprd04.prod.outlook.com (2603:10b6:610:a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Mon, 7 Apr
 2025 20:29:56 +0000
Received: from PH7PR04MB8484.namprd04.prod.outlook.com
 ([fe80::4f86:9f17:4a49:5c28]) by PH7PR04MB8484.namprd04.prod.outlook.com
 ([fe80::4f86:9f17:4a49:5c28%6]) with mapi id 15.20.8606.029; Mon, 7 Apr 2025
 20:29:55 +0000
From: Matthew Patton <matthew.patton@tscti.com>
To: "stgt@vger.kernel.org" <stgt@vger.kernel.org>
Subject: systemd files and tgtd outer loop
Thread-Topic: systemd files and tgtd outer loop
Thread-Index: AQHbp/ukowB1Qy1iDE2quC/8EU2ybw==
Date: Mon, 7 Apr 2025 20:29:55 +0000
Message-ID:
 <PH7PR04MB84841816D3D3C4AEA301606384AA2@PH7PR04MB8484.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=tscti.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8484:EE_|CH2PR04MB6807:EE_
x-ms-office365-filtering-correlation-id: d7e00ab4-3848-430c-1438-08dd7612f5a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?Windows-1252?Q?2FNhHf4jtX8cfynzorTW9YeFAoQYt9+Yc5KUC66GSU1XgeDxSuP+0jWr?=
 =?Windows-1252?Q?oQwspMOCFITdujXwIojYcqEb1dIgoiu5YLpJH1B4e68u82pF9dmvLy1C?=
 =?Windows-1252?Q?PtxRYHilNri3BHo2town2yLPcqNpPrBh2YTJlXwY7QOsv+7xrWCSzOGH?=
 =?Windows-1252?Q?2p78/Jj3KgpGSwX4TrYFi5lsQH+0kVCMJ988GxnZmTIwH1KNv5qdtY0s?=
 =?Windows-1252?Q?hhHf0GWlVaI9OQDbkQKNx2NakrzJkAiKWDEgkET3l+JZ+RN2UmPlPXQc?=
 =?Windows-1252?Q?ezKW/d6IwJZX85RA2hNH43YlIPYFWOWHW8LTC23ubf8+AVYOSlcVur3I?=
 =?Windows-1252?Q?v9uKd36lV10wZLo/AEJjJqRp0ErokRG7Ay7RnUvxhZZtF1RanQ05Xi23?=
 =?Windows-1252?Q?X+SeSU+YgHQOpOab4xAzSTTF1j1MU4sS61CDDWSC/VLxmmCw84JCzhkM?=
 =?Windows-1252?Q?mIaCg1THovfY/gZQ4nzxheyHc8HI33L3zxU6+xHnYpF3A3iIFQw6zrrA?=
 =?Windows-1252?Q?gFfXzpVE6GW9Jpq10cBdFy6OUAe6Iq30PWbXaxKe2rJ6ym1rGqdG1B37?=
 =?Windows-1252?Q?jBypfEKVmOaQYThkiqAaCNZAcbWaLs9TvkmUYTQ7k5KYYjs16hFEdtII?=
 =?Windows-1252?Q?mT9SdXksLLbW+akYxd8sLBsXiXFhnpe/0lP805NLmsfpGjNQccgucmFE?=
 =?Windows-1252?Q?P51cmAKuRUiTTpIkRib4WELZcWPQtTN23k7K1Jjm8GQih9QRvtEx4N3/?=
 =?Windows-1252?Q?yQqwoUFNhZdKOf4mGIwX8v9g7eiGJ6LPFRUIEEitwxfvX2aJ+6deC078?=
 =?Windows-1252?Q?u7mz0/mcWTd3REDYfDcm+O9IYDBDz7LPoX5xDUXysCbsp2IFmEMfS8PP?=
 =?Windows-1252?Q?twHqeQv81aT01MSLrj8jVhw2Bm12WldzDZuua3XlyyVFRRLVUBk3im67?=
 =?Windows-1252?Q?Rt+jnUVScyrI4tazcyISz8sbUwZn1YhqI5Mq7/7m30Di8uFsD1C/rNhD?=
 =?Windows-1252?Q?wlvV7pStmnF5mMgYUjLc2uZnncdGi6OjNYfPs1zI5cb1JMr0FmdiawX+?=
 =?Windows-1252?Q?vBKfvxPju3UH7K+gVk/gk99LXnnplSGzauAi/jGyuKnkOAZNOV/1Hlvf?=
 =?Windows-1252?Q?fgNYMxiuxmvwz7sME8D7b0fftB01Gl/16M+LWgkZFUCA/X421e1NxiNq?=
 =?Windows-1252?Q?DHdavAzLGP2u/lkULr3l8GudRpGJUJOlCLne9X8UtzQXkc4JGhwKXyus?=
 =?Windows-1252?Q?eC0/olmQDbpgxu64Kl4O1Vias0e1crghcgFo27VUk15lKAGFTukAgGt5?=
 =?Windows-1252?Q?ieb0onUhJAutd+AU28QnS3bk2nqQmXhkPkBIFa1h+BPeqFGduuRplQyP?=
 =?Windows-1252?Q?yob6Pghe7ns4+QeijaZRBJAcKQ8wivvseVM/tk/bvA4kgOPqdL+l253T?=
 =?Windows-1252?Q?J7iU4rVMfy1HjZrMxpEq4zmoOf8irntwmtJHUhIQzr1M7Nmaw3QP+Coi?=
 =?Windows-1252?Q?Jyjga7tD+ZmtYDUGKtnYKxVVZW1A2YOsFKkWIha/MPhaOtoS8Xtim5gf?=
 =?Windows-1252?Q?rYuV7NaWL+nVMmbd?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8484.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?iOFPr1iw+2edEjEOf5RjXuGpUMqkfU3RiMioE/cwBXb/QCCSjW9I/LQV?=
 =?Windows-1252?Q?yr7eXutmq5HUQaEdwArOmOydSqB9aW0U9ODdNQ++q1o3cs03NkHi4Nw8?=
 =?Windows-1252?Q?nAjXp8L+d+Fb4hzVtZOEoDzvT8TTvd7eO/pQdvNeTBS1dBXPCjktoPk0?=
 =?Windows-1252?Q?4ooLCcRPgetOcRtrausUSHGkjOM4DcKE7EU4ThuLmqzMqkAN6v04PLuv?=
 =?Windows-1252?Q?LRMgDCp09DqvyT/Qi7ztrhRC1xzquy1LCAa7U63u6qOqCVvoLXLSEFkl?=
 =?Windows-1252?Q?Yorv0RBhPpImM1+XL5AqCghCKcGhSvUa79cFbYElqZJBwWtckl2fbU46?=
 =?Windows-1252?Q?OXGgdRkz9GaCcPeF02HFjhcREV4gIR/YFH8zmOqsXu8GWSbxVJc042Nr?=
 =?Windows-1252?Q?yLN/zfHXxZuEMtzt4EpGVu0A/ywcw20Yq2fP3bQfn+Op5LqViiopzPzn?=
 =?Windows-1252?Q?U4McZqmVgc1+ybtGRGJcN8G8it1ijd87zl89/XFH5V6CXy/pVY167Zt9?=
 =?Windows-1252?Q?FZ136FlwYNFw9AJvjiUq8D7Gkcq7s0+RJOeQs80Se9gByykVsHtqhI8n?=
 =?Windows-1252?Q?UuYOtiTGA0Dmlr8nzkA54xHPIXyfU3+lhoWat9NkFujyQeHj5aXTmolw?=
 =?Windows-1252?Q?87DBbwwF7JagoMU6oogK5W4p+emZs6nKjRUbvxsyU/RdR1Ic2bFXmXQ8?=
 =?Windows-1252?Q?IOhDcRn8ElKYwU8l4axHNZJ3FNIZrAoF5vGsC9ntlJxt3tDw+VFAIv+G?=
 =?Windows-1252?Q?NYJ7gaEXqF6yJ6+HEswGGe4Sc36WZpx9whJcQIl4KAXkqGFwHcu6oClS?=
 =?Windows-1252?Q?BEggyzZzVeoR5naVu5SPOgRf4EQbNf3vttsQw7jowpLaLQ/L1T6vESK9?=
 =?Windows-1252?Q?RnJto9o9NKhMm3lnvPxmU3CSbxK1Z5ovUECp4lE7v2VQYNShiZOjKvpx?=
 =?Windows-1252?Q?OIcnPDBTXD8hUWhNWh3qC2NGRQiP/jkeflA0RwLYMaMpBR6GQjp3zaZS?=
 =?Windows-1252?Q?jYynbetHPFEhqNBfr6nF7ELB0mePpE8Vw46XQYC+xTD93ZC5RXGg+SbF?=
 =?Windows-1252?Q?djZQSYdCvIOWsEQ2QltO8t9iLbj2c9YPF/rDX58K8pMhMuoIWrt26VJ7?=
 =?Windows-1252?Q?a4DmBebj5F4HkTJiHmylVec0wORJLyC52sqjvD365FFF4C5lmTMifq9d?=
 =?Windows-1252?Q?cu2oAJ0lyMDDOHVH9iZq1doh/NGmFjvN9WNoE8aSWjgJQsMwbCpbgt3S?=
 =?Windows-1252?Q?S6Hia8cfjDiSHDUDd6lRAn1pCnQ5kZ/sxVArjHlkSrEwExlN0yjiNSbq?=
 =?Windows-1252?Q?XprQmmeCIwyTY4UURHLHTvkGCa9IksD2SFiu//kRHJdmoFLG7lh9VHgE?=
 =?Windows-1252?Q?xdvTkRY6CEekLoq3EEK8P6Wc8r8pirotJC8nqOHVklx46UURf5fx15en?=
 =?Windows-1252?Q?IBazeI6SexyTRzx+7RJUhijbqn57SaZ3KO5fhSs/1jUngtVt9c4f3jND?=
 =?Windows-1252?Q?DVwAilKik+/uTZw70EAlJXt4ZizG6y4onGi11pWN3YCP74eEHWHYQCjU?=
 =?Windows-1252?Q?MTguK2xSLtoa4dNbhHoeKkbt7vdBnEGk1H7HKXj56mIanhF1yAkxJuuj?=
 =?Windows-1252?Q?RTE7Bwpg0QLI5JuXuRjxAC5yqpZqdUcocgq9vVy5q2QGBcr2UI/4eQHD?=
 =?Windows-1252?Q?C6GWAO/Hqi3OCpOcoYsyzVBwC5tZ3zMS?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: tscti.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8484.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e00ab4-3848-430c-1438-08dd7612f5a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2025 20:29:55.9151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06a0a9d8-beb5-4943-9136-d4f893a1f4d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BpWLS6398bKzXCW8IbduVLGYMnPTpAZsbq99uEb64hztobqrVATuD6HJmWIn6xmgxuljA5zSn9IW4VWhy/UQKkRQPBOFGFoC4gZnS5VRSy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6807

I'm using as-packaged in Ubuntu 24.04. But reading tgtd.c I was struck by s=
ome of the logic.=0A=
=0A=
while I get the purpose of sd_notify(), technically and from an ordering pe=
rspective, shouldn't that be  only when '-exec' is called later on and targ=
ets are defined? Or are we relying on one of the 'ExecPost' actions to blow=
 up and indicate the service is failed? But isn't that way too late? Downst=
ream dependencies have already fired.=0A=
=0A=
I'm assuming '=97forground' is chosen in a systemD context is so that logs =
will be picked up by systemD. So why not #ifdef USE_SYSTEMD to also emit th=
e PID to stdout, if pidfile is undefined?=0A=
=0A=
Also the choice of LOG_WARNING in log_init() is highly unusual. It should b=
e LOG_INFO if perhaps LOG_NOTICE. A routine message is never emitted at WAR=
N.=
