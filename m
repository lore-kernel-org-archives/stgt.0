From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 0/3] Allow running tgtd as a non-root user
Date: Tue,  7 Apr 2015 11:40:31 -0700
Message-ID: <1428432034-28682-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=LRKuZp4vYWyhkfUrrgX3aD34LcmF56QigqcX8lukpfw=;
        b=ouyJlJb/Z/Rsd/7cXx6ZTrQQHMHeAGeYZbSSm2D9maUPsKJh3Ta4EnuudW5Zmp4qip
         wACtT8WLhDQu6yjVZCu4cyMHhaw5NHuOZclB7U6R1mEr0gADMPQZAyGd0eJvA6JRXv7z
         pkcfaYUMUnZfqCSxYVsHU7rondA+npvzEYvnJKgmqopRihaZkKnmuC9DzVzNbfYTVoCL
         sWoJ7qtb6xfdpA5cV7oQRej8nl6UROzSWV4Vk/nnVLm/HFBVIJ8bcL5VTgmMinXZYyOu
         9SNVR08YM3FGzXDNtgz7Df6oL+f54PDDYFy/ylaZhtpdo+y/7Pp/WEA4mzgOpGN8SYH7
         BCDg==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

Update to the patches. We don't need to make the lock file writeable
for the group.

