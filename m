From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: ISER - tgtadm: Can't find the driver
Date: Fri, 6 Dec 2013 10:02:32 +0200
Message-ID: <52A18498.2040000@mellanox.com>
References: <697D97E420EE024FB7451B574CD4991BCA072B25@NTXBOIMBX05.micron.com> <CAJZOPZ+b4Fs_krnjb-ObWcXuw5ULa=9DukV4CZ4wRvNzi7tOGg@mail.gmail.com> <697D97E420EE024FB7451B574CD4991BCA072B74@NTXBOIMBX05.micron.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <697D97E420EE024FB7451B574CD4991BCA072B74@NTXBOIMBX05.micron.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Moussa Ba (moussaba)" <moussaba@micron.com>, Or Gerlitz <or.gerlitz@gmail.com>
Cc: "stgt@vger.kernel.org" <stgt@vger.kernel.org>, Shlomi Sasson <shlomis@mellanox.com>

On 06/12/2013 00:43, Moussa Ba (moussaba) wrote:
> Thank you. Loading rdma_ucm resolved the issue. Do you think this information should be included the README.iser?  It is already mentioned that Kernel modules should be loaded but which ones is not specified.  Thank you.

the readme does say:

"When using iser, you need to make sure the kernel IB/RDMA stack
is up and running.

It's recommended to use the rping tool provided by librdmacm-utils
for quick RDMA connectivity testing between the initiator and the
target nodes."

so you want a bit more...

