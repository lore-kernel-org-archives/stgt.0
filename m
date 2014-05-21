From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] systemd notification support
Date: Wed, 21 May 2014 14:00:58 -0700
Message-ID: <537D140A.3000705@redhat.com>
References: <1400640207-2743-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090407080109030409090105"
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1400640207-2743-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stgt@vger.kernel.org
Cc: Apollon Oikonomopoulos <apoikos@debian.org>

This is a multi-part message in MIME format.
--------------090407080109030409090105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/20/2014 07:43 PM, FUJITA Tomonori wrote:
> From: Apollon Oikonomopoulos <apoikos@debian.org>
>
> tgtd may take some time to initialize before accepting management
> commands. Since management commands are used to bring the targets up
> during service startup, we have to make sure that tgtd is responsive
> before proceeding. To this end, we add a call to sd_notify(3) right
> before entering the event loop to signal systemd (if applicable) that
> the main process is ready.
>
> Systemd support with the relevant includes and linker flags is optional,
> controlled by the SD_NOTIFY make flag.
>
> Signed-off-by: Apollon Oikonomopoulos <apoikos@debian.org>

Hi Apollon,

Fedora tgtd pkg maintainer here.

Better systemd integration seems like a good way to go. BTW I feel deep 
shame about the systemd service file that Fedora is currently using 
(attached), especially the sleep. Does this or another change perhaps 
result in a better way to integrate tgt with systemd?

Do we need two service files or something?

It would be great if tgt could use the same service file(s) on all 
systemd-enabled distros, and these could be included with tgtd.

Regards -- Andy


--------------090407080109030409090105
Content-Type: text/plain; charset=UTF-8;
 name="tgtd.service"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tgtd.service"

[Unit]
Description=tgtd iSCSI target daemon
After=network.target

[Service]
EnvironmentFile=/etc/sysconfig/tgtd

ExecStart=/usr/sbin/tgtd -f $TGTD_OPTS
# see bz 848942. workaround for a race for now.
ExecStartPost=/bin/sleep 5
# Put tgtd into "offline" state until all the targets are configured.
# We don't want initiators to (re)connect and fail the connection
# if it's not ready.
ExecStartPost=/usr/sbin/tgtadm --op update --mode sys --name State -v offline
# Configure the targets.
ExecStartPost=/usr/sbin/tgt-admin -e -c $TGTD_CONFIG
# Put tgtd into "ready" state.
ExecStartPost=/usr/sbin/tgtadm --op update --mode sys --name State -v ready

# Update configuration for targets. Only targets which
# are not in use will be updated.
ExecReload=/usr/sbin/tgt-admin --update ALL -c $TGTD_CONFIG

# NOTE: Shutdown of the iscsi target may cause data corruption
# for initiators that are connected.
ExecStop=/usr/sbin/tgtadm --op update --mode sys --name State -v offline
# Remove all targets. It only removes targets which are not in use.
ExecStop=/usr/sbin/tgt-admin --update ALL -c /dev/null
# tgtd will exit if all targets were removed
ExecStop=/usr/sbin/tgtadm --op delete --mode system

[Install]
WantedBy=multi-user.target

--------------090407080109030409090105--
