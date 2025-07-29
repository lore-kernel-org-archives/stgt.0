Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D1F285C94
	for <stgt@vger.kernel.org>; Tue, 29 Jul 2025 09:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753780102; cv=none; b=mI7tWciSl7tkahQcsAgybFOUBYJOgLjf+2Fzmc2PiRBmShpo4F4hSy3ZB3oz7XGOdAQfs5QUpaBT7gCGvwybdIJC/bSJmYH/MpiUH0qYLQHdT8kqBcbMbkxcSndLFBaGjwHpj38Gy29otJOkGKki4aTavIjqdmaqxAZUNIEAPVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753780102; c=relaxed/simple;
	bh=SUYRwpII8av2WBPXei7kKMP6yg0pMC+I1LBUGOiz9wc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=YUcWuTTkpBWSfq+EB1I2dNXwodKA5ukFC7kDZAUPyHTbhG11YOw9fSNn8RjxukBttIbAeIYcenQt0N+unfWGoSydjJLSi5hWAshhSu9uVXTflGVStCcf2f8SsCWXq/5bEKVbg5EBdruQkqpSkVWhbaJPHXgpX1h2pDwgiE6t+Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSY3csr2; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSY3csr2"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-71a38e35674so2446667b3.3
        for <stgt@vger.kernel.org>; Tue, 29 Jul 2025 02:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753780099; x=1754384899; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HewaYOSvgBdyodzRPNnxeiI3LmiHU1uKvSUKsb6EPU=;
        b=mSY3csr2w7w4WEmX64Xh7/FQp0lExLvtcj6HrQetZa8Jd69D4xARKMzOaDQvz/hTM8
         6ZVDOfVf/bQLs4ZPOwok2xsq563ad4HLJ+PmGxVYABaVEWuMjHIY8LYHonn7CDgEWQ50
         /2/ZODdxej0fGvm5o24dEYYDGNDZF1+YnVUoi44tY9EuXuWcyfbEw3413ZzI7d3/iek/
         FnuduCNuJNPwEIvMAkpwUWg4vVZAmO0hOHrqgXUzgA9AnevhVN6pVKRF4hU2nspcgZ8r
         Utx334bAm58yqPNQSGDhEpuUfc+CoHm5WB+Pk400tcgZXUS6eGu9muyGSple/fj7qv9H
         wPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780099; x=1754384899;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/HewaYOSvgBdyodzRPNnxeiI3LmiHU1uKvSUKsb6EPU=;
        b=f+O5OJB14Xiy47WweenMbLd170rQo6yx1dUld2uARK35XZ7bWNhrVktGRO/ZObZCdQ
         2nYYzHcCiJaZ5xvCELYD6Kto2tC7ZekN+dr46ReqkNdNQaXtrYmuoqGjxeO8YFMAmB15
         oUv3ZWhP+aJKlU7NV5BdNaixc2sGsdPv1OKbgkh5VMHbaet+CMyKICFoh+IwuNs4zMe7
         yt+BU5W6YD5lbV/2ej2B+UpFpmWuhJ4tz89AodEvd2vmZuvt/GTzmFosTeW1E2UquUqL
         VqLK56+2xtfRtJ15wVigLs2kEaS7kr0MmCuNwnBxkElCx5UxnQhZjmyquaZOA/xtdofB
         Yz3A==
X-Gm-Message-State: AOJu0YyRFlZyuxPIJ46Suo9bV73+D+hiMqQ7tVSEPwC03g+WNshEDdjq
	W3wmUMxGqfM5MYjdxwrO+UtuhY+95rPHWi404VXtipvZ8tLxdn5ntp7SfJY3VS97xuOClUnv0qf
	X/yakZ1vkbK9YBVz8ZcXzsnrUHyawDymexn5fxFs=
X-Gm-Gg: ASbGncveKcZOHvmZhmpZs/P4cCAUqcqK8dskNTqhyZ6VboNM5tSoe+UUs0a7cdPvOcl
	VflBW4ayK/BuJzM6FO+WCuwZV1XiiZAnqcPX9uKQjvBeXnfMApy1iBuBVJe/+u7VbXSJqyGiVjG
	lNPcilIFE7gKp3FP0qL8SIQHvcg9hBUakrxPYZUkDchqEjTiZb7GSi/ksIffOftqFQBKgFApvW4
	ca0Lw==
