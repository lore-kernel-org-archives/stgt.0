From: =?UTF-8?Q?C=c3=a9dric_Lemarchand?= <cedric.lemarchand@tdf.fr>
Subject: Re: ext4 corruption with MPIO and path_grouping_policy "multibus"
Date: Wed, 17 Jan 2018 16:08:22 +0100
Message-ID: <da4703e9-d6fd-fb8b-0ea3-3a084c97b939@tdf.fr>
References: <63aea0d2-ac82-914d-6abd-10a20538646b@tdf.fr>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=TDF1.onmicrosoft.com;
 s=selector1-tdf-fr; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hljHTELgBBq8Jn0iPNeZ6zwqfbVBXSSPN7IGrs3e3rQ=;
 b=dbBkoOVjmfy+NTVHI2FeM/ASy3AKq+1lSWC4xVIdh2X3OB8HDAiX75IPuZ54d5OnuSi5p4VzFT0OdfQYOxz6zw3coTQIIc/Dk7E5n1E4vo/NI7t/xgk3zynwNxspCcnJKta3h4+2oIJBPw5WhDihOujlrvR72gpNTGEeqtBbAFk=
In-Reply-To: <63aea0d2-ac82-914d-6abd-10a20538646b@tdf.fr>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: stgt@vger.kernel.org

For the sake of history, I solve the issue by setting "bstype aio", 
which is "rdwr" by default.

Cheers


On 15/01/2018 18:55, Cédric Lemarchand wrote:
> Hello,
>
> One initiator is accessing 2 TGT instances on 2 hosts where the same 
> block device is shared among them (actually an RBD volume). The 
> configuration is as follow:
>
> TGT1:
> <target iqn.2017-08.storage:rbd0-1>
> direct-store /dev/rbd0
> write-cache off
> </target>
>
> TGT2:
> <target iqn.2017-08.storage:rbd0-2>
> direct-store /dev/rbd0
> write-cache off
> </target>
>
> On the initiator, when multipath is configured with 
> 'path_grouping_policy "multibus"' and formated in ext4, the fsck fails 
> systematically. The output of "multipath -ll" in the MP device :
>
> 360000000000000000e00000000010001 dm-17 IET,VIRTUAL-DISK
> size=93G features='1 retain_attached_hw_handler' hwhandler='0' wp=rw
> `-+- policy='service-time 0' prio=1 status=active
>   |- 11:0:0:1 sds 65:32 active ready running
>   `- 12:0:0:1 sdt 65:48 active ready running
>
> I not some errors when tgt start :
>
> read capacity (16): pass through os error: Inappropriate ioctl for device
> READ CAPACITY (16) failed: Sense category: -1, try '-v' option for 
> more information
>
> I cannot reproduce this issue with 'path_grouping_policy "failover"', 
> nor whit LIO as iSCSI target and 'path_grouping_policy "multibus"'. On 
> TGT hosts, the rbd cache is disabled ("rbd cache = false").
>
>
> Did I miss something ? Any enlightenment in order to debug further 
> will be welcomed.
>
> Debian Stretch
> kernel 4.9.65
> tgtd 1.0.69
> multipath-tools 0.6.4
> open-iscsi  2.0-874

-- 
Cédric Lemarchand
TDF
