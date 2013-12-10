From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] Fix buffer overrun issue of lld name
Date: Tue, 10 Dec 2013 18:25:34 +0900
Message-ID: <1386667534-2914-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

The string buffer of lld name in tgtadm_req struct (req->lld) will not
be null-terminated if user specifies very long lld name for the
argument of -L or --lld option.

This is because the lld name is copied with strncpy function and its
size argument is the same as buffer size.  In such a case, strncpy()
can truncate the string without appending a terminating null byte.

As a result, accesses to the lld name in mtask_execute function, for
instance, strlen(req->lld) or eprintf("...%s\n", req->lld), can
overrun.

This patch fixes the issue by setting a terminating null byte at the
end of the lld name buffer before mtask_execute() uses it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/mgmt.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/usr/mgmt.c b/usr/mgmt.c
index e795555..1eae0c9 100644
--- a/usr/mgmt.c
+++ b/usr/mgmt.c
@@ -479,6 +479,8 @@ static tgtadm_err mtask_execute(struct mgmt_task *mtask)
 	int lld_no;
 	tgtadm_err adm_err = TGTADM_INVALID_REQUEST;
 
+	req->lld[TGT_LLD_NAME_LEN - 1] = '\0';
+
 	if (!strlen(req->lld))
 		lld_no = 0;
 	else {
-- 
1.7.9.3
