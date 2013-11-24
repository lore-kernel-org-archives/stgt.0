From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Fix REPORT SUPPORTED OPCODES
Date: Sun, 24 Nov 2013 15:02:32 -0800
Message-ID: <1385334153-12171-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=nqS7bghmbmgXP4pF+USec6O4sK290LnPe+wTMLv9s4A=;
        b=H/x/wTZ0Ghw/DPKGTLvxsmsYte0oAycfBZi3U3oT2sgm1UsAXUb4ILaiwnZ5jHaOCF
         JsueKgr1GkaWD/Yr38jkBBXsNWjfh0JdJn9XXT25Bb65yb/SGqXYNWQL06tCzpBhLRI0
         bOH1Dbkh2yIk+MczB2WCYjFtkfXGbhnvkYRc1TnAJPJQyfJE6adZfoF4n+A6fZrj7sox
         P7osDaSdmpnWis7lf3s1JKcNE0SWfd6FdOlZr5n5bkYDQf8y10/vyf6BeJeg19ye2qI5
         MXw6m4oTmrsr3IazuXBKXMbJG/iMVfyQdZIfDMqbDFYz+vn5C4tEFjI5yNyCAHevbCsS
         zDvQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

List, Tomo

Please find a small patch that fixes REPORT SUPPORTED OPCODES so that
we only return those opcoes that the backend supports.
For example, for the non-RDWR backends, don't claim we support UNMAP or
WRITESAME10/16 or other more exotic opcodes.

regards
ronnie sahlberg
