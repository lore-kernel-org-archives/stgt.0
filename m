From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tgt-admin utility not working anymore
Date: Sun, 12 Jan 2014 06:32:19 +0900
Message-ID: <20140112055927M.fujita.tomonori@lab.ntt.co.jp>
References: <CAM0v-CCfGKpHfSLN=EyaLv62eeUWYn6GVNu5b_ewv-ZHdZaD_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CAM0v-CCfGKpHfSLN=EyaLv62eeUWYn6GVNu5b_ewv-ZHdZaD_Q@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: niadev67@gmail.com
Cc: stgt@vger.kernel.org

On Sat, 11 Jan 2014 16:16:49 -0500
nia dev <niadev67@gmail.com> wrote:

> This used to work ... Any idea ?
> 
> # tgt-admin --dump
> -C argument value '0' out of range
> Try `tgtadm --help' for more information.
> 
> All other options produce an error also.

How about the following?

diff --git a/usr/tgtadm.c b/usr/tgtadm.c
index a46f1a4..7771119 100644
--- a/usr/tgtadm.c
+++ b/usr/tgtadm.c
@@ -600,7 +600,7 @@ int main(int argc, char **argv)
 			ac_dir = ACCOUNT_TYPE_OUTGOING;
 			break;
 		case 'C':
-			rc = str_to_int_gt(optarg, control_port, 0);
+			rc = str_to_int_ge(optarg, control_port, 0);
 			if (rc)
 				bad_optarg(rc, ch, optarg);
 			break;
