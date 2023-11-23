Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7CD4412
	for <stgt@vger.kernel.org>; Thu, 23 Nov 2023 02:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZqyPBrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29376C433C8;
	Thu, 23 Nov 2023 02:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700707957;
	bh=rRbIXqjq8DKBA6vW+7glleky65j8TQodsqrm6IeWtY0=;
	h=Date:From:To:Subject:From;
	b=NZqyPBrkENqBt/gF6xrkJ7VrNseIFWU/gBzZmU0ii5IAFVw11TMZ8fKNhFcARHqvk
	 jiVLWRx6rMvNVXwHOoe2Ll3Y5mtmi4zYNtZ9eUHQBOIW1z1feJrwGAwTcIZWbnVnQ3
	 iiJPPRl0fX8otKsZZ+XmOOqo/185aHitLv92CM24=
Date: Wed, 22 Nov 2023 21:52:36 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: stgt@vger.kernel.org
Subject: PSA: this list has moved to new vger infra (no action required)
Message-ID: <20231122-inquisitive-translucent-rat-b7aebd@nitro>
Precedence: bulk
X-Mailing-List: stgt@vger.kernel.org
List-Id: <stgt.vger.kernel.org>
List-Subscribe: <mailto:stgt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:stgt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello, all:

This list has been migrated to the new vger infrastructure. No action is
required on your part and there should be no change in how you interact with
this list.

This message acts as a verification test that the archives are properly
updating.

If something isn't working or looking right, please reach out to
helpdesk@kernel.org.

Best regards,
-K
