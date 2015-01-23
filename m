From: =?iso-2022-jp?B?TUlOT1VSQSBNYWtvdG8gLyAbJEJMJzE6GyhCIBskQj8/GyhC?= 
	<minoura@valinux.co.jp>
Subject: ExpCmdSn and MaxCmdSn in ISCSI_OP_R2T
Date: Fri, 23 Jan 2015 09:08:33 +0900
Message-ID: <kk5iofyfjem.fsf@brer.local.valinux.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org


tgtd does not send ExpCmdSn and MaxCmdSn with OP_R2T (Ready
To Transfer) operations.  Is this behaviour correct?

At least Linux (RHEL6.2) initiators take 0 MaxCmdSn value
and get confused.


Frame 1498: 114 bytes on wire (912 bits), 114 bytes captured (912 bits)
Ethernet II, Src: XXXX, Dst: XXXX
Internet Protocol Version 4, Src: 172.17.105.40 (172.17.105.40), Dst: 172.17.105.39 (172.17.105.39)
Transmission Control Protocol, Src Port: iscsi-target (3260), Dst Port: 59099 (59099), Seq: 1620029, Ack: 42313, Len: 48
iSCSI (Ready To Transfer)
    Opcode: Ready To Transfer (0x31)
    TotalAHSLength: 0x00
    DataSegmentLength: 0x00000000
    LUN: 1 (Single Level LUN Structure)
        00.. .... = Address Mode: Single Level LUN Structure (0)
        ..00 0000 = BUS: 0
        LUN: 1
    InitiatorTaskTag: 0x0b000000
    TargetTransferTag: 0x9077e700
    StatSN: 0x0000017d
    ExpCmdSN: 0x00000000                        !!!
    MaxCmdSN: 0x00000000                        !!!
    R2TSN: 0x00000000
    BufferOffset: 0x00002000
    DesiredDataLength: 0x00000200


iscsi_r2t_build() does not fill rsp->exp_cmdsn and rsp->max_cmdsn,
while iscsi_cmd_rsp_build() and iscsi_data_rsp_build() does.

-- 
Minoura Makoto <minoura@valinux.co.jp>
