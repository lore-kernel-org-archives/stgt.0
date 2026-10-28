Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793208004;
	b=ve606q8S9H4rCDKwzpoGUTAmf2MNGH7BjAZ6O+5Llwo9qXHLaeJXuXOdwWDVNWIVl00V
	 c8cCHDjLFOLpIkrlvxNsJ3F8Dp9PRrfJHRdNupP1cvlbm3cfApEmw75isMjurUBJ2X42M
	 YRSLuoj4MKgAP07SgisxuO4OlofklVUsSikPqpTbqjY3q9wCvReeESmC2g5dKQ3JKLI1f
	 OALIuIIGhfsy2xFncR/izYrsvoL2MiMveIWaPvunlxVqUn+Oyh/0Lh+9G7XFN5aXI3B7M
	 v0aJpihMCtcaNEFzQVkuhvYbZlYC8XrpCxfepUbxOfx75QVAvhX1kvclG3jKQ1CnCYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208004;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type;
	bh=ewrN784km2vBNFM6w16+eWdRLq8a1g5ugWu3EFJFQkM=;
	b=xdzJgxh8VpxR889mTQZq8WaE+xAQdm6seeYhJYszWpti5j6QAakzu9vsMQbSLH/w4+SN
	 9Ci5DgBholFxoMDNPTRCMwwb7U/cDdhO+HR8Rs7N8/zpuTZDkwaPHb3mEvQjvT4K6E7G7
	 KE4kyOgwq/bXPONaFMORfgYZjolODQ7QXBb+dQDeQQxUhpc/pCCp71UZ3yAtt2Vzv0ed/
	 y38KTP1pHUuDZmGvior8W8Bch2VhVpSXMvPSuF1BcncSAh0GzjZL1JW2uavFv3jPcv4pA
	 pUgJyCCSNqVYljNgndw0fNpFK2rAXGmtnYMfxguxmp2xZUyI/KlthuX2zkHqyjB/Q8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m5UhXG5T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FED606A31C
	for <stgt@vger.kernel.org>; Wed, 28 Oct 2026 17:20:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24FED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m5UhXG5T
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be3ea5a7adso1335245e87.2
        for <stgt@vger.kernel.org>; Wed, 28 Oct 2026 10:20:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793208001; cv=none;
        d=google.com; s=arc-20260327;
        b=PujfsPDrgCJASJ2i/8IHOZgjjEahIy7FyBGJxrTJxePYVyQNcJzRvevY/wXd/m7o39
         ivJFuE4ogJ8afonCHPPq+xv2BVpVt/KRv2HQ79mjQZXsUG3Jmi1Bn3cKB6jdU/jB+8to
         ouqmXgDI4CeJAX14y7WTlQG5E8cfEGQXNDIV/Ps7jAxf9z7qQMjBm6KtRudWMeFfiKQL
         e7jk/93xNlgmtyUGmOaAhGuuz7nVha4WMUFNMAwpCAuXczSHutX2X8J9pDH+yICX82xL
         QSiGeJQ3waXfGXCJSm/A3favmMXf7IWd8U6zHfqG2JyfP31rSW21Kl0+oyjYod3B1sNN
         Y9Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ewrN784km2vBNFM6w16+eWdRLq8a1g5ugWu3EFJFQkM=;
        fh=/uiNFqN8+q67n2ZNml7ZcLbYU3cDOdvpS4+nRDFxycU=;
        b=HY+dQMVdIm0bUUSkq6jWBCdGwPR+FjsqPJaJ0yrNCYhKahww5iUm12qI7MsG8jORdq
         juRcPMVosMA6LaGxNjBpUB5RqSEMP5za/O51xTKky9KQYN/q7nrXfY6hPv3zICvPl3R/
         LfTug2PjDpPHljviwcJIlsVNOrdZmx4AEdR9CEyNh+1x8u8xMx2/FKAxk06Z5Ukr8bL/
         O/4Ts77x3hZu2KXKBbvu4ccxnhT8VKRv71yc5qFRtyLlE5YaSSpzOTn3uAHHJTgvjd3c
         a3f5nPcS+4Qdv8n+VZtGR1IoiEM6G9PNSxt+UR0S+NNznRvBihWxQ07DMTbGfTYKyg5a
         N0WA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793208001; x=1793812801; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ewrN784km2vBNFM6w16+eWdRLq8a1g5ugWu3EFJFQkM=;
        b=m5UhXG5T0O55kHweGMLaMHIVS6obBLpuI2LUxFIRsRkh1qPQEK8Yp4h2XABivigNUu
         6p2HzxBrXqF5mAVz5NDG3LHoZ0Yum9jgGNSWpBWNrX/WBx2khpFHQwTJI1ThThVED2c7
         yY/VAyKZZjRePSOOtLS6dtMla+elRiyXRqhqd5u4gkX3D/G3KzpgApkYTVL0haiZgaWb
         WcefhDzUlBf7+krDz/2teKlQtO7GwI4X7xS2RddMr8x3/LbTwERJOkMxKqiQ85sEaFYS
         ITR66Borr84qKmIZ1/C8/Cg4B+yHbTqEgIFKT9cEImnaBroSrNTj73vAKHih/MfZnnPS
         Stag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793208001; x=1793812801;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ewrN784km2vBNFM6w16+eWdRLq8a1g5ugWu3EFJFQkM=;
        b=vI+QrfY5DBAktgX5Gt/+cHnSfq2joVgd6nsc7XCYsA2T5bjUCQRydMAXIW0IV7TC+a
         6MCpatNlESzBba5PINbt54ZQznV7tAsofB2EXy/ONGlPI1nkCwwHoiOJ4ypKxixoPvWK
         tX+DvwfGkM5smFmtXu4xo3d9uLtRMAFRKrBdywbafnGwaRdn+iwGAO56AAbvBkERouvs
         4QkzXPMiSoyZRbW5xxhP8PcT1+UjCLKi9FENOB/qxfDEmz7NZIhG7LEdEyn6iwCH7yaR
         Ht6D7uLAzPDPPUxZUQrNuCl+F6XNlEHKbOMKu6KvCcVpAvO2PRYU9XH2BQOCw/AGI8ay
         w+PQ==
