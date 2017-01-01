From: Mr Dini <diniboy74@gmail.com>
Subject: Re: open-iscsi Cannot connect to my tgt target
Date: Sun, 1 Jan 2017 21:02:34 +0100
Message-ID: <CANVNt1Y7UO53J63Z=Rn1DCXRX4pUmbSddDQvjz2P5ZBUEUk9Lg@mail.gmail.com>
References: <CANVNt1axh1GoC28Y+Ztph_=gQP1zHeG-8BDdW47onAFX3dSH9Q@mail.gmail.com>
 <CAJt62OeYC9HWjWFfoKcf0dhKYMT7d3gkvy5HC8pjiW4D3QKXkw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to;
        bh=gqYuwghdp0stPEFAC1cKlsQbx2/e4B8qtv0p+K7FOIo=;
        b=manWbNcvVCZt9xbclH2rxJwDzodc7p/I1v9qu1ZbWc/mFF3kWZg7ECxwp7ptHD0snS
         RI3507UBIhD6p7CwoqxogF1ZPtZpwrLx59qKBbFikoysXWh+tnBwAbkulYMy7g4mRAMR
         Lk89HrYwunC7JPtZGC50Lu/lA30Nxez2Lmbjt2o6GXxEPc3adO/TNK2X6aJRr7pZbgF9
         GMj1DP31ESQVEvOG3CgF/zFDS8Nv83z5uzVXJszp3aPNzKZviUgFXRT06omI9EYxDeS6
         ZHHx/GLpQR9LR61dFW1HuvsTENYVu57fPUW7tUJUaNZ3U0tgjv2wmmv4zEFXVAjnzlzY
         GRWw==
In-Reply-To: <CAJt62OeYC9HWjWFfoKcf0dhKYMT7d3gkvy5HC8pjiW4D3QKXkw@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Ovi Chis (OviOS Linux Project)" <ovios.storage@gmail.com>, stgt@vger.kernel.org

Thanks for Your quick reply!

And Your tip worked. :) If I configure the target without user
authentication, everything works perfectly. But if there is a CHAP
user and pass, the open-iscsi Cannot connect. But the Windows PCs Can
handle the CHAP data, So that is a half win. I just have to figure
out, how Can I specify the user and pass parameters at the open-iscsi
connect command.

secondly, the target name isn't conforming to the required standards.


The name is correct. I just edited the target name because I don't
want to share my domain and etc.


Many thanks!

2016-12-31 15:31 GMT+01:00 Ovi Chis (OviOS Linux Project)
<ovios.storage@gmail.com>:
> hi,
>
> there are 2 things I think are not right in your config.
> Firts is the
> Account information:
>         testing
>         testing-out (outgoing)
>
> I am pretty sure this isn't configured properly, just try to configure a
> target without chap.
> you can use the wiki page I wrote for Arch Linux
> https://wiki.archlinux.org/index.php/TGT_iSCSI_Target
>
> secondly, the target name isn't conforming to the required standards.
> I know TGT itself doesn't care about the target names, but your innitiator
> might
>
>
>
> On 31 Dec 2016 04:30, "Mr Dini" <diniboy74@gmail.com> wrote:
>>
>> Hi,
>>
>> i am new at the iSCSI's wonderful world, So please ignore my noobness...
>>
>> I wanted to install the tgt to my ARM NAS, So I had to compile the
>> source and create a package. That was successfull. :)
>>
>> After it, I configured a target to a simple test environment, see here
>> (http://pastebin.com/u24gZ6JC).
>>
>> But when I try to login, using open-iscsi on my Ubuntu 16.04v desktop,
>> it gives me the following error:
>>
>> sudo iscsiadm -m node --login
>> Logging in to [iface: default, target: iqn.<secret>:<secret>, portal:
>> 10.0.0.27,3260] (multiple)
>> iscsiadm: Could not login to [iface: default, target:
>> iqn.<secret>:<secret>, portal: 10.0.0.27,3260].
>> iscsiadm: initiator reported error (24 - iSCSI login failed due to
>> authorization failure)
>> iscsiadm: Could not log into all portals
>>
>> What Can I Do?
>>
>> Many thanks!
>> --
>> To unsubscribe from this list: send the line "unsubscribe stgt" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