X-Google-Smtp-Source: AGHT+IELfddpwdYVJ78KvtShsMJhjkV0glvf9GAmxf2kxl4ODA2pDHFAc4WRDVe4lpu1Ghl4ABB5pyOZvBOOR094t2g=
X-Received: by 2002:a05:690c:dca:b0:719:61b8:ffd2 with SMTP id
 00721157ae682-719e35ab1e4mr161757017b3.1.1753780098857; Tue, 29 Jul 2025
 02:08:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADzRqdC_fWwiCvkNYN-VGC=q-B5Lwy34ztaGV-nWVqP4UJCBAA@mail.gmail.com>
In-Reply-To: <CADzRqdC_fWwiCvkNYN-VGC=q-B5Lwy34ztaGV-nWVqP4UJCBAA@mail.gmail.com>
From: Davy Davidse <davydavidse@gmail.com>
Date: Tue, 29 Jul 2025 11:08:04 +0200
X-Gm-Features: Ac12FXwat36cm5vKHj_alBd4LBtBuMxQ1pAjiqjgI2flQu0b8FCmCZdurJC8-yw
Message-ID: <CADzRqdDLDRZNZNaOTz=FY4ccCFSi1GkdbB+sjF4AhdTOEns-6g@mail.gmail.com>
Subject: Re: tgtd hung task during heavy I/O - fdatasync blocking indefinitely
To: stgt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
Following up on my previous email about the tgtd hung task issue, I've
done some additional investigation that might be interesting as well.

After the Windows client had been powered off for over 24 hours, TGT
still reported multiple active sessions:

root@vm-iscsibeasttgt2:~# tgtadm --lld iscsi --mode conn --op show --tid 5
Session: 21
    Connection: 1
        Initiator: iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b1=
9
Session: 20
    Connection: 1
        Initiator: iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b1=
9
Session: 19
    Connection: 1
        Initiator: iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b1=
9
[... sessions 4-18 with identical output ...]

Network layer shows different reality:
However, the network layer shows no active connections to the iSCSI port:

root@vm-iscsibeasttgt2:~# ss -tuln | grep 3260
tcp   LISTEN 0      4096             0.0.0.0:3260       0.0.0.0:*
tcp   LISTEN 0      4096                [::]:3260          [::]:*

TGT process resource usage:
The tgtd process shows unusually high thread count:

root@vm-iscsibeasttgt2:~# cat /proc/$(pidof tgtd)/status | grep -E
'Threads|FDSize'
FDSize: 128
Threads:        113

Configuration context:
The target is configured with MaxConnections=3D1, so theoretically only
one session should be possible:

<driver iscsi>
    MaxConnections 1
</driver>

Questions for the list:

* Is this session persistence behavior expected when clients
disconnect abruptly?
* Is it normal TGT still shows these connections after the client
being offline for 24 hours?
* Could these phantom sessions be related to the fdatasync() blocking
behavior described in my original email?
* Is the 113 thread count normal for TGT with multiple phantom sessions?

The disconnect between TGT's internal session state and the actual
network connections seems significant, especially given that the
original fdatasync() hang occurs during sustained I/O operations.
Thanks for any insights,
Devedse

On Mon, 28 Jul 2025 at 23:44, Davy Davidse <davydavidse@gmail.com> wrote:
>
> Hi,
>
> I'm experiencing a hung task issue with tgtd during sustained heavy
> write operations and would appreciate some guidance on debugging this
> further. I'm not very experienced in Linux nor iSCSI so I'm looking
> for some pointers as to where to look.
>
> Setup:
>
> Host: Debian 6.1.0-37-amd64 running in Proxmox VM
> Physical storage: Proxmox cluster with Ceph storage (6x 500GB local
> SSDs, replication factor 2 =3D ~2TB effective)
> VM storage: /dev/sdb backed by Ceph RBD, presented to TGT VM
> TGT configuration: serving iSCSI targets for network boot via iPXE
> Storage stack: Windows client =E2=86=92 iSCSI over Ethernet =E2=86=92 TGT=
 (rdwr) =E2=86=92 LVM
