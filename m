From: Ldm@gmx.at
Subject: Poor or non existent documentation of attributes
Date: Wed, 29 Mar 2023 13:17:08 +0200
Message-ID: <trinity-f28a7acd-b1f6-4af3-9de5-f7750d35cfba-1680088628203@3c-app-gmx-bap48>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.at; s=s31663417;
        t=1680088628; i=ldm@gmx.at;
        bh=ABF5AEEJ50ofLNw+hfNxQ+MGZr0nc1ymA/aSVQfXYQ0=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=RvCiRUBU3wMIYVUsEeBbKOTrpLjR/IJevnCroIrddtGk8t724l10jd8wU8E40Cc5J
         Bh0BrXK/TydfsT+Y5eblrDDkPyOPCAWkBRNKT6cYiTLoU7dcxaHhi/QjqM+Nz+C8qS
         ly/HK+fn8h6vRT1Mkz9KbAiyP8AuaBAOxkLL4A5ahsSuf96RsNQYfbfCcDUeuxuXpM
         /DIJaHC0CxY9/QCyQu4I8yEhsCr5azpjJafLeqBmx1ijhu2iZhKTYV19WwWyk4YowS
         RdNYmtSbGt5UEjiAdTJE1nG19IGyx9G9amh1+shw38CHtw0w14kN5COawUY7GXA8Tu
         MjPuV4B6IbvwA==
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hi,

about 6 months ago I wanted do change the sector size that is reported for a target via iSCSI. After a long Google search I found a single Reddit thread that explained that there is a possibility to configure "set attributes block_size=4096" on a block device backing store. In the mean time I found two other secondary sources about this attribute [2],[3].

But I was very surprised that there seems to be no official documentation of those attributes.

1. The MAN page for targetcli only mentions that attributes are beckstore-specific and contain values relating to the backstore and storage object. [4] [5].
2. https://github.com/Datera/targetcli references the https://github.com/Datera/targetcli wiki. Trying to reach that website in a browser yields an ERR_CONNECTION_TIMED_OUT error.
3. https://github.com/Datera/rtslib mentions the same broken website, and a rtslib-API-reference.pdf that I can't retrieve. And a Google search didn't find a single mirror of that file anywhere else [6].
4. Digging through the source code I found a list of attributes for block backstores from a parser code https://github.com/Datera/rtslib/blob/6fd0bbfc20947143eb2e4c3bfd34c65bf8551468/policy/backstore_iblock.lio but this has no description of attributes.
5. There seems to be no description or list of attributes at https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/online-storage-management
6. The targetcli util claims when I invoke "help set" that I can "Run with no parameter nor group to list all available groups, or with just a group name to list all available parameters within that group." But then when I actually call "set" without argument in a backstore I get en empty "AVAILABLE CONFIGURATION GROUPS ===============".

If I didn't accidentally find this Reddit thread I would have had no chance of knowing howset the block size. If I hadn't digged through the weeds for quite some time to write this email I would have never discovered on [2] that there is "emulate_tpu=1" which "exposes an UNMAP command which is functionally similar to TRIM for SSDs" and "is_nonrot specifies whether the pool is composed of HDDs or SSDs. Windows uses this to decide whether or not to make the iSCSI drive defragmentable", which would have been extremely advantagous to know.

I wasted too much time finding anything useful, I am frustrated. Is the official documentation really that bad, or did I miss something obvious?
Can we improve this situation?

Best regards
Markus


[1] https://www.reddit.com/r/homelab/comments/ror016/lio_target_w_zvol_for_esxi_vmkernellog_lvm_block/
[2] https://forum.level1techs.com/t/guide-iscsi-target-server-on-linux-with-zfs-for-windows-initiator-clients/174803
[3] https://serverfault.com/questions/818655/how-to-specify-sector-size-for-lvm-logical-volume
[4] https://linux.die.net/man/8/targetcli
[5] https://manpages.ubuntu.com/manpages/bionic/man8/targetcli.8.html
[6] https://www.google.com/search?q=%22rtslib-API-reference.pdf%22
