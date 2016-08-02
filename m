From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: fix stgt crash in conn_close
Date: Tue, 02 Aug 2016 12:32:52 +0900 (JST)
Message-ID: <20160802.123252.598552788702445303.tomof@acm.org>
References: <CAKbOEtvX_NBVVRvh1Ev1=-xdbq3sPa9rfxrZCWQqD0i=43Mu7Q@mail.gmail.com>
	<87mvl4zv29.fsf@desktop-ng.home.sw4me.com>
	<CAKbOEtt2jEa021ejM2Wfvq4TKcfWqjbCrR36+UYQQD7Wms1q8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAKbOEtt2jEa021ejM2Wfvq4TKcfWqjbCrR36+UYQQD7Wms1q8Q@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: chenfx2014@gmail.com
Cc: stgt@vger.kernel.org, anton.kovalenko@acronis.com

On Tue, 26 Jul 2016 17:46:19 +0800
fx chen <chenfx2014@gmail.com> wrote:

> From c0d3f1498122430a166aa304e4e58139efec788a Mon Sep 17 00:00:00 2001
> From: Chen Fangxian <chenfangxian@cmss.chinamobile.com>
> Date: Tue, 26 Jul 2016 11:33:39 +0800
> Subject: [PATCH v2] iscsi: fix segfault at conn_close
> 
> Remove some iscsi task from conn->session->cmd_list before free it,
> otherwise it may cause tgtd process crash. Below is a backtrace info:
> 
>  Program terminated with signal 11, Segmentation fault.
>  #0  0x000000000040a259 in __list_del (prev=0x7cd38c0, next=0x5aff340) at ./list.h:83
>  83  prev->next = next;
>  (gdb) bt
>  #0  0x000000000040a259 in __list_del (prev=0x7cd38c0, next=0x5aff340) at ./list.h:83
>  #1  0x000000000040a296 in list_del (entry=0x623d080) at ./list.h:88
>  #2  0x000000000040edd6 in iscsi_free_cmd_task (task=0x623d010) at iscsi/iscsid.c:1254
>  #3  0x000000000040ee6a in iscsi_scsi_cmd_done (nid=3356, result=0, scmd=0x623d0e0) at iscsi/iscsid.c:1269
>  #4  0x0000000000432dc0 in target_cmd_io_done (cmd=0x623d0e0, result=0) at target.c:1236
>  #5  0x000000000045be39 in bs_sig_request_done (fd=10, events=1, data=0x0) at bs.c:210
>  #6  0x0000000000428ff2 in event_loop () at tgtd.c:432
>  #7  0x0000000000429fca in main (argc=3, argv=0x7ffffcec25f8) at tgtd.c:624
> 
> Signed-off-by: Meng Lingkun <menglingkun@cmss.chinamobile.com>
> Signed-off-by: Wang Zhengyong <wangzhengyong@cmss.chinamobile.com>
> Reviewed-by: Wang Dongxu <wangdongxu@cmss.chinamobile.com>
> Signed-off-by: Chen Fangxian <chenfangxian@cmss.chinamobile.com>
> ---
>  usr/iscsi/iscsid.c | 4 +++-
>  usr/iscsi/iscsid.h | 2 ++
>  2 files changed, 5 insertions(+), 1 deletion(-)

Looks good to me. Thanks you so much, guys!
