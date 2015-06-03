From: "Michael Grover" <mgrover@secturion.com>
Subject: RE: FW: Error when creating a logicalunit from a regular file
Date: Tue, 2 Jun 2015 18:39:14 -0600
Message-ID: <002a01d09d95$b7b7d330$27277990$@secturion.com>
References: <CAKNWCPb+GZcSaJ1QB8OE392HCm6Xi6s3OvgFzVxNRiiRgM3S_w@mail.gmail.com>	<001201d09d89$f2b987f0$d82c97d0$@secturion.com> <CAKNWCPZ_Ub=wZPhZn_Dsd93ujMnv1pjotz9Rn+XFHBp+8w6qwg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAKNWCPZ_Ub=wZPhZn_Dsd93ujMnv1pjotz9Rn+XFHBp+8w6qwg@mail.gmail.com>
Content-Language: en-us
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: 'Ahmed Al-Mehdi' <ahmedalmehdi@gmail.com>, stgt@vger.kernel.org

Yes. Of course. Sorry about that! Run this to install semanage:

yum =E2=80=93y install policycoreutils-python

-----Original Message-----
=46rom: Ahmed Al-Mehdi [mailto:ahmedalmehdi@gmail.com]=20
Sent: Tuesday, June 02, 2015 6:11 PM
To: Michael Grover; stgt@vger.kernel.org
Subject: Re: FW: Error when creating a logicalunit from a regular file

Hi Michael,

Thank you for the suggestion.  I will look into trying it out.  Just a =
bit of a background. I am running CentOS 7.  I don't even have "semanag=
e" installed by default, but I am sure I can install it.  I looked into=
 the man page of "semange" (option "fcontext") not sure what exactly th=
e command is doing.  Any idea?

Thank you,
Ahmed.


On Tue, Jun 2, 2015 at 4:14 PM, Michael Grover <mgrover@secturion.com> =
wrote:
> Ahmed,
>
> For some reason stgt is blocking my access to the mail server from th=
is address, so I'm going around it.
>
> I had the exact same problem with CentOS 6.5 when I was trying to cre=
ate some "file" drives. SELinux was denying iSCSI access to the files I=
 was creating as drives in iSCSI. I ran the following commands:
>
> semanage fcontext =E2=80=93a =E2=80=93t tgtd_var_lib_t <drive_path> r=
estorecon =E2=80=93Rv=20
> <drive_path>
>
> Then restarted tgt and all was well.
>
> Hope this helps!
>
>
> -----Original Message-----
> From: stgt-owner@vger.kernel.org [mailto:stgt-owner@vger.kernel.org]=20
> On Behalf Of Ahmed Al-Mehdi
> Sent: Tuesday, June 02, 2015 3:48 PM
> To: stgt@vger.kernel.org
> Subject: Error when creating a logicalunit from a regular file
>
> Hello,
>
> I am trying to setup tgt on a CentOS 7 system.    I created a target,
> and enabled "ALL" initiators to login.  When I try to create a logica=
l unit from a regular file (which I believe is supported and should
> work), I get the error message "tgtadm: invalid request".   In the
> logs, I see an error message related to "Permission denied".  Can som=
eone please help or give me pointers to debug this issue.  Please CC me=
 in the response.
>
>
> # tgtadm --mode target --op new --tid 1 --targetname target1 # tgtadm=
 --mode target --op bind --tid 1 -I ALL # tgtadm --mode target --op sho=
w Target 1: target1
>     System information:
>         Driver: iscsi
>         State: ready
>     I_T nexus information:
>     LUN information:
>         LUN: 0
>             Type: controller
>             SCSI ID: IET     00010000
>             SCSI SN: beaf10
>             Size: 0 MB, Block size: 1
>             Online: Yes
>             Removable media: No
>             Prevent removal: No
>             Readonly: No
>             SWP: No
>             Thin-provisioning: No
>             Backing store type: null
>             Backing store path: None
>             Backing store flags:
>     Account information:
>     ACL information:
>         ALL
>
>
> # ls -l /tmp/tgt_disk2_dd
> -rwxrwxrwx. 1 root root 1048576 Jun  2 14:18 /tmp/tgt_disk2_dd
>
> # tgtadm --lld iscsi  --mode logicalunit --op new --tid 1 --lun 2  -b=
=20
> /tmp/tgt_disk2_dd
> tgtadm: invalid request
>
>
> I see the following log entries:
>
> Jun 02 14:39:46 unknown0800275C3F01 tgtd[5505]: tgtd: device_mgmt(246=
)
> sz:23 params:path=3D/tmp/tgt_disk2_dd
> Jun 02 14:39:46 unknown0800275C3F01 tgtd[5505]: tgtd: bs_thread_open(=
412) 16 Jun 02 14:39:46 unknown0800275C3F01 tgtd[5505]: tgtd:
> backed_file_open(92) Could not open /tmp/tgt_disk2_dd, Permission den=
ied Jun 02 14:39:46 unknown0800275C3F01 tgtd[5505]: tgtd:
> backed_file_open(92) Could not open /tmp/tgt_disk2_dd, Permission=20
> denied
>
>
> Thank you very much in advance,
> Ahmed.
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in th=
e=20
> body of a message to majordomo@vger.kernel.org More majordomo info at=
  http://vger.kernel.org/majordomo-info.html
>
