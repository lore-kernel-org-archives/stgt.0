From: Yifeng Xu <skypexu@gmail.com>
Subject: main thread event loop can be blocked
Date: Tue, 27 Jan 2015 21:02:08 +0800
Message-ID: <CAD-e951btOZgPw_af3SUoS4+yKjd4NOv2J6nsWMLpPR0FyxeYg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=2yAbF56IK2/xQuncxlYVQMgU2PUxqYU2B9i1kpRynsw=;
        b=jgQvoutkZOoWWQbEyzBjhIv7VtzEB2o3o3da9mznjyUKaTXr6/q2BEEGxAXJWGPRgu
         v7r6s3Ceyl+bLync44uC/sS07/lLK4uCvbKsmjFwtF8xGHXOylsMREW9zIgThBb/40qY
         U1w0Uxmb0VjbuNq1IFm2C2OuIRFuCV/hEuBUsyThLNqsUC63YMDic2SsS2W0ABAwZ/Oc
         VXsxKvuf22zHh2B1+eWW1FHV+5nar7e6rMfpanphL4LJWRw/WRM1lHp0RLOjSfRCMicS
         Ik0Cqbjb2W1dOqwUwD4iIXvsPXwZLGDkCFGQQYukuAufwIvGxHYPwIaEeJtGigqL9n43
         zkqQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

if a backing store is network based, when it is added to a target as a
lun, the main thread may be blocked in its bs_open function,
then all network I/O for other luns will be blocked too, what's the
solution to the problem ?

Regards,
