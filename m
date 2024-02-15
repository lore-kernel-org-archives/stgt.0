Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94977391
	for <stgt@vger.kernel.org>; Thu, 15 Feb 2024 00:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707956797; cv=none; b=Tczm8KvV6va7T/49nKqt+X+PO7HHWYqIsG+Q9WCJ8O4KUB8lIBdrcselRVKikqUftua6YTppNQ2Po8M2hRLP7v38QBJs2hP/wkB7FyKyhfxZy7/kzcC6Br1X/1T4SbIYRC8F9kykDkTpWWH7je8QZLTkVcZzbhn+HhTRgbaAM/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707956797; c=relaxed/simple;
	bh=vRYczHBP2SSm0vJjNuYX6X0V5ZloZx4b77sUMWHB6jU=;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cYeKAGv/59CZ/7zI8R28UReol5l7Yi0kW3vGFzMgNjRAnrKuhz9uAiWNKyzdcDftHGW1zta077pOhRO1o4VkO83aUd1ztAmnC5WM88BL0v+ExikRf+gWDGDQ3YdG724wqaFBWpo4nVk0/t0P0COVecY5R/hh0md1uKmfpghofRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bjSDuBuu; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bjSDuBuu"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1db4244f2e3so751835ad.1
        for <stgt@vger.kernel.org>; Wed, 14 Feb 2024 16:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707956795; x=1708561595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aro9dTlC5SvZdYBk1MTVKKhShu9eHwFk8QQGeOKisUU=;
        b=bjSDuBuuhIqQnOtQDFqtmzdfb3w186Z8eYuk9z4jMrEr99lLT6rlWvcbImgvxbc8D/
         RKKHWLJyjVJdc+oRPkaUDwmdoKoL6k5UmUlwNh1jfjpHAzlZ6WmS7FBDoyinjeoaP6D4
         IwlyGKEnFaYLaXQ0Lt847s1htPcwedw49ixnM3GyD6eOj4u0FkTkzHJeHTkcQzuc6aQ5
         R0iSwNqMzKYhQvR9SFffgwCgz/hAiJcYzEcZtZsZESJquPwwdjil96gjh65zYXHKxLIw
         j0kTuFVMVYqk/Jy4p/JVWe1pIWHH1M0dKQFl38iA29//6gByov+h/rv38/Jb0rT6Tyd3
         A1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707956795; x=1708561595;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aro9dTlC5SvZdYBk1MTVKKhShu9eHwFk8QQGeOKisUU=;
        b=lV6Wv0rKskEuKaoSB9ZYaKcjAYbKHGMUp6tvR9uU5qESgAE3WbkozPn+n0azYJDz6T
         m2VvCOnjEdl01oOPij7MxcbdfnrcMt1/g7u+zI5SX/ua+xN8idRwXjGMxyxC31Lfg4ra
         Js/0YFFqImdF5rcTXuWV+AFk+AUUuFN/nLFxip2wKZYKF8e/z9zOz4nbb19Rz9bWGn91
         VpP76mO0tNnr0D8S0bOdVMr+7t8YujLi/ySST+PGwWFCiiXiRefKA5sVkSQF/MLPbs4U
         wKDXLigDzGpi6r7uBDTr7YGto2DgKehOQSgDHpVZCJjLkIb70BQC9TniUkjp5shaz8T1
         SBGA==
X-Gm-Message-State: AOJu0Yz+bT9CBtUAir2V6Pj8fMp4kSBRR64X+F0eny7Lxvcc9vgUfLBp
	OdnovKcroeP/xQyx9WMDYAypGpAIDbE7VzbVd8HmbKoItAW6xI0tnSW8sEH/
X-Google-Smtp-Source: AGHT+IGH+rzd6+RGTcgyMiBkdOicWd3a9RGVEEsTjoNK7CnXwGdMOBd/oq8f9VltFukjypoyyvb9pg==
X-Received: by 2002:a17:903:2282:b0:1d9:3411:b10f with SMTP id b2-20020a170903228200b001d93411b10fmr270486plh.0.1707956794717;
        Wed, 14 Feb 2024 16:26:34 -0800 (PST)
