
# Ra

![[attachments/Pasted image 20240613140545.png]]


**Story**

You have gained access to the internal network of WindCorp, the multibillion dollar company, running an extensive social media campaign claiming to be unhackable (ha! so much for that claim!).

Next step would be to take their crown jewels and get full access to their internal network. You have spotted a new windows machine that may lead you to your end goal. Can you conquer this end boss and own their internal network?

Happy Hacking! 

@4nqr34z and @theart42

(Give it at least 5 minutes to boot)

---

Nmap scan

```shell
# Nmap 7.94SVN scan initiated Thu Jun 13 13:47:34 2024 as: nmap -sCV -p- --min-rate=1000 -T4 -oN scan -vv 10.10.32.159
Nmap scan report for 10.10.32.159
Host is up, received echo-reply ttl 127 (0.21s latency).
Scanned at 2024-06-13 13:47:34 WAT for 315s
Not shown: 65500 filtered tcp ports (no-response)
PORT      STATE SERVICE             REASON          VERSION
53/tcp    open  domain              syn-ack ttl 127 Simple DNS Plus
80/tcp    open  http                syn-ack ttl 127 Microsoft IIS httpd 10.0
| http-methods: 
|   Supported Methods: OPTIONS TRACE GET HEAD POST
|_  Potentially risky methods: TRACE
|_http-title: Windcorp.
|_http-server-header: Microsoft-IIS/10.0
88/tcp    open  kerberos-sec        syn-ack ttl 127 Microsoft Windows Kerberos (server time: 2024-06-13 12:50:50Z)
135/tcp   open  msrpc               syn-ack ttl 127 Microsoft Windows RPC
139/tcp   open  netbios-ssn         syn-ack ttl 127 Microsoft Windows netbios-ssn
389/tcp   open  ldap                syn-ack ttl 127 Microsoft Windows Active Directory LDAP (Domain: windcorp.thm0., Site: Default-First-Site-Name)
445/tcp   open  microsoft-ds?       syn-ack ttl 127
464/tcp   open  kpasswd5?           syn-ack ttl 127
593/tcp   open  ncacn_http          syn-ack ttl 127 Microsoft Windows RPC over HTTP 1.0
636/tcp   open  ldapssl?            syn-ack ttl 127
2179/tcp  open  vmrdp?              syn-ack ttl 127
3268/tcp  open  ldap                syn-ack ttl 127 Microsoft Windows Active Directory LDAP (Domain: windcorp.thm0., Site: Default-First-Site-Name)
3269/tcp  open  globalcatLDAPssl?   syn-ack ttl 127
3389/tcp  open  ms-wbt-server       syn-ack ttl 127 Microsoft Terminal Services
| rdp-ntlm-info: 
|   Target_Name: WINDCORP
|   NetBIOS_Domain_Name: WINDCORP
|   NetBIOS_Computer_Name: FIRE
|   DNS_Domain_Name: windcorp.thm
|   DNS_Computer_Name: Fire.windcorp.thm
|   DNS_Tree_Name: windcorp.thm
|   Product_Version: 10.0.17763
|_  System_Time: 2024-06-13T12:52:00+00:00
|_ssl-date: 2024-06-13T12:52:38+00:00; 0s from scanner time.
| ssl-cert: Subject: commonName=Fire.windcorp.thm
| Issuer: commonName=Fire.windcorp.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2024-06-12T12:45:59
| Not valid after:  2024-12-12T12:45:59
| MD5:   20d3:7cfb:c26c:aca2:f7d4:aa3d:88fd:dcd1
| SHA-1: c39d:8f17:f22a:9065:265d:f38d:33f0:cdc6:271b:840f
| -----BEGIN CERTIFICATE-----
| MIIC5jCCAc6gAwIBAgIQQwLF9cX/8IpIJtZbk1pTiDANBgkqhkiG9w0BAQsFADAc
| MRowGAYDVQQDExFGaXJlLndpbmRjb3JwLnRobTAeFw0yNDA2MTIxMjQ1NTlaFw0y
| NDEyMTIxMjQ1NTlaMBwxGjAYBgNVBAMTEUZpcmUud2luZGNvcnAudGhtMIIBIjAN
| BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsJ75ZDywzugXP1CNG/aEOEM1Y+WQ
| /2nTaHHQjVv3G703ALjVfVWSgHjvYvD/t3ktWcGLsJoS9Qd7mTiPxV8mA7U6ncoI
| UH2brRdPUdZ4XoTIk44HawLt5MoPI22OapKlUpxwan4CqtBKCw7Kwhlxn2y9BaOf
| bT1heG5P8X1cAR4tgV2ZBNUMa6nlqYymWi+Fu322MQIBVV7GRFv0KzlFcc2fihpS
| HWDM/oe1aZFV5EkBef60mSVmpJBC+8JYj5gnrAscT1mnfYakX9HqjBMLYUoyQbar
| 9MlXzSX4v/nHbKaRTdIWltCQcZqIFOJDDgIjBxlE4Ew/7HwzmM64JLjRQQIDAQAB
| oyQwIjATBgNVHSUEDDAKBggrBgEFBQcDATALBgNVHQ8EBAMCBDAwDQYJKoZIhvcN
| AQELBQADggEBAEtVK7YTAjFXLvJgUb5QEe97EVxgK9nbBTVYkwA8jpeN141fxlQN
| 42zOog9UUnqSmreA/QT0a7azZ+O4E2UFO50GwZ9bb3x5auudA0+E3EQCq5uQY7KU
| i97q+rNIjg5iM3DP7MVPkkTN7ubQRx3LP1fQJ4Bp9F9v6EMV6xgv6hBSt/jvjlLO
| Y8EyugVGJSsRVRSq3IBLGh/+uJhbmSKEOm1Hk/iWS6ujXyJjmh3y3UGbPLE/bRpd
| k9Jt+lleLCqL/Y0HeFUJxdRlOcJGoX5EuYWLiZ/od8em2ZEulxOa5sUffCrYSSpA
| jH/JAfXE2yWgCT5PdEVa3iWanFs+bJEckIM=
|_-----END CERTIFICATE-----
5222/tcp  open  jabber              syn-ack ttl 127
| ssl-cert: Subject: commonName=fire.windcorp.thm
| Subject Alternative Name: DNS:fire.windcorp.thm, DNS:*.fire.windcorp.thm
| Issuer: commonName=fire.windcorp.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2020-05-01T08:39:00
| Not valid after:  2025-04-30T08:39:00
| MD5:   b715:5425:83f3:a20f:75c8:ca2d:3353:cbb7
| SHA-1: 97f7:0772:a26b:e324:7ed5:bbcb:5f35:7d74:7982:66ae
| -----BEGIN CERTIFICATE-----
| MIIDLzCCAhegAwIBAgIIXUFELG7QgAIwDQYJKoZIhvcNAQELBQAwHDEaMBgGA1UE
| AwwRZmlyZS53aW5kY29ycC50aG0wHhcNMjAwNTAxMDgzOTAwWhcNMjUwNDMwMDgz
| OTAwWjAcMRowGAYDVQQDDBFmaXJlLndpbmRjb3JwLnRobTCCASIwDQYJKoZIhvcN
| AQEBBQADggEPADCCAQoCggEBAKLH0/j17RVdD8eXC+0IFovAoql2REjOSf2NpJLK
| /6fgtx3CA4ftLsj7yOpmj8Oe1gqfWd2EM/zKk+ZmZwQFxLQL93t1OD/za1gyclxr
| IVbPVWqFoM2BUU9O3yU0VVRGP7xKDHm4bcoNmq9UNurEtFlCNeCC1fcwzfYvKD89
| X04Rv/6kn1GlQq/iM8PGCLDUf1p1WJcwGT5FUiBa9boTU9llBcGqbodZaBKzPPP8
| DmvSYF71IKBT8NsVzqiAiO3t/oHgApvUd9BqdbZeN46XORrOhBQV0xUpNVy9L5OE
| UAD1so3ePTNjpPE5SfTKymT1a8Fiw5kroKODN0nzy50yP3UCAwEAAaN1MHMwMQYD
| VR0RBCowKIIRZmlyZS53aW5kY29ycC50aG2CEyouZmlyZS53aW5kY29ycC50aG0w
| HQYDVR0OBBYEFOtMzqgfsY11qewZNfPjiLxnGykGMB8GA1UdIwQYMBaAFOtMzqgf
| sY11qewZNfPjiLxnGykGMA0GCSqGSIb3DQEBCwUAA4IBAQAHofv0VP+hE+5sg0KR
| 2x0Xeg4cIXEia0c5cIJ7K7bhfoLOcT7WcMKCLIN3A416PREdkB6Q610uDs8RpezJ
| II/wBoIp2G0Y87X3Xo5FmNJjl9lGX5fvayen98khPXvZkurHdWdtA4m8pHOdYOrk
| n8Jth6L/y4L5WlgEGL0x0HK4yvd3iz0VNrc810HugpyfVWeasChhZjgAYXUVlA8k
| +QxLxyNr/PBfRumQGzw2n3msXxwfHVzaHphy56ph85PcRS35iNqgrtK0fe3Qhpq7
| v5vQYKlOGq5FI6Mf9ni7S1pXSqF4U9wuqZy4q4tXWAVootmJv1DIgfSMLvXplN9T
| LucP
|_-----END CERTIFICATE-----
| fingerprint-strings: 
|   RPCCheck: 
|_    <stream:error xmlns:stream="http://etherx.jabber.org/streams"><not-well-formed xmlns="urn:ietf:params:xml:ns:xmpp-streams"/></stream:error></stream:stream>
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     xmpp: 
|       version: 1.0
|     errors: 
|       invalid-namespace
|       (timeout)
|     capabilities: 
|     unknown: 
|     auth_mechanisms: 
|     stream_id: aq9x1f5h4r
|     compression_methods: 
|_    features: 
|_ssl-date: 2024-06-13T12:52:38+00:00; -1s from scanner time.
5223/tcp  open  ssl/jabber          syn-ack ttl 127
|_ssl-date: 2024-06-13T12:52:38+00:00; 0s from scanner time.
| fingerprint-strings: 
|   RPCCheck: 
|_    <stream:error xmlns:stream="http://etherx.jabber.org/streams"><not-well-formed xmlns="urn:ietf:params:xml:ns:xmpp-streams"/></stream:error></stream:stream>
| ssl-cert: Subject: commonName=fire.windcorp.thm
| Subject Alternative Name: DNS:fire.windcorp.thm, DNS:*.fire.windcorp.thm
| Issuer: commonName=fire.windcorp.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2020-05-01T08:39:00
| Not valid after:  2025-04-30T08:39:00
| MD5:   b715:5425:83f3:a20f:75c8:ca2d:3353:cbb7
| SHA-1: 97f7:0772:a26b:e324:7ed5:bbcb:5f35:7d74:7982:66ae
| -----BEGIN CERTIFICATE-----
| MIIDLzCCAhegAwIBAgIIXUFELG7QgAIwDQYJKoZIhvcNAQELBQAwHDEaMBgGA1UE
| AwwRZmlyZS53aW5kY29ycC50aG0wHhcNMjAwNTAxMDgzOTAwWhcNMjUwNDMwMDgz
| OTAwWjAcMRowGAYDVQQDDBFmaXJlLndpbmRjb3JwLnRobTCCASIwDQYJKoZIhvcN
| AQEBBQADggEPADCCAQoCggEBAKLH0/j17RVdD8eXC+0IFovAoql2REjOSf2NpJLK
| /6fgtx3CA4ftLsj7yOpmj8Oe1gqfWd2EM/zKk+ZmZwQFxLQL93t1OD/za1gyclxr
| IVbPVWqFoM2BUU9O3yU0VVRGP7xKDHm4bcoNmq9UNurEtFlCNeCC1fcwzfYvKD89
| X04Rv/6kn1GlQq/iM8PGCLDUf1p1WJcwGT5FUiBa9boTU9llBcGqbodZaBKzPPP8
| DmvSYF71IKBT8NsVzqiAiO3t/oHgApvUd9BqdbZeN46XORrOhBQV0xUpNVy9L5OE
| UAD1so3ePTNjpPE5SfTKymT1a8Fiw5kroKODN0nzy50yP3UCAwEAAaN1MHMwMQYD
| VR0RBCowKIIRZmlyZS53aW5kY29ycC50aG2CEyouZmlyZS53aW5kY29ycC50aG0w
| HQYDVR0OBBYEFOtMzqgfsY11qewZNfPjiLxnGykGMB8GA1UdIwQYMBaAFOtMzqgf
| sY11qewZNfPjiLxnGykGMA0GCSqGSIb3DQEBCwUAA4IBAQAHofv0VP+hE+5sg0KR
| 2x0Xeg4cIXEia0c5cIJ7K7bhfoLOcT7WcMKCLIN3A416PREdkB6Q610uDs8RpezJ
| II/wBoIp2G0Y87X3Xo5FmNJjl9lGX5fvayen98khPXvZkurHdWdtA4m8pHOdYOrk
| n8Jth6L/y4L5WlgEGL0x0HK4yvd3iz0VNrc810HugpyfVWeasChhZjgAYXUVlA8k
| +QxLxyNr/PBfRumQGzw2n3msXxwfHVzaHphy56ph85PcRS35iNqgrtK0fe3Qhpq7
| v5vQYKlOGq5FI6Mf9ni7S1pXSqF4U9wuqZy4q4tXWAVootmJv1DIgfSMLvXplN9T
| LucP
|_-----END CERTIFICATE-----
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     xmpp: 
|     capabilities: 
|     unknown: 
|     errors: 
|       (timeout)
|     compression_methods: 
|     auth_mechanisms: 
|_    features: 
5229/tcp  open  jaxflow?            syn-ack ttl 127
5262/tcp  open  jabber              syn-ack ttl 127
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     xmpp: 
|       version: 1.0
|     errors: 
|       invalid-namespace
|       (timeout)
|     capabilities: 
|     unknown: 
|     auth_mechanisms: 
|     stream_id: a82olae5ka
|     compression_methods: 
|_    features: 
| fingerprint-strings: 
|   RPCCheck: 
|_    <stream:error xmlns:stream="http://etherx.jabber.org/streams"><not-well-formed xmlns="urn:ietf:params:xml:ns:xmpp-streams"/></stream:error></stream:stream>
5263/tcp  open  ssl/jabber          syn-ack ttl 127
| ssl-cert: Subject: commonName=fire.windcorp.thm
| Subject Alternative Name: DNS:fire.windcorp.thm, DNS:*.fire.windcorp.thm
| Issuer: commonName=fire.windcorp.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2020-05-01T08:39:00
| Not valid after:  2025-04-30T08:39:00
| MD5:   b715:5425:83f3:a20f:75c8:ca2d:3353:cbb7
| SHA-1: 97f7:0772:a26b:e324:7ed5:bbcb:5f35:7d74:7982:66ae
| -----BEGIN CERTIFICATE-----
| MIIDLzCCAhegAwIBAgIIXUFELG7QgAIwDQYJKoZIhvcNAQELBQAwHDEaMBgGA1UE
| AwwRZmlyZS53aW5kY29ycC50aG0wHhcNMjAwNTAxMDgzOTAwWhcNMjUwNDMwMDgz
| OTAwWjAcMRowGAYDVQQDDBFmaXJlLndpbmRjb3JwLnRobTCCASIwDQYJKoZIhvcN
| AQEBBQADggEPADCCAQoCggEBAKLH0/j17RVdD8eXC+0IFovAoql2REjOSf2NpJLK
| /6fgtx3CA4ftLsj7yOpmj8Oe1gqfWd2EM/zKk+ZmZwQFxLQL93t1OD/za1gyclxr
| IVbPVWqFoM2BUU9O3yU0VVRGP7xKDHm4bcoNmq9UNurEtFlCNeCC1fcwzfYvKD89
| X04Rv/6kn1GlQq/iM8PGCLDUf1p1WJcwGT5FUiBa9boTU9llBcGqbodZaBKzPPP8
| DmvSYF71IKBT8NsVzqiAiO3t/oHgApvUd9BqdbZeN46XORrOhBQV0xUpNVy9L5OE
| UAD1so3ePTNjpPE5SfTKymT1a8Fiw5kroKODN0nzy50yP3UCAwEAAaN1MHMwMQYD
| VR0RBCowKIIRZmlyZS53aW5kY29ycC50aG2CEyouZmlyZS53aW5kY29ycC50aG0w
| HQYDVR0OBBYEFOtMzqgfsY11qewZNfPjiLxnGykGMB8GA1UdIwQYMBaAFOtMzqgf
| sY11qewZNfPjiLxnGykGMA0GCSqGSIb3DQEBCwUAA4IBAQAHofv0VP+hE+5sg0KR
| 2x0Xeg4cIXEia0c5cIJ7K7bhfoLOcT7WcMKCLIN3A416PREdkB6Q610uDs8RpezJ
| II/wBoIp2G0Y87X3Xo5FmNJjl9lGX5fvayen98khPXvZkurHdWdtA4m8pHOdYOrk
| n8Jth6L/y4L5WlgEGL0x0HK4yvd3iz0VNrc810HugpyfVWeasChhZjgAYXUVlA8k
| +QxLxyNr/PBfRumQGzw2n3msXxwfHVzaHphy56ph85PcRS35iNqgrtK0fe3Qhpq7
| v5vQYKlOGq5FI6Mf9ni7S1pXSqF4U9wuqZy4q4tXWAVootmJv1DIgfSMLvXplN9T
| LucP
|_-----END CERTIFICATE-----
| fingerprint-strings: 
|   RPCCheck: 
|_    <stream:error xmlns:stream="http://etherx.jabber.org/streams"><not-well-formed xmlns="urn:ietf:params:xml:ns:xmpp-streams"/></stream:error></stream:stream>
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     xmpp: 
|     capabilities: 
|     unknown: 
|     errors: 
|       (timeout)
|     compression_methods: 
|     auth_mechanisms: 
|_    features: 
|_ssl-date: 2024-06-13T12:52:38+00:00; 0s from scanner time.
5269/tcp  open  xmpp                syn-ack ttl 127 Wildfire XMPP Client
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     xmpp: 
|     capabilities: 
|     unknown: 
|     errors: 
|       (timeout)
|     compression_methods: 
|     auth_mechanisms: 
|_    features: 
5270/tcp  open  ssl/xmpp            syn-ack ttl 127 Wildfire XMPP Client
| ssl-cert: Subject: commonName=fire.windcorp.thm
| Subject Alternative Name: DNS:fire.windcorp.thm, DNS:*.fire.windcorp.thm
| Issuer: commonName=fire.windcorp.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2020-05-01T08:39:00
| Not valid after:  2025-04-30T08:39:00
| MD5:   b715:5425:83f3:a20f:75c8:ca2d:3353:cbb7
| SHA-1: 97f7:0772:a26b:e324:7ed5:bbcb:5f35:7d74:7982:66ae
| -----BEGIN CERTIFICATE-----
| MIIDLzCCAhegAwIBAgIIXUFELG7QgAIwDQYJKoZIhvcNAQELBQAwHDEaMBgGA1UE
| AwwRZmlyZS53aW5kY29ycC50aG0wHhcNMjAwNTAxMDgzOTAwWhcNMjUwNDMwMDgz
| OTAwWjAcMRowGAYDVQQDDBFmaXJlLndpbmRjb3JwLnRobTCCASIwDQYJKoZIhvcN
| AQEBBQADggEPADCCAQoCggEBAKLH0/j17RVdD8eXC+0IFovAoql2REjOSf2NpJLK
| /6fgtx3CA4ftLsj7yOpmj8Oe1gqfWd2EM/zKk+ZmZwQFxLQL93t1OD/za1gyclxr
| IVbPVWqFoM2BUU9O3yU0VVRGP7xKDHm4bcoNmq9UNurEtFlCNeCC1fcwzfYvKD89
| X04Rv/6kn1GlQq/iM8PGCLDUf1p1WJcwGT5FUiBa9boTU9llBcGqbodZaBKzPPP8
| DmvSYF71IKBT8NsVzqiAiO3t/oHgApvUd9BqdbZeN46XORrOhBQV0xUpNVy9L5OE
| UAD1so3ePTNjpPE5SfTKymT1a8Fiw5kroKODN0nzy50yP3UCAwEAAaN1MHMwMQYD
| VR0RBCowKIIRZmlyZS53aW5kY29ycC50aG2CEyouZmlyZS53aW5kY29ycC50aG0w
| HQYDVR0OBBYEFOtMzqgfsY11qewZNfPjiLxnGykGMB8GA1UdIwQYMBaAFOtMzqgf
| sY11qewZNfPjiLxnGykGMA0GCSqGSIb3DQEBCwUAA4IBAQAHofv0VP+hE+5sg0KR
| 2x0Xeg4cIXEia0c5cIJ7K7bhfoLOcT7WcMKCLIN3A416PREdkB6Q610uDs8RpezJ
| II/wBoIp2G0Y87X3Xo5FmNJjl9lGX5fvayen98khPXvZkurHdWdtA4m8pHOdYOrk
| n8Jth6L/y4L5WlgEGL0x0HK4yvd3iz0VNrc810HugpyfVWeasChhZjgAYXUVlA8k
| +QxLxyNr/PBfRumQGzw2n3msXxwfHVzaHphy56ph85PcRS35iNqgrtK0fe3Qhpq7
| v5vQYKlOGq5FI6Mf9ni7S1pXSqF4U9wuqZy4q4tXWAVootmJv1DIgfSMLvXplN9T
| LucP
|_-----END CERTIFICATE-----
|_ssl-date: 2024-06-13T12:52:37+00:00; -1s from scanner time.
5275/tcp  open  jabber              syn-ack ttl 127
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     xmpp: 
|       version: 1.0
|     errors: 
|       invalid-namespace
|       (timeout)
|     capabilities: 
|     unknown: 
|     auth_mechanisms: 
|     stream_id: 2z6mvzbspw
|     compression_methods: 
|_    features: 
| fingerprint-strings: 
|   RPCCheck: 
|_    <stream:error xmlns:stream="http://etherx.jabber.org/streams"><not-well-formed xmlns="urn:ietf:params:xml:ns:xmpp-streams"/></stream:error></stream:stream>
5276/tcp  open  ssl/jabber          syn-ack ttl 127 Ignite Realtime Openfire Jabber server 3.10.0 or later
| ssl-cert: Subject: commonName=fire.windcorp.thm
| Subject Alternative Name: DNS:fire.windcorp.thm, DNS:*.fire.windcorp.thm
| Issuer: commonName=fire.windcorp.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2020-05-01T08:39:00
| Not valid after:  2025-04-30T08:39:00
| MD5:   b715:5425:83f3:a20f:75c8:ca2d:3353:cbb7
| SHA-1: 97f7:0772:a26b:e324:7ed5:bbcb:5f35:7d74:7982:66ae
| -----BEGIN CERTIFICATE-----
| MIIDLzCCAhegAwIBAgIIXUFELG7QgAIwDQYJKoZIhvcNAQELBQAwHDEaMBgGA1UE
| AwwRZmlyZS53aW5kY29ycC50aG0wHhcNMjAwNTAxMDgzOTAwWhcNMjUwNDMwMDgz
| OTAwWjAcMRowGAYDVQQDDBFmaXJlLndpbmRjb3JwLnRobTCCASIwDQYJKoZIhvcN
| AQEBBQADggEPADCCAQoCggEBAKLH0/j17RVdD8eXC+0IFovAoql2REjOSf2NpJLK
| /6fgtx3CA4ftLsj7yOpmj8Oe1gqfWd2EM/zKk+ZmZwQFxLQL93t1OD/za1gyclxr
| IVbPVWqFoM2BUU9O3yU0VVRGP7xKDHm4bcoNmq9UNurEtFlCNeCC1fcwzfYvKD89
| X04Rv/6kn1GlQq/iM8PGCLDUf1p1WJcwGT5FUiBa9boTU9llBcGqbodZaBKzPPP8
| DmvSYF71IKBT8NsVzqiAiO3t/oHgApvUd9BqdbZeN46XORrOhBQV0xUpNVy9L5OE
| UAD1so3ePTNjpPE5SfTKymT1a8Fiw5kroKODN0nzy50yP3UCAwEAAaN1MHMwMQYD
| VR0RBCowKIIRZmlyZS53aW5kY29ycC50aG2CEyouZmlyZS53aW5kY29ycC50aG0w
| HQYDVR0OBBYEFOtMzqgfsY11qewZNfPjiLxnGykGMB8GA1UdIwQYMBaAFOtMzqgf
| sY11qewZNfPjiLxnGykGMA0GCSqGSIb3DQEBCwUAA4IBAQAHofv0VP+hE+5sg0KR
| 2x0Xeg4cIXEia0c5cIJ7K7bhfoLOcT7WcMKCLIN3A416PREdkB6Q610uDs8RpezJ
| II/wBoIp2G0Y87X3Xo5FmNJjl9lGX5fvayen98khPXvZkurHdWdtA4m8pHOdYOrk
| n8Jth6L/y4L5WlgEGL0x0HK4yvd3iz0VNrc810HugpyfVWeasChhZjgAYXUVlA8k
| +QxLxyNr/PBfRumQGzw2n3msXxwfHVzaHphy56ph85PcRS35iNqgrtK0fe3Qhpq7
| v5vQYKlOGq5FI6Mf9ni7S1pXSqF4U9wuqZy4q4tXWAVootmJv1DIgfSMLvXplN9T
| LucP
|_-----END CERTIFICATE-----
|_ssl-date: 2024-06-13T12:52:37+00:00; -1s from scanner time.
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     xmpp: 
|     capabilities: 
|     unknown: 
|     errors: 
|       (timeout)
|     compression_methods: 
|     auth_mechanisms: 
|_    features: 
5985/tcp  open  http                syn-ack ttl 127 Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
7070/tcp  open  http                syn-ack ttl 127 Jetty 9.4.18.v20190429
|_http-server-header: Jetty(9.4.18.v20190429)
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: Openfire HTTP Binding Service
7443/tcp  open  ssl/http            syn-ack ttl 127 Jetty 9.4.18.v20190429
|_http-server-header: Jetty(9.4.18.v20190429)
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
| ssl-cert: Subject: commonName=fire.windcorp.thm
| Subject Alternative Name: DNS:fire.windcorp.thm, DNS:*.fire.windcorp.thm
| Issuer: commonName=fire.windcorp.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2020-05-01T08:39:00
| Not valid after:  2025-04-30T08:39:00
| MD5:   b715:5425:83f3:a20f:75c8:ca2d:3353:cbb7
| SHA-1: 97f7:0772:a26b:e324:7ed5:bbcb:5f35:7d74:7982:66ae
| -----BEGIN CERTIFICATE-----
| MIIDLzCCAhegAwIBAgIIXUFELG7QgAIwDQYJKoZIhvcNAQELBQAwHDEaMBgGA1UE
| AwwRZmlyZS53aW5kY29ycC50aG0wHhcNMjAwNTAxMDgzOTAwWhcNMjUwNDMwMDgz
| OTAwWjAcMRowGAYDVQQDDBFmaXJlLndpbmRjb3JwLnRobTCCASIwDQYJKoZIhvcN
| AQEBBQADggEPADCCAQoCggEBAKLH0/j17RVdD8eXC+0IFovAoql2REjOSf2NpJLK
| /6fgtx3CA4ftLsj7yOpmj8Oe1gqfWd2EM/zKk+ZmZwQFxLQL93t1OD/za1gyclxr
| IVbPVWqFoM2BUU9O3yU0VVRGP7xKDHm4bcoNmq9UNurEtFlCNeCC1fcwzfYvKD89
| X04Rv/6kn1GlQq/iM8PGCLDUf1p1WJcwGT5FUiBa9boTU9llBcGqbodZaBKzPPP8
| DmvSYF71IKBT8NsVzqiAiO3t/oHgApvUd9BqdbZeN46XORrOhBQV0xUpNVy9L5OE
| UAD1so3ePTNjpPE5SfTKymT1a8Fiw5kroKODN0nzy50yP3UCAwEAAaN1MHMwMQYD
| VR0RBCowKIIRZmlyZS53aW5kY29ycC50aG2CEyouZmlyZS53aW5kY29ycC50aG0w
| HQYDVR0OBBYEFOtMzqgfsY11qewZNfPjiLxnGykGMB8GA1UdIwQYMBaAFOtMzqgf
| sY11qewZNfPjiLxnGykGMA0GCSqGSIb3DQEBCwUAA4IBAQAHofv0VP+hE+5sg0KR
| 2x0Xeg4cIXEia0c5cIJ7K7bhfoLOcT7WcMKCLIN3A416PREdkB6Q610uDs8RpezJ
| II/wBoIp2G0Y87X3Xo5FmNJjl9lGX5fvayen98khPXvZkurHdWdtA4m8pHOdYOrk
| n8Jth6L/y4L5WlgEGL0x0HK4yvd3iz0VNrc810HugpyfVWeasChhZjgAYXUVlA8k
| +QxLxyNr/PBfRumQGzw2n3msXxwfHVzaHphy56ph85PcRS35iNqgrtK0fe3Qhpq7
| v5vQYKlOGq5FI6Mf9ni7S1pXSqF4U9wuqZy4q4tXWAVootmJv1DIgfSMLvXplN9T
| LucP
|_-----END CERTIFICATE-----
|_http-title: Openfire HTTP Binding Service
7777/tcp  open  socks5              syn-ack ttl 127 (No authentication; connection failed)
| socks-auth-info: 
|_  No authentication
9090/tcp  open  zeus-admin?         syn-ack ttl 127
| fingerprint-strings: 
|   GetRequest: 
|     HTTP/1.1 200 OK
|     Date: Thu, 13 Jun 2024 12:50:49 GMT
|     Last-Modified: Fri, 31 Jan 2020 17:54:10 GMT
|     Content-Type: text/html
|     Accept-Ranges: bytes
|     Content-Length: 115
|     <html>
|     <head><title></title>
|     <meta http-equiv="refresh" content="0;URL=index.jsp">
|     </head>
|     <body>
|     </body>
|     </html>
|   HTTPOptions: 
|     HTTP/1.1 200 OK
|     Date: Thu, 13 Jun 2024 12:51:01 GMT
|     Allow: GET,HEAD,POST,OPTIONS
|   JavaRMI, drda, ibm-db2-das, informix: 
|     HTTP/1.1 400 Illegal character CNTL=0x0
|     Content-Type: text/html;charset=iso-8859-1
|     Content-Length: 69
|     Connection: close
|     <h1>Bad Message 400</h1><pre>reason: Illegal character CNTL=0x0</pre>
|   SqueezeCenter_CLI: 
|     HTTP/1.1 400 No URI
|     Content-Type: text/html;charset=iso-8859-1
|     Content-Length: 49
|     Connection: close
|     <h1>Bad Message 400</h1><pre>reason: No URI</pre>
|   WMSRequest: 
|     HTTP/1.1 400 Illegal character CNTL=0x1
|     Content-Type: text/html;charset=iso-8859-1
|     Content-Length: 69
|     Connection: close
|_    <h1>Bad Message 400</h1><pre>reason: Illegal character CNTL=0x1</pre>
9091/tcp  open  ssl/xmltec-xmlmail? syn-ack ttl 127
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP: 
|     HTTP/1.1 400 Illegal character CNTL=0x0
|     Content-Type: text/html;charset=iso-8859-1
|     Content-Length: 69
|     Connection: close
|     <h1>Bad Message 400</h1><pre>reason: Illegal character CNTL=0x0</pre>
|   GetRequest: 
|     HTTP/1.1 200 OK
|     Date: Thu, 13 Jun 2024 12:51:14 GMT
|     Last-Modified: Fri, 31 Jan 2020 17:54:10 GMT
|     Content-Type: text/html
|     Accept-Ranges: bytes
|     Content-Length: 115
|     <html>
|     <head><title></title>
|     <meta http-equiv="refresh" content="0;URL=index.jsp">
|     </head>
|     <body>
|     </body>
|     </html>
|   HTTPOptions: 
|     HTTP/1.1 200 OK
|     Date: Thu, 13 Jun 2024 12:51:14 GMT
|     Allow: GET,HEAD,POST,OPTIONS
|   Help: 
|     HTTP/1.1 400 No URI
|     Content-Type: text/html;charset=iso-8859-1
|     Content-Length: 49
|     Connection: close
|     <h1>Bad Message 400</h1><pre>reason: No URI</pre>
|   RPCCheck: 
|     HTTP/1.1 400 Illegal character OTEXT=0x80
|     Content-Type: text/html;charset=iso-8859-1
|     Content-Length: 71
|     Connection: close
|     <h1>Bad Message 400</h1><pre>reason: Illegal character OTEXT=0x80</pre>
|   RTSPRequest: 
|     HTTP/1.1 400 Unknown Version
|     Content-Type: text/html;charset=iso-8859-1
|     Content-Length: 58
|     Connection: close
|     <h1>Bad Message 400</h1><pre>reason: Unknown Version</pre>
|   SSLSessionReq: 
|     HTTP/1.1 400 Illegal character CNTL=0x16
|     Content-Type: text/html;charset=iso-8859-1
|     Content-Length: 70
|     Connection: close
|_    <h1>Bad Message 400</h1><pre>reason: Illegal character CNTL=0x16</pre>
| ssl-cert: Subject: commonName=fire.windcorp.thm
| Subject Alternative Name: DNS:fire.windcorp.thm, DNS:*.fire.windcorp.thm
| Issuer: commonName=fire.windcorp.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2020-05-01T08:39:00
| Not valid after:  2025-04-30T08:39:00
| MD5:   b715:5425:83f3:a20f:75c8:ca2d:3353:cbb7
| SHA-1: 97f7:0772:a26b:e324:7ed5:bbcb:5f35:7d74:7982:66ae
| -----BEGIN CERTIFICATE-----
| MIIDLzCCAhegAwIBAgIIXUFELG7QgAIwDQYJKoZIhvcNAQELBQAwHDEaMBgGA1UE
| AwwRZmlyZS53aW5kY29ycC50aG0wHhcNMjAwNTAxMDgzOTAwWhcNMjUwNDMwMDgz
| OTAwWjAcMRowGAYDVQQDDBFmaXJlLndpbmRjb3JwLnRobTCCASIwDQYJKoZIhvcN
| AQEBBQADggEPADCCAQoCggEBAKLH0/j17RVdD8eXC+0IFovAoql2REjOSf2NpJLK
| /6fgtx3CA4ftLsj7yOpmj8Oe1gqfWd2EM/zKk+ZmZwQFxLQL93t1OD/za1gyclxr
| IVbPVWqFoM2BUU9O3yU0VVRGP7xKDHm4bcoNmq9UNurEtFlCNeCC1fcwzfYvKD89
| X04Rv/6kn1GlQq/iM8PGCLDUf1p1WJcwGT5FUiBa9boTU9llBcGqbodZaBKzPPP8
| DmvSYF71IKBT8NsVzqiAiO3t/oHgApvUd9BqdbZeN46XORrOhBQV0xUpNVy9L5OE
| UAD1so3ePTNjpPE5SfTKymT1a8Fiw5kroKODN0nzy50yP3UCAwEAAaN1MHMwMQYD
| VR0RBCowKIIRZmlyZS53aW5kY29ycC50aG2CEyouZmlyZS53aW5kY29ycC50aG0w
| HQYDVR0OBBYEFOtMzqgfsY11qewZNfPjiLxnGykGMB8GA1UdIwQYMBaAFOtMzqgf
| sY11qewZNfPjiLxnGykGMA0GCSqGSIb3DQEBCwUAA4IBAQAHofv0VP+hE+5sg0KR
| 2x0Xeg4cIXEia0c5cIJ7K7bhfoLOcT7WcMKCLIN3A416PREdkB6Q610uDs8RpezJ
| II/wBoIp2G0Y87X3Xo5FmNJjl9lGX5fvayen98khPXvZkurHdWdtA4m8pHOdYOrk
| n8Jth6L/y4L5WlgEGL0x0HK4yvd3iz0VNrc810HugpyfVWeasChhZjgAYXUVlA8k
| +QxLxyNr/PBfRumQGzw2n3msXxwfHVzaHphy56ph85PcRS35iNqgrtK0fe3Qhpq7
| v5vQYKlOGq5FI6Mf9ni7S1pXSqF4U9wuqZy4q4tXWAVootmJv1DIgfSMLvXplN9T
| LucP
|_-----END CERTIFICATE-----
9389/tcp  open  mc-nmf              syn-ack ttl 127 .NET Message Framing
49671/tcp open  msrpc               syn-ack ttl 127 Microsoft Windows RPC
49672/tcp open  ncacn_http          syn-ack ttl 127 Microsoft Windows RPC over HTTP 1.0
49673/tcp open  msrpc               syn-ack ttl 127 Microsoft Windows RPC
49674/tcp open  msrpc               syn-ack ttl 127 Microsoft Windows RPC
49693/tcp open  msrpc               syn-ack ttl 127 Microsoft Windows RPC
7 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port5222-TCP:V=7.94SVN%I=7%D=6/13%Time=666AEB3F%P=x86_64-pc-linux-gnu%r
SF:(RPCCheck,9B,"<stream:error\x20xmlns:stream=\"http://etherx\.jabber\.or
SF:g/streams\"><not-well-formed\x20xmlns=\"urn:ietf:params:xml:ns:xmpp-str
SF:eams\"/></stream:error></stream:stream>");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port5223-TCP:V=7.94SVN%T=SSL%I=7%D=6/13%Time=666AEB54%P=x86_64-pc-linux
SF:-gnu%r(RPCCheck,9B,"<stream:error\x20xmlns:stream=\"http://etherx\.jabb
SF:er\.org/streams\"><not-well-formed\x20xmlns=\"urn:ietf:params:xml:ns:xm
SF:pp-streams\"/></stream:error></stream:stream>");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port5262-TCP:V=7.94SVN%I=7%D=6/13%Time=666AEB3F%P=x86_64-pc-linux-gnu%r
SF:(RPCCheck,9B,"<stream:error\x20xmlns:stream=\"http://etherx\.jabber\.or
SF:g/streams\"><not-well-formed\x20xmlns=\"urn:ietf:params:xml:ns:xmpp-str
SF:eams\"/></stream:error></stream:stream>");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port5263-TCP:V=7.94SVN%T=SSL%I=7%D=6/13%Time=666AEB54%P=x86_64-pc-linux
SF:-gnu%r(RPCCheck,9B,"<stream:error\x20xmlns:stream=\"http://etherx\.jabb
SF:er\.org/streams\"><not-well-formed\x20xmlns=\"urn:ietf:params:xml:ns:xm
SF:pp-streams\"/></stream:error></stream:stream>");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port5275-TCP:V=7.94SVN%I=7%D=6/13%Time=666AEB3F%P=x86_64-pc-linux-gnu%r
SF:(RPCCheck,9B,"<stream:error\x20xmlns:stream=\"http://etherx\.jabber\.or
SF:g/streams\"><not-well-formed\x20xmlns=\"urn:ietf:params:xml:ns:xmpp-str
SF:eams\"/></stream:error></stream:stream>");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port9090-TCP:V=7.94SVN%I=7%D=6/13%Time=666AEB2A%P=x86_64-pc-linux-gnu%r
SF:(GetRequest,11D,"HTTP/1\.1\x20200\x20OK\r\nDate:\x20Thu,\x2013\x20Jun\x
SF:202024\x2012:50:49\x20GMT\r\nLast-Modified:\x20Fri,\x2031\x20Jan\x20202
SF:0\x2017:54:10\x20GMT\r\nContent-Type:\x20text/html\r\nAccept-Ranges:\x2
SF:0bytes\r\nContent-Length:\x20115\r\n\r\n<html>\n<head><title></title>\n
SF:<meta\x20http-equiv=\"refresh\"\x20content=\"0;URL=index\.jsp\">\n</hea
SF:d>\n<body>\n</body>\n</html>\n\n")%r(JavaRMI,C3,"HTTP/1\.1\x20400\x20Il
SF:legal\x20character\x20CNTL=0x0\r\nContent-Type:\x20text/html;charset=is
SF:o-8859-1\r\nContent-Length:\x2069\r\nConnection:\x20close\r\n\r\n<h1>Ba
SF:d\x20Message\x20400</h1><pre>reason:\x20Illegal\x20character\x20CNTL=0x
SF:0</pre>")%r(WMSRequest,C3,"HTTP/1\.1\x20400\x20Illegal\x20character\x20
SF:CNTL=0x1\r\nContent-Type:\x20text/html;charset=iso-8859-1\r\nContent-Le
SF:ngth:\x2069\r\nConnection:\x20close\r\n\r\n<h1>Bad\x20Message\x20400</h
SF:1><pre>reason:\x20Illegal\x20character\x20CNTL=0x1</pre>")%r(ibm-db2-da
SF:s,C3,"HTTP/1\.1\x20400\x20Illegal\x20character\x20CNTL=0x0\r\nContent-T
SF:ype:\x20text/html;charset=iso-8859-1\r\nContent-Length:\x2069\r\nConnec
SF:tion:\x20close\r\n\r\n<h1>Bad\x20Message\x20400</h1><pre>reason:\x20Ill
SF:egal\x20character\x20CNTL=0x0</pre>")%r(SqueezeCenter_CLI,9B,"HTTP/1\.1
SF:\x20400\x20No\x20URI\r\nContent-Type:\x20text/html;charset=iso-8859-1\r
SF:\nContent-Length:\x2049\r\nConnection:\x20close\r\n\r\n<h1>Bad\x20Messa
SF:ge\x20400</h1><pre>reason:\x20No\x20URI</pre>")%r(informix,C3,"HTTP/1\.
SF:1\x20400\x20Illegal\x20character\x20CNTL=0x0\r\nContent-Type:\x20text/h
SF:tml;charset=iso-8859-1\r\nContent-Length:\x2069\r\nConnection:\x20close
SF:\r\n\r\n<h1>Bad\x20Message\x20400</h1><pre>reason:\x20Illegal\x20charac
SF:ter\x20CNTL=0x0</pre>")%r(drda,C3,"HTTP/1\.1\x20400\x20Illegal\x20chara
SF:cter\x20CNTL=0x0\r\nContent-Type:\x20text/html;charset=iso-8859-1\r\nCo
SF:ntent-Length:\x2069\r\nConnection:\x20close\r\n\r\n<h1>Bad\x20Message\x
SF:20400</h1><pre>reason:\x20Illegal\x20character\x20CNTL=0x0</pre>")%r(HT
SF:TPOptions,56,"HTTP/1\.1\x20200\x20OK\r\nDate:\x20Thu,\x2013\x20Jun\x202
SF:024\x2012:51:01\x20GMT\r\nAllow:\x20GET,HEAD,POST,OPTIONS\r\n\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port9091-TCP:V=7.94SVN%T=SSL%I=7%D=6/13%Time=666AEB42%P=x86_64-pc-linux
SF:-gnu%r(GetRequest,11D,"HTTP/1\.1\x20200\x20OK\r\nDate:\x20Thu,\x2013\x2
SF:0Jun\x202024\x2012:51:14\x20GMT\r\nLast-Modified:\x20Fri,\x2031\x20Jan\
SF:x202020\x2017:54:10\x20GMT\r\nContent-Type:\x20text/html\r\nAccept-Rang
SF:es:\x20bytes\r\nContent-Length:\x20115\r\n\r\n<html>\n<head><title></ti
SF:tle>\n<meta\x20http-equiv=\"refresh\"\x20content=\"0;URL=index\.jsp\">\
SF:n</head>\n<body>\n</body>\n</html>\n\n")%r(HTTPOptions,56,"HTTP/1\.1\x2
SF:0200\x20OK\r\nDate:\x20Thu,\x2013\x20Jun\x202024\x2012:51:14\x20GMT\r\n
SF:Allow:\x20GET,HEAD,POST,OPTIONS\r\n\r\n")%r(RTSPRequest,AD,"HTTP/1\.1\x
SF:20400\x20Unknown\x20Version\r\nContent-Type:\x20text/html;charset=iso-8
SF:859-1\r\nContent-Length:\x2058\r\nConnection:\x20close\r\n\r\n<h1>Bad\x
SF:20Message\x20400</h1><pre>reason:\x20Unknown\x20Version</pre>")%r(RPCCh
SF:eck,C7,"HTTP/1\.1\x20400\x20Illegal\x20character\x20OTEXT=0x80\r\nConte
SF:nt-Type:\x20text/html;charset=iso-8859-1\r\nContent-Length:\x2071\r\nCo
SF:nnection:\x20close\r\n\r\n<h1>Bad\x20Message\x20400</h1><pre>reason:\x2
SF:0Illegal\x20character\x20OTEXT=0x80</pre>")%r(DNSVersionBindReqTCP,C3,"
SF:HTTP/1\.1\x20400\x20Illegal\x20character\x20CNTL=0x0\r\nContent-Type:\x
SF:20text/html;charset=iso-8859-1\r\nContent-Length:\x2069\r\nConnection:\
SF:x20close\r\n\r\n<h1>Bad\x20Message\x20400</h1><pre>reason:\x20Illegal\x
SF:20character\x20CNTL=0x0</pre>")%r(DNSStatusRequestTCP,C3,"HTTP/1\.1\x20
SF:400\x20Illegal\x20character\x20CNTL=0x0\r\nContent-Type:\x20text/html;c
SF:harset=iso-8859-1\r\nContent-Length:\x2069\r\nConnection:\x20close\r\n\
SF:r\n<h1>Bad\x20Message\x20400</h1><pre>reason:\x20Illegal\x20character\x
SF:20CNTL=0x0</pre>")%r(Help,9B,"HTTP/1\.1\x20400\x20No\x20URI\r\nContent-
SF:Type:\x20text/html;charset=iso-8859-1\r\nContent-Length:\x2049\r\nConne
SF:ction:\x20close\r\n\r\n<h1>Bad\x20Message\x20400</h1><pre>reason:\x20No
SF:\x20URI</pre>")%r(SSLSessionReq,C5,"HTTP/1\.1\x20400\x20Illegal\x20char
SF:acter\x20CNTL=0x16\r\nContent-Type:\x20text/html;charset=iso-8859-1\r\n
SF:Content-Length:\x2070\r\nConnection:\x20close\r\n\r\n<h1>Bad\x20Message
SF:\x20400</h1><pre>reason:\x20Illegal\x20character\x20CNTL=0x16</pre>");
Service Info: Host: FIRE; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| p2p-conficker: 
|   Checking for Conficker.C or higher...
|   Check 1 (port 59353/tcp): CLEAN (Timeout)
|   Check 2 (port 39456/tcp): CLEAN (Timeout)
|   Check 3 (port 7954/udp): CLEAN (Timeout)
|   Check 4 (port 50612/udp): CLEAN (Timeout)
|_  0/4 checks are positive: Host is CLEAN or ports are blocked
|_clock-skew: mean: 0s, deviation: 0s, median: 0s
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2024-06-13T12:52:02
|_  start_date: N/A

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Thu Jun 13 13:52:49 2024 -- 1 IP address (1 host up) scanned in 315.06 seconds
```

