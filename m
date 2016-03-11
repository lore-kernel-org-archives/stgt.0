From: Chris Friesen <chris.friesen@windriver.com>
Subject: race condition in tgt-admin ?
Date: Fri, 11 Mar 2016 11:05:39 -0600
Message-ID: <56E2FAE3.6010409@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org

Hi,

We're running tgt-1.0.55 and have run into an interesting problem.
Under heavy load we seem to be hitting a race in tgt-admin where it
ends up using the same "--tid" value for multiple volumes.

This seems to cause an error, "Could not create target because it already exists for volume: volume-65324c83-b534-4c81-aecc-07a7f18de92f".

Does anyone know if this issue has been resolved in more recent versions?

Thanks,
Chris
