From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Reply:Fw:Reply:Reply:Re: attached devices exported by tgt not oprational
Date: Tue, 23 Sep 2014 12:48:00 -0700
Message-ID: <CAN05THSp7Dum6qOKHbxFJvFDMHTN9yJ6E58GGN+16dUvjoXNWA@mail.gmail.com>
References: <3616009.10224.1489d510c3b.Coremail.xizhiyong18@163.com>
	<365c29a9.b193.148a1a32a70.Coremail.xizhiyong18@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=ksu1zyFasWYUYI2ExhLh59Ac/PTY0Cyn1hH6iWNQ3XE=;
        b=tvALuEBoQt4JKuJNkRIedUlanKZlKex4t8ljW/XuEZRaPCC5FxJCCOVgQqsF5P/4HV
         VEjIfBeYL1WeK5p82nboVqLdaYQlMw3W6J7zq0rPl7Ume7O1acXg/X8hvsK2NsCQ7B+3
         2lfZrHGAYAop70aXnb94wlNpVwxLq7/BUe0T/C75Z2R7IBcfMK+A/bdFPE844MHmCTIT
         cfy7DBDkygIsTptVnu2xTlgSPPR1R98r8I+W1mhKMwun4CzXC3j1yUoGSEUZnFwjpgXC
         xrY5xY4wpIwQA2XDXkjEjnkyxAfb8WM0hMOftup5/PifduovpYxmbqaKrxv/alkdmnmp
         2mTw==
In-Reply-To: <365c29a9.b193.148a1a32a70.Coremail.xizhiyong18@163.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?5bit5pm65YuH?= <xizhiyong18@163.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stgt <stgt@vger.kernel.org>

On Tue, Sep 23, 2014 at 1:31 AM, =E5=B8=AD=E6=99=BA=E5=8B=87 <xizhiyong=
18@163.com> wrote:
>
> in tgt, i found that, when a lun is created or destroyed, ASC_REPORTE=
D_LUNS_DATA_HAS_CHANGED was add to I_T by
> ua_sense_add(), except for command REPORT LUN,
> in IET, i do not find the same program logic,
> is this the reason why i met the problem when i using tgt, but not wh=
en IET=EF=BC=9F


That is very likely and probably why you see this.
It is odd that your initiator appears to temporarily drop the capacity
to 0 on this
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.752462] sdd: detected=
 capacity change from 1073807360 to 0
until it has re-issued a new READCAPACITY to re-learn the correct
capacity again.

I would have imagined that an initiator would have kept the old data
until the point it could verify whether the device had actually
changed or not.
But maybe they have reason for this? But it sounds somewhat odd
initiator behaviour.


=46or device startup, when you start tgtd and there are ways to stop th=
e
initiator from being able to access any LUNs at all until you have
finished setting up everything in TGTD.

If you use tgtadm to set up the target and all the LUNs, then if you
change your scripts so that you create all the LUNs and all the
configuration before allowing any initiators to connect,
then I think your initiators will not see these unit attentions.

I.e. change the scripts to wait doing this line at the very end when
LUN creation has finished :
   # Allow ALL initiators to connect to this target
   tgtadm --lld iscsi --mode target --op bind --tid 1 --initiator-addre=
ss ALL


