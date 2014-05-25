From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH 2/2] iser: add portals support
Date: Sun, 25 May 2014 14:10:26 +0300
Message-ID: <1401016226-3404-3-git-send-email-roid@mellanox.com>
References: <1401016226-3404-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1401016226-3404-1-git-send-email-roid@mellanox.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

This adds IPv6 support for iser.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 usr/iscsi/iser.c |  110 ++++++++++++++++++++++++++++++++++++++++++------------
 usr/iscsi/iser.h |    8 ++++
 2 files changed, 94 insertions(+), 24 deletions(-)

diff --git a/usr/iscsi/iser.c b/usr/iscsi/iser.c
index 35c6faa..ace8da3 100644
--- a/usr/iscsi/iser.c
+++ b/usr/iscsi/iser.c
@@ -51,7 +51,8 @@ static struct iscsi_transport iscsi_iser;
 
 /* global, across all devices */
 static struct rdma_event_channel *rdma_evt_channel;
-static struct rdma_cm_id *cma_listen_id;
+
+LIST_HEAD(iser_portals_list);
 
 /* accepted at RDMA layer, but not yet established */
 static LIST_HEAD(temp_conn);
@@ -3338,19 +3339,31 @@ static void iser_device_release(struct iser_device *dev)
 		eprintf("ibv_dealloc_pd failed: (errno=%d %m)\n", errno);
 }
 
-/*
- * Init entire iscsi transport.  Begin listening for connections.
- */
-static int iser_ib_init(void)
+static int iser_add_portal(struct addrinfo *res, short int port)
 {
 	int err;
-	struct sockaddr_in sock_addr;
-	short int port = iser_listen_port;
+	int afonly = 1;
+	struct sockaddr_storage sock_addr;
+	struct rdma_cm_id *cma_listen_id;
+	struct iser_portal *portal = NULL;
 
-	rdma_evt_channel = rdma_create_event_channel();
-	if (!rdma_evt_channel) {
-		eprintf("Failed to initialize RDMA; load kernel modules?\n");
-		return -1;
+	portal = zalloc(sizeof(struct iser_portal));
+	if (!portal) {
+	    eprintf("zalloc failed.\n");
+	    return -1;
+	}
+	portal->af = res->ai_family;
+	portal->port = port;
+
+	memset(&sock_addr, 0, sizeof(sock_addr));
+	if (res->ai_family == AF_INET6) {
+		((struct sockaddr_in6 *) &sock_addr)->sin6_family = AF_INET6;
+		((struct sockaddr_in6 *) &sock_addr)->sin6_port = htons(port);
+		((struct sockaddr_in6 *) &sock_addr)->sin6_addr = in6addr_any;
+	} else {
+		((struct sockaddr_in *) &sock_addr)->sin_family = AF_INET;
+		((struct sockaddr_in *) &sock_addr)->sin_port = htons(port);
+		((struct sockaddr_in *) &sock_addr)->sin_addr.s_addr = INADDR_ANY;
 	}
 
 	err = rdma_create_id(rdma_evt_channel, &cma_listen_id, NULL,
@@ -3359,11 +3372,11 @@ static int iser_ib_init(void)
 		eprintf("rdma_create_id failed, %m\n");
 		return -1;
 	}
+	portal->cma_listen_id = cma_listen_id;
+
+	rdma_set_option(cma_listen_id, RDMA_OPTION_ID,
+			RDMA_OPTION_ID_AFONLY, &afonly, sizeof(afonly));
 
-	memset(&sock_addr, 0, sizeof(sock_addr));
-	sock_addr.sin_family = AF_INET;
-	sock_addr.sin_port = htons(port);
-	sock_addr.sin_addr.s_addr = INADDR_ANY;
 	err =
 	    rdma_bind_addr(cma_listen_id, (struct sockaddr *) &sock_addr);
 	if (err) {
@@ -3384,8 +3397,47 @@ static int iser_ib_init(void)
 		return -1;
 	}
 
+        list_add(&portal->iser_portal_siblings, &iser_portals_list);
+	return err;
+}
+
+/*
+ * Init entire iscsi transport.  Begin listening for connections.
+ */
+static int iser_ib_init(void)
+{
+	int err;
+	short int port = iser_listen_port;
+	struct addrinfo hints, *res, *res0;
+	char servname[64];
+
+	rdma_evt_channel = rdma_create_event_channel();
+	if (!rdma_evt_channel) {
+		eprintf("Failed to initialize RDMA; load kernel modules?\n");
+		return -1;
+	}
+
+	memset(servname, 0, sizeof(servname));
+	snprintf(servname, sizeof(servname), "%d", port);
+
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_socktype = SOCK_STREAM;
+	hints.ai_flags = AI_PASSIVE;
+
+	err = getaddrinfo(NULL, servname, &hints, &res0);
+	if (err) {
+		eprintf("unable to get address info, %m\n");
+		return -errno;
+	}
+
+	for (res = res0; res; res = res->ai_next) {
+		err = iser_add_portal(res, port);
+		if (err)
+		    return err;
+	}
+
 	dprintf("listening for iser connections on port %d\n", port);
-	err = tgt_event_add(cma_listen_id->channel->fd, EPOLLIN,
+	err = tgt_event_add(rdma_evt_channel->fd, EPOLLIN,
 			    iser_handle_rdmacm, NULL);
 	if (err)
 		return err;
@@ -3393,9 +3445,23 @@ static int iser_ib_init(void)
 	return err;
 }
 
-static void iser_ib_release(void)
+void iser_delete_portals(void)
 {
 	int err;
+	struct iser_portal *portal, *ptmp;
+
+	list_for_each_entry_safe(portal, ptmp, &iser_portals_list,
+				 iser_portal_siblings) {
+		err = rdma_destroy_id(portal->cma_listen_id);
+		if (err)
+			eprintf("rdma_destroy_id failed: (errno=%d %m)\n", errno);
+		list_del(&portal->iser_portal_siblings);
+		free(portal);
+	}
+}
+
+static void iser_ib_release(void)
+{
 	struct iser_device *dev, *tdev;
 
 	assert(list_empty(&iser_conn_list));
@@ -3405,13 +3471,9 @@ static void iser_ib_release(void)
 		free(dev);
 	}
 
-	if (cma_listen_id) {
-		tgt_event_del(cma_listen_id->channel->fd);
-
-		err = rdma_destroy_id(cma_listen_id);
-		if (err)
-			eprintf("rdma_destroy_id failed: (errno=%d %m)\n", errno);
-
+	if (!list_empty(&iser_portals_list)) {
+		tgt_event_del(rdma_evt_channel->fd);
+		iser_delete_portals();
 		rdma_destroy_event_channel(rdma_evt_channel);
 	}
 }
diff --git a/usr/iscsi/iser.h b/usr/iscsi/iser.h
index 48d0a8c..5f1fb69 100644
--- a/usr/iscsi/iser.h
+++ b/usr/iscsi/iser.h
@@ -30,6 +30,14 @@
 
 extern short control_port;
 
+struct iser_portal {
+	struct list_head iser_portal_siblings;
+	int port;
+	int af;
+	struct rdma_cm_id *cma_listen_id;
+};
+
+
 /*
  * The IB-extended version from the kernel.  Stags and VAs are in
  * big-endian format.
-- 
1.7.1
