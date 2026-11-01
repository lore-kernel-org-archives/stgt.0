Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793492934;
	b=q8tvf39/KgqNrsR0psKHyB1VubYp65LF4BRZ3GyM938pdYIzt3tboiy8aArZVzk4tEe6
	 51PIHi5vxh1xJO43DckqFlRVL/Hp8Edhe5/guOs6B7XJAV5kFmJbSSmQ7vcNQlnNvkleW
	 7RVGnE53svY834s/89t2AwE8mUjlgQD1YwPu4qmWaqyzxGXeB6TBBQou8TCEJNIJ4/TW0
	 vLziQSoj/hWZNKk1sbkhgx/qu/wb46LmYjwCvixpBxGlkYAvNoAza+grlH3EaSf5PkglO
	 q8O0FPAL9WpMkkpBPTn6+ntONzxS4TgGaPhxiIfD72ws99lqv641BHYhrtL2+QyWbyA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793492934;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=gN5wmHIb3xZuzXnRqoigAbjeDrHmQV/gylMG0li+IgI=;
	b=Ahi+TL4TDFKR1NMSu78tt3FEO7dXC/BwzObAHTSDCiRYXA/8I49+zRXHEYqj41k6CJq2
	 39aLLhX60p5sAA51lEB01Huv5ZAHHYp6MZVrADBn35st/NNRze5nC8CsscQFVDo5dE/Jd
	 JfUYILVQ/Xb+mcJ1GmG0Q84wTaVJiVAP6hRsusMWXWMoiCYwG8ugFzUz+ze8T1VdNLehu
	 2chebohoLSkI5f50JWDQqEyJFj8im/nHe48iOE+dhemINKr63CZsbV9bFfGFZ9Fq6kzr9
	 8Hs4eGXOibhxcjK98Us0uK7jtmXMhdGEmV4M1+WxpwvkN0Xs4cMVfc0cCdHZKaQIKiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AECT2MRa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF85606A31A
	for <stgt@vger.kernel.org>; Sun,  1 Nov 2026 00:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCF85606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AECT2MRa
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8a05effaf8dso1039419b3a.2
        for <stgt@vger.kernel.org>; Sat, 31 Oct 2026 17:28:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793492933; cv=none;
        d=google.com; s=arc-20260327;
        b=fRm1xJScQi6ZABpzJPOYru0fGlX3bFZkcK1r/J6EVc+UBLJm6V8bb8l/jhkGcR3Nt4
         34YHAcZd6mXOMk74qHAY+i/1Nk7ip44qd0IAP0I34aArGtjZ3I4HByTVVwi6XF56guT7
         B83sO1aimJEu9fXbqWokwza8cMg1jnFy28QZ4MBVO7kMtn51ubnY8uJdSSuOw7lrzswo
         cXotFT1slSFzfBBfBJqoNM+IyzFTcMeuE7VLajgDdG8/xVpX1ZYTvj3Mw0FnrsAffmrj
         pwx8NxIDY3GhYNoY5wX4ARja3UKltJAWECaZ7QYzF8v9BTFQ2TNa90X4fV2shIWel7jm
         Z9Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gN5wmHIb3xZuzXnRqoigAbjeDrHmQV/gylMG0li+IgI=;
        fh=kM9pcmKCNWzG9Ys7BD9ymMIeehjd6YqBBlFEvXkYoek=;
        b=luLjcdyTM8avc+/jquQ9a7e+y830O0K+4U2Bsm5DeUGtF/QDJ3yUKSHgPXvrr69vkR
         mfsfafDbnuuAiBU1GJ2ONb8Kuwj2Um30/zIZvunGnNzy/8+KJzzVhknPQQkDyAYXwOE2
         jY+Ebxai+tZbaWIo/7Ff+tUUTLPfqhTsHlLbM9eLFNHUuXs937Q+J2Sr47aDbK1ODNV8
         eaxG7toaK7bkoT5LbXSGdg6gZASXFN0BmjuHamwi+CLbu1oFJZyQKK323Syny8bw0kNt
         pQHjJNRAV+tS2d7XCDFTyulSqVdObj0f+puD1uE3kSaPTdk04HX11RhnBcLnff8mudoo
         HBTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793492933; x=1794097733; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gN5wmHIb3xZuzXnRqoigAbjeDrHmQV/gylMG0li+IgI=;
        b=AECT2MRabjAJFIN5o82Ywtct/VOHeJbx+/eD4TMZHFFqREZEYvXz9xGumUOF+tYqBr
         Y5rjRRlqalpRqFBhV0CSPMoZ4j8P7Xl46/+m8TrB+2G2riFLxjbM5h4CJOLqV4a0Jg8J
         nGbc4sgH3dy7z2sz24sEDjSJ9rHK1Aq4awhjpwojfZ43KNMuNH4BsTaKA16m68JFZ28e
         ZWHuCBiQaLUV2POR+uAG1BvQU1OpCswUN0STOapLnOuRYmUwv+Mz/BHsoSO+15E00r3P
         mgACzNJ0oEDc4YqdT0YrWxOqJoPXcgvPPuujyz1GasF/9zo8x9t1BJUEk2rUHUnRnRwS
         fXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793492933; x=1794097733;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gN5wmHIb3xZuzXnRqoigAbjeDrHmQV/gylMG0li+IgI=;
        b=l/pX0NMoolNUu7fgRq2umV3Va71kEOSzRnAQW0fMIJd4BLDPTPBdpgRjEzsxU1mdR+
         InP+UDXM0cjppCQxhpt5Q2fTZNwIX1uw5ruqXD3w6ymlbBu2vMe1TMamIj1+QuPh85pV
         HvXbp5XMAkAJQB68a2QlyGB0/XkfizTooi4M2ZtfaVCNRsQzYkTR/3m/JlW0Kq7IzbcX
         MnOCpmyHBOnWp7FpD4KyWSKxezKoG18sWQGgTDEl+/MgdMJuigzhL4Fxn1qBtDdVvfXr
         gNu0IgGWjEg4PhOpO31CSEhYTo00xw5oAVroU/P6pxrzoXgcMe4ouGpVxiuTVXROpMCn
         0jyw==
