From: Frank Michel <fmfranck@gmail.com>
Subject: Network performances using Tgtd on a USB3 device
Date: Tue, 20 Oct 2015 22:53:04 +0200
Message-ID: <CAKn=86Ow3bo8WMKyO5oVAM4pb78SSnQ2MQYm6-_J53cAsQVyqw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=f4FbuwVVW+/kICHM1MNbmfGWj6X/jwDMxYmOrxCOdVc=;
        b=vEorcKJMaQ2zX1UW9OnIxtALIxO41dG5S40y7P7c6Y03Bz8fAPe8K5TXEAmasRw17e
         dUmfjwi8PC+ly/GDuYtADRrbWTiD00fgqZgcObtmd99FZIctFygl7KB8PR3mEBmUFwkQ
         4OKFPyPe3/6ncBa0LMO8GU5a1/7l9DGWSkEAxjANqLLVnp6F9AIFlq+WFGSqSUYxlhtH
         WytQfPeNlDJVsYoICD9ShHXh0+MqOthxZIZ7mZJ9oRNkmfMwFg4lP9CO0gdBqZcOF8Ng
         eOoU1EnW6SFLu13vYwO8WE7JqZa/czc2E6ZC7i6HXuIjc+F3EAfrE0RfuTMfn/JoKWrX
         2gUw==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hello,

We just tested the performances of a USB3 device imported using a
iSCSI link (tgtd + iscsiadm between 2 rhel 6 boxes).

The disk is mounted with the "sync" (server side) and written to using
the "O_DIRECT" option (client side). We write to the disk using the
following command:

    dd if=src_from_fast_device of=dest_on_test_device bs=128k oflag=direct

When we test the disk locally, we reach about 50MB/s which is nice.
However, when we use a iSCSI link, we cannot reach more than 6MB/s on
a Gigabyte network.

We tried a disk emulation and a passthrough iSCSI exports without much
performance gain.

Is there some parameters we could ajust on the server or client side
to gain back our writing performance in such a case ?

Is there a way to workaround this situation, while still keeping the
"sync" mount and "O_DIRECT" write so we avoid dirty pages bloating
problems on the client side ?

Thanks for your help,
