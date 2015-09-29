From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Does tgt-admin supports bs-type sheepdog?
Date: Tue, 29 Sep 2015 14:00:28 +0200
Message-ID: <560A7D5C.9030909@mejor.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mejor.pl;
	 s=cokolwiek; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:Subject:From:To; bh=j9otZ+2M71ltZwCx4BPK6GLqYHmYq+KjA1YhNufQLPQ=;
	 b=F3GwQS1hrHwCBc8jpwvvRkHjGPAOTBOZbOyl35BEisG6oFe030Aw/InfuGsQEYj9sKl8Fw4z7o
	BmpLS0AbDAFrvchTRPlH8NrOVtjF/LJP3cIVMEkfLzqLkGsmofJHYE;
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hello all!

I've got installed tgt-1.0.60, iI'm trying to define sheepdog store in
targets.conf file. Content of targets.conf is:
# cat /etc/tgt/targets.conf
default-driver iscsi

<target iqn.backup.sheep:usun>
        bs-type sheepdog
        backing-store tcp:127.0.0.1:7000:usun
</target>

but tgt-admin throws:
# tgt-admin -p -e
# Adding target: iqn.backup.sheep:usun
tgtadm -C 0 --lld iscsi --op new --mode target --tid 1 -T
iqn.backup.sheep:usun
# Skipping device: tcp:127.0.0.1:7000:usun
# tcp:127.0.0.1:7000:usun does not exist - please check the
configuration file
tgtadm -C 0 --lld iscsi --op bind --mode target --tid 1 -I ALL


Does tgt-admin supports sheepdog or I made a mistake in targets.conf?

Marcin