X-Gm-Message-State: AFq9FYL/qNtr6xSS2R5t6TIMJyRNizlr0c6Jz0zki7KYI9wiBxWbir+B
	L5NKlb0JaNjKPO8nxstTHVLkX9FQAx7T4IGkQBK9hd3XyOQErkQFymPSTfT56tywFzdVMbMUs+H
	bO/WKHgZZEr5UazJHVk8gJ2YWoCHldOumEt83
X-Gm-Gg: AYBFou0M5gyL6v7lKGBDw2D66pG7QDo61NYFbPfQ6zqsYFUN4nkPf6PE18+t4nyrUzn
	T+VtAqnUbMF41fvKdwfwaXdxaN+FBpNqBYE50dQHNZDY8YwMKgOiA1Fjt6IZy7lD1mx3wOvQWIy
	51BOxkcVJl7dECpWfaMJk9XlQWvkjDgBuM2/3xCE8oo/f++PWIIKN9JmK0ptVztuWOkjTQsuIDV
	hC97DjM35uFWE6g1/mm1FIjsqjTLRFDQgvq/jZdZKH4Jzphmo9j2FlOOPtyJ79T1MpbIQ59fZSd
	YDP+mKmwjFcNojc9QvxuD+TTo6VguwHxPmsukn2U2du1vWCmrPmyp6o4Y/nx2bfgFf5qvGNSPCz
	O5LxfVbY0e9jLXJRnFKMqsC/6bgqnZUteBms/qYvr3ft/RyCGwawbHIMczWNd
X-Received: by 2002:a05:6a00:1412:b0:880:5fe5:a81f with SMTP id
 d2e1a72fcca58-8a9bb7a0df1mr5605858b3a.11.1793492933031; Sat, 31 Oct 2026
 17:28:53 -0700 (PDT)
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Post: <mailto:stgt@vger.kernel.org>
List-Help: <mailto:stgt+help@vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
List-Owner: <mailto:stgt+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CANSHS5iBzs5P66b_oyTUyU9nMM1X-OyVGoNXxNxpcTaKoNY+Xg@mail.gmail.com>
In-Reply-To: <CANSHS5iBzs5P66b_oyTUyU9nMM1X-OyVGoNXxNxpcTaKoNY+Xg@mail.gmail.com>
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
Date: Sun, 1 Nov 2026 09:28:41 +0900
X-Gm-Features: AclHuK_FsZyqDc6fOzWHJ2V22WuhkoVqk8wVmnPkLAvrYv5PBuwRrgQKQYjTMp4
Message-ID: <CAJ+Zx=12ZMd-EdPJPPCxZwLhLdwy7NjEFsxkbJNTHomvP=no_A@mail.gmail.com>
Subject: Re: Security: unauthenticated heap write / RCE chain in tgtd iSCSI
 (public since Aug 2, unpatched in 1.0.97)
