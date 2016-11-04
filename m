From: FUJITA Tomonori <tomof@acm.org>
Subject: 1.0.69 released
Date: Fri, 04 Nov 2016 09:21:16 +0900 (JST)
Message-ID: <20161104.092116.1305564732068174900.tomof@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

Here's 1.0.69 release.

=
FUJITA Tomonori (1):
      tgt 1.0.69

Ronnie Sahlberg (2):
      Validate the DataOut length in WRITE_SAME_1*
      WRITE_SAME_* TL==0 means all blocks from LBA until the end of device.

Takashi Menjo (1):
      sheepdog: reject snapshot as a LUN to avoid deleting working VDI
