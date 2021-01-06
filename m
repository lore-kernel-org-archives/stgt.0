From: Michael Ablassmeier <abi@grinser.de>
Subject: Re: [PATCH] VTL emulation, no barcodes shown in mtx
Date: Wed, 6 Jan 2021 23:28:42 +0100
Message-ID: <20210106222842.f7wj3s4leywrg7m4@lrrr.dead-link.org>
References: <20210106185825.h7v4dpn2cg3gdejc@lrrr.dead-link.org>
 <20210106220805.gztfmh7he76pwnci@lrrr.dead-link.org>
Reply-To: Michael Ablassmeier <abi@grinser.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tmsurmvkcmxhrz4a"
Return-path: <stgt-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20210106220805.gztfmh7he76pwnci@lrrr.dead-link.org>
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org


--tmsurmvkcmxhrz4a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi,

attached patch should fix this regression.

On Wed, Jan 06, 2021 at 11:08:05PM +0100, Michael Ablassmeier wrote:
>  > commit 73cb8f355479d8f7cb402ca967b137d4a32c8f76
>  > Author: FUJITA Tomonori <tomof@acm.org>
>  > Date:   Fri Jul 28 11:34:15 2017 +0900
>  >     smc: fix snprintf warnings with gcc7
> 
> i reverted both commits and removed -WAll from the makefile to be
> able to compile, and now mtx show the barcodes:
> 
>  >  Storage Changer /dev/sg8:1 Drives, 8 Slots ( 0 Import/Export )
>  >  Data Transfer Element 0:Empty
>  >        Storage Element 1:Full :VolumeTag=TAPE001                        
>  >        Storage Element 2:Full :VolumeTag=TAPE002  
> 
> 
> bye,
>     - michael

--tmsurmvkcmxhrz4a
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="patch.diff"

diff --git a/usr/smc.c b/usr/smc.c
index bbc7b7f..5efcbd7 100644
--- a/usr/smc.c
+++ b/usr/smc.c
@@ -184,7 +184,7 @@ static int add_element_descriptor(uint8_t *data, struct slot *s,
 		{
 			char buf[sizeof(attr->scsi_sn) + 1];
 			memset(buf, 0, sizeof(buf));
-			snprintf(buf, sizeof(buf), "%-s", attr->scsi_sn);
+			snprintf(buf, sizeof(buf), "%-10s", attr->scsi_sn);
 			memcpy((char *)&data[i + 28], buf, 10);
 		}
 	}

--tmsurmvkcmxhrz4a--
