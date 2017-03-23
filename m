From: Lee Duncan <lduncan@suse.com>
Subject: Re: open-iscsi Cannot connect to my tgt target
Date: Thu, 23 Mar 2017 17:07:12 -0400
Message-ID: <9d379ddd-623a-4fdc-aaf9-bbf4ba8973d6@suse.com>
References: <CANVNt1axh1GoC28Y+Ztph_=gQP1zHeG-8BDdW47onAFX3dSH9Q@mail.gmail.com>
 <CAJt62OeYC9HWjWFfoKcf0dhKYMT7d3gkvy5HC8pjiW4D3QKXkw@mail.gmail.com>
 <CANVNt1Y7UO53J63Z=Rn1DCXRX4pUmbSddDQvjz2P5ZBUEUk9Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <CANVNt1Y7UO53J63Z=Rn1DCXRX4pUmbSddDQvjz2P5ZBUEUk9Lg@mail.gmail.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mr Dini <diniboy74@gmail.com>, "Ovi Chis (OviOS Linux Project)" <ovios.storage@gmail.com>, stgt@vger.kernel.org

On 01/01/2017 03:02 PM, Mr Dini wrote:
> Thanks for Your quick reply!
> 
> And Your tip worked. :) If I configure the target without user
> authentication, everything works perfectly. But if there is a CHAP
> user and pass, the open-iscsi Cannot connect. But the Windows PCs Can
> handle the CHAP data, So that is a half win. I just have to figure
> out, how Can I specify the user and pass parameters at the open-iscsi
> connect command.
> 

The file /etc/iscsi/iscsid.conf, the iscsi daemon configuration file,
tells you how to set up CHAP for iSCSI, and it certainly should be working.


> secondly, the target name isn't conforming to the required standards.
> 
> 
> The name is correct. I just edited the target name because I don't
> want to share my domain and etc.
> 
> 
> Many thanks!
> 

-- 
Lee Duncan
SUSE Labs