Received: from localhost (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902c24400b001d9cfb9af20sm39186plg.70.2024.02.14.16.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 16:26:34 -0800 (PST)
Date: Thu, 15 Feb 2024 09:26:33 +0900 (JST)
Message-Id: <20240215.092633.419504594582279426.fujita.tomonori@gmail.com>
To: andreas@canonical.com
Cc: stgt@vger.kernel.org, sergio.durigan@canonical.com
Subject: Re: tgt on arm64 and USE_SIGNALFD
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
In-Reply-To: <CANYNYEGR=8vV4JFicnWZ=MDwMc9zjPxHJ8tNj=zSner30UpeXg@mail.gmail.com>
References: <CANYNYEGR=8vV4JFicnWZ=MDwMc9zjPxHJ8tNj=zSner30UpeXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

On Wed, 14 Feb 2024 17:14:42 -0300
Andreas Hasenack <andreas@canonical.com> wrote:

> is USE_SIGNALFD meant to be supported on arm64? The check in
> bs/util.h[1] is looking for __NR_signalfd, but arm64 only has the
> newer __NR_signalfd4[2]:
> 
> #if defined(__NR_signalfd) && defined(USE_SIGNALFD)
> ...
> #else
> #define __signalfd(fd, mask, flags) (-1)
> struct signalfd_siginfo {
> };
> #endif

I think that we don't need this hack anymore (it was necessary when
the signalfd feature was introduced). I've not tested on arm64 but
I guess that simply using sys/signalfd.h works like the following?


diff --git a/usr/bs.c b/usr/bs.c
index 8171a32..8da5a9b 100644
--- a/usr/bs.c
+++ b/usr/bs.c
@@ -311,7 +311,7 @@ static int bs_init_signalfd(void)
 	sigaddset(&mask, SIGUSR2);
 	sigprocmask(SIG_BLOCK, &mask, NULL);
 
-	sig_fd = __signalfd(-1, &mask, 0);
+	sig_fd = signalfd(-1, &mask, 0);
 	if (sig_fd < 0)
 		return 1;
 
diff --git a/usr/util.h b/usr/util.h
index c709f9b..8aef6ab 100644
--- a/usr/util.h
+++ b/usr/util.h
@@ -14,11 +14,12 @@
 #include <stdlib.h>
 #include <string.h>
 #include <limits.h>
+#include <linux/fs.h>
 #include <linux/types.h>
 #include <sys/ioctl.h>
-#include <linux/fs.h>
-#include <sys/types.h>
+#include <sys/signalfd.h>
 #include <sys/stat.h>
+#include <sys/types.h>
 
 #include "be_byteshift.h"
 
@@ -103,44 +104,6 @@ static inline int between(uint32_t seq1, uint32_t seq2, uint32_t seq3)
 
 extern unsigned long pagesize, pageshift;
 
-#if defined(__NR_signalfd) && defined(USE_SIGNALFD)
-
-/*
- * workaround for broken linux/signalfd.h including
- * usr/include/linux/fcntl.h
- */
-#define _LINUX_FCNTL_H
-
-#include <linux/signalfd.h>
-
-static inline int __signalfd(int fd, const sigset_t *mask, int flags)
-{
-	int fd2, ret;
-
-	fd2 = syscall(__NR_signalfd, fd, mask, _NSIG / 8);
-	if (fd2 < 0)
-		return fd2;
-
-	ret = fcntl(fd2, F_GETFL);
-	if (ret < 0) {
-		close(fd2);
-		return -1;
-	}
-
-	ret = fcntl(fd2, F_SETFL, ret | O_NONBLOCK);
-	if (ret < 0) {
-		close(fd2);
-		return -1;
-	}
-
-	return fd2;
-}
-#else
-#define __signalfd(fd, mask, flags) (-1)
-struct signalfd_siginfo {
-};
-#endif
-
 /* convert string to integer, check for validity of the string numeric format
  * and the natural boundaries of the integer value type (first get a 64-bit
  * value and check that it fits the range of the destination integer).
