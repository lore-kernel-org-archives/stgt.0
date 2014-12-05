From: The Lee-Man <leeman.duncan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: new comer questions on tgt,lio-utils and iscsitarget
Date: Fri, 5 Dec 2014 12:20:50 -0800 (PST)
Message-ID: <e0bc09cd-af79-438b-bb78-69b0bc952139@googlegroups.com>
References: <1785a48b-abb3-4262-97ff-c7bf6951804a@googlegroups.com> <c16aa0b5-3c31-4287-a41c-436af3b54896@googlegroups.com>
 <54820A91.20105@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_1728_1436505390.1417810850593"
Return-path: <open-iscsi+bncBC755V5RXMKBBI5HRCSAKGQEZHZXQOQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlegroups.com; s=20120806;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-type:x-original-sender:reply-to:precedence
         :mailing-list:list-id:list-post:list-help:list-archive:sender
         :list-subscribe:list-unsubscribe;
        bh=g9wiV4eL5kTNNtMq3bBnPEsYoCmaQ4iQ5q5aYvtFVwo=;
        b=otL7+dLYbRrkccpiUsFQJrQFE9pI19fAy9Wett1sw6fqAY24zCVJm+om5GKdPN0UaU
         s4T3isSkVxLQ2cSROP14Ruknx6niRDI9ymWn93YFUL9we24eGV9i9I12CI/jmYDUPFcb
         +k0XY9yzmjJde0kDUCY9FN3m/IX0/toUqZfuZwJBtZFH7VJpCB8fl6Z/TEj45fNfiFEA
         9yQSXqQgtk0/09wKWxJxpYOU30/sUzoPDz6EwIdg3v7lpGq4WGA9J3BQQUCjKTPfNPO6
         XQvs0yNlzLvua2zZXJBYbo+BrUI7fcPKcxrMei0e9KJ6/57oBjrJL0Hp8frLLiDCWzMs
         ELPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-type:x-original-sender:reply-to:precedence
         :mailing-list:list-id:list-post:list-help:list-archive:sender
         :list-subscribe:list-unsubscribe;
        bh=g9wiV4eL5kTNNtMq3bBnPEsYoCmaQ4iQ5q5aYvtFVwo=;
        b=y0wRi0bK6sPMtpA4cEM3lvVzE05EwCjGxpZBomaTCOwmgYFICOiw4oKTAsdpxWzI04
         vjs+7SpdU2ktcCwn+637WQgSx+ThhXIqhi2T3eswZtviE+VQESrhRLD+khA9TGMglC1s
         0BY9EcrRuwLwYu8WAcNWhHE4iWulPRSXvkTx0BSFocWVhrmpOmh2OXcJ8HJuJd+trE0z
         gtwMPenQ01AvktGCiplJCe5Thri5EDAPixgvtYnRsSr73sSOWLV/Nn+DHMMqdn/KpzVD
         tTBZXwLC8skXQxdNdri8j+Xic09vy0x7vsrLfL4v/Tnf8UZPObwpS01UXFrk/gqATurW
         riyQ==
In-Reply-To: <54820A91.20105-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <stgt.vger.kernel.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: stgt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

------=_Part_1728_1436505390.1417810850593
Content-Type: multipart/alternative; 
	boundary="----=_Part_1729_1334930156.1417810850593"

------=_Part_1729_1334930156.1417810850593
Content-Type: text/plain; charset=UTF-8

On Friday, December 5, 2014 11:42:12 AM UTC-8, Andy Grover wrote:
>
> On 12/04/2014 01:13 PM, The Lee-Man wrote: 
> > On Tuesday, December 2, 2014 6:59:02 PM UTC-8, pilla...-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org 
> wrote: 
> >     1 \ both lio-utils and tgt are pure user space program? Both of them 
> >     are using the kernel iscsi module ? So ,what is the difference 
> >     between them? 
> > 
> > No, I believe the "tgt" (or stgt) package uses a user-space daemon, but 
> > it only handles administration of connections. The transport is handled 
> > by the kernel. See http://stgt.sourceforge.net 
>
> Actually the website is a little out of date. stgt moved to entirely 
> userspace, around 2011. 
>
> -- Andy 
>
>
Interesting. The version on SUSE still uses tgtd. :-/

I suppose I could update it, but I spend most of my time on 
lio-utils/targetcli/targte-isns these days. 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

------=_Part_1729_1334930156.1417810850593
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Friday, December 5, 2014 11:42:12 AM UTC-8, Andy Grover=
 wrote:<blockquote class=3D"gmail_quote" style=3D"margin: 0;margin-left: 0.=
8ex;border-left: 1px #ccc solid;padding-left: 1ex;">On 12/04/2014 01:13 PM,=
 The Lee-Man wrote:
<br>&gt; On Tuesday, December 2, 2014 6:59:02 PM UTC-8, <a>pilla...@gmail.c=
om</a> wrote:
<br>&gt; &nbsp; &nbsp; 1 \ both lio-utils and tgt are pure user space progr=
am? Both of them
<br>&gt; &nbsp; &nbsp; are using the kernel iscsi module ? So ,what is the =
difference
<br>&gt; &nbsp; &nbsp; between them?
<br>&gt;
<br>&gt; No, I believe the "tgt" (or stgt) package uses a user-space daemon=
, but
<br>&gt; it only handles administration of connections. The transport is ha=
ndled
<br>&gt; by the kernel. See <a href=3D"http://stgt.sourceforge.net" target=
=3D"_blank" onmousedown=3D"this.href=3D'http://www.google.com/url?q\75http%=
3A%2F%2Fstgt.sourceforge.net\46sa\75D\46sntz\0751\46usg\75AFQjCNGwLdczck0xk=
38Rz1D2T9Nw9HNEQQ';return true;" onclick=3D"this.href=3D'http://www.google.=
com/url?q\75http%3A%2F%2Fstgt.sourceforge.net\46sa\75D\46sntz\0751\46usg\75=
AFQjCNGwLdczck0xk38Rz1D2T9Nw9HNEQQ';return true;">http://stgt.sourceforge.n=
et</a>
<br>
<br>Actually the website is a little out of date. stgt moved to entirely=20
<br>userspace, around 2011.
<br>
<br>-- Andy
<br>
<br></blockquote><div><br></div><div>Interesting. The version on SUSE still=
 uses tgtd. :-/</div><div><br></div><div>I suppose I could update it, but I=
 spend most of my time on lio-utils/targetcli/targte-isns these days.&nbsp;=
</div></div>

<p></p>

-- <br />
You received this message because you are subscribed to the Google Groups &=
quot;open-iscsi&quot; group.<br />
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org">open-isc=
si+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
To post to this group, send email to <a href=3D"mailto:open-iscsi@googlegro=
ups.com">open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
Visit this group at <a href=3D"http://groups.google.com/group/open-iscsi">h=
ttp://groups.google.com/group/open-iscsi</a>.<br />
For more options, visit <a href=3D"https://groups.google.com/d/optout">http=
s://groups.google.com/d/optout</a>.<br />

------=_Part_1729_1334930156.1417810850593--

------=_Part_1728_1436505390.1417810850593--
