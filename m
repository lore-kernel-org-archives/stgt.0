From: Horace <horace@zmail.hkisl.net>
Subject: multipath and VPD 83 problem
Date: Fri, 22 Apr 2016 11:55:15 +0800 (HKT)
Message-ID: <1175090433.13678228.1461297315219.JavaMail.zimbra@zmail.hkisl.net>
References: <S1752338AbcDVDZZ/20160422032525Z+1212@vger.kernel.org>
Reply-To: Horace Ng <horace@hkisl.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <S1752338AbcDVDZZ/20160422032525Z+1212@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

Dear all,

I'm trying to set up multipath on the same target across two hosts, however, since the tgtd version on each of the host is different, they're presenting different VPD INQUIRY and hence I could not set it up on vmware. Is there a way that I can disable "Designation descriptor number 3" on the newer version of tgtd? Thanks in advance.


[root@vmc8520 ~]# sg_inq --vpd --page=0x83 /dev/sdc
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 40
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: vclouds0
      vendor specific: 
  Designation descriptor number 2, descriptor length: 12
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 3, Locally assigned:
      [0x3000000400000001]
[root@vmc8520 ~]# sg_inq --vpd --page=0x83 /dev/sdf
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 40
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: vclouds0
      vendor specific: 
  Designation descriptor number 2, descriptor length: 12
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 3, Locally assigned:
      [0x3000000300000001]
  Designation descriptor number 3, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x0
      Vendor Specific Identifier: 0x0
      Vendor Specific Identifier Extension: 0x11111
      [0x60000000000000000000000000011111]
