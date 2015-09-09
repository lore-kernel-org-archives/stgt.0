From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] Add WRITE_ATOMIC_16 support
Date: Wed,  9 Sep 2015 11:43:54 -0700
Message-ID: <1441824235-7724-1-git-send-email-ronniesahlberg@gmail.com>
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=h1f5Scl+jhuGNlCznlPKZzKWGSxSuBClDeWnfLPceiI=;
        b=mKfaQbBsr/n53Xn2whRQwHIiVBnNu4jEDruKBEkk0OmE5i8eJF2OwuAvn2eEEegcuQ
         giThBkxv9PYXzorV82BDKFJhajlVgaeZArmLFQsNLPJ4cMCfhy4Tnjf5TZaKXBJod0qQ
         F6cweD5F3nLSVoEV+R6+OxaKQxEYOCVDGXG19aVt73KlC+BmFeQcYucTwupePOAFRyF4
         oVxvB4ICEPC4+Fh95cJchDP0qTT1m+CsBcPuPHfKjqs4gYbwS714tnWMOzJHPqXcsoya
         AHCAlpZB6/a8OKzNQiqypkGjYCFDSbigI3gTtoFmuWMYO/MjWYzs33B7KVW81st/p+uw
         IGVw==
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


Tomo, All,

Please find attached a patch that adds support for the new opcode
WRITE_ATOMIC_16 to the bs_rdwr backend.

I try to make it as atomic as possible by using mmap and mlock to ensure that
both the write buffer and the file region we are writing to will be all
present and locked down in memory before I just memcpy() the data.
At that stage it is then assumed that the memcpy() will never fail short.

The patch also adds the three new write atomic fields to the block limits
vpd page and sets some sane defaults.
Maximum amount of write atomic is set to the arbitrary limit of 16MByte
and alignment and granularity is computed based on the blocksize of the
underlying filesystem.

regards
ronnie sahlberg
