From: Steven Graf <sgraf@resolutech.net>
Subject: Re: about print_disksize
Date: Wed, 30 Sep 2015 08:39:57 -0400
Message-ID: <D2091F72-36DE-4840-8454-4E879FB42088@resolutech.net>
References: <0C3F6DA3760D0C4691E69E5BE224FF495E158CC6@H3CMLB12-EX.srv.huawei-3com.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=resolutech.net; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-sasl-enc
	:x-sasl-enc; s=mesmtp; bh=kqrX3aJpd/7plYq7xboL5mL6AoM=; b=Z/Jq1m
	ZdPD4DoRNHQbGonYFNGIRPVMFfwVBX91RZHPZ04ST+FXZ7LBZB/0n3Uloda0mMyi
	23/qZEXhXFK0109N0KhJZk7zJIqr8HYH64crrdPtm4enaE+ctwlLg0qdXhhlTGuT
	JLOVvS40RCPR8IsG/Bavgc1Xqxwr+g8pL6rYw=
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-sasl-enc:x-sasl-enc; s=smtpout; bh=kqrX3aJpd/7plYq
	7xboL5mL6AoM=; b=aiGDmdGO2/Ju5dyXKmo9deeGzecnrZS6GEEzfSq2jZzj4xQ
	RJ/qVrUJ5WkEmh4FMLsdRhfyPTLNYTERAgP5J9Shw+n4T3stf619zcdUMefkjo+3
	uDgXojUPLqz+C9Sw7UdmVz5IU3uIXRzk1Pp4iNbKisejBgxtPLaSHy7HkWNQ=
In-Reply-To: <0C3F6DA3760D0C4691E69E5BE224FF495E158CC6@H3CMLB12-EX.srv.huawei-3com.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="windows-1254"
To: "yangruifeng.09209@h3c.com" <yangruifeng.09209@h3c.com>
Cc: "stgt@vger.kernel.org" <stgt@vger.kernel.org>, "zhengbin.08747@h3c.com" <zhengbin.08747@h3c.com>

Yang,

I believe your computation has over simplified the calculation taking p=
lace.  A megabyte is actually 1024 * 1024.  Furthermore the calculation=
 is being run against an existing number so the result is the existing =
number expressed as MB.  Lastly the calculations seem very deliberate s=
o my assumption is that there is some additional data is in band with t=
he underlying data and needs to be stripped from the calculation.

Cheers,

-S

Sent from your iPhone

> On Sep 28, 2015, at 11:38 PM, "yangruifeng.09209@h3c.com" <yangruifen=
g.09209@h3c.com> wrote:
>=20
> Hi All=C2=A3=C2=AC
>=20
> In print_disksize(target.c)
> mb =3D ((size / 512) - (((size / 512) / 625) - 974)) / 1950;=20
>=20
> Why this?=20
> 512=C2=A1=C2=A2625=C2=A1=C2=A2974=C2=A1=C2=A21950 mean what?
>=20
> Why not like this,
> Mb =3D size / (1000 * 1000)?Simpler and easier to understand
>=20
> Thanks=C2=A3=C2=AC
> Ruifeng Yang
> =04=C3=A8=C2=BA{.n=C3=87+=E2=80=B0=C2=B7=C5=B8=C2=AE=E2=80=B0=C2=AD=E2=
=80=A0+%=C5=A0=C3=8Blzwm=E2=80=A6=C3=A9b=C2=9D=C3=AB=C2=A7=C2=B2=C3=A6=C3=
=ACr=C2=B8=E2=80=BAz=C3=8B`=C2=B6)=C3=AD=E2=80=A6=C3=A6=C3=A8w*=1Fjg=C2=
=AC=C2=B1=C2=A8=1E=C2=B6=E2=80=B0=C5=A1=C5=BD=C5=A0=C3=9D=C2=A2j/=C2=81=
=C3=AA=C3=A4z=C2=B9=C3=9E=E2=80=93=C5=A0=C3=A02=C5=A0=C3=9E=E2=84=A2=C2=
=A8=C3=A8=C2=AD=C3=9A&=C2=A2)=C3=9F=C2=A1=C2=ABa=C2=B6=C3=9A=7F=C3=BE=C3=
=B8=1E=C2=AEG=C2=AB=C2=9D=C3=A9h=C2=AE=0F=C3=A6j:+v=E2=80=B0=C2=A8=C5=A0=
w=C3=A8=E2=80=A0=C3=99=C2=A5
This email and any files transmitted with it are confidential and inten=
ded solely for the use of the individual or entity to whom they are add=
ressed. If you have received this email in error please notify the syst=
em manager. Please note that any views or opinions presented in this em=
ail are solely those of the author and do not necessarily represent tho=
se of the company. Finally, the recipient should check this email and a=
ny attachments for the presence of viruses. The company accepts no liab=
ility for any damage caused by any virus transmitted by this email.

Resolutech, LLC, PO Box 650991, Sterling, VA 20165, www.resolutech.net