To: Cyber Kendra <carecyberkendra@gmail.com>
Cc: stgt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vivek,

Thanks for the heads-up. Here are answers to your questions.

Confirmation:
- Issue 1 (Data-Out offset not bounds-checked) is real. A Data-Out
  PDU with a large offset could write past the task's data buffer.
- Issue 2 (R2T TTT carries a task pointer) is real. The low 32 bits
  of a heap address were sent to the initiator.
- Issue 3 (READ over-read): the over-read needs a corrupted transfer
  length. That can only come from the out-of-bounds write in Issue 1.
  With Issue 1 fixed, this path is closed. I also checked that the
  transfer length never exceeds the read buffer in normal operation,
  so no separate fix is needed.

Fix:
Both issues are fixed in the git master:
- Data-Out now checks the offset and length against the task buffer:
  https://github.com/fujita/tgt/commit/e3b418a
- The R2T TTT is set to 0 instead of the task pointer:
  https://github.com/fujita/tgt/commit/a3f4a25
The fixes are small and already committed.

CVE:
The project does not manage CVE IDs and will not request one. We
handle these as normal bug fixes. Anyone who wants a CVE can request
it.

Please let me know if you need anything else.

On Thu, Oct 29, 2026 at 2:10=E2=80=AFAM Cyber Kendra <carecyberkendra@gmail=
.com> wrote:
>
> Hello Team,
>
> I'm Vivek, editor of Cyber Kendra (cyberkendra.com), an independent cyber=
security news site. I'm writing because a public write-up describes a remot=
e, unauthenticated code execution chain in tgtd, and as far as I can tell, =
the project has not been notified.
>
> Write-up (public since August 2, 2026):
> https://warez.sl0p.foo/tgt-iscsi-rce/
>
> The page says it was produced by AI agents, records no vendor contact, an=
d links a working Python proof-of-concept. I have not independently verifie=
d the exploit.
>
> The write-up describes three issues. I confirmed the code locations again=
st the current master (f0dc199, v1.0.97):
>
> 1. usr/iscsi/iscsid.c:1578, iscsi_data_out_rx_start():
>    conn->req.data =3D task->data + be32_to_cpu(req->offset);
>    There is no check that offset + dlength stays within the task's data b=
uffer. According to the write-up, a crafted Data-Out PDU can therefore writ=
e attacker-controlled bytes out of bounds on the heap.
>
> 2. usr/iscsi/iscsid.c:1181, iscsi_r2t_build():
>    rsp->ttt =3D (unsigned long) task;
>    Every R2T sends the low 32 bits of a heap address to the initiator.
>
> 3. READ over-read: the write-up says corrupting a pending READ's transfer=
 length (via issue 1) makes tgtd return about 64KB of adjacent heap, which =
discloses the program and libc base addresses.
>
> Chained together, the write-up reports root code execution against Arch L=
inux's tgt 1.0.97-3 package with ASLR enabled. The attack needs no authenti=
cation when CHAP is not configured.
>
> The write-up suggests three fixes: bounds-check the Data-Out offset and l=
ength against the task's data length, replace the pointer-derived TTT with =
an opaque per-task counter, and validate transfer_len on the READ path.
>
> Because the details and the PoC are already public, there is no embargo t=
o protect. I plan to publish a news article, and I would welcome your comme=
nt before then, in particular:
>
> - Can you confirm the issues?
> - Is a fix planned, and roughly when?
> - Will the project request a CVE?
> - What mitigations do you recommend for users in the meantime?
>
> I will include your response, and I will update the article when a fix is=
 released.
>
> Thank you for your work on tgt.
>
> Best regards,
> Vivek
> Editor, Cyber Kendra
> https://cyberkendra.com
