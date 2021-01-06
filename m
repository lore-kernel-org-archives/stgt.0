From: Michael Ablassmeier <abi@grinser.de>
Subject: Re: VTL emulation, no barcodes shown in mtx
Date: Wed, 6 Jan 2021 20:01:32 +0100
Message-ID: <20210106190132.dektdwtuqbvf4bpe@lrrr.dead-link.org>
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

On Wed, Jan 06, 2021 at 07:58:25PM +0100, Michael Ablassmeier wrote:
> im trying to create a virtual tape library based on the DVD/CD example,
> the commands used are:
> 
> > tgtadm --op new --mode logicalunit --tid 1 --lun 1 --device-type tape 
> > [..]

The output is missing the relevant image commands which were used to
create the medias:

> tgtimg --op new --device-type tape --type DATA --barcode TAPE001 --size 500 --file ${VTL}/TAPE001
> tgtimg --op new --device-type tape --type DATA --barcode TAPE002 --size 500 --file ${VTL}/TAPE002

thanks,
    - michael
