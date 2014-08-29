From: John Edwards <john.edwards@linguamatics.com>
Subject: Re: Fwd: Forcing release of rx on CentOS 6
Date: Fri, 29 Aug 2014 07:59:35 +0100
Message-ID: <540024D7.4070304@linguamatics.com>
References: <53FF3FDD.7040400@linguamatics.com> <53FF4276.3010006@linguamatics.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <53FF4276.3010006@linguamatics.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: stgt@vger.kernel.org

Panic over. A colleague of mine had incorrectly configured the bonded 
SAN interface for Active-Active operation on a switch that will only 
support Active-Passive. Bad voodoo ensued.

Many thanks to Steven Graf (sgraf@resolutech.net) for responding to my 
query.

John

On 28/08/14 15:53, John Edwards wrote:
> Hi,
>
> I'm suffering some serious performance issues with a pair of iSCSI
> servers based on CentOS 6 and tgtg. VMs using the storage regularly lock
> up for a while before returning to normal operation.
>
> I have matched up VM lockups to errors like this in the logs of the
> iSCSI servers.
>
>   Aug 28 14:32:26 delia-mgt tgtd: conn_close(101) connection closed,
> 0x1264a88 1
>   Aug 28 14:32:26 delia-mgt tgtd: conn_close(107) sesson 0x1242330 1
>   Aug 28 14:32:26 delia-mgt tgtd: conn_close(101) connection closed,
> 0x1249068 4
>   Aug 28 14:32:26 delia-mgt tgtd: conn_close(107) sesson 0x1244520 1
>   Aug 28 14:32:26 delia-mgt tgtd: conn_close(165) Forcing release of rx
> task 0x1255210 e000001a
>   Aug 28 14:32:26 delia-mgt tgtd: conn_close(101) connection closed,
> 0x12647b8 3
>   Aug 28 14:32:26 delia-mgt tgtd: conn_close(107) sesson 0x1255fe0 1
>   Aug 28 14:32:26 delia-mgt tgtd: conn_close(165) Forcing release of rx
> task 0x1255770 b000004d
>
> DD tests from within the VMs show very poor write performance, the DD
> tests also trigger the above errors:
>   [root@centos65 ~]# dd if=/dev/zero of=/dev/drbd0 bs=1M count=1024
> conv=sync
>   1024+0 records in
>   1024+0 records out
>   1073741824 bytes (1.1 GB) copied, 176.358 s, 6.1 MB/s
>
> But iperf tests between VMs and the iSCSI server show ~800Mbs and the
> raw sequential writes to the DRBD volume is ~1.8Gbs
>
> To elaborate on my setup I have:
>
>   * 2 CentOS 6 servers in a Red Hat Cluster (CMAN) cluster
>       o They operate in a Primary/Secondary configuration
>       o They replicate using DRBD
>       o They only serve a single target to a pool of 3 xenservers
>
>
> My targets.conf is very simple:
>
>   default-driver iscsi
>
>   <target iqn.2014-07.com.linguamatics:iscsi0>
>      backing-store /dev/drbd0
>      initiator-address 10.252.15.0/24
>      incominguser iscsi $secret_goes_here
>   </target>
>
>
> Here is my cluster conf if it is of any use:
> <?xml version="1.0"?>
> <cluster config_version="1" name="cluiscsi">
>      <cman expected_votes="1" two_node="1"/>
>      <clusternodes>
>          <clusternode name="delia-mgt.linguamatics.com" nodeid="1">
>              <fence>
>                  <method name="ipmi">
>                      <device action="reboot" delay="15" name="idrac01"/>
>                  </method>
>              </fence>
>          </clusternode>
>          <clusternode name="deirdre-mgt.linguamatics.com" nodeid="2">
>              <fence>
>                  <method name="ipmi">
>                      <device action="reboot" name="idrac02"/>
>                  </method>
>              </fence>
>          </clusternode>
>      </clusternodes>
>      <fencedevices>
>          <fencedevice agent="fence_ipmilan"
> ipaddr="delia-idrac.linguamatics.com" login="root" name="idrac01"
> passwd="$secret"/>
>          <fencedevice agent="fence_ipmilan"
> ipaddr="deirdre-idrac.linguamatics.com" login="root" name="idrac02"
> passwd="$secret"/>
>      </fencedevices>
>      <fence_daemon post_join_delay="30"/>
>      <totem rrp_mode="none" secauth="off"/>
>      <rm>
>          <failoverdomains>
>              <failoverdomain name="drbd-delia" nofailback="0"
> ordered="1" restricted="1">
>                  <failoverdomainnode name="delia-mgt.linguamatics.com"
> priority="1"/>
>              </failoverdomain>
>              <failoverdomain name="drbd-deirdre" nofailback="0"
> ordered="1" restricted="1">
>                  <failoverdomainnode name="deirdre-mgt.linguamatics.com"
> priority="1"/>
>              </failoverdomain>
>              <failoverdomain name="iscsi" nofailback="1" ordered="1"
> restricted="1">
>                  <failoverdomainnode name="delia-mgt.linguamatics.com"
> priority="1"/>
>                  <failoverdomainnode name="deirdre-mgt.linguamatics.com"
> priority="2"/>
>              </failoverdomain>
>          </failoverdomains>
>          <resources>
>              <drbd name="res0" resource="r0"/>
>              <script file="/etc/init.d/drbd" name="drbd"/>
>              <script file="/etc/init.d/tgtd" name="iscsid"/>
>          </resources>
>          <service autostart="1" domain="drbd-delia" exclusive="0"
> name="drbddelia" recovery="restart">
>              <script ref="drbd"/>
>          </service>
>          <service autostart="1" domain="drbd-deirdre" exclusive="0"
> name="drbddeirdre" recovery="restart">
>              <script ref="drbd"/>
>          </service>
>          <service autostart="1" domain="iscsi" exclusive="0"
> name="iscsi" recovery="relocate">
>              <drbd ref="res0">
>                  <ip address="10.252.15.15" monitor_link="on"
> sleeptime="10">
>                      <script ref="iscsid"/>
>                  </ip>
>              </drbd>
>          </service>
>      </rm>
> </cluster>
>
> Does anyone have any idea what is causing these errors?
>
> Thanks in advance,
>
> John Edwards
>
