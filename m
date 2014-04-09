From: Steven Graf <sgraf@resolutech.net>
Subject: Problem with iSCSI over localhost
Date: Tue, 08 Apr 2014 23:19:03 -0400
Message-ID: <5344BC27.6080707@resolutech.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010005020309000903080502"
Return-path: <stgt-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=resolutech.net; h=
	message-id:date:from:mime-version:to:subject:content-type; s=
	mesmtp; bh=mKEhTW3mCOftzda9xH6LJK0k4eY=; b=j9YpgyUqN30nUbRm9Fuep
	JvgPK9TYPoMa815GDy7+J8dNpiHcPdj8qJtN3sfWuUMgoltl0FoWQejkW7ud9wCS
	C3uvuvsfe5WFyMJYiCuAOikItkdXN2f+hC2Da4952sr9WbpayQLRCgIqwPtUxmod
	gflQRkVtK7Bz3J1XJpNrtw=
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=message-id:date:from:mime-version:to
	:subject:content-type; s=smtpout; bh=mKEhTW3mCOftzda9xH6LJK0k4eY
	=; b=Dp9JUPk1WlNFJW/tJgHHJxtHYpWdeiRET2aGPE8saw89wN72H3atvBpMjkJ
	6I795mmNgRkb1UEEtACK2U3sJB5T5Qc9QB9Fyh4cVuzI/IpqTZRbjsGzQTJFCT0h
	a9wqQZElOqRcrxdJfyhm9bjAbt2Ndi8W0gzGCkfYNiMrfVDY=
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: stgt@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010005020309000903080502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello everyone,

I'm presently trying to get stgt (v1.0.46) and open-iscsi (v6.2.0-873)
to play nice together over localhost using an off port.  I have stgt
configured to bind to 127.0.0.1 on port 40960:

tcp        0      0 127.0.0.1:40960             0.0.0.0:*
    LISTEN      1700/tgtd

I can successfully connect with netcat to this IP and port, and I also
flushed the firewall rules for good measure.  Here is my target.conf:

[root@localhost developer]# cat /etc/tgt/conf.d/mytarget.conf
<target iqn.2014-04.woot.ventureindustries:san.target01>
backing-store /dev/sdb
</target>

When I use iscsiadm to list the targets I get the following:

[root@localhost developer]# iscsiadm --mode discovery -t sendtarget -p
127.0.0.1:40960
# BEGIN RECORD 6.2.0-873.10.el6
discovery.startup =3D manual
discovery.type =3D sendtargets
discovery.sendtargets.address =3D 127.0.0.1
discovery.sendtargets.port =3D 40960
discovery.sendtargets.auth.authmethod =3D None
discovery.sendtargets.auth.username =3D <empty>
discovery.sendtargets.auth.password =3D <empty>
discovery.sendtargets.auth.username_in =3D <empty>
discovery.sendtargets.auth.password_in =3D <empty>
discovery.sendtargets.timeo.login_timeout =3D 15
discovery.sendtargets.use_discoveryd =3D No
discovery.sendtargets.discoveryd_poll_inval =3D 30
discovery.sendtargets.reopen_max =3D 5
discovery.sendtargets.timeo.auth_timeout =3D 45
discovery.sendtargets.timeo.active_timeout =3D 30
discovery.sendtargets.iscsi.MaxRecvDataSegmentLength =3D 32768
# END RECORD

When I try to log into the target it fails.

iscsiadm --mode node --targetname
iqn.2014-04.woot.ventureindustries:san.target01 --login

Here are the messages I get from /var/log/messages:

Apr  8 19:54:56 localhost iscsid: cannot make a connection to
127.0.0.1:40960 (-1,13)
Apr  8 19:55:49 localhost iscsid: Connection-1:0 to [target:
iqn.2014-04.woot.ventureindustries:san.target01, portal:
127.0.0.1,40960] through [iface: default] is shutdown.

I also ran tcpdump -vvv -i lo and I see my netcat traffic, but I never
see anything when I kick this off.

Any ideas what may be going wrong here?

Thanks in advanced!

