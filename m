From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Add WRITE_ATOMIC_16 support
Date: Thu, 10 Sep 2015 17:36:35 -0700
Message-ID: <1441931796-20788-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=7y7dXj395zKcflRZH8PhJ/6/1CVLuWYvfUbTKHA59XI=;
        b=qtmE83q6yMTkx5lgIoV/PuAbG31xr3mRkub+LJpzq7U7UHczqMf+v9/9OCcZnjA3f2
         lU2ePkVAaCp7QO2AHixcf/vqG9FTEiCw8/2DsZ7/BQ1bjphpOPywjJFXeWCYaB/6B7qz
         Y/3oPSZYPGZdrVW1rRm6X8Od6AZzz1g+VHfkU4ifhos9QYFJenw4uJz3T/vhainyu/nu
         u2SuCYsVnxG+3DTsOmWMhAQOI8Wh6kvKhEh4NJUShHEyS6NP8lLKcbJuJkJG+pxmMWGZ
         dcRCzf/vs/ZeKBqVIxjIL04KaFeeLIMgOhjs0L7+d28UI3VHE2F7SceZp+vPRmv78W/J
         ALOQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


Tomo, All

Version 3 of the WRITE_ATOMIC_16 patch.

Changes since version 2:
* WriteAtomic with transfer-length == 0 is actually not an error.

Changes since version 1:
* Use msync( MS_SYNC|MS_ASYNC) depending on whether or not FUA is set or not.
