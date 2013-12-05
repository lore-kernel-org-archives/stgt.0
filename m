From: "Moussa Ba (moussaba)" <moussaba@micron.com>
Subject: FW: ISER - tgtadm: Can't find the driver
Date: Thu, 5 Dec 2013 22:04:39 +0000
Message-ID: <697D97E420EE024FB7451B574CD4991BCA072B55@NTXBOIMBX05.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

#ls -lZ /dev/infiniband/*

ls -lZ /dev/infiniband/* 

crw-rw---- root root ?                                /dev/infiniband/issm0
crw-rw---- root root ?                                /dev/infiniband/issm1
crw-rw---- root root ?                                /dev/infiniband/issm2
crw-rw---- root root ?                                /dev/infiniband/issm3
crw-rw-rw- root root ?                                /dev/infiniband/umad0
crw-rw-rw- root root ?                                /dev/infiniband/umad1
crw-rw-rw- root root ?                                /dev/infiniband/umad2
crw-rw-rw- root root ?                                /dev/infiniband/umad3
crw-rw-rw- root root ?                                /dev/infiniband/uverbs0
crw-rw-rw- root root ?                                /dev/infiniband/uverbs1



> -----Original Message-----
> From: Moussa Ba (moussaba)
> Sent: Thursday, December 05, 2013 1:42 PM
> To: 'stgt@vger.kernel.org'
> Cc: Shlomi Sasson; 'Or Gerlitz'
> Subject: ISER - tgtadm: Can't find the driver
> 
> I have been trying to reactivate a tgt array I was using a few months
> ago. I am currently using 3.12 but, tgtdadm
> fails with a:
> 
> tgtadm: Can't find the driver
> 
> I ran the following commands to configure it:
> 
> 
> 
> taskset  0x00000100 tgtd  --control-port 0 --iscsi
> portal=192.168.104.2:3260 --iser port=3260
> 
> echo "Creating iqn.target0"
> tgtadm --lld iser --mode target --op new --tid=1 --targetname
> iqn.target0 -C 0
> tgtadm --lld iser --mode logicalunit --op new --tid 1 --lun 1 -b
> /dev/rssda --bstype rdwr -C 0
> tgtadm --lld iser --mode logicalunit --op update --tid 1 --lun 1 --
> params scsi_id="$RSSDA_ID" -C 0
> tgtadm --op update --mode target --tid 1 --name=MaxQueueCmd --value=256
> tgtadm --lld iser --mode target --op bind --tid 1 -I ALL
> 
> 
> 
> Below are the modules Loaded
> 
> mlx4_en                76854  0
> mlx4_ib               129860  16
> ib_sa                  23653  4 rdma_cm,ib_ipoib,ib_cm,mlx4_ib
> ib_mad                 40129  4 ib_cm,ib_umad,mlx4_ib,ib_sa
> ib_core                72427  11
> ib_iser,ib_isert,rdma_cm,iw_cm,ib_ipoib,ib_cm,ib_uverbs,ib_umad,mlx4_ib
> ,ib_sa,ib_mad
> mlx4_core             202689  2 mlx4_en,mlx4_ib
> rdma_cm                39115  2 ib_iser,ib_isert
> iw_cm                   9936  1 rdma_cm
> ib_addr                 6528  1 rdma_cm
> ib_cm                  37980  2 rdma_cm,ib_ipoib
> ib_uverbs              36365  48
> rdma_cm                39115  2 ib_iser,ib_isert
> ib_mad                 40129  4 ib_cm,ib_umad,mlx4_ib,ib_sa