--=20
Steven Graf
President
Resolutech, LLC


--------------ms010005020309000903080502
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIKSzCC
BRowggQCoAMCAQICEG0Z6qcZT2ozIuYiMnqqcd4wDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNV
BAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3Qu
Y29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQg
RW1haWwwHhcNMTEwNDI4MDAwMDAwWhcNMjAwNTMwMTA0ODM4WjCBkzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENPTU9ETyBDbGllbnQgQXV0aGVudGlj
YXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAJKEhFtLV5jUXi+LpOFAyKNTWF9mZfEyTvefMn1V0HhMVbdClOD5J3EHxcZppLkyxPFA
GpDMJ1Zifxe1cWmu5SAb5MtjXmDKokH2auGj/7jfH0htZUOMKi4rYzh337EXrMLaggLW1DJq
1GdvIBOPXDX65VSAr9hxCh03CgJQU2yVHakQFLSZlVkSMf8JotJM3FLb3uJAAVtIaN3FSrTg
7SQfOq9xXwfjrL8UO7AlcWg99A/WF1hGFYE8aIuLgw9teiFX5jSw2zJ+40rhpVJyZCaRTqWS
D//gsWD9Gm9oUZljjRqLpcxCm5t9ImPTqaD8zp6Q30QZ9FxbNboW86eb/8ECAwEAAaOCAUsw
ggFHMB8GA1UdIwQYMBaAFImCZ33EnSZwAEu0UEh83j2uBG59MB0GA1UdDgQWBBR6E04AdFvG
eGNkJ8Ev4qBbvHnFezAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADARBgNV
HSAECjAIMAYGBFUdIAAwWAYDVR0fBFEwTzBNoEugSYZHaHR0cDovL2NybC51c2VydHJ1c3Qu
Y29tL1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmwwdAYI
KwYBBQUHAQEEaDBmMD0GCCsGAQUFBzAChjFodHRwOi8vY3J0LnVzZXJ0cnVzdC5jb20vVVRO
QWRkVHJ1c3RDbGllbnRfQ0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1
c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQCF1r54V1VtM39EUv5C1QaoAQOAivsNsv1Kv/av
QUn1G1rF0q0bc24+6SZ85kyYwTAo38v7QjyhJT4KddbQPTmGZtGhm7VNm2+vKGwdr+XqdFqo
2rHA8XV6L566k3nK/uKRHlZ0sviN0+BDchvtj/1gOSBH+4uvOmVIPJg9pSW/ve9g4EnlFsjr
P0OD8ODuDcHTzTNfm9C9YGqzO/761Mk6PB/tm/+bSTO+Qik5g+4zaS6CnUVNqGnagBsePdIa
XXxHmaWbCG0SmYbWXVcHG6cwvktJRLiQfsrReTjrtDP6oDpdJlieYVUYtCHVmdXgQ0BCML7q
peeU0rD+83X5f27nMIIFKTCCBBGgAwIBAgIQf4e4LraqByclcbQtwHo3lTANBgkqhkiG9w0B
AQUFADCBkzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENP
TU9ETyBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xMzA5
MjQwMDAwMDBaFw0xNDA5MjQyMzU5NTlaMCUxIzAhBgkqhkiG9w0BCQEWFHNncmFmQHJlc29s
dXRlY2gubmV0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvM3lav1SjW+kVClB
oBonrPDc4aH5wfb1KmuscRYRE+7tB7bU5PEwaMjlBDzFttP6OmD3IAoon8agv8YZc+maXMOw
q8D2JvUfNUMwfoE5q6q8XLsoFyEOuMRiTEDhVfhscdS8FZkVs0XCKjXObxUeHFaspifwX+yH
u5u5f5tBuCzOoxKzrP3nlaf3I7ycS7IW9q4dGVVgyIlqS/WyjIFXqK5duSZzwri1w+KCX2aa
65ijc0Ttkj26PR5j1wmGf78wo42TR8Kzelbyo1VOu1dnmdmTVwGKMKi/qrJUxqTv5I1DmJfG
16GWOblpLkApNvLXPW/QfJLq4ULwjSjdnb7AdQIDAQABo4IB5DCCAeAwHwYDVR0jBBgwFoAU
ehNOAHRbxnhjZCfBL+KgW7x5xXswHQYDVR0OBBYEFJyemVU1Hf2k2+uhQC0zEb+KmnBrMA4G
A1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMCAGA1UdJQQZMBcGCCsGAQUFBwMEBgsrBgEE
AbIxAQMFAjARBglghkgBhvhCAQEEBAMCBSAwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAQEw
KzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwVwYDVR0fBFAw
TjBMoEqgSIZGaHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RPQ2xpZW50QXV0aGVudGlj
YXRpb25hbmRTZWN1cmVFbWFpbENBLmNybDCBiAYIKwYBBQUHAQEEfDB6MFIGCCsGAQUFBzAC
hkZodHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9DT01PRE9DbGllbnRBdXRoZW50aWNhdGlvbmFu
ZFNlY3VyZUVtYWlsQ0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5j
b20wHwYDVR0RBBgwFoEUc2dyYWZAcmVzb2x1dGVjaC5uZXQwDQYJKoZIhvcNAQEFBQADggEB
AFeNDWERDQWpyKeRjC/PWOXvxTehUAOIjFtN8slcXxdspITrep67XpB5gDimZqi8RXatx45A
9hHUL9wEVx68qg/eeI1dRpq/2vFIL3EMYDcUG1fxvq8M45EgB76ynBSz/4O8l0Oty2QyLGL8
MCmGWbcrRZt9ixaI2hDwkLI/cqRTwPjIUAbpg5eZ95LCthRYdB8Haw4Vk7PtpO060cpr3rj/
l25pV4yTOZTNs1wmDK3tB4uloRh6w3ttC3RkCBVFUBdRSo6TbPamYwMtrJjENlu892Q8lSjz
vJuLra9xPnerLWCAA39O37KlFUT9K9Xt5EQKrUJsBBq5Un0eZK4xwVAxggQZMIIEFQIBATCB
qDCBkzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
BxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENPTU9E
TyBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIQf4e4LraqBycl
cbQtwHo3lTAJBgUrDgMCGgUAoIICRTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
SIb3DQEJBTEPFw0xNDA0MDkwMzE5MDNaMCMGCSqGSIb3DQEJBDEWBBS6XuKSiLvEGFTTbqRx
knSuRFLHEzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYI
KoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqG
SIb3DQMCAgEoMIG5BgkrBgEEAYI3EAQxgaswgagwgZMxCzAJBgNVBAYTAkdCMRswGQYDVQQI
ExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9E
TyBDQSBMaW1pdGVkMTkwNwYDVQQDEzBDT01PRE8gQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFu
ZCBTZWN1cmUgRW1haWwgQ0ECEH+HuC62qgcnJXG0LcB6N5UwgbsGCyqGSIb3DQEJEAILMYGr
oIGoMIGTMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE5MDcGA1UEAxMwQ09N
T0RPIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhB/h7gutqoH
JyVxtC3AejeVMA0GCSqGSIb3DQEBAQUABIIBAHuTe8pJAzj2j5JE2BGxdJr+Gn7KwUlrXO1b
UaKdXxaCoUplHbz9PcVLQkmmPIg2A56i80BlHL4TalegRBA2di/fiGr0INuoZhic/nR1XP1k
byE64en8AnCfwptmuQyBW5k7FuejfSsR05vLrtbzy6b3LLUknTygWHHnue5TbUAPXd0VuXo3
ebh8x4jBxWvJyCLHL0/wvX0mPcX5ulUE+v2k/w5Q3CUn6fJ3YvdUawijae9jN1+OHxAnrNjT
kIqvM/Y9L0S20+acRHy/m2F+tD62goiQJ9ZZyrzmSZsaRgEg7Bod2yQCNYDEV/kSazBxSvin
arq2RlmIIYtELEVjHWYAAAAAAAA=
--------------ms010005020309000903080502--
