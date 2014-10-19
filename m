From: eric pretorious <epretorious@gmail.com>
Subject: Re: Basic Configuration Troubles
Date: Sat, 18 Oct 2014 17:57:46 -0700
Message-ID: <CAHtv24U4JUqLh2spTP2sEmUgQWYVerYYx+w0b+aBo3NfWzDhmw@mail.gmail.com>
References: <CAHtv24UiOOSx2F5cOmaPxXtQzrnVCfOQTOvm2euQFQbz33ZLtA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=ENcBLDiVuLdlIcICchCpkY57eFrUPUgVAtakIaCPOiQ=;
        b=aII//UD9IJ07/db1lKUMawF9UAXR5boahIEJU0PSHz2U/nEEZ3EWeJFJNP8lE387xk
         9F3FOTS2/v9Tho5/RuACCxXSLA0CekOcBJs9SCqgs8Vf2sRpiW8txQp2EKvNj/JFXR6P
         0peygvATZPS1acXtn452hVR15YnOkGkxzaob5nazWPcsmp2tkkB4JzZRviIjWLHMv98H
         tLDZLlIMIPLrll74F40ge4QLXPjKCzQLDlyDsWQGZY8DekAUDUW8TwrhRivSDcOWUJBx
         i+x4dHOjodVW/BW4lIMbpSD2c38NJNBuEzyGoPFapqtHv7vCXTSXtGZRfn6kh0Z2+F/+
         E9cw==
In-Reply-To: <CAHtv24UiOOSx2F5cOmaPxXtQzrnVCfOQTOvm2euQFQbz33ZLtA@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

FWIW: I read the scsi-target-utils Quickstart Guide and noticed that
the Guide prefers to use the /usr/sbin/tgtadm command so I've verified
the configuration using /usr/sbin/tgtadm *instead*of*
/usr/sbin/tgt-admin and found that the results are identical.

> [root@aoe-1 ~]# tgtadm --lld iscsi --mode target --op show > /tmp/tgtadm.txt
> [root@aoe-1 ~]# tgt-admin -s > /tmp/tgt-admin.txt
> [root@aoe-1 ~]# diff /tmp/tgtadm.txt /tmp/tgt-admin.txt

Thanks, again!
Eric Pretorious

On Sat, Oct 18, 2014 at 11:16 AM, eric pretorious <epretorious@gmail.com> wrote:
>> [root@aoe-1 ~]# tgt-admin -s
>> Target 1: iqn.2014-09.com.example.san-1:drbd0
>>     System information:
>>         Driver: iscsi
>>         State: ready
>>     I_T nexus information:
>>     LUN information:
>>         LUN: 0
>>             Type: controller
>>             SCSI ID: IET     00010000
>>             SCSI SN: beaf10
>>             Size: 0 MB, Block size: 1
>>             Online: Yes
>>             Removable media: No
>>             Prevent removal: No
>>             Readonly: No
>>             Backing store type: null
>>             Backing store path: None
>>             Backing store flags:
>>         LUN: 1
>>             Type: disk
>>             SCSI ID: IET     00010001
>>             SCSI SN: beaf11
>>             Size: 535 MB, Block size: 512
>>             Online: Yes
>>             Removable media: No
>>             Prevent removal: No
>>             Readonly: No
>>             Backing store type: rdwr
>>             Backing store path: /dev/drbd0
>>             Backing store flags:
>>     Account information:
>>     ACL information:
>>         ALL
