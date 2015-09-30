From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: Re: Does tgt-admin supports bs-type sheepdog?
Date: Wed, 30 Sep 2015 10:57:46 +0900
Message-ID: <CAE1WaKLUU2Ci7O7amRYHG28YGRs5hfG5_uMHu6Co3xjFbL2hoA@mail.gmail.com>
References: <560A7D5C.9030909@mejor.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=hz5OT3KQDVc8BrupK/zjKEtxRuudEIWC2C69IsXaB7M=;
        b=kwum7TzdwEgOYFteG9Qnq5Sh2RQsErWMiaVWsY+XfdNxjLfTTWslhmIZspOkVkTmiH
         +aV3r75DWo0r53/9ud9ky0dUO//wR2p0mUD0boCxKbHR13Fu8SBGEOvTjiKeRAiGVqpp
         FauvVGFA34ikG4Lf3ESiZeMv/ltf4PaV4b6N9NW3+rzIMYw4fFaSAfL1ZJskw6XQvAGY
         UASGPrldMzVHt4UIHmS44USI5tuG3rt0jxExnZfkWq5YHXmqBa6rWqFThKa2wPobST+/
         3kzBsYqia0gpXc2fKxK6eaAPh1EnzwgeZhEbFHomkiKmKOig6XvH4fEcNpsRKBXGqdmh
         UtrA==
In-Reply-To: <560A7D5C.9030909@mejor.pl>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Marcin_Miros=C5=82aw?= <marcin@mejor.pl>, sheepdog <sheepdog@lists.wpkg.org>
Cc: stgt <stgt@vger.kernel.org>

Hi Marcin,

On Tue, Sep 29, 2015 at 9:00 PM, Marcin Miros=C5=82aw <marcin@mejor.pl>=
 wrote:
> Hello all!
>
> I've got installed tgt-1.0.60, iI'm trying to define sheepdog store i=
n
> targets.conf file. Content of targets.conf is:
> # cat /etc/tgt/targets.conf
> default-driver iscsi
>
> <target iqn.backup.sheep:usun>
>         bs-type sheepdog
>         backing-store tcp:127.0.0.1:7000:usun
> </target>
>
> but tgt-admin throws:
> # tgt-admin -p -e
> # Adding target: iqn.backup.sheep:usun
> tgtadm -C 0 --lld iscsi --op new --mode target --tid 1 -T
> iqn.backup.sheep:usun
> # Skipping device: tcp:127.0.0.1:7000:usun
> # tcp:127.0.0.1:7000:usun does not exist - please check the
> configuration file
> tgtadm -C 0 --lld iscsi --op bind --mode target --tid 1 -I ALL
>
>
> Does tgt-admin supports sheepdog or I made a mistake in targets.conf?

AFAIK, the script doesn't support sheepdog as a backing store type.
Could you add it to our issue tracker? Someone will work on it in the
near future :)

Thanks,
Hitoshi

>
> Marcin
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