I do not know the corresponding way to do this with tgt-admin since I
never use that tool :-(


If this only happens when you start the tgt service and you use
/etc/init.d/ scripts from your system, you can check in which order
the script does these things.
I never use the scripts that come from the distros so I don;t know the
exact details in which order they do things.


regards
ronnie sahlberg


>
>
> At 2014-09-22 20:23:27, "=E5=B8=AD=E6=99=BA=E5=8B=87" <xizhiyong18@16=
3.com> wrote:
>>may you give some advise to me about the problem report by me.
>>
>>-------- Forwarding messages --------
>>From: "=E5=B8=AD=E6=99=BA=E5=8B=87" &lt;xizhiyong18@163.com&gt;
>>Date: 2014-09-22 03:29:51
>>To:  "=E5=B8=AD=E6=99=BA=E5=8B=87" &lt;xizhiyong18@163.com&gt;
>>Cc:  "ronnie sahlberg" &lt;ronniesahlberg@gmail.com&gt;,stgt@vger.ker=
nel.org
>>Subject: Reply:Reply:Re: attached devices exported by tgt not opratio=
nal
>>from the syslog of the initiator side, it seams the sd_revalide_disk =
was trigged more
>>than once, and it succeed first time, when logged  "sd 7:0:0:4: [sdf]=
 Attached SCSI disk",
>>i don't when and where the sd_revalidate was called again, and it fai=
led when send SCSI
>>command TEST_UNIT_READ and RRAD_CAPACITY.
>>
>>
>>
>>At 2014-09-11 11:35:57, "=E5=B8=AD=E6=99=BA=E5=8B=87" <xizhiyong18@16=
3.com> wrote:
>>>first of all, thanks for your reply.
>>>in my program, it will use 128 LUNS at the most each target, so LUNS=
 id will
>>>not outnumber 255.
>>>
>>>here is some syslog when the problem occur. you can search [sdf] to =
find some
>>>info, like "[sdf] READ CAPACITY(16) failed" or "[sdf] Unit Not Ready=
", and "sdf: detected capacity change from 9664266240 to 0",
>>>"Sense Key : Illegal Request [current]", "Add. Sense: Logical unit n=
ot supported"
>>>--------------------------------------------------------------------=
----------------------
>>>
>>>#:~/tgt_debug$ cat syslog |grep -C 1 -e "sdf\|sd 7:0:0:4"
>>>
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.426520] sd 7:0:0:4: [=
sdf] 18875520 512-byte logical blocks: (9.66 GB/9.00 GiB)
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.426629] sd 7:0:0:3: [=
sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or =
=46UA
>>>--
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.427236] sd 7:0:0:5: A=
ttached scsi generic sg12 type 0
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.427409] sd 7:0:0:4: [=
sdf] Write Protect is off
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.427414] sd 7:0:0:4: [=
sdf] Mode Sense: 69 00 00 08
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.427545] sd 7:0:0:5: [=
sdg] 2097280 512-byte logical blocks: (1.07 GB/1.00 GiB)
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.427875] sd 7:0:0:4: [=
sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or =
=46UA
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.427926] scsi 7:0:0:7:=
 Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
>>>--
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.443681] sd 7:0:0:5: [=
sdg] Attached SCSI disk
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.458714]  sdf: unknown=
 partition table
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.460786] sd 7:0:0:4: [=
sdf] Attached SCSI disk
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.476316]  sdh: unknown=
 partition table
