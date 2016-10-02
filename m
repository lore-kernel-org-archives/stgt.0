From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [Patch 0/0] Fix two issues with WRITE_SAME*
Date: Sun,  2 Oct 2016 09:04:00 -0700
Message-ID: <1475424242-18168-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=/QJCXyAovgaIOyiSFiTS/WJT+hrVzh/anB5OfXqUvkM=;
        b=jze+HwyX2bnQHCmaoo3qi8oEP0JQBEaQqTZzYjCFmFzqX4Uvw9fHZvXQoHZ9EIhtRX
         cY7P21WEmrrVOYTHxl342qgorLm8cof5CXvq12EXV11GOPzry1KJF3fjhkzWmA69ujNS
         Y/CfVsJDuaJT252MUwnqeNmEJ36QsJCvKrx3ZcUbnLpWQmy1cDN+k8+JDbzha9coQge9
         SGf0qvWaqKq2m9WG8pdLAYRJUjnIB+5kBF62rfaWZRoWDqvOdonK6LOCWCw3lx7A0fDv
         9jerJiju1Nw7XSai7lt0xVKsJImlQKCKt9KrZiwoiFOjlO4W8NLkvLPBkL9ZWcQtgtVQ
         AC9g==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: tomof@acm.org

Fix two issues with WRITE_SAME* found using the libiscsi test suite.
When TL is set to 0 this means that the command will cover all blocks
from the specified LBA until end of device.
If DataOut is provided then it must be exactly one block in size.
(DataOut may be omitted for unmap operations)

 sbc.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)
