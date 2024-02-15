Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C868B130ADD
	for <stgt@vger.kernel.org>; Thu, 15 Feb 2024 13:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708004400; cv=none; b=BU5J7Fyi4LiCei+09qD/zbTFMqbYT05N3E73+Jwiva8TkHALVlrv/UO4Ml6OZNFwMOhSvflgXNEW+vvuBvlquuRR88G8Umi/TcKgOcOE7+fJDCfeRi6EX54959prXEgUw8UHkRQ9x3Gky6etfVUch23q3DFOxJJctydFCC78oaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708004400; c=relaxed/simple;
	bh=M95Z0vzRBeQxHgvq0r46Arq0YU4v0YJfT3eepWVFjhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i4HnKZCED0tA8aBrX6EWQO5jakzCz6P7NQXrYTH9UFHZaSlVJjc3Xc6DYzuTd3iqnpzwM5gaQ70GuAMJlGQpYrjHohsTgJP/7paQIi1+5QLbGP0OQriXq52QDkLpuFLSrIKhgKQPLz7tzG9bNnglk5J0d9Ly7pEYItYZEOv6PVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=FVsHqJlU; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="FVsHqJlU"
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id F2D993FFCE
	for <stgt@vger.kernel.org>; Thu, 15 Feb 2024 13:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1708004395;
	bh=M95Z0vzRBeQxHgvq0r46Arq0YU4v0YJfT3eepWVFjhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=FVsHqJlUa0FC8xlB2BiVwI5ID0ONOJJ9vsqmEl8bNbvXQ2kUfRf6j/XIhEBXhg2uQ
	 JWZ0SVBgRrjYOgpC0x7Kbw2TH9G1Fn4A2mhr2lCIVO0UhQqF0uqVTIc3eZ2/nyiAvW
	 XIVD4x3vKjpfVMlTyl85Bdt1czy3Pup7rfI4x2xYocmCgF7XsF7C/XWbHREHP1r1L1
	 auepLtWFh7qqNoZn4JgkdD+DInaLkURQV4NeGTOMIjpEse56tTovJSReils/5WGCli
	 3WW0YsxCxpsv8Q51wcNlPdf3P7hs4XFDY4aERnYUGbVZXnDBe/8b/7d0FbmvtlCfLW
	 V9FiYIsDiv9LQ==
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-607ac101b6fso16834687b3.2
        for <stgt@vger.kernel.org>; Thu, 15 Feb 2024 05:39:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708004395; x=1708609195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M95Z0vzRBeQxHgvq0r46Arq0YU4v0YJfT3eepWVFjhM=;
        b=jP0CKeXeLhsvfXVmJxvl/SwI0F9HIxHPPbSX/5HAM/fABmC/Z5/5VBN3cCxxWyoCTd
         UqDuaX0qWTa/TG0V/KhEdhAi/WG3ofM1YcA0TmlHMCGTPRKfm3hGRoZE2Vrq1Vb4iHyC
         T04rsGD6KbSDZWUkVAr5EktQyE+uxbfL1qc/pEi+EtY9AOb54gj/dv1BAWIFE6BOleuO
         3DnES9xpnyRhrCubiO38JCzzYLtFERWKx9yA8zn7OU/MMlu5Vgcl8w+HIYM+YNoGJsB6
         Oy9Q/F1BzV0yS47c/2mCM/dclKAvYPtEHKq5Zhr8FgkWuaLUeDcAPR4jntpao29JKVlg
         plOA==
X-Gm-Message-State: AOJu0YzRR7Pb+GBL0AAond7h8tew6LY02Lo/dBAVRb+WvU3blvRUfqAd
	uNDJ6FtmH7ejGJkFPoZDfTFuj5+2ht2ezjOdZncV7oKxJCtqo+kf3N8XuEN2ZouDIBRqjnaFfWc
	LTvwrV2XldgcDz7nYNDf2TZ4JpRO/Lk8E6KLtmkB7d8vzr+0krMkRfVQtXp4Rg5aqouihaqKWAq
	5JIn+GDvPgnoqKNZEhU4GjcK/C24BMWjeQDe3MwAG4Vps6Ywb+ow==
X-Received: by 2002:a25:c50b:0:b0:dcc:5a73:1cad with SMTP id v11-20020a25c50b000000b00dcc5a731cadmr1780633ybe.42.1708004395069;
        Thu, 15 Feb 2024 05:39:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTPozycxUChK9nztaZJsLKIWdql0QAI6rwrPRk6Uk/L6QC2Y2vdTOPXdqHQGHuf8hrQQLOkzsYtNseX0z4n1Y=
X-Received: by 2002:a25:c50b:0:b0:dcc:5a73:1cad with SMTP id
 v11-20020a25c50b000000b00dcc5a731cadmr1780618ybe.42.1708004394840; Thu, 15
 Feb 2024 05:39:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANYNYEGR=8vV4JFicnWZ=MDwMc9zjPxHJ8tNj=zSner30UpeXg@mail.gmail.com>
 <20240215.092633.419504594582279426.fujita.tomonori@gmail.com>
In-Reply-To: <20240215.092633.419504594582279426.fujita.tomonori@gmail.com>
From: Andreas Hasenack <andreas@canonical.com>
Date: Thu, 15 Feb 2024 10:39:43 -0300
Message-ID: <CANYNYEHY=t+f7oV0A-+3faAgiSzb90mp6KB7XF2k=bVgpR_3dg@mail.gmail.com>
Subject: Re: tgt on arm64 and USE_SIGNALFD
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: stgt@vger.kernel.org, sergio.durigan@canonical.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Feb 14, 2024 at 9:26=E2=80=AFPM FUJITA Tomonori
<fujita.tomonori@gmail.com> wrote:
>
> Hi,
>
> On Wed, 14 Feb 2024 17:14:42 -0300
> Andreas Hasenack <andreas@canonical.com> wrote:
>
> > is USE_SIGNALFD meant to be supported on arm64? The check in
> > bs/util.h[1] is looking for __NR_signalfd, but arm64 only has the
> > newer __NR_signalfd4[2]:
> >
> > #if defined(__NR_signalfd) && defined(USE_SIGNALFD)
> > ...
> > #else
> > #define __signalfd(fd, mask, flags) (-1)
> > struct signalfd_siginfo {
> > };
> > #endif
>
> I think that we don't need this hack anymore (it was necessary when
> the signalfd feature was introduced). I've not tested on arm64 but
> I guess that simply using sys/signalfd.h works like the following?

Yes, thank you, that worked just fine!
