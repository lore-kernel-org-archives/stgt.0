From: Dongliang Ma <mdl13412@gmail.com>
Subject: [tgt] [PATCH] Fix shmat() wrong return value test method
Date: Tue,  8 Jul 2014 19:54:34 +0800 (CST)
Message-ID: <20140708115434.4A9BD199D497@localhost.localhost>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:subject:message-id:date;
        bh=q0/6fFIyJL5IZIeSDL1R7vRBB7IY1aDbiQujJYHneLc=;
        b=VFJs9zTXvjIMjbMPN+2iFZQUakwuq4iPSmbg9ZpRcOQG+ENdTeWqn5qsJ8CnH5WpOq
         GKIKJXq1gkhgr4C6M5J4XKfvgJrrX13oR8zCYpbn0wRz8ShuEjECdmBIVGXjWUyKcb/m
         RvUdrrITXfnF96Eevy8RWUADVaMxla1w0YT4u3+Xi6e5n+sSKhwQAnZNEGzV7q4C3GBK
         X7+LQDO4gl37sZt6Uw/UfNnCyzsPOROVAKDsFACgPHR1liFGrFIVY2BxWWSJwTu24efY
         xFvTaK17AmHy6H+DvO8s2kPQdXHztDMD5J1uuM7Dp8zqLwefltkLOS733zEFvkzF7dM6
         Vtgg==
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
