Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89ED6A002
	for <stgt@vger.kernel.org>; Wed, 14 Feb 2024 20:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707941699; cv=none; b=TnPga+IpC1QjwG1lyquJ6t0TdnzbfplwV2AxDAusWvOEOOiLtNhkkCsIi9ilAkHHEqzxVj/Mupu2xAXsIJGOuuwnGFsV8I94vS8CAI/GT2ByWYEOlM51K5GjbXz4+DXHbpOrL2KVC7JUF+fxWJ6+E7/g9mCP3uerRMQ+92M4wbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707941699; c=relaxed/simple;
	bh=td2MzYE76fZKZcB5K55oP5edQ5CK7wc4qMQEAwD1MEE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=DK8UMpHaZtWcpxNmTiTGDyXNqY0e4paoV7sEj9yXulumrGtVcJ6w41uNSLcLYOoxOUZszXQlkeKvlkEC+i8HBn2pQYK2o43c9QEPKO0yMH8gSxX4XVsmu5tZCAyKGS1TcwPqBS6CRihTQSSp2h53Mn5kaCdoBzek30Dm3s1G6po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=XaevDNSp; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="XaevDNSp"
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 958DE3FA81
	for <stgt@vger.kernel.org>; Wed, 14 Feb 2024 20:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1707941694;
	bh=oggdNOjLrrMPrYUcFCEWKsRKbKz6hr23flUhe1cFmeQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type;
	b=XaevDNSpmhOa+su8Qv1ZwBqvJ+EIa7qdm9+WRLAFAYP5FzsIWKbKfZPQmpeB13iyZ
	 26PJedkoqw26VAUWLpm28lqDSroxGQu9xp2d+wde5s9lGDk7drCvCaUyQnPLgZkKD2
	 PZx/AxO0yUyiK2BJXuKLnS9Aj1b8VcqF3M3erfxyTzaBx8UpuqO5VX1Y/ujDr+Ykt7
	 J0vonbXXZqaW9cNmoNemvrt5/CWm0unSb24m+chdSukjJx5kicchQPkUBWI4jlcdDy
	 xci/2OL5NV8n7cko1yN6Haf6UCPlsnwfzHyUH6ewFXpVVf/cfZl8kGoRWH2NFKZQtV
	 7DvfwHv8kbxxg==
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-6077ec913f0so3339877b3.0
        for <stgt@vger.kernel.org>; Wed, 14 Feb 2024 12:14:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707941693; x=1708546493;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oggdNOjLrrMPrYUcFCEWKsRKbKz6hr23flUhe1cFmeQ=;
        b=P/wkyys9R57MIsCGzhjMBEFGdNulKh/UaNUVvBhZp8JofCatXcCii4y2r1vtjWSlVZ
         VlCGNy0NH7qo5Um+gVtvy4jGHsGBqngLvQHz+kbGkgjt6qIrtMBvY1YHBSAXeOh0QEq4
         qqgrqq9ZVYu5M6d3DOwKy5sbswaJ5gGjnCSCijppaCxoQgQudfe9twrlk3mlwSZjC5xU
         tIrWeVrx0dy4sDRLFAQKf7RgsJXfcuFqjH2ALPdGHMiczDw1qsvWQBuhvnkVLyiUezmo
         MqgqUJYJn6ojnn0jopU9Mlwwz2Rotwjf4WCJZh2SphyNapZOMSaylRh2kLdRCleWIwf7
         liPQ==
X-Gm-Message-State: AOJu0Ywn45yNOgdeJeqCVB/MjMsGMKGlRUlXKdVx3ZoC+SRccUSkK/Im
	NTl8KHWpX4b251IrcIurAHQ1HsIFW2X1WkRgsUk6AXwyBgMp07OXYVNIPiotL5/7+fhWJ6dVFBe
	ZaScP1yp2zsUYMwovL5OoF5E276K4PW966dzS9jv+lmaXc7xftryedoO/ruBz7Bv8jCIkRpTika
	qMjvN2b+ow6ffbcJXA4kRBrQ8eRjuge1a6iHv64lv+JA0jQabuig==
X-Received: by 2002:a0d:eb0a:0:b0:607:7c17:431b with SMTP id u10-20020a0deb0a000000b006077c17431bmr3745281ywe.18.1707941693410;
        Wed, 14 Feb 2024 12:14:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtqs1UlBGFaxQeGRoRPmnYUkIdvVB/4HxhlC/9oN7StxrjnAHf4WRrMiYDMJ52EoIOliEZGrJ48R2WRAJtFAo=
X-Received: by 2002:a0d:eb0a:0:b0:607:7c17:431b with SMTP id
 u10-20020a0deb0a000000b006077c17431bmr3745258ywe.18.1707941693131; Wed, 14
 Feb 2024 12:14:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Andreas Hasenack <andreas@canonical.com>
Date: Wed, 14 Feb 2024 17:14:42 -0300
Message-ID: <CANYNYEGR=8vV4JFicnWZ=MDwMc9zjPxHJ8tNj=zSner30UpeXg@mail.gmail.com>
Subject: tgt on arm64 and USE_SIGNALFD
To: stgt@vger.kernel.org, Sergio Durigan Junior <sergio.durigan@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

is USE_SIGNALFD meant to be supported on arm64? The check in
bs/util.h[1] is looking for __NR_signalfd, but arm64 only has the
newer __NR_signalfd4[2]:

#if defined(__NR_signalfd) && defined(USE_SIGNALFD)
...
#else
#define __signalfd(fd, mask, flags) (-1)
struct signalfd_siginfo {
};
#endif

Since that #ifdef fails, the signalfd_siginfo struct gets redefined to
be empty, and this is tripping a gcc check later on in usr/bs.c[3]
when gcc thinks something is being written into siginfo which is now
zero bytes long:

struct signalfd_siginfo siginfo[16];
...
ret =3D read(fd, (char *)siginfo, sizeof(siginfo));

Build:
bs.c: In function =E2=80=98bs_sig_request_done=E2=80=99:
bs.c:196:15: error: =E2=80=98read=E2=80=99 writing 1 byte into a region of =
size 0
overflows the destination [-Werror=3Dstringop-overflow=3D]
  196 |         ret =3D read(fd, (char *)siginfo, sizeof(siginfo));
      |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bs.c:193:33: note: destination object =E2=80=98siginfo=E2=80=99 of size 0
  193 |         struct signalfd_siginfo siginfo[16];
      |                                 ^~~~~~~

This error happens with -D_FORTIFY_SOURCE=3D3 and -O of 1 or higher, and
looks like a gcc bug, and a few similar to this have been filed
already[4].


1. https://github.com/fujita/tgt/blob/master/usr/util.h#L106
2. https://github.com/bminor/glibc/blob/f9ac84f92f151e07586c55e14ed628d493a=
5929d/sysdeps/unix/sysv/linux/aarch64/arch-syscall.h#L255
3. https://github.com/fujita/tgt/blob/master/usr/bs.c#L196
4. https://gcc.gnu.org/bugzilla/buglist.cgi?quicksearch=3Dwriting%201%20byt=
e%20into%20a%20region%20of%20size%200
