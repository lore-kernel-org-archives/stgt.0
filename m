Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2471B963
	for <stgt@vger.kernel.org>; Fri, 16 Feb 2024 10:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708077698; cv=none; b=OCi4D7qlJBpaHh5ngAzpEoCfSZojNnMq1Rr4/0MUPRk2SoAsCXLVkCYZnKneaBBdWbT5ZndSh7WJ9SndhhPsmCy+UjqR+GREF8ee8BwcayZ/968Kd7uV6m3faGRP4naUWFT4ivsbWJf36EqwScL9Xl7qT5Gpe+QBFV6KaVVYrc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708077698; c=relaxed/simple;
	bh=/axvw9iPJcZYAuR3TwP+Zf+CMy1ZsBAUzviPrUj0eEA=;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:
	 Mime-Version:Content-Type; b=s9V11slGsgoLxgT6AROceDi54Mm09iJ1z87ySEvHz5kywy25/xS7w8K9ailHDvnzxijXn6WFrXZazuQbIzEi7hpuVv0WN7j2ZYPC4sGWC3es6V8+K4gmePvqNSBSF8HExLYskPbOl2sR5eavtHI4+A+7gyRucSsOHiODIdIAppw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gjyynqdD; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gjyynqdD"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d3ae9d1109so2485995ad.0
        for <stgt@vger.kernel.org>; Fri, 16 Feb 2024 02:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708077696; x=1708682496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/axvw9iPJcZYAuR3TwP+Zf+CMy1ZsBAUzviPrUj0eEA=;
        b=gjyynqdDQKqHS1WFtJ3CLU/JIncvw7R2C9OIyikZ7bY4PbeFZC/8Ei7ki690TR+yXG
         4o7ChPVYzrIB5hjPueIfyGaURP7aKXOSYs8kZJqX1vK5SUkwrcXtUKUh+lRYik6uXtSU
         2dQqODF425x73lPsso2+W78gCrpzEbKzD6lw1+NVas0BN54ZA+dZ/UV1avYropd+CuRL
         id3JcX/ys8jLUrpADl2dxIBx6MxTUHD22Od8FX5OJ30TuJjDtSKemdt3T5aFmIjm4k6/
         40zBKxHQdHqpug68d7kWCROqZ8WEM75vCJxjmE5rNE8GdIWiFluKgWj5fFrZR4JAPyny
         kP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708077696; x=1708682496;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/axvw9iPJcZYAuR3TwP+Zf+CMy1ZsBAUzviPrUj0eEA=;
        b=ZpqN8RSazOgxEWegfEZzWLy+zpxQMzTbFyYUZerK3WPHiLDGtm9c+EvvZQw9CNnYL1
         wptvgSHYt4k+cDKOp5E20Q03VdK4/q6KBBh+rGnaodZNpc7eoSHpcRj41qojJ88irieK
         8JlRK2ruWDl+fyqia6f0OZXvIfRMcVhPKwuk3MolUPSPpdTlI1oWw1m+j1aZDAGKyvnN
         Bcr++OkaMoMSAfjIsrs4/2jPCge3VQJk+93HjC9cyz+JabSC4hFlnO2Unzuxbcx5HdyT
         Ama5isHk21tzvv39IfHjRL58NnoaIYKsTiPQMpNeN7m2HtlridIXuU2V2ktaDm6TiY9o
         7E2A==
X-Forwarded-Encrypted: i=1; AJvYcCVUyOXnkmSfnBIoNYZ6FSAF2XyWAj/SgZ9uRZPmjHz/DBdPVg8yeNNJKsGmntxgRnSogLngnauE8hGUB/m622RllJVXNg==
X-Gm-Message-State: AOJu0YxGzQAyq/tpWToVPC+yt+BOhyjo3w09AB2YLDycrl2doQJ3X1Tg
	VbEsbyTSavqlSaqGbaitdE8KpF4OBOGCDqTB0T2RIdF9IXWlwsIK
X-Google-Smtp-Source: AGHT+IGi+NDOICo5u8Cj6VL6q5PumQAquowmwmz/rvRNL9sbuxP03/W+4emTxwby0NH410b5rl+4Gw==
X-Received: by 2002:a17:90a:70c7:b0:298:cc02:4fd2 with SMTP id a7-20020a17090a70c700b00298cc024fd2mr1693391pjm.2.1708077696251;
        Fri, 16 Feb 2024 02:01:36 -0800 (PST)
