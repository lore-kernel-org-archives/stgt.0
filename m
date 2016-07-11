From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: how to schedule priority between three open-iscsi clients and stgt
Date: Mon, 11 Jul 2016 13:56:11 +0200
Message-ID: <8adf706a-9835-6763-6c22-35073cb97917@powercraft.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: stgt@vger.kernel.org

Hello everybody,

I got three open-iscsi clients that deliver one big data lun that has 
lvm over it to serve logical volumes, one server does daily back-ups and 
two servers are compute nodes for kvm guests.

The problem is that when I run an ionice -c 3 dd bs=16M of=/dev/vg/lv 
oflag=direct to restore a back-up the two other nodes are being IO 
starved/suffocated and the guests are getting IO time-outs and very high 
latency.

I use 10-Gigabit X540-AT2 Intel network controllers on all servers.

The backup server that runs the dd commands already has a queue_depth of 
1, the other two nodes have an queue_depth of 8.

root@backup:~# cat /sys/block/sdt/device/queue_depth
1

root@virtualization01:~# cat /sys/block/sdd/device/queue_depth
8

root@virtualization02:~# cat /sys/block/sdd/device/queue_depth
8

How can I improve the latency and IO priority of the other two nodes 
that run the kvm guests?

Kind regards,

Jelle de Jong


# iscsiadm --mode node --targetname 
iqn.2012-10.nl.powercraft:storage.iscsi0 --portal 192.168.35.6:3260
# BEGIN RECORD 2.0-873
node.name = iqn.2012-10.nl.powercraft:storage.iscsi0
node.tpgt = 1
node.startup = automatic
node.leading_login = No
iface.hwaddress = <empty>
iface.ipaddress = <empty>
iface.iscsi_ifacename = default
iface.net_ifacename = <empty>
iface.transport_name = tcp
iface.initiatorname = <empty>
iface.bootproto = <empty>
iface.subnet_mask = <empty>
iface.gateway = <empty>
iface.ipv6_autocfg = <empty>
iface.linklocal_autocfg = <empty>
iface.router_autocfg = <empty>
iface.ipv6_linklocal = <empty>
iface.ipv6_router = <empty>
iface.state = <empty>
iface.vlan_id = 0
iface.vlan_priority = 0
iface.vlan_state = <empty>
iface.iface_num = 0
iface.mtu = 0
iface.port = 0
node.discovery_address = 192.168.35.6
node.discovery_port = 3260
node.discovery_type = send_targets
node.session.initial_cmdsn = 0
node.session.initial_login_retry_max = 8
node.session.xmit_thread_priority = -20
node.session.cmds_max = 128
node.session.queue_depth = 32
node.session.nr_sessions = 1
node.session.auth.authmethod = None
node.session.auth.username = <empty>
node.session.auth.password = <empty>
node.session.auth.username_in = <empty>
node.session.auth.password_in = <empty>
node.session.timeo.replacement_timeout = 480
node.session.err_timeo.abort_timeout = 15
node.session.err_timeo.lu_reset_timeout = 30
node.session.err_timeo.tgt_reset_timeout = 30
node.session.err_timeo.host_reset_timeout = 60
node.session.iscsi.FastAbort = Yes
node.session.iscsi.InitialR2T = No
node.session.iscsi.ImmediateData = Yes
node.session.iscsi.FirstBurstLength = 262144
node.session.iscsi.MaxBurstLength = 16776192
node.session.iscsi.DefaultTime2Retain = 60
node.session.iscsi.DefaultTime2Wait = 5
node.session.iscsi.MaxConnections = 4
node.session.iscsi.MaxOutstandingR2T = 1
node.session.iscsi.ERL = 0
node.conn[0].address = 192.168.35.6
node.conn[0].port = 3260
node.conn[0].startup = manual
node.conn[0].tcp.window_size = 524288
node.conn[0].tcp.type_of_service = 0
node.conn[0].timeo.logout_timeout = 15
node.conn[0].timeo.login_timeout = 15
node.conn[0].timeo.auth_timeout = 45
node.conn[0].timeo.noop_out_interval = 15
node.conn[0].timeo.noop_out_timeout = 30
node.conn[0].iscsi.MaxXmitDataSegmentLength = 0
node.conn[0].iscsi.MaxRecvDataSegmentLength = 262144
node.conn[0].iscsi.HeaderDigest = None
node.conn[0].iscsi.DataDigest = None
node.conn[0].iscsi.IFMarker = No
node.conn[0].iscsi.OFMarker = No
# END RECORD
