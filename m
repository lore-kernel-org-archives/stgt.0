From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: [PATCH] doc/iscsi: typo fix in doc/README.iscsi
Date: Sat, 18 Jan 2014 10:59:28 +0800
Message-ID: <52D9EE10.7020001@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        bh=s8EHG43n+LQjI1+sbZlR1YyjoYhOb2Ty/StKoTk7Ed0=;
        b=UGQ54yQlUHIhiM1queoCNR0lSdyGAjTtw4lOXoV8qcSQClGa0UO+rORTTOPpqIf3kT
         FIl2YcMqmaO8hmFGN3CNSMsVjf6h4zHXOCvzjTCxbV7O3K6duJ7f4CmGBI5TqzgLU1d1
         ZJWC3xyqkdOByNQ8EPDKRmc1QsiohBYz1kOBesFA72bubHPC/82a0K48VSJLo3nJTDXy
         oJRc2XB2mmfSaLUQ2UOoft6SjgYVYTO8oUlp3YGD3MtxrZVPW9nStr1rGYfAmAUzJu3E
         9vtsC6HUX3TXT+m3gXHdb+kn5A/XpXMPKLQ32nOQKJiQ3i6xU3GRo/t2VQqLIg3TI5TO
         txuw==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 doc/README.iscsi |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/doc/README.iscsi b/doc/README.iscsi
index 4ff3028..9fc21dd 100644
--- a/doc/README.iscsi
+++ b/doc/README.iscsi
@@ -25,7 +25,7 @@ The following example creates a target with id 1 (the iqn is
 iqn.2001-04.com.example:storage.disk2.amiens.sys1.xyz) and adds a
 logical unit (backed by /dev/hdc1) with lun 1.
 
-Let's create one target devce.
+Let's create one target device.
 
 host:~/tgt$ su
 host:~/tgt# ./usr/tgtadm --lld iscsi --op new --mode target --tid 1 -T iqn.2001-04.com.example:storage.disk2.amiens.sys1.xyz
@@ -113,7 +113,7 @@ Note "ACL information" section. "ALL" means that this target accepts
 any initiators. The ACL feature also provides the access control based
 on initiators' addresses.
 
-First, let's remove "ALL" options:
+First, let's remove "ALL" option:
 
 host:~/tgt# ./usr/tgtadm --lld iscsi --op unbind --mode target --tid 1 -I ALL
 host:~/tgt# ./usr/tgtadm --lld iscsi --op show --mode target
@@ -224,12 +224,12 @@ IFMarkInt=Reject
 MaxConnections=1
 
 
-You can chage iSCSI parameters like the folloing (e.g. set
+You can change iSCSI parameters like the following (e.g. set
 MaxRecvDataSegmentLength to 16384):
 
 host:~/tgt# ./usr/tgtadm --lld iscsi --mode target --op update --tid 1 --name MaxRecvDataSegmentLength --value 16384
 
-You can get iSCSI parameters again to see it change:
+You can get iSCSI parameters again to see its change:
 
 host:~/tgt# ./usr/tgtadm --lld iscsi --op show --mode target --tid 1
 MaxRecvDataSegmentLength=16384
-- 
1.7.1
