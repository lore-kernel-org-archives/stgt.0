From: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Subject: [PATCH 0/3] various update for sheepdog driver
Date: Sun,  6 Jul 2014 23:30:29 +0900
Message-ID: <1404657032-17629-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=7j41xzLSCqnWSpd+ltN+khe6q8O1WchkzvHMNl2walY=;
        b=kXIfVwFUJRXq11hXdQ/oHno8ZgfpQmxhZp/eqFzd8forPd9/xdVz72CEsQo8qxYlJy
         MEQuKyVMNTH8Pm7ACJPvS8n6eo8bzyZKvDbocK5cQJ37wGxLaXFOzXk89QGhbSrhhsn6
         6QGMdUaibEa9rJaqppSSmxdRHvMS8C1wImVjBfMgcnygN2/IYCQjAnFD9rKD+jL+eVTm
         4aJs2McAhsubJNPxv1pGRM9Urvpk7aNIP87ORJAc09pjNExpAs0FTLwuc9YoRZdbFsum
         D8i09rCDUCDJkLpU90E/HRB5YOaChp+LySTQYMFZYS6hh9Wy6UfdmkUQ8rSDKLahENj7
         23GQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: sheepdog@lists.wpkg.org, Hitoshi Mitake <mitake.hitoshi@gmail.com>

This patchset contain some update for sheepdog driver. The most
important one is the first patch. With this patch, iSCSI target with
sheepdog virtual disk can enable caching feature of sheepdog.

Others are mainly for documenting purpose.

Hitoshi Mitake (3):
  sheepdog: turn on cache flag of write request
  sheepdog: update layout of inode object header
  sheepdog: add documentation

 doc/README.sheepdog | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 usr/bs_sheepdog.c   |  29 +++++++++++++--
 2 files changed, 126 insertions(+), 3 deletions(-)
 create mode 100644 doc/README.sheepdog

-- 
1.9.1
