From: Roi Dayan <roid@mellanox.com>
Subject: [PATCH] Fix tgtd.spec to build on SLES
Date: Fri,  2 May 2014 10:13:00 +0300
Message-ID: <1399014780-12052-1-git-send-email-roid@mellanox.com>
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fujita.tomonori@lab.ntt.co.jp
Cc: stgt@vger.kernel.org, Roi Dayan <roid@mellanox.com>

The docbook package name is different between RedHat and SLES.

Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 scripts/tgtd.spec |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/tgtd.spec b/scripts/tgtd.spec
index 19873e4..e0e38db 100644
--- a/scripts/tgtd.spec
+++ b/scripts/tgtd.spec
@@ -8,10 +8,12 @@ License:        GPLv2
 URL:            http://stgt.sourceforge.net/
 Source0:        %{name}-%{version}-%{release}.tgz
 BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
-BuildRequires:  pkgconfig libibverbs-devel librdmacm-devel libxslt docbook-style-xsl libaio-devel
+BuildRequires:  pkgconfig libibverbs-devel librdmacm-devel libxslt libaio-devel
 %if %{defined suse_version}
+BuildRequires:  docbook-xsl-stylesheets
 Requires: aaa_base
 %else
+BuildRequires:  docbook-style-xsl
 Requires(post): chkconfig
 Requires(preun): chkconfig
 Requires(preun): initscripts
-- 
1.7.8.2