Received: from localhost (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id sl13-20020a17090b2e0d00b00296f4fc7e60sm4957561pjb.12.2024.02.16.02.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 02:01:35 -0800 (PST)
Date: Fri, 16 Feb 2024 19:01:35 +0900 (JST)
Message-Id: <20240216.190135.2258273287506713873.fujita.tomonori@gmail.com>
To: andreas@canonical.com
Cc: fujita.tomonori@gmail.com, stgt@vger.kernel.org,
 sergio.durigan@canonical.com
Subject: Re: tgt on arm64 and USE_SIGNALFD
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
In-Reply-To: <CANYNYEHY=t+f7oV0A-+3faAgiSzb90mp6KB7XF2k=bVgpR_3dg@mail.gmail.com>
References: <CANYNYEGR=8vV4JFicnWZ=MDwMc9zjPxHJ8tNj=zSner30UpeXg@mail.gmail.com>
	<20240215.092633.419504594582279426.fujita.tomonori@gmail.com>
	<CANYNYEHY=t+f7oV0A-+3faAgiSzb90mp6KB7XF2k=bVgpR_3dg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: base64

T24gVGh1LCAxNSBGZWIgMjAyNCAxMDozOTo0MyAtMDMwMA0KQW5kcmVhcyBIYXNlbmFjayA8YW5k
cmVhc0BjYW5vbmljYWwuY29tPiB3cm90ZToNCg0KPiBIZWxsbywNCj4gDQo+IE9uIFdlZCwgRmVi
IDE0LCAyMDI0IGF0IDk6MjbigK9QTSBGVUpJVEEgVG9tb25vcmkNCj4gPGZ1aml0YS50b21vbm9y
aUBnbWFpbC5jb20+IHdyb3RlOg0KPj4NCj4+IEhpLA0KPj4NCj4+IE9uIFdlZCwgMTQgRmViIDIw
MjQgMTc6MTQ6NDIgLTAzMDANCj4+IEFuZHJlYXMgSGFzZW5hY2sgPGFuZHJlYXNAY2Fub25pY2Fs
LmNvbT4gd3JvdGU6DQo+Pg0KPj4gPiBpcyBVU0VfU0lHTkFMRkQgbWVhbnQgdG8gYmUgc3VwcG9y
dGVkIG9uIGFybTY0PyBUaGUgY2hlY2sgaW4NCj4+ID4gYnMvdXRpbC5oWzFdIGlzIGxvb2tpbmcg
Zm9yIF9fTlJfc2lnbmFsZmQsIGJ1dCBhcm02NCBvbmx5IGhhcyB0aGUNCj4+ID4gbmV3ZXIgX19O
Ul9zaWduYWxmZDRbMl06DQo+PiA+DQo+PiA+ICNpZiBkZWZpbmVkKF9fTlJfc2lnbmFsZmQpICYm
IGRlZmluZWQoVVNFX1NJR05BTEZEKQ0KPj4gPiAuLi4NCj4+ID4gI2Vsc2UNCj4+ID4gI2RlZmlu
ZSBfX3NpZ25hbGZkKGZkLCBtYXNrLCBmbGFncykgKC0xKQ0KPj4gPiBzdHJ1Y3Qgc2lnbmFsZmRf
c2lnaW5mbyB7DQo+PiA+IH07DQo+PiA+ICNlbmRpZg0KPj4NCj4+IEkgdGhpbmsgdGhhdCB3ZSBk
b24ndCBuZWVkIHRoaXMgaGFjayBhbnltb3JlIChpdCB3YXMgbmVjZXNzYXJ5IHdoZW4NCj4+IHRo
ZSBzaWduYWxmZCBmZWF0dXJlIHdhcyBpbnRyb2R1Y2VkKS4gSSd2ZSBub3QgdGVzdGVkIG9uIGFy
bTY0IGJ1dA0KPj4gSSBndWVzcyB0aGF0IHNpbXBseSB1c2luZyBzeXMvc2lnbmFsZmQuaCB3b3Jr
cyBsaWtlIHRoZSBmb2xsb3dpbmc/DQo+IA0KPiBZZXMsIHRoYW5rIHlvdSwgdGhhdCB3b3JrZWQg
anVzdCBmaW5lIQ0KDQpUaGFua3MhDQoNCkkndmUgYWRkZWQgT19OT05CTE9DSyBmbGFnIGFuZCBt
ZXJnZWQgdGhlIGZvbGxvd2luZzoNCg0KLQ0KRnJvbTogRlVKSVRBIFRvbW9ub3JpIDxmdWppdGEu
dG9tb25vcmlAZ21haWwuY29tPg0KRGF0ZTogRnJpLCAxNiBGZWIgMjAyNCAwOTozNTozOCArMDkw
MA0KU3ViamVjdDogW1BBVENIXSBmaXggYXJtNjQgY29tcGlsZSBicmVha2FnZQ0KDQpUaGlzIHJl
bW92ZXMgdGhlIGhhY2sgZm9yIHNpZ25hbGZkLCB3aGljaCB1c2VzIF9fTlJfc2lnbmFsZmQgdG8g
Y2hlY2sNCndoZXRoZXIgYSBzeXN0ZW0gc3VwcG9ydHMgc2lnbmFsZmQgb3Igbm90LiBhcm02NCB1
c2VzIF9OUl9zaWduYWxmZDQgc28NCnRndCB3cm9uZ2x5IGFzc3VtZXMgdGhhdCBhcm02NCBkb2Vz
bid0IHN1cHBvcnQgc2lnbmFsZmQuDQoNClRoaXMgaGFjayB3YXMgaW50cm9kdWNlZCB3aGVuIHNv
bWUgZGlzdHJpYnV0aW9ucyBkb2Vzbid0IGhhdmUgYSBoZWFkZXINCmZpbGUgZm9yIHNpZ25hbGZk
LiBOb3cgYWxsIHRoZSBkaXN0cmlidXRpb25zIHNob3VsZCBoYXZlIHNvIHdlIGNhbg0Kc2ltcGx5
IHVzZSBzeXMvc2lnbmFsZmQuaA0KDQpSZXBvcnRlZC1ieTogQW5kcmVhcyBIYXNlbmFjayA8YW5k
cmVhc0BjYW5vbmljYWwuY29tPg0KU2lnbmVkLW9mZi1ieTogRlVKSVRBIFRvbW9ub3JpIDxmdWpp
dGEudG9tb25vcmlAZ21haWwuY29tPg0KLS0tDQogdXNyL2JzLmMgICB8ICAyICstDQogdXNyL3V0
aWwuaCB8IDQzICsrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCiAy
IGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNDEgZGVsZXRpb25zKC0pDQoNCmRpZmYg
LS1naXQgYS91c3IvYnMuYyBiL3Vzci9icy5jDQppbmRleCA4MTcxYTMyLi4yMTU0N2Q1IDEwMDY0
NA0KLS0tIGEvdXNyL2JzLmMNCisrKyBiL3Vzci9icy5jDQpAQCAtMzExLDcgKzMxMSw3IEBAIHN0
YXRpYyBpbnQgYnNfaW5pdF9zaWduYWxmZCh2b2lkKQ0KIAlzaWdhZGRzZXQoJm1hc2ssIFNJR1VT
UjIpOw0KIAlzaWdwcm9jbWFzayhTSUdfQkxPQ0ssICZtYXNrLCBOVUxMKTsNCiANCi0Jc2lnX2Zk
ID0gX19zaWduYWxmZCgtMSwgJm1hc2ssIDApOw0KKwlzaWdfZmQgPSBzaWduYWxmZCgtMSwgJm1h
c2ssIE9fTk9OQkxPQ0spOw0KIAlpZiAoc2lnX2ZkIDwgMCkNCiAJCXJldHVybiAxOw0KIA0KZGlm
ZiAtLWdpdCBhL3Vzci91dGlsLmggYi91c3IvdXRpbC5oDQppbmRleCBjNzA5ZjliLi44YWVmNmFi
IDEwMDY0NA0KLS0tIGEvdXNyL3V0aWwuaA0KKysrIGIvdXNyL3V0aWwuaA0KQEAgLTE0LDExICsx
NCwxMiBAQA0KICNpbmNsdWRlIDxzdGRsaWIuaD4NCiAjaW5jbHVkZSA8c3RyaW5nLmg+DQogI2lu
Y2x1ZGUgPGxpbWl0cy5oPg0KKyNpbmNsdWRlIDxsaW51eC9mcy5oPg0KICNpbmNsdWRlIDxsaW51
eC90eXBlcy5oPg0KICNpbmNsdWRlIDxzeXMvaW9jdGwuaD4NCi0jaW5jbHVkZSA8bGludXgvZnMu
aD4NCi0jaW5jbHVkZSA8c3lzL3R5cGVzLmg+DQorI2luY2x1ZGUgPHN5cy9zaWduYWxmZC5oPg0K
ICNpbmNsdWRlIDxzeXMvc3RhdC5oPg0KKyNpbmNsdWRlIDxzeXMvdHlwZXMuaD4NCiANCiAjaW5j
bHVkZSAiYmVfYnl0ZXNoaWZ0LmgiDQogDQpAQCAtMTAzLDQ0ICsxMDQsNiBAQCBzdGF0aWMgaW5s
aW5lIGludCBiZXR3ZWVuKHVpbnQzMl90IHNlcTEsIHVpbnQzMl90IHNlcTIsIHVpbnQzMl90IHNl
cTMpDQogDQogZXh0ZXJuIHVuc2lnbmVkIGxvbmcgcGFnZXNpemUsIHBhZ2VzaGlmdDsNCiANCi0j
aWYgZGVmaW5lZChfX05SX3NpZ25hbGZkKSAmJiBkZWZpbmVkKFVTRV9TSUdOQUxGRCkNCi0NCi0v
Kg0KLSAqIHdvcmthcm91bmQgZm9yIGJyb2tlbiBsaW51eC9zaWduYWxmZC5oIGluY2x1ZGluZw0K
LSAqIHVzci9pbmNsdWRlL2xpbnV4L2ZjbnRsLmgNCi0gKi8NCi0jZGVmaW5lIF9MSU5VWF9GQ05U
TF9IDQotDQotI2luY2x1ZGUgPGxpbnV4L3NpZ25hbGZkLmg+DQotDQotc3RhdGljIGlubGluZSBp
bnQgX19zaWduYWxmZChpbnQgZmQsIGNvbnN0IHNpZ3NldF90ICptYXNrLCBpbnQgZmxhZ3MpDQot
ew0KLQlpbnQgZmQyLCByZXQ7DQotDQotCWZkMiA9IHN5c2NhbGwoX19OUl9zaWduYWxmZCwgZmQs
IG1hc2ssIF9OU0lHIC8gOCk7DQotCWlmIChmZDIgPCAwKQ0KLQkJcmV0dXJuIGZkMjsNCi0NCi0J
cmV0ID0gZmNudGwoZmQyLCBGX0dFVEZMKTsNCi0JaWYgKHJldCA8IDApIHsNCi0JCWNsb3NlKGZk
Mik7DQotCQlyZXR1cm4gLTE7DQotCX0NCi0NCi0JcmV0ID0gZmNudGwoZmQyLCBGX1NFVEZMLCBy
ZXQgfCBPX05PTkJMT0NLKTsNCi0JaWYgKHJldCA8IDApIHsNCi0JCWNsb3NlKGZkMik7DQotCQly
ZXR1cm4gLTE7DQotCX0NCi0NCi0JcmV0dXJuIGZkMjsNCi19DQotI2Vsc2UNCi0jZGVmaW5lIF9f
c2lnbmFsZmQoZmQsIG1hc2ssIGZsYWdzKSAoLTEpDQotc3RydWN0IHNpZ25hbGZkX3NpZ2luZm8g
ew0KLX07DQotI2VuZGlmDQotDQogLyogY29udmVydCBzdHJpbmcgdG8gaW50ZWdlciwgY2hlY2sg
Zm9yIHZhbGlkaXR5IG9mIHRoZSBzdHJpbmcgbnVtZXJpYyBmb3JtYXQNCiAgKiBhbmQgdGhlIG5h
dHVyYWwgYm91bmRhcmllcyBvZiB0aGUgaW50ZWdlciB2YWx1ZSB0eXBlIChmaXJzdCBnZXQgYSA2
NC1iaXQNCiAgKiB2YWx1ZSBhbmQgY2hlY2sgdGhhdCBpdCBmaXRzIHRoZSByYW5nZSBvZiB0aGUg
ZGVzdGluYXRpb24gaW50ZWdlcikuDQotLSANCjIuMzQuMQ0KDQo=
