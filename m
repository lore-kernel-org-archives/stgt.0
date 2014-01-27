From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tgtadm/tgtd management issue: buffer size truncated sometimes
Date: Tue, 28 Jan 2014 00:42:19 +0900 (JST)
Message-ID: <20140128.004219.1568838937885776146.fujita.tomonori@lab.ntt.co.jp>
References: <52A65E29-5717-4DEA-BDD4-CB9700D218E0@evasive.ru>
	<20140124.192139.1568838937885768572.fujita.tomonori@lab.ntt.co.jp>
	<C6A6622D-F621-4889-AE5C-A7F603B84105@evasive.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <C6A6622D-F621-4889-AE5C-A7F603B84105@evasive.ru>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: artyom@evasive.ru
Cc: stgt@vger.kernel.org

Hi,

On Mon, 27 Jan 2014 18:44:42 +0400
Artyom Pervukhin <artyom@evasive.ru> wrote:

> I've done some additional stracing on the tgtd's side this time, please see below:
> 
> Testing 300 targets:
> 
> command:
> 
> root@sandbox:~ # tgtadm -C 0 --op show --mode target
> 
> (command shows full output)
> 
> tgtd writes:
> 
> write(10, "\0\0\0\0\305\325\4\0", 8)    = 8
> write(10, "Target 1: iqn.2014-01:d1\n    Sys"..., 316861) = 224000
> write(10, "       State: ready\n    I_T nexu"..., 92861) = 92861
> 
> command:
> 
> root@sandbox:~ # tgtadm -C 0 --op show --mode target | wc -c                                                                                                                
> 316860
> 
> tgtd writes stays the same as above.
> 
> 
> 
> Testing 900 targets:
> 
> root@sandbox:~ # tgtadm -C 0 --op show --mode target
> 
> (command shows incomplete output)
> 
> tgtd writes:
> 
> write(10, "\0\0\0\0u\205\16\0", 8)      = 8
> write(10, "Target 1: iqn.2014-01:d1\n    Sys"..., 951661) = 256000
> write(10, "a: No\n            Prevent remova"..., 695661) = 176000
> write(10, " Removable media: No\n           "..., 519661) = 176000
> write(10, "T nexus information:\n    LUN inf"..., 343661) = 176000
> write(10, "  Backing store path: None\n     "..., 167661) = 167661
> 
> command:
> 
> root@sandbox:~ # tgtadm -C 0 --op show --mode target | wc -c                                                                                                                
> 929621
> 
> tgtd writes:
> 
> write(10, "\0\0\0\0u\205\16\0", 8)      = 8
> write(10, "Target 1: iqn.2014-01:d1\n    Sys"..., 951661) = 944000
> write(10, "t removal: No\n            Readon"..., 7661) = -1 EPIPE (Broken pipe)
> --- SIGPIPE (Broken pipe) @ 0 (0) ---
> 
> 
> 
> Seeing this, I assumed the bug is on tgtadm's side.

Thanks a lot for the investigation. The following fixes the problem?

Note that tgtd uses a stream to store what tgtd sends to tgtadm. The
buffer of the stream is managed glibc (internally allocated via
malloc). That's a limit about how many targets you can see via tgtadm.


diff --git a/usr/tgtadm.c b/usr/tgtadm.c
index cc63fbf..8e0d5dd 100644
--- a/usr/tgtadm.c
+++ b/usr/tgtadm.c
@@ -234,7 +234,8 @@ static int ipc_mgmt_connect(int *fd)
 static int ipc_mgmt_rsp(int fd, struct tgtadm_req *req)
 {
 	struct tgtadm_rsp rsp;
-	int err, rest, len;
+	int err, len, done;
+	char *buf;
 
 retry:
 	err = recv(fd, &rsp, sizeof(rsp), MSG_WAITALL);
@@ -278,23 +279,28 @@ retry:
 		}
 	}
 
-	rest = rsp.len - sizeof(rsp);
-	if (!rest)
+	len = rsp.len - sizeof(rsp);
+	if (!len)
 		return 0;
 
-	while (rest) {
-		char buf[BUFSIZE];
-		memset(buf, 0, sizeof(buf));
-		len = min_t(int, sizeof(buf) - 1, rest);
-		err = read(fd, buf, len);
-		if (err <= 0) {
-			eprintf("\ncan't get the full response, %m\n");
-			return errno;
+	buf = malloc(len);
+	done = 0;
+	while (len > done) {
+		int ret;
+		ret = read(fd, buf + done, len - done);
+		if (ret < 0) {
+			if (errno == EAGAIN)
+				continue;
+			fprintf(stderr, "failed to read from tgtd, %d", errno);
+			break;
 		}
-		fputs(buf, stdout);
-		rest -= len;
+		done += ret;
 	}
 
+	if (done == len)
+		fputs(buf, stdout);
+	free(buf);
+
 	return 0;
 }
 
