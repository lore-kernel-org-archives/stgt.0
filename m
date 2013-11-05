From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] tgtadm: add missing outgoing option to the help of unbind operation
Date: Wed,  6 Nov 2013 02:59:19 +0900
Message-ID: <1383674359-11389-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

The help message of bind operation explains that --outgoing option is
used for an outgoing account:

--lld <driver> --mode account --op bind --tid <id> --user <name> [--outgoing]
      add the specific account having <name> to
      the specific target with <id>.
      <user> could be <IncomingUser> or <OutgoingUser>.
      If you use --outgoing option, the account will
      be added as an outgoing account.

However, the help message of unbind operation lacks the --outgoing
option even though it is mandatory to delete outgoing account:

--lld <driver> --mode account --op unbind --tid <id> --user <name>
      delete the specific account having <name> from specific
      target.

Thus, users will see the following error since they don't know the
--outgoing option is needed:

  "tgtadm: can't find the account"

This fixes the issue by adding description of the outgoing option also
to the help message of unbind operation.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 usr/tgtadm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/usr/tgtadm.c b/usr/tgtadm.c
index 91e46c9..a46f1a4 100644
--- a/usr/tgtadm.c
+++ b/usr/tgtadm.c
@@ -184,9 +184,10 @@ static void usage(int status)
 		"\t<user> could be <IncomingUser> or <OutgoingUser>.\n"
 		"\tIf you use --outgoing option, the account will\n"
 		"\tbe added as an outgoing account.\n"
-		"--lld <driver> --mode account --op unbind --tid <id> --user <name>\n"
+		"--lld <driver> --mode account --op unbind --tid <id> --user <name> [--outgoing]\n"
 		"\tdelete the specific account having <name> from specific\n"
-		"\ttarget.\n"
+		"\ttarget. The --outgoing option must be added if you\n"
+		"\tdelete an outgoing account.\n"
 		"--lld <driver> --mode lld --op start\n"
 		"\tStart the specified lld without restarting the tgtd process.\n"
 		"--control-port <port> use control port <port>\n"
-- 
1.7.9.3
