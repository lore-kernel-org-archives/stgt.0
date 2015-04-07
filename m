From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 0/3] Allow running tgtd as a non-root user
Date: Tue,  7 Apr 2015 11:29:06 -0700
Message-ID: <1428431349-24087-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=leClB0GUxayo+F1y58FcbiBdUlCEOEua1DC1etrWAFc=;
        b=xWp/bTDrWao6+iLbHFXOlaBxZZ9TMlgMqf/LF/9x/J0vMwVIGmbbHNkFMXMTzU+70C
         BI/Tt4u5HZ+LEPxDbvXZpMAil1SDQ8wq6425w1XQW3QcgZ1i6rPiLDHAWEdJL0VKy7Ec
         KpeQa8X3d9MJmvNYlFYdDqpHAQLfpCq54j5GxvNaH/Z9I1/RbcDOdAZm1avbmmREILlJ
         7PIsRvPWdQpuoUXZ6AzxSGAtQgK9232m+ccjwmxWKwe5dNFJIXDtuKBhpB5IJ6YTxZVQ
         wNMou3Xj5YszdfigHb5MG7nrgyZ7c8IWWzLLfcRkhTDOnNVxJHIxZqZrhk0l5zUtOb5j
         LslA==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

List, Tomo

Please find three trivial patches to allow running tgtd as a normal
unprivileged user.