Add the entry to the `/etc/hosts` file

![[attachments/Pasted image 20240613140020.png]]

# Web Enumeration

Website running on port 80

![[attachments/Pasted image 20240613140200.png]]

using burpsuite we can see a request being made to the endpoint `fire.windcorp.thm:9090` and there are also various emails disclosed

![[attachments/Pasted image 20240613142013.png]]

Extracted the emails and usernames, it could be useful later

Emails

```
organicfish718@fire.windcorp.thm
organicwolf509@fire.windcorp.thm
tinywolf424@fire.windcorp.thm
Emile@fire.windcorp.thm
buse@fire.windcorp.thm
Edward@fire.windcorp.thm
Edeltraut@fire.windcorp.thm
angrybird253@fire.windcorp.thm
tinygoose102@fire.windcorp.thm
brownostrich284@fire.windcorp.thm
sadswan869@fire.windcorp.thm
goldencat416@fire.windcorp.thm
whiteleopard529@fire.windcorp.thm
happymeercat399@fire.windcorp.thm
orangegorilla428@fire.windcorp.thm
```

Usernames

```
organicfish718
organicwolf509
tinywolf424
Emile
buse
Edward
Edeltraut
angrybird253
tinygoose102
brownostrich284
sadswan869
goldencat416
whiteleopard529
happymeercat399
orangegorilla428
```