>>>--
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.701790] Add. Sense: R=
eported luns data has changed
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.703810] sd 7:0:0:4: [=
sdf] Unit Not Ready
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.703814] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.703815] Sense Key : U=
nit Attention [current]
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.703818] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:25 10-120-120-35 kernel: [1144399.703821] Add. Sense: R=
eported luns data has changed
>>>--
>>>Aug 26 16:02:26 10-120-120-35 kernel: [1144400.336478] Add. Sense: R=
eported luns data has changed
>>>Aug 26 16:02:26 10-120-120-35 kernel: [1144400.338547] sd 7:0:0:4: [=
sdf] Unit Not Ready
>>>Aug 26 16:02:26 10-120-120-35 kernel: [1144400.338552] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:26 10-120-120-35 kernel: [1144400.338554] Sense Key : U=
nit Attention [current]
>>>Aug 26 16:02:26 10-120-120-35 kernel: [1144400.338558] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:26 10-120-120-35 kernel: [1144400.338561] Add. Sense: R=
eported luns data has changed
>>>--
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.752462] sdd: detected=
 capacity change from 1073807360 to 0
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.752987] sd 7:0:0:4: [=
sdf] Unit Not Ready
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.752990] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.752991] Sense Key : U=
nit Attention [current]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.752994] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.752997] Add. Sense: R=
eported luns data has changed
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753254] sd 7:0:0:4: W=
arning! Received an indication that the LUN assignments on this target =
have changed. The Linux SCSI layer does not automatically remap LUN ass=
ignments.
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753472] sd 7:0:0:4: W=
arning! Received an indication that the LUN assignments on this target =
have changed. The Linux SCSI layer does not automatically remap LUN ass=
ignments.
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753655] sd 7:0:0:4: W=
arning! Received an indication that the LUN assignments on this target =
have changed. The Linux SCSI layer does not automatically remap LUN ass=
ignments.
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753666] sd 7:0:0:4: [=
sdf] READ CAPACITY(16) failed
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753672] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753674] Result: hostb=
yte=3DDID_OK driverbyte=3DDRIVER_SENSE
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753676] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753677] Sense Key : U=
nit Attention [current]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753680] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753682] Add. Sense: R=
eported luns data has changed
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.753883] sd 7:0:0:4: W=
arning! Received an indication that the LUN assignments on this target =
have changed. The Linux SCSI layer does not automatically remap LUN ass=
ignments.
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.754075] sd 7:0:0:4: W=
arning! Received an indication that the LUN assignments on this target =
have changed. The Linux SCSI layer does not automatically remap LUN ass=
ignments.
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.754275] sd 7:0:0:4: W=
arning! Received an indication that the LUN assignments on this target =
have changed. The Linux SCSI layer does not automatically remap LUN ass=
ignments.
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.754286] sd 7:0:0:4: [=
sdf] READ CAPACITY failed
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.754291] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.754292] Result: hostb=
yte=3DDID_OK driverbyte=3DDRIVER_SENSE
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.754295] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.754296] Sense Key : U=
nit Attention [current]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.754299] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.754301] Add. Sense: R=
eported luns data has changed
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.756150] sdf: detected=
 capacity change from 9664266240 to 0
>>>Aug 26 16:02:28 10-120-120-35 kernel: [1144402.756639] sd 7:0:0:5: [=
sdg] Unit Not Ready
>>>--
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144402.925588] scsi 3:0:0:21=
: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144402.925959] sd 7:0:0:4: [=
sdf] 18875520 512-byte logical blocks: (9.66 GB/9.00 GiB)
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144402.926000] sd 3:0:0:21: =
Attached scsi generic sg59 type 0
>>>--
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144402.927749] sd 3:0:0:22: =
[sdbc] 18875520 512-byte logical blocks: (9.66 GB/9.00 GiB)
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144402.927762] sdf: detected=
 capacity change from 0 to 9664266240
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144402.927843] scsi 3:0:0:23=
: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
>>>--
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.191743] Add. Sense: R=
eported luns data has changed
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.195776] sd 7:0:0:4: [=
sdf] Unit Not Ready
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.195779] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.195780] Sense Key : U=
nit Attention [current]
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.195784] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.195786] Add. Sense: R=
eported luns data has changed
>>>--
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.592427] sd 7:0:0:39: =
[sdbx] Mode Sense: 69 00 00 08
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.592809] sd 7:0:0:40: =
Attached scsi generic sg82 type 0
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.594486] sd 7:0:0:39: =
[sdbx] Write cache: enabled, read cache: enabled, doesn't support DPO o=
r FUA
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.594696] sd 7:0:0:40: =
[sdby] 18875520 512-byte logical blocks: (9.66 GB/9.00 GiB)
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.595825] sd 7:0:0:40: =
[sdby] Write Protect is off
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.595831] sd 7:0:0:40: =
[sdby] Mode Sense: 69 00 00 08
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.596261] sd 7:0:0:40: =
[sdby] Write cache: enabled, read cache: enabled, doesn't support DPO o=
r FUA
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.605687]  sdbx: unknow=
n partition table
>>>--
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.610455] sd 7:0:0:39: =
[sdbx] Attached SCSI disk
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.613057] sd 7:0:0:40: =
[sdby] Attached SCSI disk
>>>Aug 26 16:02:29 10-120-120-35 kernel: [1144403.617631] sd 3:0:0:13: =
[sdaf] Warning! Received an indication that the LUN assignments on this=
 target have changed. The Linux SCSI layer does not automatically remap=
 LUN assignments.
