Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24716692E1
	for <stgt@vger.kernel.org>; Wed,  7 Feb 2024 23:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707349158; cv=none; b=EfYbc7wDos1jug3HgwT7I6hv6YhsMlVDrZPQ/0kBqgzvK4ijG/g+XOLOqRcYxPYIezdPJ5Y4YDUeAO2+ThiAOBEy/noYRhTys+YZrue05mJr2VknrCiJ98Ux9kG/48yKu/wLfqbdt2ncPRcJXteILor6/mUd0ocOr60IxKUpUiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707349158; c=relaxed/simple;
	bh=Qhd4Nlu3S697j3LqYkXgyIajmdXx76n7oNmSdH1W53M=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=KgFk/igSbiGyJRswfUp4+1AnOvwBKA40NvRunKjIFDj0wkpnpUM7QHYJlCCCFiFWDt4houoaIouWIHa4fme9QYZw9KEsvpg6Cv1UlvAtSReLDFOnV4wDMR9QUpqsZ7Rr9BDpRO4rJIzzdEIVjnQXo02iOvAqm0N7Ixg3B/9DMy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WR+aEDot; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WR+aEDot"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e065e5f721so849612b3a.3
        for <stgt@vger.kernel.org>; Wed, 07 Feb 2024 15:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707349156; x=1707953956; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qhd4Nlu3S697j3LqYkXgyIajmdXx76n7oNmSdH1W53M=;
        b=WR+aEDotUp/EkhbiI58ILoFu+5UaphU/fwA5SIDswalY3NA/QcVLSScZ+qxeYQ/I9b
         X/z8pqyG02f/P8BO493yY1+seAiRvKwCIMZL6vFQwsCQtHmnReB+2HuuSSYvnBYvunWr
         HVweH+G5ddHCI8l5jTxHiwx2EMSg3CFQTX7jsHkDVlf8s+BvN3qhGrEHuMOzcztpVv9V
         NZVekgMNGOmiE62X34wa4ZKZXnqOjm0AS5IFDbCwGZMSA6KMCivw2vCNEKLHrF/2NnHA
         ECRlD2NLjMSNLU3pbq+jR2usAcfhpCKn+xx04Tm3Xd3QRr0QkJ4i8n6y7SLmj9T9oDux
         SenQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707349156; x=1707953956;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qhd4Nlu3S697j3LqYkXgyIajmdXx76n7oNmSdH1W53M=;
        b=ZmnagwcvXmD0ALQ8wuGWYyihIwbL4iHiZgEpiTbTTqkdIvRILlyNNNkXe4EHly2CCq
         46TGLksz/Gvdk3bg4HhibMdWynyJuTQ5OCstfZV4kqq5eas1dS/jR8zt5SDDdTZbG6UX
         JaMLm/tdYwkDwoF00SRUHZ3Y9aRYXA7M/DLMNALRX6il30B/QlkakMc/1fqrEMRvmUIg
         KCGRXXKO600R71wUf99CxjRrvMxiNBPWIl2aTdbVTzdcVb6H7halQr+8p2BGp0QeoTbD
         B1LAVacYFWcdkEHUlTN+OnhHTREwvnIOVqQPAYjy0h6nFNhHsGrNf/oyChse2AnBNnak
         BiOA==
X-Gm-Message-State: AOJu0Yxz3M5hPDZGpXqCh4632jU5aEhJ1cD/dgE31Gem/oRlGTMqmAyt
	Aa9skA+DEkK9slKQFfbb59PvfMQY2VfY48vyWoYjw+CJDH6UvCZoeywBPvAr
X-Google-Smtp-Source: AGHT+IGERgkOrWdYLRzBgFWplMwMwzdCIzLHC6wPnMgMPaSEDy9uTNq6nj3J+uDVIbH3h8QGLCnPVQ==
X-Received: by 2002:a05:6a20:d395:b0:19e:99cf:f5be with SMTP id iq21-20020a056a20d39500b0019e99cff5bemr9513711pzb.25.1707349155908;
        Wed, 07 Feb 2024 15:39:15 -0800 (PST)
Received: from smtpclient.apple ([2601:1c0:577f:9f2c::2])
        by smtp.gmail.com with ESMTPSA id ck4-20020a056a02090400b0059b2316be86sm2037517pgb.46.2024.02.07.15.39.15
        for <stgt@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Feb 2024 15:39:15 -0800 (PST)
From: Lee Duncan <leeman.duncan@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: possible issue with CHAP
Message-Id: <EE0EC088-7F99-4FC5-AF54-E959644CEBA5@gmail.com>
Date: Wed, 7 Feb 2024 15:39:04 -0800
To: stgt@vger.kernel.org
X-Mailer: Apple Mail (2.3774.400.31)

Hi:

Long time no talk.

I was testing a possible bug in open-iscsi initiator today, and I tried =
the tgt target for the first time in a while.

My issue has to do with CHAP. I am trying to generate an error by =
setting up CHAP in my open-iscsi initiator, and not setting it up in =
your target. I expect my initiator to complain that there is no CHAP.

But to my surprise I=E2=80=99m able to login to the target, even though =
I=E2=80=99m expecting CHAP. Is this expected.

I thought (perhaps incorrectly) that the initiator and target would =
negotiate the authmethod at startup. My initiator would say =E2=80=9CCHAP=E2=
=80=9D, and the target would say =E2=80=9CNone=E2=80=9D, and they wold =
fail.

When I try this with the kernel LIO target. it definately complains that =
it cannot login.

So what do you think? What is the correct behavior?

P.S. Please include my email in replies, as I=E2=80=99m not yet on your =
mailing list.
=E2=80=94=20
Lee Duncan

