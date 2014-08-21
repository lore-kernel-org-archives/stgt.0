From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Add a DVD jukebox script
Date: Wed, 20 Aug 2014 19:21:44 -0700
Message-ID: <1408587705-19310-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=/B5zTbKe1OrSYYfLXa4dmjlKrvpdIuiImwVPXerM8Rs=;
        b=F5WA5FqxWkEcf76J6LbKNEH3+QIMtGC35dhVjdGS849wmw81M/tAZObfppt3Kld7lP
         GbxKqs8PKtV9E857Ngkz3BoaptzcsjkLAdncaKu9LNZmi+4dKxELCSZJd+oX/c+PaPrY
         PXodC9eUZRWH/D1Ki1ZLVrfpIg6HQfnLit+ZVyydF/w0ekF7p5/1HTs2NZytLYaz0TQU
         hI45426jVpUuvqHwK3F2VR3DzwhmAG/wfdjRLaZKHdRX298ohUEjoNqqv7lBu5hq+JET
         5SUjACEhKDM+3Pi4clBp5caqaevfmCD+dvMBgNG656fAMTn4c5IT9R03F776NQ9VwMy5
         o/xQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Ronnie Sahlberg <ronniesahlberg@gmail.com>

List, Tomo,

Please find a patch to add a new README file that is a simple shell script
that will automatically set up and export all the .iso images in a directory
as a dvd jukebox.

This makes it a snap to set up and export all the ISOs in your collection.


Ronnie Sahlberg (1):
  DOCS: add an example dvd jukebox script

 doc/README.dvdjukebox |  100 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 100 insertions(+), 0 deletions(-)
 create mode 100755 doc/README.dvdjukebox

-- 
1.7.3.1
