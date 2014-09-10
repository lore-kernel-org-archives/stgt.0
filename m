From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: attached devices exported by tgt not oprational
Date: Wed, 10 Sep 2014 11:21:59 -0700
Message-ID: <CAN05THR5CspBXYiJtFKW3BoMCNsjFdPS27DYB9g6mNy6pA1SGg@mail.gmail.com>
References: <4c901b0f.155f4.14834f2d962.Coremail.xizhiyong18@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=tGc1B75FYpUL1Womvyz90jsrESsxq+GCmkvoi+tYqjQ=;
        b=Rywk+M5AQ2v4rn74REvOUprPTuTl/7i0YT76d8inA9s4NOzDY8Mdm1lVjScqUm3nBu
         nw+qyT/oNEafMrxH2j3ywu/yvkjJj01E7mIjqtekNZTbuMwUx56Xio5ZjW0wacO5krq4
         7S7v9l1Fx541SZcMhtHGi9tYGooVWY8uEReefFOW9zt7ITVnakVhgROfZ+Y/8v2T8xT7
         4n9rLBFfupYV4BvZ7M0816EiIdEUVU5crbADRSp0nOiTUAt1g13JrVtHsJMApTmH/k4W
         5hGY96rfuMENibH3+6x/oyqH91AEqD735BogqY/BOPFZgvGdQQiLxR76gNltMYfQ31eS
         3cQw==
In-Reply-To: <4c901b0f.155f4.14834f2d962.Coremail.xizhiyong18@163.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?5bit5pm65YuH?= <xizhiyong18@163.com>
Cc: stgt <stgt@vger.kernel.org>

When  you say "many devices" exactly how many are you referring to?
Can you check if this problem you have only occur when you go from 255
LUNs to something higher?


The default LUN addressing scheme only allows LUNs numbered 0 to 255.
To go to higher LUN numbers, which TGTD supports, doe require that you
switch to a different addressing format
and it may be that your initiator can not handle those other modes.

Often it might look like you have LUNs 0-255 and then there is a jump
to the next LUN which has the number 16640 if the initiator can not
handle addressing modes properly.


I do not know how IET does the LUN numbering.

If you can collect a wireshark trace of iscsiadm --login  from both
STGT and IET then I can take a quick look and see if that is the issue
you are facing.



regards
ronnie sahlberg


On Mon, Sep 1, 2014 at 11:00 PM, =E5=B8=AD=E6=99=BA=E5=8B=87 <xizhiyong=
18@163.com> wrote:
>
> when i export many block device by tgt , in one single target , this =
means many exported lun in one target, to another
> machine by iscsi=E3=80=82
>
> in another machine , attach the devices by open-iscsi=E3=80=82when i =
wait the
> size of the device attached change from 0 to correct size=EF=BC=8C i =
create raid1 with two devices by mdadm=E3=80=82at this time, mdadm repo=
rt like
> "/dev/sdem is not suitable for this array.", i read the code of mdadm=
 ,that because it cannot open the device=E3=80=82sometime it even repor=
t
> "failed to open /dev/** after earlier success - aborting "=E3=80=82
>
> i do not know whether it's because i used the device when it's not re=
ady yet, or the problem of tgt=E3=80=82
>
> all the above said happened when many target lun(tgt) created at the =
same
> time concurrently=E3=80=82it do not happen in nomal time. when i chan=
ge tgt to iet, it
> do not happen either=E3=80=82
>
>
>
> tgt version: 1.0.48
>
> open-iscsi version:iscsiadm version 2.0-873
>
> linux system: Linux  3.10.40-amd64  GNU/Linux
>
>
>
>
>
> -------------
>
> Zhiyong Xi