> thin =E2=86=92 Ceph RBD =E2=86=92 local SSDs
> Target configuration: See below
> Use case: LAN party network boot - multiple Windows clients boot from
> disk images over network (And just because I like this concept)
>
> Client Configuration:
>
> Windows client boots via iPXE from iSCSI target
> PrimoCache installed with 20GB RAM cache (since the connection to the
> iSCSI disks can be a little slow, PrimoCache is effectively a windows
> read-write cache)
> PrimoCache configuration: caches all reads/writes to improve network
> storage performance
> Steam installation target: ~70GB game download/installation
>
> Issue Manifestation: During the GTA 5 installation via Steam, the
> first ~20GB of writes are absorbed by PrimoCache's RAM buffer and
> appear to complete quickly. However, once the cache fills up,
> PrimoCache begins flushing data to the network storage (TGT).
>
> The installation progresses normally for a while as data streams
> through the cache to the iSCSI target, but at some point (usually
> around 30-40GB into the installation), all I/O operations completely
> cease. The Windows client shows the Steam download as paused/stalled,
> and the system becomes effectively frozen for storage operations.
>
> At this point, the TGT target becomes unresponsive - no new I/O
> operations are processed, and the client cannot complete any disk
> operations. This coincides with the kernel hung task message appearing
> in dmesg.
>
> Kernel trace:
>
> [14259.621377] INFO: task tgtd:824 blocked for more than 241 seconds.
> [14259.627485] Call Trace:
> [14259.628232]  <TASK>
> [14259.628867]  __schedule+0x34d/0x9e0
> [14259.629728]  schedule+0x5a/0xd0
> [14259.630527]  io_schedule+0x42/0x70
> [14259.631387]  folio_wait_bit_common+0x13d/0x350
> [14259.632388]  ? filemap_alloc_folio+0x100/0x100
> [14259.633441]  folio_wait_writeback+0x28/0x80
> [14259.634347]  __filemap_fdatawait_range+0x90/0x120
> [14259.635403]  file_write_and_wait_range+0x6f/0x90
> [14259.636510]  blkdev_fsync+0x13/0x30
> [14259.637373]  __x64_sys_fdatasync+0x4b/0x90
>
>
> The trace shows tgtd is blocked in fdatasync(), waiting for writeback
> to complete.
>
> Current LVM thin pool status:
>
> thin_pool: 499.75GB, 17.11% data, 16.42% metadata
> Target LV: iscsi_grandia2, 250GB, 34.20% used
> Chunk size: default (64KB)
>
> Additional Observations:
>
> The issue appears to be triggered specifically by sustained write workloa=
ds
> Multiple I_T nexus connections (4-23) from the same initiator
> (iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19) all from
> IP 10.62.0.57 - What could this mean?
> No obvious issues visible in Ceph cluster health during the hang
> LVM thin pool has plenty of free space (17.11% data usage, 16.42%
> metadata usage)
>
> Some more information:
>
> root@vm-iscsibeasttgt2:~# tgtadm --lld iscsi --mode target --op show --ti=
d 5
> nop_interval=3D0
> nop_count=3D0
> MaxRecvDataSegmentLength=3D8192
> HeaderDigest=3DNone
> DataDigest=3DNone
> InitialR2T=3DYes
> MaxOutstandingR2T=3D1
> ImmediateData=3DYes
> FirstBurstLength=3D65536
> MaxBurstLength=3D262144
> DataPDUInOrder=3DYes
> DataSequenceInOrder=3DYes
> ErrorRecoveryLevel=3D0
> IFMarker=3DNo
> OFMarker=3DNo
> DefaultTime2Wait=3D2
> DefaultTime2Retain=3D20
> OFMarkInt=3DReject
> IFMarkInt=3DReject
> MaxConnections=3D1
> RDMAExtensions=3DYes
> TargetRecvDataSegmentLength=3D262144
> InitiatorRecvDataSegmentLength=3D262144
> MaxOutstandingUnexpectedPDUs=3D0
> MaxXmitDataSegmentLength=3D8192
> MaxQueueCmd=3D128
>
> root@vm-iscsibeasttgt2:~# lvs -a
>   LV                VG       Attr       LSize    Pool      Origin
> Data%  Meta%  Move Log Cpy%Sync Convert
>   iscsi_devedselvm  iscsi_vg Vwi-aotz--  100.00g thin_pool        0.00
>   iscsi_grandia2    iscsi_vg Vwi-aotz--  250.00g thin_pool        34.20
>   [lvol0_pmspare]   iscsi_vg ewi-------  128.00m
>   thin_pool         iscsi_vg twi-aotz-- <499.75g                  17.11  =
16.42
>   [thin_pool_tdata] iscsi_vg Twi-ao---- <499.75g
>   [thin_pool_tmeta] iscsi_vg ewi-ao----  128.00m
>
> dmesg:
> [14259.621377] INFO: task tgtd:824 blocked for more than 241 seconds.
> [14259.623000]       Not tainted 6.1.0-37-amd64 #1 Debian 6.1.140-1
> [14259.624314] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [14259.625871] task:tgtd            state:D stack:0     pid:824
> ppid:1      flags:0x00004002
> [14259.627485] Call Trace:
> [14259.628232]  <TASK>
> [14259.628867]  __schedule+0x34d/0x9e0
> [14259.629728]  schedule+0x5a/0xd0
> [14259.630527]  io_schedule+0x42/0x70
> [14259.631387]  folio_wait_bit_common+0x13d/0x350
> [14259.632388]  ? filemap_alloc_folio+0x100/0x100
> [14259.633441]  folio_wait_writeback+0x28/0x80
> [14259.634347]  __filemap_fdatawait_range+0x90/0x120
> [14259.635403]  file_write_and_wait_range+0x6f/0x90
> [14259.636510]  blkdev_fsync+0x13/0x30
> [14259.637373]  __x64_sys_fdatasync+0x4b/0x90
> [14259.638283]  do_syscall_64+0x55/0xb0
> [14259.639220]  ? __rseq_handle_notify_resume+0xa9/0x4a0
> [14259.640361]  ? do_futex+0x106/0x1b0
> [14259.641207]  ? futex_wake+0x7c/0x180
> [14259.641997]  ? do_futex+0xda/0x1b0
> [14259.642843]  ? __x64_sys_futex+0x8e/0x1d0
> [14259.643869]  ? exit_to_user_mode_prepare+0x40/0x1e0
> [14259.644972]  ? syscall_exit_to_user_mode+0x1e/0x40
> [14259.645986]  ? do_syscall_64+0x61/0xb0
> [14259.646786]  ? do_syscall_64+0x61/0xb0
> [14259.647659]  ? do_syscall_64+0x61/0xb0
> [14259.648528]  ? do_syscall_64+0x61/0xb0
> [14259.649453]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> [14259.650454] RIP: 0033:0x7f3194c90cba
> [14259.651218] RSP: 002b:00007f316d7fac70 EFLAGS: 00000293 ORIG_RAX:
> 000000000000004b
> [14259.652659] RAX: ffffffffffffffda RBX: 00005576cb22d8a0 RCX: 00007f319=
4c90cba
> [14259.654022] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000=
000000f
> [14259.655403] RBP: 0000000000000000 R08: 0000000000000035 R09: 00000000f=
fffffff
> [14259.656820] R10: 0000000000000000 R11: 0000000000000293 R12: 000000000=
0000000
> [14259.658114] R13: 000000000000000f R14: 00007ffcb3047e80 R15: 00007f316=
cffb000
> [14259.659461]  </TASK>
>
> tgt-admin -s:
> Target 5: iqn.2024-11.local.vm-iscsibeast:grandia2
>     System information:
>         Driver: iscsi
>         State: ready
>     I_T nexus information:
>         I_T nexus: 4
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 5
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 6
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 7
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 8
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 9
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 10
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 11
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 12
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 13
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 14
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 15
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 16
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 17
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 18
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 19
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 20
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 21
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>         I_T nexus: 23
>             Initiator:
> iqn.2010-04.org.ipxe:98ae8321-e8c8-ab14-ae97-345a60b59b19 alias: none
>             Connection: 1
>                 IP Address: 10.62.0.57
>     LUN information:
>         LUN: 0
>             Type: controller
>             SCSI ID: IET     00050000
>             SCSI SN: beaf50
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
>         LUN: 1
>             Type: disk
>             SCSI ID: IET     00050001
>             SCSI SN: beaf51
>             Size: 268435 MB, Block size: 512
>             Online: Yes
>             Removable media: No
>             Prevent removal: No
>             Readonly: No
>             SWP: No
>             Thin-provisioning: No
>             Backing store type: rdwr
>             Backing store path: /dev/iscsi_vg/iscsi_grandia2
>             Backing store flags:
>     Account information:
>     ACL information:
>         ALL
>
> root@vm-iscsibeasttgt2:~# cat /etc/tgt/conf.d/iscsi.conf
> # TGT iSCSI Configuration
> # Auto-generated by debian-server-setup-tgt.sh
> # Using all TGT defaults for optimal connection management
>
> # Default settings
> default-driver iscsi
>
> # Prevent connection accumulation for iPXE clients
> <driver iscsi>
>     MaxConnections 1
> </driver>
>
> # Include user-specific target files
> include /etc/tgt/conf.d/targets/*.conf
>
> So I'm mainly curious if someone has some ideas what is causing this
> problem. I would expect that "slow" storage would just "slow down"
> write operations. Not cause a complete system freeze and eventual
> bluescreen in windows stating "Critical_process_died". Also I'm not
> sure if this is the place to ask these questions as I've never used a
> mailing list before. So if not, feel free to point me to the right
> place.
>
> Kind regards,
> Devedse