Navigating to the url `http://fire.windcorp.thm:9090` takes us to an openfire administration console

![[attachments/Pasted image 20240613142351.png]]

Tried using an exploit to gain admin access but it didn't work

![[attachments/Pasted image 20240613144943.png]]

![[attachments/Pasted image 20240613145034.png]]

Going back to the domain `windcorp.thm` we  have a couple things 

List of IT support-staff (Full Names)

![[attachments/Pasted image 20240613150036.png]]

Employees in focus shows some more employee full names

![[attachments/Pasted image 20240613150141.png]]

The middle one might be a hint or not because in the password reset functionality there is a security question for pet's name.

![[attachments/Pasted image 20240613150244.png]]

So if we are able to get her pet's name somehow we can maybe reset the password.

# SMB Enumeration

Port 445 is running so we can perform SMB enumeration with a variety of tools.

`enum4linux` with guess access doesn't give anything useful. Same with `smbclient`.

# Username Enumeration (kerbrute)

Kerbrute is a tool used to quickly bruteforce and enumerate valid Active Directory accounts through Kerberos Pre-Authentication

![[attachments/Pasted image 20240613151134.png]]

```shell
./kerbrute userenum -d windcorp.thm usernames.txt --dc 10.10.103.148
```

with the usernames obtained earlier we can see 13 valid usernames

