From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [sheepdog] [PATCH] bs_sheepdog.c: fix io errors during writing
 to a snapshot
Date: Tue, 07 Jan 2014 22:21:39 +0900 (JST)
Message-ID: <20140107.222139.1568838937885759101.fujita.tomonori@lab.ntt.co.jp>
References: <1389099571-10567-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<87ppo4c4ej.wl%mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <87ppo4c4ej.wl%mitake.hitoshi@gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi@gmail.com
Cc: konishi.ryusuke@lab.ntt.co.jp, stgt@vger.kernel.org, mitake.hitoshi@lab.ntt.co.jp, sheepdog@lists.wpkg.org

On Tue, 07 Jan 2014 22:23:00 +0900
Hitoshi Mitake <mitake.hitoshi@gmail.com> wrote:

> At Tue,  7 Jan 2014 21:59:31 +0900,
> Ryusuke Konishi wrote:
>> 
>> The sheepdog driver fails with io errors when write access is
>> requested for a snapshot vdi.  The failure happens in create_branch
>> function:
>> 
>>  tgtd: read_write_object(684) No object found (oid: 8000000
>>  000000000, old_oid: 0)
>>  tgtd: create_branch(1160) reloading new inode object failed
>>  tgtd: bs_sheepdog_request(1197) creating writable VDI from
>>  snapshot failed
>> 
>>  sd 12:0:0:1: [sdb] Unhandled sense code
>>  sd 12:0:0:1: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>>  sd 12:0:0:1: [sdb] Sense Key : Medium Error [current]
>>  sd 12:0:0:1: [sdb] Add. Sense: Unrecovered read error
>>  sd 12:0:0:1: [sdb] CDB: Write(10): 2a 00 00 00 20 a8 00 00 08 00
>>  Buffer I/O error on device sdb1, logical block 1041
>>  lost page write due to I/O error on sdb1
>> 
>> This turned out to be caused by a race condition among multiple write
>> requests.  When bs_sheepdog_request() receives a write request for the
>> snapshot vdi, it tries to change the snapshot to a writable vdi with
>> the create_branch function.  However, the current implementation of
>> create_branch() cannot handle concurrent requests exclusively nor
>> protected from regular io routine (sd_io).
>> 
>> This fixes the above io-error issue by serializing create_branch()
>> with a pthread reader/writer lock, and also fixes the race condition
>> between create_branch() and sd_io() with the lock.
>> 
>> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
>> Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
>> ---
>>  usr/bs_sheepdog.c |   22 +++++++++++++++++-----
>>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> Ooops, thanks a lot for your fix. It must be a very hard debug and
> sorry for annoying!
> 
> Reviewed-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Applied, thanks a lot, guys.
