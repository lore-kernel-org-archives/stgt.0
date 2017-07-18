From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/2] GCC 7 fixes, still need help with smc.c
Date: Tue, 18 Jul 2017 13:52:56 -0700
Message-ID: <20170718205258.6246-1-agrover@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 3315761BB0
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: stgt@vger.kernel.org

tgt doesn't build on Fedora 26 using GCC 7, which has added some
additional snprintf compilation checks. These two patches fix some
minor ones, but there are also a number in smc.c. I don't have enough
familiarity with that code or the SMC spec to be confident I'd fix
them properly. Maybe someone else could take a look? Here they are:

smc.c: In function ‘build_element_descriptors’:
smc.c:164:41: error: ‘snprintf’ output truncated before the last format character [-Werror=format-truncation=]
    snprintf((char *)&data[i], 32, "%-32s", s->volume_tag);
                                         ^
smc.c:164:4: note: ‘snprintf’ output 33 bytes into a destination of size 32
    snprintf((char *)&data[i], 32, "%-32s", s->volume_tag);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
smc.c:166:41: error: ‘snprintf’ output truncated before the last format character [-Werror=format-truncation=]
    snprintf((char *)&data[i], 32, "%-32s", s->barcode);
                                         ^
smc.c:166:4: note: ‘snprintf’ output 33 bytes into a destination of size 32
    snprintf((char *)&data[i], 32, "%-32s", s->barcode);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
smc.c:184:40: error: ‘%-10s’ directive output may be truncated writing between 10 and 36 bytes into a region of size 11 [-Werror=format-truncation=]
   snprintf((char *)&data[i + 28], 11, "%-10s", attr->scsi_sn);
                                        ^~~~~
smc.c:184:3: note: ‘snprintf’ output between 11 and 37 bytes into a destination of size 11
   snprintf((char *)&data[i + 28], 11, "%-10s", attr->scsi_sn);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[1]: *** [Makefile:94: smc.o] Error 1
make: *** [Makefile:24: programs] Error 2

Thanks -- Regards -- Andy

Andy Grover (2):
  Fix header warning with GCC 7 for major()
  Remove incorrect size specifier in spc_lu_init

 usr/bs_sg.c | 1 +
 usr/spc.c   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.9.4
