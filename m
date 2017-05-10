From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] use-after-free while iterating session->conn_list (two
 places)
Date: Wed, 10 May 2017 10:34:55 +0900 (JST)
Message-ID: <20170510.103455.1306558653114725733.tomof@acm.org>
References: <1493829345850.48512@acronis.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <1493829345850.48512@acronis.com>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Anton.Kovalenko@acronis.com
Cc: stgt@vger.kernel.org

On Wed, 3 May 2017 16:35:45 +0000
Anton Kovalenko <Anton.Kovalenko@acronis.com> wrote:

> The problem (accessing session->conn_list after freeing session) was discovered using valgrind.
> 
> Note that while list_for_each_entry_safe is safe against current list element destruction, 
> it is UNSAFE against the traversed list_head (third argument) becoming invalid during iteration.
> That's exactly what happens when the last connection of a session goes away (conn_exit -> session_put -> use-after-free).

Great catch, applied both. Any other places like this?

Thanks a lot!
