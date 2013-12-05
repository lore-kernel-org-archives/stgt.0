From: "Moussa Ba (moussaba)" <moussaba@micron.com>
Subject: RE: ISER - tgtadm: Can't find the driver
Date: Thu, 5 Dec 2013 22:43:13 +0000
Message-ID: <697D97E420EE024FB7451B574CD4991BCA072B74@NTXBOIMBX05.micron.com>
References: <697D97E420EE024FB7451B574CD4991BCA072B25@NTXBOIMBX05.micron.com>
 <CAJZOPZ+b4Fs_krnjb-ObWcXuw5ULa=9DukV4CZ4wRvNzi7tOGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAJZOPZ+b4Fs_krnjb-ObWcXuw5ULa=9DukV4CZ4wRvNzi7tOGg@mail.gmail.com>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: "stgt@vger.kernel.org" <stgt@vger.kernel.org>, Shlomi Sasson <shlomis@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>

Thank you. Loading rdma_ucm resolved the issue. Do you think this information should be included the README.iser?  It is already mentioned that Kernel modules should be loaded but which ones is not specified.  Thank you.

Moussa

> -----Original Message-----
> From: Or Gerlitz [mailto:or.gerlitz@gmail.com]
> Sent: Thursday, December 05, 2013 2:13 PM
> To: Moussa Ba (moussaba)
> Cc: stgt@vger.kernel.org; Shlomi Sasson; Or Gerlitz
> Subject: Re: ISER - tgtadm: Can't find the driver
> 
> On Thu, Dec 5, 2013 at 11:42 PM, Moussa Ba (moussaba)
> <moussaba@micron.com> wrote:
> > I have been trying to reactivate a tgt array I was using a few months
> ago. I am currently using 3.12 but, tgtdadm
> > fails with a:
> >
> > tgtadm: Can't find the driver
> >
> > I ran the following commands to configure it:
> >
> >
> >
> > taskset  0x00000100 tgtd  --control-port 0 --iscsi
> portal=192.168.104.2:3260 --iser port=3260
> >
> > echo "Creating iqn.target0"
> > tgtadm --lld iser --mode target --op new --tid=1 --targetname
> iqn.target0 -C 0
> > tgtadm --lld iser --mode logicalunit --op new --tid 1 --lun 1 -b
> /dev/rssda --bstype rdwr -C 0
> > tgtadm --lld iser --mode logicalunit --op update --tid 1 --lun 1 --
> params scsi_id="$RSSDA_ID" -C 0
> > tgtadm --op update --mode target --tid 1 --name=MaxQueueCmd --
> value=256
> > tgtadm --lld iser --mode target --op bind --tid 1 -I ALL
> >
> >
> >
> > Below are the modules Loaded
> >
> > mlx4_en                76854  0
> > mlx4_ib               129860  16
> > ib_sa                  23653  4 rdma_cm,ib_ipoib,ib_cm,mlx4_ib
> > ib_mad                 40129  4 ib_cm,ib_umad,mlx4_ib,ib_sa
> > ib_core                72427  11
> ib_iser,ib_isert,rdma_cm,iw_cm,ib_ipoib,ib_cm,ib_uverbs,ib_umad,mlx4_ib
> ,ib_sa,ib_mad
> > mlx4_core             202689  2 mlx4_en,mlx4_ib
> > rdma_cm                39115  2 ib_iser,ib_isert
> > iw_cm                   9936  1 rdma_cm
> > ib_addr                 6528  1 rdma_cm
> > ib_cm                  37980  2 rdma_cm,ib_ipoib
> > ib_uverbs              36365  48
> > rdma_cm                39115  2 ib_iser,ib_isert
> > ib_mad                 40129  4 ib_cm,ib_umad,mlx4_ib,ib_sa
> 
> For some reason the ib_mad and rdma_cm modules are listed twice...
> anyway, you need rdma_ucm which is the ib_uverbs equivalent --
> provides access to the kernel rdma_cm. I would recommend to run rping
> which is provided by librdmacm-utils to very there's proper user space
> access to the kernel IB stack .
> 
> Or.
