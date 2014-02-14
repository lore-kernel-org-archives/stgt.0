From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v4 RFC 3/5] tgtd: add a new option "-T" for specifying a number of threads which send/recv iSCSI PDUs
Date: Fri, 14 Feb 2014 20:21:31 +0900
Message-ID: <1392376893-26106-4-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
References: <1392376893-26106-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1392376893-26106-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stgt@vger.kernel.org
Cc: mitake.hitoshi@gmail.com, Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>

Currently, nr_iothreads, specified with "-t" option, is used as a
number of worker threads per logical unit conventionally in some
backing store drivers.

This patch adds a new option "-T" to tgtd for specified a number of
threads which send/recv iSCSI PDUs. Because using the "-t" option for
this purpose would be introduce inconvenience of performance tuning.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 usr/iscsi/iscsi_tcp.c |    2 ++
 usr/tgtd.c            |   10 +++++++++-
 usr/tgtd.h            |    1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/usr/iscsi/iscsi_tcp.c b/usr/iscsi/iscsi_tcp.c
index 9a41466..d00265e 100644
--- a/usr/iscsi/iscsi_tcp.c
+++ b/usr/iscsi/iscsi_tcp.c
@@ -37,6 +37,8 @@
 #include "util.h"
 #include "work.h"
 
+int nr_tcp_iothreads = 1;
+
 static void iscsi_tcp_st_event_handler(int fd, int events, void *data);
 static void iscsi_tcp_release(struct iscsi_connection *conn);
 static struct iscsi_task *iscsi_tcp_alloc_task(struct iscsi_connection *conn,
diff --git a/usr/tgtd.c b/usr/tgtd.c
index 50e1c83..09c1442 100644
--- a/usr/tgtd.c
+++ b/usr/tgtd.c
@@ -55,13 +55,14 @@ static struct option const long_options[] = {
 	{"foreground", no_argument, 0, 'f'},
 	{"control-port", required_argument, 0, 'C'},
 	{"nr_iothreads", required_argument, 0, 't'},
+	{"nr_tcp_iothreads", required_argument, 0, 'T'},
 	{"debug", required_argument, 0, 'd'},
 	{"version", no_argument, 0, 'V'},
 	{"help", no_argument, 0, 'h'},
 	{0, 0, 0, 0},
 };
 
-static char *short_options = "fC:d:t:Vh";
+static char *short_options = "fC:d:t:VhT:";
 static char *spare_args;
 
 static void usage(int status)
@@ -77,6 +78,8 @@ static void usage(int status)
 		"-f, --foreground        make the program run in the foreground\n"
 		"-C, --control-port NNNN use port NNNN for the mgmt channel\n"
 		"-t, --nr_iothreads NNNN specify the number of I/O threads\n"
+		"-T, --nr_tcp_iothreads NNNN specify the number of I/O threads"
+		" for send/recv iSCSI PDU\n"
 		"-d, --debug debuglevel  print debugging information\n"
 		"-V, --version           print version and exit\n"
 		"-h, --help              display this help and exit\n",
@@ -546,6 +549,11 @@ int main(int argc, char **argv)
 			if (ret)
 				bad_optarg(ret, ch, optarg);
 			break;
+		case 'T':
+			ret = str_to_int_gt(optarg, nr_tcp_iothreads, 0);
+			if (ret)
+				bad_optarg(ret, ch, optarg);
+			break;
 		case 'd':
 			ret = str_to_int_range(optarg, is_debug, 0, 1);
 			if (ret)
diff --git a/usr/tgtd.h b/usr/tgtd.h
index 8a25521..a708f13 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -257,6 +257,7 @@ enum mgmt_req_result {
 extern int system_active;
 extern int is_debug;
 extern int nr_iothreads;
+extern int nr_tcp_iothreads;
 extern struct list_head bst_list;
 
 extern int ipc_init(void);
-- 
1.7.10.4