X-Gm-Message-State: AFq9FYIUyhOrqOTloWSh9/ep2CWil8dUe5YRhOAqSVkwJz+yo2cFE2LF
	JjS9qRPWNXw/A+9qqJm+S7pwakNloqwVGsjt46UEnMXZijglmMaSuB0x5HLF8XLiAfITuXwBaVs
	GmAdA1Y7DoWbSCz6o47DJaDYDwe3+Jc5UGoCd
X-Gm-Gg: AYBFou24eQqYfYMMGVJgUQVxCx+tEygIPd3pO5X/dkpaZgzo4aVm/xtakZ322nWtouL
	jTZE6fHZ4ArkDHblYSpbOR4re0igq5Xzy67gArPM8d4+R4oJQ0oEvVaqoquKq4uoVonFOBDe8ek
	ECfJUoXSK7gsMp7KD1GU2/fnllbSsO8BEV4IMKsxRPMjK91mt0WrmNLxqqCh3ZqY/k+WkxqBkOg
	X/YQP9bpsLuQYX4zbNuw1alNrGhyZOzQXlsFSjHKyhwvE+QCLHp+JxzeL4mY1WRDf0xD5iQIP0I
	7Z5byKcJabtlQd8rOm+PrRMHAL/uarlRpIuzmKxQ77DGupdR9wxDb7Hgf9Jk4mSRMBOwUVdpXZu
	toCyZr2kSeyb4cJ9/1KsoLHRnYEgRd+XSzi4lSSMuN9iPw1VpaJL/WOdVMfng4TtN4YmfzQ==
X-Received: by 2002:a05:6512:688b:20b0:5bf:cf80:aa76 with SMTP id
 2adb3069b0e04-5bfcf80aa88mr514876e87.0.1793208001192; Wed, 28 Oct 2026
 10:20:01 -0700 (PDT)
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Post: <mailto:stgt@vger.kernel.org>
List-Help: <mailto:stgt+help@vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
List-Owner: <mailto:stgt+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Cyber Kendra <carecyberkendra@gmail.com>
Date: Wed, 28 Oct 2026 22:49:27 +0530
X-Gm-Features: AclHuK86t5nzalAYhdAlSEmM5H0ygTTvU0v41xor4_N0LmkZXY3fupkz0yA7HVc
Message-ID: <CANSHS5jo6Fh-eQBT2-V+aUxQz6xE3ncjeBHq0g85NXYDc3pDEQ@mail.gmail.com>
Subject: Security: unauthenticated heap write / RCE chain in tgtd iSCSI
 (public since Aug 2, unpatched in 1.0.97)
To: stgt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Team,

I'm Vivek, editor of Cyber Kendra (cyberkendra.com), an independent
cybersecurity news site. I'm writing because a public write-up
describes a remote, unauthenticated code execution chain in tgtd, and
as far as I can tell, the project has not been notified.

Write-up (public since August 2, 2026):
https://warez.sl0p.foo/tgt-iscsi-rce/

The page says it was produced by AI agents, records no vendor contact,
and links a working Python proof-of-concept. I have not independently
verified the exploit.

The write-up describes three issues. I confirmed the code locations
against the current master (f0dc199, v1.0.97):

1. usr/iscsi/iscsid.c:1578, iscsi_data_out_rx_start():
   conn->req.data = task->data + be32_to_cpu(req->offset);
   There is no check that offset + dlength stays within the task's
data buffer. According to the write-up, a crafted Data-Out PDU can
therefore write attacker-controlled bytes out of bounds on the heap.

2. usr/iscsi/iscsid.c:1181, iscsi_r2t_build():
   rsp->ttt = (unsigned long) task;
   Every R2T sends the low 32 bits of a heap address to the initiator.

3. READ over-read: the write-up says corrupting a pending READ's
transfer length (via issue 1) makes tgtd return about 64KB of adjacent
heap, which discloses the program and libc base addresses.

Chained together, the write-up reports root code execution against
Arch Linux's tgt 1.0.97-3 package with ASLR enabled. The attack needs
no authentication when CHAP is not configured.

The write-up suggests three fixes: bounds-check the Data-Out offset
and length against the task's data length, replace the pointer-derived
TTT with an opaque per-task counter, and validate transfer_len on the
READ path.

Because the details and the PoC are already public, there is no
embargo to protect. I plan to publish a news article, and I would
welcome your comment before then, in particular:

- Can you confirm the issues?
- Is a fix planned, and roughly when?
- Will the project request a CVE?
- What mitigations do you recommend for users in the meantime?

I will include your response, and I will update the article when a fix
is released.

Thank you for your work on tgt.

Best regards,
Vivek
Editor, Cyber Kendra
https://cyberkendra.com
