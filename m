From: nia dev <niadev67@gmail.com>
Subject: Re: [sheepdog] [PATCH] bs_sheepdog.c: fix io errors during writing to
 a snapshot
Date: Sun, 12 Jan 2014 01:43:14 -0500
Message-ID: <CAM0v-CCyM+ybdOpywxSaFXSL6Anu8ZLHKUfU=wY49303H-y_tw@mail.gmail.com>
References: <1389099571-10567-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<87ppo4c4ej.wl%mitake.hitoshi@gmail.com>
	<20140107.222139.1568838937885759101.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=3V+bzRGWPtiK891OHo86JOHzT2zTyFtCHJ6l6O3NJ4k=;
        b=ZTOy1Cwb6tgJivXwQbzF9dapeWjGiYsxVbd6qs/VBWKVY5+kw7LXs4R167aUqo37n3
         s8EcIIQFeqNT4xpSULTsd7msrJ6+xm/7f4MDEZ7u12KFXfvM6CCUCJmQLI0tbsegS/TK
         EdlLIAjCJRjtPvh0gj3YIYLUn5JDogIvEGt9atMXAIjvcJXqRk0rLkt/5ycYkdPtHJLV
         ZSf+uGwFjhS4KW1Frrdsgrgn27Ehvs3XvzckAM94hwb4gEvIpGk5yV5GTT7r7F8bkeO2
         6AU2r6SRXZF9V0WRspUlAr34A2TQshK979PY8E5mGifjYmc0bizcLhdP3IeaLyj/HSn2
         DiUg==
In-Reply-To: <20140107.222139.1568838937885759101.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mitake.hitoshi@gmail.com, konishi.ryusuke@lab.ntt.co.jp, stgt@vger.kernel.org, mitake.hitoshi@lab.ntt.co.jp, sheepdog@lists.wpkg.org

Works now :-) Thanks !!!

On Tue, Jan 7, 2014 at 8:21 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Tue, 07 Jan 2014 22:23:00 +0900
> Hitoshi Mitake <mitake.hitoshi@gmail.com> wrote:
>
>> At Tue,  7 Jan 2014 21:59:31 +0900,
>> Ryusuke Konishi wrote:
>>>
>>> The sheepdog driver fails with io errors when write access is
>>> requested for a snapshot vdi.  The failure happens in create_branch
>>> function:
>>>
>>>  tgtd: read_write_object(684) No object found (oid: 8000000
>>>  000000000, old_oid: 0)
>>>  tgtd: create_branch(1160) reloading new inode object failed
>>>  tgtd: bs_sheepdog_request(1197) creating writable VDI from
>>>  snapshot failed
>>>
>>>  sd 12:0:0:1: [sdb] Unhandled sense code
>>>  sd 12:0:0:1: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>>>  sd 12:0:0:1: [sdb] Sense Key : Medium Error [current]
>>>  sd 12:0:0:1: [sdb] Add. Sense: Unrecovered read error
>>>  sd 12:0:0:1: [sdb] CDB: Write(10): 2a 00 00 00 20 a8 00 00 08 00
>>>  Buffer I/O error on device sdb1, logical block 1041
>>>  lost page write due to I/O error on sdb1
>>>
>>> This turned out to be caused by a race condition among multiple write
>>> requests.  When bs_sheepdog_request() receives a write request for the
>>> snapshot vdi, it tries to change the snapshot to a writable vdi with
>>> the create_branch function.  However, the current implementation of
>>> create_branch() cannot handle concurrent requests exclusively nor
>>> protected from regular io routine (sd_io).
>>>
>>> This fixes the above io-error issue by serializing create_branch()
>>> with a pthread reader/writer lock, and also fixes the race condition
>>> between create_branch() and sd_io() with the lock.
>>>
>>> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
>>> Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
>>> ---
>>>  usr/bs_sheepdog.c |   22 +++++++++++++++++-----
>>>  1 file changed, 17 insertions(+), 5 deletions(-)
>>
>> Ooops, thanks a lot for your fix. It must be a very hard debug and
>> sorry for annoying!
>>
>> Reviewed-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
>
> Applied, thanks a lot, guys.
> --
> To unsubscribe from this list: send the line "unsubscribe stgt" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
