From: Theophanis Kontogiannis <tkonto@gmail.com>
Subject: Help with attributes
Date: Sun, 19 Oct 2014 11:19:20 +0300
Message-ID: <54437408.9090309@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        bh=LXZ5PcjxFJft8KsrcnYhdPVcjMY1nQDgDw4/0lyIOoM=;
        b=DJism+KnoJ0jd17+GamMpOViIQsXoCxpeOQaOzvYFiMzW/jovsL58rUCM3zmmPLCTu
         vf51i9+GiZXbqXa10vmVodOc2IU3hSeiQJZYN+IxEP6FC1ScuVkQqLJlxF4jqhdf9De9
         ATYaewIr2im/3nbID3zQ32ruf10qByM6J2v96/ttY7KpdhnTWHtYfCg08bpnoUWS9xrB
         QaDoZn4KPp6ALRqAWvo0CCJGEp/85K4y6T7nCIh1YjnLvxiA2g1kRKVXF4xdJ/q+ibVy
         sHi1N1fX/SuFHS7EXjLo7KSY9YjqkM9IuiS4LSUtSJBuHFUOKd90c5PSrFN4hWtfROQW
         yHOg==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: stgt@vger.kernel.org

Hello All,

Thank you in advance for your time.

I am trying to figure out, how to add attributes like vendor_id or scsi=
_sn.


Reading through
/usr/share/doc/scsi-target-utils-1.0.14/README.lu_configuration, and
going through some examples, it looks that '--params' will do the job.

Going for it, I would expect that tgt-admin --dump would give the xlm
including those parameters, but apparently it does not.

How can I confirm that the parameters are in place?




--=20

Kind Regards,
Theophanis Kontogiannis

=CC=D6=D7
=C8=CA
