From: Phillip Brown <phillip.brown.j@gmail.com>
Subject: "tgtadm --mode system --show" doesn't show  global 'outgoing' users
 if there are no global incoming users
Date: Fri, 15 Aug 2014 16:39:18 +1000
Message-ID: <53EDAB16.7010505@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        bh=FOqLpogTEgQ+v97Oi8yxyKKoTtBEMitufmla/oXXFKc=;
        b=RDs7ByJ9Gz10qVQLMIMdM62I9cO7hHqOAd5vtRZvzoiy4UnASi3OX6C4yn/GAJQ7R/
         qc2k/Uu8tNgIvkiFitMlwaPoWZpJNiyOvReA/qRqm8Fh6wpKBIoaGM8ZJtwE9M0dE57Y
         +ceukFKu39nYuHEKoaG8d593vKwRI/xTQhtBmjbJrQkyS11avvsIEfozvSuLN5pNLK9+
         vRs35j9J7JKw8PxRSF5lsaAk6oBCWH7iyK2/GknqI06+2+5o0q5grYOPGJKuRb4bYde/
         zCePBpZLA0A5EgU6Fhrotd8d6QBXl9VpiNBqT8Y8mbeI/DYmw0rxCp4TKdiyw30S8HW2
         XjAA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: stgt@vger.kernel.org

Note - I am not subscribed to the mailing list

Noticed that if there are 'outgoing' users but no 'incoming' users bound 
at system level, then tgtadm --mode system --show does not show the 
outgoing users. c.f. at target level where targets show outgoing users 
even if there are no incoming users

[root@filer3 init.d]# tgtadm --op show --mode sys
System:
        State: ready
LLDs:
        iser: error
        iscsi: ready
Backing stores:
        rdwr (bsoflags sync:direct)
        aio
        ssc
        null
        bsg
        sg
Device types:
        passthrough
        tape
        changer
        controller
        osd
        cd/dvd
        disk
iSNS:
        iSNS=Off
        iSNSServerIP=
        iSNSServerPort=3205
        iSNSAccessControl=Off
[root@filer3 init.d]# tgtadm --lld iscsi --mode account --op new --user 
test --password testpass
[root@filer3 init.d]# tgtadm --mode account --op bind --user test --outgoing
[root@filer3 init.d]# tgtadm --mode sys --op show
System:
        State: ready
LLDs:
        iser: error
        iscsi: ready
Backing stores:
        rdwr (bsoflags sync:direct)
        aio
        ssc
        null
        bsg
        sg
Device types:
        passthrough
        tape
        changer
        controller
        osd
        cd/dvd
        disk
iSNS: *   Account info for outg**oing user should be here*
        iSNS=Off
        iSNSServerIP=
        iSNSServerPort=3205
        iSNSAccessControl=Off
[root@filer3 init.d]# tgtadm --mode account --op bind --user test
[root@filer3 init.d]# tgtadm --mode sys --op show
System:
        State: ready
LLDs:
        iser: error
        iscsi: ready
Backing stores:
        rdwr (bsoflags sync:direct)
        aio
        ssc
        null
        bsg
        sg
Device types:
        passthrough
        tape
        changer
        controller
        osd
        cd/dvd
        disk
Account information:
        test
        test (outgoing)
iSNS:
        iSNS=Off
        iSNSServerIP=
        iSNSServerPort=3205
        iSNSAccessControl=Off
[root@filer3 init.d]#


Problem seems to be with this 'if' statement in targets.c:system_show 
function

--------->> if (global_target.account.nr_inaccount) {
                                int i, aid;
                                concat_printf(b, _TAB1 "%s\n", "Account 
information:\n");
                                for (i = 0; i < 
global_target.account.nr_inaccount; i++) {
                                                aid = 
global_target.account.in_aids[i];
                                                concat_printf(b, _TAB1 
"%s\n",
            __account_lookup_id(aid)->user);
                                }
                                if (global_target.account.out_aid) {
                                                aid = 
global_target.account.out_aid;
                                                concat_printf(b, _TAB1 
"%s (outgoing)\n",
            __account_lookup_id(aid)->user);
                                }
                }

Does there really need to be that test?

regards

Phillip Brown
