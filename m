From: Michael Ablassmeier <abi@grinser.de>
Subject: VTL: Data block may return twice
Date: Fri, 8 Jan 2021 23:02:59 +0100
Message-ID: <20210108220259.thrrvjfzxf6otczn@lrrr.dead-link.org>
Reply-To: Michael Ablassmeier <abi@grinser.de>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
Content-Disposition: inline
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

hi,

while running the bacula tape test via btape, the append suite failed
against TGT Tape (6bd8382 tgt 1.0.80), it would expect 4 blocks on
tape but discovers 5:

 >  ./btape -c /etc/bacula/bacula-sd.conf /dev/nst1
 >  End scanning the tape.
 >  We should be in file 4. I am at file 5. This is NOT correct!!!!

it seems reading the blocks from the VTL tape if the next position is
Filemark and then EOD, returns it twice ..  which is reproducible via
dd:

Write one block to tape and rewind:

 dd if=/dev/zero of=/dev/nst1 bs=65536 count=1
 mt -f /dev/nst1 rewind

Now attempt reads:

  dd if=/dev/nst1 of=/dev/zero bs=65536 count=1
  1+0 records in
  1+0 records out
  65536 bytes (66 kB, 64 KiB) copied, 0.000753197 s, 87.0 MB/s
  dd if=/dev/nst1 of=/dev/zero bs=65536 count=1
  0+0 records in
  0+0 records out
  0 bytes copied, 0.000803429 s, 0.0 kB/s
  dd if=/dev/nst1 of=/dev/zero bs=65536 count=1
  1+0 records in
  1+0 records out
  65536 bytes (66 kB, 64 KiB) copied, 0.0005939 s, 110 MB/s
  -> this block here, should never been returned, there is
  no more data on the VTL

as far as i had time to take a look, the second read operation in
resp_var_read notices file mark position:

  bs_ssc.c
  346  if (!length) {
  347   if (h->blk_type == BLK_FILEMARK)
  348       goto skip_and_out;                                                                                                                                                       

which in turn calls 

  361 skip_and_out:
  362    ret = skip_next_header(cmd->dev); 

basically moving the position inside the VTL to the wrong place,
..making the third read from the tape to return data from the
same block again :)

bye,
    - michael
