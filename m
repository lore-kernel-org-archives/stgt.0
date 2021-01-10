From: Mark Harvey <markh794@gmail.com>
Subject: Re: RFC: Fault injection
Date: Mon, 11 Jan 2021 09:46:51 +1100
Message-ID: <95338304-20BE-4DF4-BBD9-473B7EEAA67B@gmail.com>
References: <20210108141206.hhiamqwn3tbk3kxl@lrrr.dead-link.org>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Content-Transfer-Encoding: quoted-printable
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PwKfVBeXT+udd8ShD5UUYyJCASNabZ6H6rUjxX8p+Bw=;
        b=kdmyLUgUGw0+YESR6G/QCDSoftQVIqVZ2dc1PX+8fT+WQqDuNnvi8v6C7b2HO6xG6Y
         8XdJkR/Yu4PHo4XjihMu/E9Z1yeqJyzl6yQ5QOvbNOJHTPGCfp7+FRHCPK8ZWUp6SMUx
         jsujrlMov/W1e2TKwPzZ1WluVtOpzE3tSaca/KY5j6Rqths3+QvrwxnIeHRIQioBqaMt
         B7mgyWeRFXv3qe2KNuL44yZGzmuOAvUjTjq5AL+UUhhgoiMeFRs3QBdhsZ2qTu9JAPi0
         qCacYx/9HAo4aQzg5S0P++Ujxh2Jf5K+eHFaXDfdLkuG/0317M2Rm4Ds8e/jxiF+CHuT
         Qcng==
In-Reply-To: <20210108141206.hhiamqwn3tbk3kxl@lrrr.dead-link.org>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michael Ablassmeier <abi@grinser.de>
Cc: stgt@vger.kernel.org

The other option would be to use (hijack) the SCSI =E2=80=98SEND =
DIAGNOSTIC=E2=80=99 / =E2=80=98RECEIVE DIAGNOSTIC RESULTS=E2=80=99 op =
codes..

Code up a list of useful fault-injection conditions within DIAGNOSTIC OP =
code.. Pass any metadata as part of the payload - such as block =
number(s), after x reads/writes, only fault on a block size of x, only =
error on barcode xyz, fail first n attempts on reading block.

The RECEIVE DIAGNOSTIC could return any conditions already set..

Just a thought.

Cheers
Mark




> On 9 Jan 2021, at 01:12, Michael Ablassmeier <abi@grinser.de> wrote:
>=20
> hi,
>=20
> im searching for a way to be able to easily simulate faulty tape =
drives
> for CI/Testing purposes. The VTL emulation in TGT seems to have all =
the
> functionality required for my purpose and so i went on and implemented =
a
> proof of concept.
>=20
> The POC uses the VTL Tapes MAM header to store information about which
> errnous behavior should be simulated in case the tape is written.
> Different tapes can as such simulate different fault behaviors.
>=20
> See following description for more details:
>=20
> =
https://github.com/abbbi/tgt/blob/fault_injection/doc/README.ssc-fault-inj=
ection
>=20
> Is there any interest in getting such a feature into TGT's VTL
> emulation? Full diff here:
>=20
> https://github.com/fujita/tgt/compare/master...abbbi:fault_injection
>=20
> As the MAM header is probably not the best way for storing the
> information, would it be a good solution to store a special file
> alongside to the VTL file, including more meta information related to
> this feature?
>=20
> bye,
>    - michael

