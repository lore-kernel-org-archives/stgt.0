From: Michael Ablassmeier <abi@grinser.de>
Subject: Re: VTL emulation, no barcodes shown in mtx
Date: Wed, 6 Jan 2021 23:08:05 +0100
Message-ID: <20210106220805.gztfmh7he76pwnci@lrrr.dead-link.org>
References: <20210106185825.h7v4dpn2cg3gdejc@lrrr.dead-link.org>
Reply-To: Michael Ablassmeier <abi@grinser.de>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20210106185825.h7v4dpn2cg3gdejc@lrrr.dead-link.org>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

hi again,

On Wed, Jan 06, 2021 at 07:58:25PM +0100, Michael Ablassmeier wrote:
> > mtx -f /dev/sg8 status
> > Storage Changer /dev/sg8:1 Drives, 8 Slots ( 0 Import/Export )
> > Data Transfer Element 0:Empty
> > Storage Element 1:Full 
> > Storage Element 2:Full 
> > Storage Element 3:Empty:VolumeTag=

it seems this i a regression introduced by one of the following commits
to smc.c:

 >  commit 2de8bebe132e3b998bf4848d0bd22b50367ad4b8
 >  Author: Lee Duncan <lduncan@suse.com>
 >  Date:   Sat Feb 16 10:29:19 2019 -0800
 > 
 >      Fix gcc7 string truncation warnings.

 > commit 73cb8f355479d8f7cb402ca967b137d4a32c8f76
 > Author: FUJITA Tomonori <tomof@acm.org>
 > Date:   Fri Jul 28 11:34:15 2017 +0900
 >     smc: fix snprintf warnings with gcc7

i reverted both commits and removed -WAll from the makefile to be
able to compile, and now mtx show the barcodes:

 >  Storage Changer /dev/sg8:1 Drives, 8 Slots ( 0 Import/Export )
 >  Data Transfer Element 0:Empty
 >        Storage Element 1:Full :VolumeTag=TAPE001                        
 >        Storage Element 2:Full :VolumeTag=TAPE002  


bye,
    - michael
