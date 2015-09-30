From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: Does tgt-admin supports bs-type sheepdog?
Date: Wed, 30 Sep 2015 09:45:38 +0200
Message-ID: <560B9322.1060708@mejor.pl>
References: <560A7D5C.9030909@mejor.pl>
 <CAE1WaKLUU2Ci7O7amRYHG28YGRs5hfG5_uMHu6Co3xjFbL2hoA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mejor.pl;
	 s=cokolwiek; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
	MIME-Version:Date:Message-ID:From:Cc:References:To:Subject;
	bh=RnQfGItHUkC6tQ6yy8wfwy++/86TZKP5hRnUV5o/a8k=; b=qLCeDtQh5OWEX/Dl9kK3VWJ8+r
	NF9/s5UypMdvE7BvoGFluKyvA4DqE5bo7BP1s2DLwMbX9fz69sqRZsbzgNrcYcl3sh5i9Xm2CpspB
	gOW429HgbGpkDII/HN0gbKm/V;
In-Reply-To: <CAE1WaKLUU2Ci7O7amRYHG28YGRs5hfG5_uMHu6Co3xjFbL2hoA@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="macroman"; format="flowed"
To: Hitoshi Mitake <mitake.hitoshi@gmail.com>, sheepdog <sheepdog@lists.wpkg.org>
Cc: stgt <stgt@vger.kernel.org>

W dniu 30.09.2015 o 03:57, Hitoshi Mitake pisze:
> Hi Marcin,
>
> On Tue, Sep 29, 2015 at 9:00 PM, Marcin Miros=C5=82aw <marcin@mejor.p=
l> wrote:
>> Hello all!
>>
>> I've got installed tgt-1.0.60, iI'm trying to define sheepdog store =
in
>> targets.conf file. Content of targets.conf is:
>> # cat /etc/tgt/targets.conf
>> default-driver iscsi
>>
>> <target iqn.backup.sheep:usun>
>>          bs-type sheepdog
>>          backing-store tcp:127.0.0.1:7000:usun
>> </target>
>>
>> but tgt-admin throws:
>> # tgt-admin -p -e
>> # Adding target: iqn.backup.sheep:usun
>> tgtadm -C 0 --lld iscsi --op new --mode target --tid 1 -T
>> iqn.backup.sheep:usun
>> # Skipping device: tcp:127.0.0.1:7000:usun
>> # tcp:127.0.0.1:7000:usun does not exist - please check the
>> configuration file
>> tgtadm -C 0 --lld iscsi --op bind --mode target --tid 1 -I ALL
>>
>>
>> Does tgt-admin supports sheepdog or I made a mistake in targets.conf=
?
>
> AFAIK, the script doesn't support sheepdog as a backing store type.
> Could you add it to our issue tracker? Someone will work on it in the
> near future :)


Thanks for answer, I assumed that "our issue tracker" is a sheepdog=20
tracker;) https://github.com/sheepdog/sheepdog/issues/176
Done,
Marcin
