From: Yifeng Xu <skypexu@gmail.com>
Subject: race condition between target life cycle and login
Date: Sun, 5 Jul 2015 10:57:29 +0800
Message-ID: <CAD-e953UY+3o-jYgJegO-Mhva4nYtGUjPsph0Rv515jfKWHABQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=IGRm900lh/eKgI76GpUbrTbS8PLKfwdRqZuTaZkOvLc=;
        b=envR9kLVe8JitTAuD2Y1WIB6z/XBcDjhzWvciMkXIyvMVS6ounAcHmCImZUYgk3Mwx
         cr+tVHxF6rnwW7ZJlwqu5VD6y0SuGVF979gRdUdQwvw+cZqp/Xfmp9ir6MxmDEyqKdsp
         vqWIDa/kTqofOexlnm9C/3vAZKStEg0W7KKoGUCPZmEyUDbyGw/ZuBd3++hKx2A5YKqL
         xI5jL02KZV3bt6P5aWKEBwJyLk1oQW6HYYleiyNReucyKAlvZ32DLGrDPybZK+KPSUzF
         00Hi1HgHRYjS1Kl7QEVL5MufJABgc2jfMvZ2F7pRUCAiUJsXyBR9cGtlDfX0oJTM0+BD
         DVWQ==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org

Hi,

I think there is a race condition between target recreating and
iscsi_tcp_conn_login_complete(), later only checks tid, but during
login procedure, a target may be destroyed and recreated,  and
it is another different target at all.

I think there should be a generation number saved both in connection and
target, the iscsi_tcp_conn_login_complete() should check it.

Regards,
Skype Xu
