From: Dongliang Ma <mdl13412@gmail.com>
Subject: [tgt] [PATCH] Fix shmat() wrong return value test method
Date: Tue,  8 Jul 2014 18:07:09 +0800 (CST)
Message-ID: <20140708100709.695A7199A8DB@localhost.localhost>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:subject:message-id:date;
        bh=q0/6fFIyJL5IZIeSDL1R7vRBB7IY1aDbiQujJYHneLc=;
        b=dbfeDpic/+zQBa6zCjWbK+9dUZtUZrtdrv9JzixU02kFGUI5dP3SVnONOC3BiWNWr8
         XgsONMDlNgXgk3TG7ccTkRGLYB0msrW6Cav6gQQ3QFo0FlVHJy2GIYRnt6iYRlWQ1Yni
         HN/IA2YQpA77jcUWzmbMnoeAQU9Qca3sBdyxtNRHdNTtXEFMRYVdsd+RKuvgGj38CPvF
         CdbR+5epCwILFheN1STnVlzwYkKmIJOlmGmCK72INbSksHXudstAFfzjqfcT/l3rS3pq
         DEDmmr/Ybbe3G+3tyPA0t+SknT+E3i7uEQt0HG5kFClNdmQQU03NYYoUuvfUwIuHf5YV
         Btyw==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

From: Dongliang Ma <mdl13412 at gmail.com>

This patch fixed the invalid shmat() return value test method.

Signed-off-by: Dongliang Ma <mdl13412 at gmail.com>
---
usr/log.c |    6 +++---
1 files changed, 3 insertions(+), 3 deletions(-)
---
diff --git a/usr/log.c b/usr/log.c
index 2f0c4d4..24a3af9 100644
--- a/usr/log.c
+++ b/usr/log.c
@@ -61,7 +61,7 @@ static int logarea_init (int size)
 	}
 
 	la = shmat(shmid, NULL, 0);
-	if (!la) {
+	if (la == ((void *) -1)) {
 		syslog(LOG_ERR, "shmat logarea failed %d", errno);
 		return 1;
 	}
@@ -79,7 +79,7 @@ static int logarea_init (int size)
 	}
 
 	la->start = shmat(shmid, NULL, 0);
-	if (!la->start) {
+	if (la->start == ((void *) -1)) {
 		syslog(LOG_ERR, "shmat msg failed %d", errno);
 		shmdt(la);
 		return 1;
@@ -101,7 +101,7 @@ static int logarea_init (int size)
 		return 1;
 	}
 	la->buff = shmat(shmid, NULL, 0);
-	if (!la->buff) {
+	if (la->buff == ((void *) -1)) {
 		syslog(LOG_ERR, "shmat logmsgfailed %d", errno);
 		shmdt(la->start);
 		shmdt(la);
