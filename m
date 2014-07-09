From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: Re: what do these abort_cmd(1324) and abort_task_set(1348) messages
 in the logs mean?
Date: Wed, 09 Jul 2014 16:15:42 +0200
Message-ID: <53BD4E8E.9030900@powercraft.nl>
References: <53A01747.3010708@powercraft.nl> <20140627.205748.1568838937885792032.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20140627.205748.1568838937885792032.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dear FUJITA,

On 27/06/14 13:57, FUJITA Tomonori wrote:
> On Tue, 17 Jun 2014 12:24:07 +0200 Jelle de Jong
> <jelledejong@powercraft.nl> wrote:
> 
>> What do these tgtd messages mean? Is something wrong? Why are
>> they there?
>> 
>> http://paste.debian.net/105427/
> 
> A SCSI command was aborted for some reason (e.g. the time-out of a
> SCSI command due to the overloaded iscsi target).
> 
> The cricial bug about this was fixed in 1.0.48. I would recommend
> you to update tgt if you use the older version.

I upgraded to version 1.0.48 about a week ago for further testing, I
also added a complete new network path, with new network cards and
direct connections, but I keep getting these same errors:

http://paste.debian.net/108884/

Is this a bug in tgtd? Is there some tgtd option or environment
variable that I can set to get more information.

This system have been stable for more then a year with very old
versions 1.0.17 of tgt but these versions didn't shutdown the target
very reliable when using pacemaker and corosync, making it hang (I
didn't experience this with the newer versions).

Kind regards,

Jelle de Jong



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iJwEAQECAAYFAlO9TooACgkQ1WclBW9j5HnfrAP+KNwdgBC1RNQKxQiT81ZiVLA7
p0OwND1AFyusnflzjO7qecNZ5kvTL/Z5zoRM+P9ecw9kmGFRQojPsYOof/7nqMFA
UCx5sI7Jp9XNW/C6ZYX6QM//t1d0UPCAIDwciG37a/Lpymo5xj/UkJ5JcZg1rCaB
Nsfq1SRcYHVevUIVRaw=
=L21b
-----END PGP SIGNATURE-----
