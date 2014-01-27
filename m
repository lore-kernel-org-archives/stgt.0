From: Artyom Pervukhin <artyom@evasive.ru>
Subject: Re: tgtadm/tgtd management issue: buffer size truncated sometimes
Date: Mon, 27 Jan 2014 20:12:20 +0400
Message-ID: <9EDAF161-8C9B-4B6A-BA04-2B93772A7991@evasive.ru>
References: <52A65E29-5717-4DEA-BDD4-CB9700D218E0@evasive.ru> <20140124.192139.1568838937885768572.fujita.tomonori@lab.ntt.co.jp> <C6A6622D-F621-4889-AE5C-A7F603B84105@evasive.ru> <20140128.004219.1568838937885776146.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20140128.004219.1568838937885776146.fujita.tomonori@lab.ntt.co.jp>
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org


On 27 Jan 2014, at 19:42, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.j=
p> wrote:

> Hi,
>=20
> On Mon, 27 Jan 2014 18:44:42 +0400
> Artyom Pervukhin <artyom@evasive.ru> wrote:
>=20
>> I've done some additional stracing on the tgtd's side this time, ple=
ase see below:
>>=20
>> Testing 300 targets:
>>=20
>> command:
>>=20
>> root@sandbox:~ # tgtadm -C 0 --op show --mode target
>>=20
>> (command shows full output)
>>=20
>> tgtd writes:
>>=20
>> write(10, "\0\0\0\0\305\325\4\0", 8)    =3D 8
>> write(10, "Target 1: iqn.2014-01:d1\n    Sys"..., 316861) =3D 224000
>> write(10, "       State: ready\n    I_T nexu"..., 92861) =3D 92861
>>=20
>> command:
>>=20
>> root@sandbox:~ # tgtadm -C 0 --op show --mode target | wc -c        =
                                                                       =
                                =20
>> 316860
>>=20
>> tgtd writes stays the same as above.
>>=20
>>=20
>>=20
>> Testing 900 targets:
>>=20
>> root@sandbox:~ # tgtadm -C 0 --op show --mode target
>>=20
>> (command shows incomplete output)
>>=20
>> tgtd writes:
>>=20
>> write(10, "\0\0\0\0u\205\16\0", 8)      =3D 8
>> write(10, "Target 1: iqn.2014-01:d1\n    Sys"..., 951661) =3D 256000
>> write(10, "a: No\n            Prevent remova"..., 695661) =3D 176000
>> write(10, " Removable media: No\n           "..., 519661) =3D 176000
>> write(10, "T nexus information:\n    LUN inf"..., 343661) =3D 176000
>> write(10, "  Backing store path: None\n     "..., 167661) =3D 167661
>>=20
>> command:
>>=20
>> root@sandbox:~ # tgtadm -C 0 --op show --mode target | wc -c        =
                                                                       =
                                =20
>> 929621
>>=20
>> tgtd writes:
>>=20
>> write(10, "\0\0\0\0u\205\16\0", 8)      =3D 8
>> write(10, "Target 1: iqn.2014-01:d1\n    Sys"..., 951661) =3D 944000
>> write(10, "t removal: No\n            Readon"..., 7661) =3D -1 EPIPE=
 (Broken pipe)
>> --- SIGPIPE (Broken pipe) @ 0 (0) ---
>>=20
>>=20
>>=20
>> Seeing this, I assumed the bug is on tgtadm's side.
>=20
> Thanks a lot for the investigation. The following fixes the problem?
>=20
> Note that tgtd uses a stream to store what tgtd sends to tgtadm. The
> buffer of the stream is managed glibc (internally allocated via
> malloc). That's a limit about how many targets you can see via tgtadm=
=2E
>=20
>=20
> diff --git a/usr/tgtadm.c b/usr/tgtadm.c
> index cc63fbf..8e0d5dd 100644
> --- a/usr/tgtadm.c
> +++ b/usr/tgtadm.c
> @@ -234,7 +234,8 @@ static int ipc_mgmt_connect(int *fd)
> static int ipc_mgmt_rsp(int fd, struct tgtadm_req *req)
> {
> 	struct tgtadm_rsp rsp;
> -	int err, rest, len;
> +	int err, len, done;
> +	char *buf;
>=20
> retry:
> 	err =3D recv(fd, &rsp, sizeof(rsp), MSG_WAITALL);
> @@ -278,23 +279,28 @@ retry:
> 		}
> 	}
>=20
> -	rest =3D rsp.len - sizeof(rsp);
> -	if (!rest)
> +	len =3D rsp.len - sizeof(rsp);
> +	if (!len)
> 		return 0;
>=20
> -	while (rest) {
> -		char buf[BUFSIZE];
> -		memset(buf, 0, sizeof(buf));
> -		len =3D min_t(int, sizeof(buf) - 1, rest);
> -		err =3D read(fd, buf, len);
> -		if (err <=3D 0) {
> -			eprintf("\ncan't get the full response, %m\n");
> -			return errno;
> +	buf =3D malloc(len);
> +	done =3D 0;
> +	while (len > done) {
> +		int ret;
> +		ret =3D read(fd, buf + done, len - done);
> +		if (ret < 0) {
> +			if (errno =3D=3D EAGAIN)
> +				continue;
> +			fprintf(stderr, "failed to read from tgtd, %d", errno);
> +			break;
> 		}
> -		fputs(buf, stdout);
> -		rest -=3D len;
> +		done +=3D ret;
> 	}
>=20
> +	if (done =3D=3D len)
> +		fputs(buf, stdout);
> +	free(buf);
> +
> 	return 0;
> }
>=20

I=92ve just applied this patch and the problem is gone: all tests I=92v=
e used before are passing.

Thanks a lot!