From: Maksym Lobur <mlobur@mirantis.com>
Subject: [tgtadm] Looking for a Persistent Reservations support
Date: Wed, 27 May 2015 00:25:31 +0300
Message-ID: <A557C827-44FD-4585-ABA7-D22B4BB54EC4@mirantis.com>
References: <CFA7795E-D088-44A8-9B55-A168FA1796A2@mirantis.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mirantis.com; s=google;
        h=from:content-type:content-transfer-encoding:subject:date:references
         :to:message-id:mime-version;
        bh=yHLiJvpA/sxePnvNN7VgPdIelffOxrr5J5DQrR6IPK8=;
        b=WPyn3mFHSi6HGoThIbBrtb6HkK+HMA6V7a77HzpM02YgDNfZPBhi0hC7WV7/EmxSBn
         dHAkJ3CcjTZsRZ4Z0t5EgqUBXTxt4j7Jc1DMiRcd2+Kwdk9q53An8+Zn1G85HqaPIQAo
         wc+GTdBGgjpxPxB8Fgt5+riw25gR5UAMLgmz8=
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: stgt@vger.kernel.org

Hi All,

I am interested if Persistent Reservations (SCSI-3) are fully supported=
 in tgtadm. I=92m using ubuntu 14.04.2, tgt 1:1.0.43-0ubuntu4. We were =
going to use tgtadm to configure targets for Windows 2008 clustering.=20
I found an old comparison [1] which says SCSI-3 =93not all functionalit=
y implemented=94. Could anyone please give an update?

[1] http://scst.sourceforge.net/comparison.html

Thanks!
Max Lobur