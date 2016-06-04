From: =?GB2312?B?t+vBpg==?= <lifeng1519@gmail.com>
Subject: Re: Resend [PATCH 2/2] convert scsi_cmnd.h macro to normal functions
Date: Sat, 4 Jun 2016 08:05:31 +0800
Message-ID: <432A95CE-D974-42D8-97BC-F05E9172A510@gmail.com>
References: <1464851831-105676-1-git-send-email-li.feng@oracle.com> <1464851831-105676-2-git-send-email-li.feng@oracle.com> <20160603.075427.1545942096518976934.tomof@acm.org>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=Gjla+r0YUEj9PnAlrr9BAdK9nnZGEqhec888Cowzqyg=;
        b=YQZ1x5tidCAHBf62hO6Tza8X4eIU3kPm2W1O0GELQdMeHX/feELk3qruTRDsgPoN8U
         nPLWAiMdih0hld5kTmNk3OKH9d6IFXS4BLABYAh0Y/zWEdgEtDZ2OcbA+28hP46M6RYV
         1PW++70QKxyErYd8ol7TJ/zuJuh2H+Oxysz/f5hRtESfHWmVzfMR8du8hy4G5kjhBfer
         bRSGTdz5rQhyWpFtMj9jlsDha777VUqpEmd6WCBe2CJsn4XO4Tp5kYG/Ci/pfponqsYA
         2ap3rqT8w2WaFoeO+S5rfmWZRrjFbFtvdM9Cw2TWutgumdFaV41XVVxHaB6Q5c4nIy93
         PJNQ==
In-Reply-To: <20160603.075427.1545942096518976934.tomof@acm.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="gb2312"
To: FUJITA Tomonori <tomof@acm.org>
Cc: li.feng@oracle.com, stgt@vger.kernel.org

OK, I agree with you. This is a very low level API. We don't need make =
a change unless it has a problem.

Meanwhile, this tgt is an excellent project for learning iSCSI.

Thank you.

/Alex

> =D4=DA 2016=C4=EA6=D4=C23=C8=D5=A3=AC=C9=CF=CE=E76:54=A3=ACFUJITA Tom=
onori <tomof@acm.org> =D0=B4=B5=C0=A3=BA
>=20
> On Thu,  2 Jun 2016 15:17:11 +0800
> Feng Li <li.feng@oracle.com> wrote:
>=20
>> From: Feng Li <lifeng1519@gmail.com>
>>=20
>> When I read this code, I found it's hard to understand about these m=
acros.
>> I hardly find where are the definitions of some functions.
>> Therefore, I expand them to normal functions for convience.
>>=20
>> Signed-off-by: Feng Li <lifeng1519@gmail.com>
>> ---
>> usr/scsi_cmnd.h | 298 ++++++++++++++++++++++++++++++++--------------=
----------
>> 1 file changed, 170 insertions(+), 128 deletions(-)
>=20
> Sorry, I'm not inclined to apply this.
>=20
> I agree that it's hard to understand these macros however it has been
> working. Also it's unlikely that we would need to change them
> frequently. So I want to avoid change the working code just for
> readability.