# AS-REP Roasting

After getting valid user accounts, the common thing to do is to perform `AS-REP Roasting` using the tool `GetNPUsers`

![[attachments/Pasted image 20240613151814.png]]

No luck here. None of the accounts are ASReproastable

# Web Enumeration (Part 2)

After much searching i couldn't find anything good so i decided to take a step back.

Going back to the main page and taking more time to inspect it, i discovered something interesting

![[attachments/Pasted image 20240613155541.png]]

The name of the image is `lilyleAndSparky`. That is most probably the user's username and pet name.

Trying to reset the password with this new info

![[attachments/Pasted image 20240613155829.png]]

Success

Login on the openfire admin console

![[attachments/Pasted image 20240613155913.png]]

It didn't work.

So i tried enumerating with smb instead.

# SMB Enumeration (Part 2)

Using smbclient

![[attachments/Pasted image 20240613160342.png]]

It works

Using smbmap we can see the share permissions

![[attachments/Pasted image 20240613160528.png]]

Adding the -r flag allows us to see sub directories for each share, and in the `Shared` share we can find the first flag

![[attachments/Pasted image 20240613161237.png]]

add the `--download PATH` to the command to download the flag

![[attachments/Pasted image 20240613161401.png]]

# User Enumeration

With the credential obtained we can enumerate even more usernames with netexec

![[attachments/Pasted image 20240613165108.png]]

There are way too many users (3999)

![[attachments/Pasted image 20240613165146.png]]

We can output the result into a file and extract the usernames  to maybe use for attacks later.

Checking the share `Shared`, we can see the spark version in use on the machine

![[attachments/Pasted image 20240614095855.png]]

Checking online for an exploit

we find a github repo that contains info on the exploit and we can see the creator of the room was part of this finding

![[attachments/Pasted image 20240614100350.png]]

Download the debian package and install, if you are using debian based Linux distro of course


![[attachments/Pasted image 20240614154819.png]]