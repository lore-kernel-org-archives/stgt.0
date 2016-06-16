From: "M. Piscaer" <debian@masterpe.nl>
Subject: vmware esx iscsi
Date: Thu, 16 Jun 2016 17:11:08 +0200
Message-ID: <5762C18C.7000803@masterpe.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

I'm trying to connect an vmware esxi hosts to an stgt target.

I have this little config:

<target iqn.2014-04.rbdstore.example.com:loop>
    driver iscsi
    backing-store /var/tgt/store1
    scsi_id 00010005
</target>


tgt-admin -s
Target 1: iqn.2014-04.rbdstore.example.com:loop
    System information:
        Driver: iscsi
        State: ready
    I_T nexus information:
        I_T nexus: 9
            Initiator: iqn.1998-01.com.vmware:test-esx-02-795ba8ca
alias: none
            Connection: 0
                IP Address: 10.114.13.124
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: IET     00010000
            SCSI SN: beaf10
            Size: 0 MB, Block size: 1
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: null
            Backing store path: None
            Backing store flags:
        LUN: 1
            Type: disk
            SCSI ID: 00010005
            SCSI SN: beaf11
            Size: 21475 MB, Block size: 512
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: rdwr
            Backing store path: /var/tgt/store1
            Backing store flags:
    Account information:
    ACL information:
        ALL

ls -l /var/tgt/store1
-rw-rw-rw- 1 root root 21474836480 Jun 16 16:15 /var/tgt/store1


The problem is that I get vmware error when I try to mount the datastore.


From vmkernel.log I see the following:

2016-06-16T15:09:46.005Z cpu0:33350)WARNING: iscsi_vmk:
iscsivmk_StopConnection: vmhba38:CH:0 T:0 CN:0: iSCSI connection is
being marked "OFFLINE" (Event:4)
2016-06-16T15:09:46.006Z cpu0:33350)WARNING: iscsi_vmk:
iscsivmk_StopConnection: Sess [ISID: 00023d000001 TARGET:
iqn.2014-04.rbdstore.example.com:loop TPGT: 1 TSIH: 0]
2016-06-16T15:09:46.006Z cpu0:33350)WARNING: iscsi_vmk:
iscsivmk_StopConnection: Conn [CID: 0 L: 10.114.13.124:31270 R:
10.114.13.61:3260]
2016-06-16T15:09:46.006Z cpu0:33350)WARNING: iscsi_vmk:
iscsivmk_TaskMgmtIssue: vmhba38:CH:0 T:0 L:1 : Task mgmt "Abort Task"
with itt=0x739 (refITT=0x737) timed out.
2016-06-16T15:09:46.293Z cpu1:32838)WARNING: NMP:
nmp_DeviceRequestFastDeviceProbe:237: NMP device
"t10.0001000500000000000000000000000000000000000000000000000000000000"
state in doubt; requested fast path state update...
2016-06-16T15:09:46.670Z cpu1:32800)ScsiDeviceIO: 2651:
Cmd(0x43a5c07a8f40) 0x2a, CmdSN 0x17 from world 39720 to dev
"t10.0001000500000000000000000000000000000000000000000000000000000000"
failed H:0x3 D:0x0 P:0x0 Possible sense data: 0x0 0x0 0x0.
2016-06-16T15:09:46.671Z cpu15:39720)BC: 2430: Failed to write
(uncached) object
't10.0001000500000000000000000000000000000000000000000000000000000000':
Timeout
2016-06-16T15:09:48.778Z cpu0:33350)iscsi_vmk: iscsivmk_ConnNetRegister:
socket 0x4304164f13f0 network resource pool netsched.pools.persist.iscsi
associated
2016-06-16T15:09:48.778Z cpu0:33350)iscsi_vmk: iscsivmk_ConnNetRegister:
socket 0x4304164f13f0 network tracker id 16768
tracker.iSCSI.10.114.13.61 associated
2016-06-16T15:09:49.031Z cpu0:33350)WARNING: iscsi_vmk:
iscsivmk_StartConnection: vmhba38:CH:0 T:0 CN:0: iSCSI connection is
being marked "ONLINE"
2016-06-16T15:09:49.031Z cpu0:33350)WARNING: iscsi_vmk:
iscsivmk_StartConnection: Sess [ISID: 00023d000001 TARGET:
iqn.2014-04.rbdstore.example.com:loop TPGT: 1 TSIH: 0]
2016-06-16T15:09:49.031Z cpu0:33350)WARNING: iscsi_vmk:
iscsivmk_StartConnection: Conn [CID: 0 L: 10.114.13.124:47349 R:
10.114.13.61:3260]
2016-06-16T15:09:49.035Z cpu11:39586)ScsiCore: 1609: Power-on Reset
occurred on vmhba38:C0:T0:L1
2016-06-16T15:09:49.408Z cpu1:32800)NMP: nmp_ThrottleLogForDevice:3298:
Cmd 0x9e (0x439dc0784f00, 0) to dev "mpx.vmhba32:C0:T0:L0" on path
"vmhba32:C0:T0:L0" Failed: H:0x0 D:0x2 P:0x0 Valid sense data: 0x5 0x20
0x0. Act:NONE
2016-06-16T15:10:13.286Z cpu8:33251)NMP:
nmp_ResetDeviceLogThrottling:3349: last error status from device
t10.0001000500000000000000000000000000000000000000000000000000000000
repeated 108 times
