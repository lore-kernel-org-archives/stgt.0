From: Michael Grover <michaelgrover@gmail.com>
Subject: Unable to create target drives in non-root directory in CentOS 6.5
Date: Mon, 7 Dec 2015 14:59:29 -0500
Message-ID: <CAAGs95CfsBMRTMjgH=sg=Z+bZMwr460CHOZ+ArzDQi=4uMb51g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=i3LVju2NMqZQgJGpC1aU3V9PFjXcnmZWG2HUMYIfuXw=;
        b=NgPf8qxK0+zdS/bcnAxZ5hbrf2jk9NU86Co//Ql80eBL2NXGLQq+DFF/XPdpEbG600
         9eW7sCtyLQZFf36LURy4ZHsfOYujRcZY2oq7AVWpGbG/Cl0K1kw/cw001yC9ihFQn7GV
         rrJAHYyagzR7xK4UUR3u3UJlAjoojp9xfcSICcLWF9VBeEBzDGQvxEXaauFnE2uymMT1
         939UI2trGTard42U14rCC187Nm0xIXjY/cUSULeze8GAv42bu5xssQUiJNam/5vxVGhl
         hM01bNcpyyRKYZmL3oWHQ8dfPt0mX2lhlzZQalsKxik3teVltqa/EGFw60VB4HpZxYDi
         /i2w==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

I'm trying to create target drive files on CentOS 6.5 using stgt. I am
not able to create the drives on a non-root directory. Here's what I
do:


I create two drive files, one on the root directory and one on a
directory owned by a user called "iscsi_target":

dd if=/dev/zero of=/iscsi_drives/temp
dd if=/dev/zero of=/home/iscsi_target/iscsi_drives/temp


I do a little SELinux management:

semanage fcontext -a -t tgtd_var_lib_t /iscsi_drives/temp
semanage fcontext -a -t tgtd_var_lib_t /home/iscsi_target/iscsi_drives/temp
restorecon -Rv /iscsi_drives/temp
restorecon -Rv /home/iscsi_target/iscsi_drives/temp



Here is what the pertinent lines in my targets.conf file look like:

<target iqn.2015.12.com.mysite:temp_target>
  #backing-store /home/iscsi_target/iscsi_drives/temp
  backing-store /iscsi_drives/temp
</target>

If I start the tgtd service, I get no errors. However, if I toggle the
comments on the two backing-store lines, switching which drive my
target uses, I get the following error:

Command:
    tgtadm -C 0 --lld iscsi --op new --mode logicalunit --tid 1 --lun
1 -b /home/iscsi_target/iscsi_drives/temp
exited with code: 22.


Do you know what might be going on here?

Thanks for any help.
