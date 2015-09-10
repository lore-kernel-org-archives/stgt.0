From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Add WRITE_ATOMIC_16 support
Date: Thu, 10 Sep 2015 05:58:16 -0700
Message-ID: <1441889897-6683-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=oov9k+Rpo1sOI0R4WYY7B2rHW1beXim0zJVReJCbmL0=;
        b=zoKZf9EJgr7PbJyq4z8VoOrIZwe3lzbNhszVXaGzvMjgTGqc9KY1CeB2/iyGTZRZcH
         5bqUNQvjZkqwtPM2EmUbhlRbncnXKXEgi+RUo44UrjyLpXfmd2PpZ4s+7bVU+KszIGj0
         BLh09WoZvJV28BDuR/iM+duPe8d3+Svci54ZJS3zgD+VLy3qD+GUJeaXDFpU3Uon10fo
         UtTeubwt1cK7apjSeUjc96bQEIz6Xcek+gjhlTSjLIMt5FfkoHu+aRKJSdgKwE32sf9H
         CYZlDn/3zJ1pYKi3otY/NDgND6PS1C/twipNkzCNQsRVGKahhCtDG1mOh4kQfW7HsbyL
         64dg==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


Tomo, All

Version 2 of the WRITE_ATOMIC_16 patch.

Changes since version 1:
* Use msync( MS_SYNC|MS_ASYNC) depending on whether or not FUA is set or not.

 