>>>--
>>>Aug 26 16:02:33 10-120-120-35 kernel: [1144407.432518]  md113: unkno=
wn partition table
>>>Aug 26 16:02:33 10-120-120-35 kernel: [1144407.662356] sd 7:0:0:4: [=
sdf] Synchronizing SCSI cache
>>>Aug 26 16:02:33 10-120-120-35 kernel: [1144407.663163] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:33 10-120-120-35 kernel: [1144407.663167] Result: hostb=
yte=3DDID_OK driverbyte=3DDRIVER_SENSE
>>>Aug 26 16:02:33 10-120-120-35 kernel: [1144407.663170] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:33 10-120-120-35 kernel: [1144407.663172] Sense Key : I=
llegal Request [current]
>>>Aug 26 16:02:33 10-120-120-35 kernel: [1144407.663175] sd 7:0:0:4: [=
sdf]
>>>Aug 26 16:02:33 10-120-120-35 kernel: [1144407.663178] Add. Sense: L=
ogical unit not supported
>>>
>>>
>>>At 2014-09-11 02:21:59, "ronnie sahlberg" <ronniesahlberg@gmail.com>=
 wrote:
>>>>When  you say "many devices" exactly how many are you referring to?
>>>>Can you check if this problem you have only occur when you go from =
255
>>>>LUNs to something higher?
>>>>
>>>>
>>>>The default LUN addressing scheme only allows LUNs numbered 0 to 25=
5.
>>>>To go to higher LUN numbers, which TGTD supports, doe require that =
you
>>>>switch to a different addressing format
>>>>and it may be that your initiator can not handle those other modes.
>>>>
>>>>Often it might look like you have LUNs 0-255 and then there is a ju=
mp
>>>>to the next LUN which has the number 16640 if the initiator can not
>>>>handle addressing modes properly.
>>>>
>>>>
>>>>I do not know how IET does the LUN numbering.
>>>>
>>>>If you can collect a wireshark trace of iscsiadm --login  from both
>>>>STGT and IET then I can take a quick look and see if that is the is=
sue
>>>>you are facing.
>>>>
>>>>
>>>>
>>>>regards
>>>>ronnie sahlberg
>>>>
>>>>
>>>>On Mon, Sep 1, 2014 at 11:00 PM, =E5=B8=AD=E6=99=BA=E5=8B=87 <xizhi=
yong18@163.com> wrote:
>>>>>
>>>>> when i export many block device by tgt , in one single target , t=
his means many exported lun in one target, to another
>>>>> machine by iscsi=E3=80=82
>>>>>
>>>>> in another machine , attach the devices by open-iscsi=E3=80=82whe=
n i wait the
>>>>> size of the device attached change from 0 to correct size=EF=BC=8C=
 i create raid1 with two devices by mdadm=E3=80=82at this time, mdadm r=
eport like
>>>>> "/dev/sdem is not suitable for this array.", i read the code of m=
dadm ,that because it cannot open the device=E3=80=82sometime it even r=
eport
>>>>> "failed to open /dev/** after earlier success - aborting "=E3=80=82
>>>>>
>>>>> i do not know whether it's because i used the device when it's no=
t ready yet, or the problem of tgt=E3=80=82
>>>>>
>>>>> all the above said happened when many target lun(tgt) created at =
the same
>>>>> time concurrently=E3=80=82it do not happen in nomal time. when i =
change tgt to iet, it
>>>>> do not happen either=E3=80=82
>>>>>
>>>>>
>>>>>
>>>>> tgt version: 1.0.48
>>>>>
>>>>> open-iscsi version:iscsiadm version 2.0-873
>>>>>
>>>>> linux system: Linux  3.10.40-amd64  GNU/Linux
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> -------------
>>>>>
>>>>> Zhiyong Xi
