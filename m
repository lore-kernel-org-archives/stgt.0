From: eric pretorious <epretorious@gmail.com>
Subject: Re: Support for Multipath?
Date: Sat, 12 Dec 2015 09:25:45 -0800
Message-ID: <CAHtv24WBoaLfnHQA4KtHvxrd7Vc8jXxxthc8R4Y0AuXDbwyGBg@mail.gmail.com>
References: <CAHtv24W651AWGB6VyZz_d6Hnx9Zp5t4NSNAPMpzrLJjgS9RzVw@mail.gmail.com>
	<VI1PR05MB13901D8D419FFE777C882600B50A0@VI1PR05MB1390.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        bh=MI0UR/dXTG/qvU0qV7Yzp4U+FfrSLhRtxbW/pgvmWgo=;
        b=rCe0E/yVj1NA6OzOdt2VAbS4cCU8TiqXsKffZOM0N9fBQcpHt/3obw5+gMLOYE0Aeo
         3ksMtFbTyROlEExR4E+alanlBh5DBFpA1xfGC17cVQEeEQXCSp0walQtXk+g/0HlqFS2
         Ybe1X502JbbLFxHgmaVXdJAb3hUOdqj2IFLEAfx18w8180RbxpZlNChPzh3Yfsw9/o29
         Zct5+a0zVLOmr+Y+Rj1grxfnwMuCJypuJIEnWvCtP023R+OU3/o3Sguw2fWRQ6kWkaeA
         9xFmz4mD0kSPgtSTQgQvad46V2mW6oO1vjoSO5WvzmPznqN/fOzYsJSxBzKBIY8viEt4
         JZgw==
In-Reply-To: <VI1PR05MB13901D8D419FFE777C882600B50A0@VI1PR05MB1390.eurprd05.prod.outlook.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

> Do you mean support for device mapper multipath?

Yes.

> You don=E2=80=99t need anything special. Connect to tgtd from 2 ports=
 and you'll have 2 block devices (if its 1 target and 1 lun).

Thanks, Roi: That was pretty easy!

Steps to I used to verify... (Initiator is also multi-homed:
172.16.0.2.& 172.16.0.3. Target is *also* multi-homed: 172.16.0.29 &
172.16.0.30.)

> [root@initiator ~]# iscsiadm -m node
> iscsiadm: No records found
>
> [root@initiator ~]# iscsiadm -m discovery --type sendtargets -p 172.1=
6.0.29
> 172.16.0.29:3260,1 iqn.2015-12.com.example.target:One
> 172.16.0.29:3260,1 iqn.2015-12.com.example.target:Two
>
> [root@initiator ~]# iscsiadm -m discovery --type sendtargets -p 172.1=
6.0.30
> 172.16.0.30:3260,1 iqn.2015-12.com.example.target:One
> 172.16.0.30:3260,1 iqn.2015-12.com.example.target:Two
>
> [root@initiator ~]# iscsiadm -m node
> 172.16.0.29:3260,1 iqn.2015-12.com.example.target:One
> 172.16.0.30:3260,1 iqn.2015-12.com.example.target:One
> 172.16.0.29:3260,1 iqn.2015-12.com.example.target:Two
> 172.16.0.30:3260,1 iqn.2015-12.com.example.target:Two
>
> [root@initiator ~]# multipath -ll
>
> [root@initiator ~]# iscsiadm -m node -T iqn.2015-12.com.example.targe=
t:One -p 172.16.0.29 -l
> Logging in to [iface: default, target: iqn.2015-12.com.example.target=
:One, portal: 172.16.0.29,3260] (multiple)
> Login to [iface: default, target: iqn.2015-12.com.example.target:One,=
 portal: 172.16.0.29,3260] successful.
>
> [root@initiator ~]# iscsiadm -m session
> tcp: [3] 172.16.0.29:3260,1 iqn.2015-12.com.example.target:One (non-f=
lash)
>
> [root@initiator ~]# multipath -ll
> 1IET     00010001 dm-2 IET,VIRTUAL-DISK
> size=3D800M features=3D'0' hwhandler=3D'0' wp=3Drw
> `-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
>   `- 5:0:0:1 sdb 8:16 active ready running
>
> [root@initiator ~]# iscsiadm -m node -T iqn.2015-12.com.example.targe=
t:One -p 172.16.0.30 -l
> Logging in to [iface: default, target: iqn.2015-12.com.example.target=
:One, portal: 172.16.0.30,3260] (multiple)
> Login to [iface: default, target: iqn.2015-12.com.example.target:One,=
 portal: 172.16.0.30,3260] successful.
>
> [root@initiator ~]# iscsiadm -m session
> tcp: [3] 172.16.0.29:3260,1 iqn.2015-12.com.example.target:One (non-f=
lash)
> tcp: [4] 172.16.0.30:3260,1 iqn.2015-12.com.example.target:One (non-f=
lash)
>
> [root@initiator ~]# multipath -ll
> 1IET     00010001 dm-2 IET,VIRTUAL-DISK
> size=3D800M features=3D'0' hwhandler=3D'0' wp=3Drw
> |-+- policy=3D'round-robin 0' prio=3D1 status=3Denabled
> | `- 5:0:0:1 sdb 8:16 active ready running
> `-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
>   `- 6:0:0:1 sdc 8:32 active ready running

Thanks, again!

Eric Pretorious
Portland, Oregon

On Sun, Dec 6, 2015 at 4:32 AM, Roi Dayan <roid@mellanox.com> wrote:
> Hi Eric,
>
> Do you mean support for device mapper multipath?
> You don=E2=80=99t need anything special. Connect to tgtd from 2 ports=
 and you'll have 2 block devices (if its 1 target and 1 lun).
> In the initiator rescan the devices by executing multipath and using =
"multipath -l" you can see a dm that is over the 2 block devices.
>
> Thanks,
> Roi
>
> -----Original Message-----
> From: stgt-owner@vger.kernel.org [mailto:stgt-owner@vger.kernel.org] =
On Behalf Of eric pretorious
> Sent: Saturday, December 05, 2015 12:41 AM
> To: stgt@vger.kernel.org
> Subject: Support for Multipath?
>
> Hello:
>
> Does stgt include support for multipath?
> Is there any special configuration required on the target?
> How is multipath enabled/disabled/tested in stgt?
>
> --
> Eric Pretorious
> Portland, OR
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in th=
e body of a message to majordomo@vger.kernel.org More majordomo info at=
  http://vger.kernel.org/majordomo-info.html
>
> _____________________________________________________________________=
_
> This email has been scanned by the Symantec Email Security.cloud serv=
ice.
> For more information please visit http://www.symanteccloud.com ______=
________________________________________________________________



--=20
Eric Pretorious
+1.530.386.3649
