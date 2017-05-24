From: Anton Kovalenko <Anton.Kovalenko@acronis.com>
Subject: Re: undeletable targets with connections fixed with last commits?
Date: Wed, 24 May 2017 11:46:49 +0000
Message-ID: <1495626408911.78066@acronis.com>
References: <CAD_6HTExuEA8-xPp30KoyL-qpe2h+CovoCUY+F1xtj58btaLyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=acronis.com
        ; s=exim; h=MIME-Version:Content-Transfer-Encoding:Content-Type:In-Reply-To:
        References:Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FzSqkOQbM4XC+aF407S0D0Z0lphBqeZM/nHERkPXMhI=; b=vl/NOxlnMBI0fQhkzDrStgpRnB
        mJE8RmlWASz6QjrGK723h9l95uZ2UQzW8ma2T8Vb/JbsUaa2zQKHkW25J5Hfwhu9Q4T+7Ov0Loq4u
        4Rb5gMUjrkWszxrVpuYSRxiPdl8XgSXC2G5cHqPcAgOb+49ROcovoDt96wGvIurPouvU=;
In-Reply-To: <CAD_6HTExuEA8-xPp30KoyL-qpe2h+CovoCUY+F1xtj58btaLyQ@mail.gmail.com>
Content-Language: ru-RU
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: Benedikt Fraunhofer <fraunhofer@traced.net>, "stgt@vger.kernel.org" <stgt@vger.kernel.org>

Hi Benedikt!=0A=
=0A=
No, those commits are unlikely to solve the problem you describe.=0A=
=0A=
As far as I remember, connection might remain on session's list (and sessio=
n remains referenced, etc.) until all its SCSI "tasks" have completed (forc=
e-close doesn't change that). The catch is that force-close succeeds and re=
turns immediately.=0A=
=0A=
If you're lucky, task(s) affecting the connection refcount will complete ev=
entually (so you just wait and retry, monitoring --op show --mode conn to s=
ee when it's worth trying). If there's a connection that just doesn't go aw=
ay after repeated --op delete --mode conn, then you're unlucky.=0A=
=0A=
I've been through a situation where there are tasks that are unable to comp=
lete forever: when two or more ABORT_TASK[_SET] management requests affect =
the same command, which is already in_scsi (submitted to kernel), all reque=
sts but the last one are stuck forever. It can't be fixed without either in=
troducing many-to-many relation between SCSI commands and ABORT_TASK reques=
ts (I've got an experimental patch for it), or implementing some other chan=
ge to ABORT_TASK[_SET] handling.=0A=
=0A=
By the way, as of the whole force-remove-target thing, I prefer the followi=
ng:=0A=
=0A=
* tgtadm --mode target --op delete --force  (should delete a target despite=
 existing connections),=0A=
* to mitigate the problem with active sessions having active commands, prev=
enting LUN deletion, retry on error message "logical unit is still active".=
=0A=
=0A=
The problem with in_scsi tasks (including ABORT_TASK[_SET] hanging forever)=
 is not solved this way either, but at least we don't have to close each co=
nnection separately (I believe that tgt-admin code handling of forced targe=
t removal was written before --force support on target deletion was added t=
o tgtd/tgtadm).=0A=
=0A=
________________________________________=0A=
=EF=D4: stgt-owner@vger.kernel.org <stgt-owner@vger.kernel.org> =CF=D4 =C9=
=CD=C5=CE=C9 Benedikt Fraunhofer <fraunhofer@traced.net>=0A=
=EF=D4=D0=D2=C1=D7=CC=C5=CE=CF: 17 =CD=C1=D1 2017 =C7. 17:30=0A=
=EB=CF=CD=D5: stgt@vger.kernel.org=0A=
=F4=C5=CD=C1: undeletable targets with connections fixed with last commits?=
=0A=
=0A=
Hello List!=0A=
=0A=
do the last commits=0A=
=0A=
Avoid session* dangling reference on forced target destroy.=0A=
and=0A=
Avoid dangling session reference in login_security_done=0A=
=0A=
address the problem of targets that just won't go away?=0A=
=0A=
We're running 1.0.63 and quite often have the problem that we can't=0A=
delete targets and stgt think's there are connections while the=0A=
connection has already been shut down.=0A=
Also, those connections seem to pile up. We've some targets with >100=0A=
Connections to it while the initiator itself sees only one.=0A=
=0A=
:# tgt-admin -v --force --delete iqn.2016-01.net.g:xbbs-szq8:iscsi=0A=
# Removing target: iqn.2016-01.net.g:xbbs-szq8:iscsi=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1016 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1012 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 10 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 436 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1017 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1013 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 530 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 435 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1014 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 554 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1019 --cid 1=0A=
tgtadm -C 0 --mode target --op delete --tid=3D27=0A=
tgtadm: this target is still active=0A=
Command:=0A=
        tgtadm -C 0 --mode target --op delete --tid=3D27=0A=
        exited with code: 22.=0A=
=0A=
## trying with force one connection to go away=0A=
=0A=
:# tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1016 --cid 1 --force=
=0A=
:# tgt-admin -v --force --delete iqn.2016-01.net.g:xbbs-szq8:iscsi=0A=
# Removing target: iqn.2016-01.net.g:xbbs-szq8:iscsi=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 10 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 554 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1013 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1016 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1019 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1012 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1014 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 435 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 1017 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 530 --cid 1=0A=
tgtadm -C 0 --op delete --mode conn --tid 27 --sid 436 --cid 1=0A=
tgtadm -C 0 --mode target --op delete --tid=3D27=0A=
tgtadm: this target is still active=0A=
Command:=0A=
        tgtadm -C 0 --mode target --op delete --tid=3D27=0A=
        exited with code: 22.=0A=
=0A=
##connection still there=0A=
=0A=
Offlineing the target, removing initiators (unbind) doesn't change anything=
.=0A=
=0A=
Thx in advance=0A=
  Benedikt=0A=
--=0A=
To unsubscribe from this list: send the line "unsubscribe stgt" in=0A=
the body of a message to majordomo@vger.kernel.org=0A=
More majordomo info at  http://vger.kernel.org/majordomo-info.html=0A=
