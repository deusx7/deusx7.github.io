
# Ra

![[attachments/Pasted image 20240530152449.png]]

**Story**

You have gained access to the internal network of WindCorp, the multibillion dollar company, running an extensive social media campaign claiming to be unhackable (ha! so much for that claim!).

Next step would be to take their crown jewels and get full access to their internal network. You have spotted a new windows machine that may lead you to your end goal. Can you conquer this end boss and own their internal network?

Confirm connectivity

![[attachments/Pasted image 20240530152917.png]]

Alright we are good to go
# Nmap Scan

```shell
# Nmap 7.94SVN scan initiated Thu May 30 15:29:36 2024 as: nmap -sCV -p- --min-rate=1000 -T4 -oN scan -vv 10.10.58.169
Nmap scan report for 10.10.58.169
Host is up, received echo-reply ttl 127 (0.16s latency).
Scanned at 2024-05-30 15:29:37 WAT for 371s
Not shown: 65499 filtered tcp ports (no-response)
PORT      STATE SERVICE             REASON          VERSION
53/tcp    open  domain              syn-ack ttl 127 Simple DNS Plus
80/tcp    open  http                syn-ack ttl 127 Microsoft IIS httpd 10.0
| http-methods: 
|   Supported Methods: OPTIONS TRACE GET HEAD POST
|_  Potentially risky methods: TRACE
|_http-title: Windcorp.
|_http-server-header: Microsoft-IIS/10.0
88/tcp    open  kerberos-sec        syn-ack ttl 127 Microsoft Windows Kerberos (server time: 2024-05-30 14:33:51Z)
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
| ssl-cert: Subject: commonName=Fire.windcorp.thm
| Issuer: commonName=Fire.windcorp.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2024-05-29T14:27:19
| Not valid after:  2024-11-28T14:27:19
| MD5:   92fd:7169:534c:2e9e:2dbf:949c:b236:6635
| SHA-1: 8566:71bb:a3ef:4c0f:b0ff:c086:fd2f:f79c:3b99:9337
| -----BEGIN CERTIFICATE-----
| MIIC5jCCAc6gAwIBAgIQTx135MvkLppPHRIXHZ1huTANBgkqhkiG9w0BAQsFADAc
| MRowGAYDVQQDExFGaXJlLndpbmRjb3JwLnRobTAeFw0yNDA1MjkxNDI3MTlaFw0y
| NDExMjgxNDI3MTlaMBwxGjAYBgNVBAMTEUZpcmUud2luZGNvcnAudGhtMIIBIjAN
| BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAucuDj9DCgevhzLU9ix7VCxlliLtY
| n7zoNE2UXtWXtDhnsZofM14v9EUjzqPQ00hNb+/aKCa0Y3xpALsxACtkCu0tso+W
| wm1VoeXhf5u32Mpv7PwTiXJjSA1cqeiv/+T+nB9bjZ/QiEAkGCNe+TQGRNOmmU4h
| QdxzffT3RMTMqA+5XAoMlK4W5rCx1Iumtpk+WIgC8DnmDWjhjV4UE9pAsS8aCztg
| AbSbZXqVKrVfqHn9i4NZ5bxmSpQWDbuUv0UTyR8flsVZRmTfxM+9F6OiM7/UQ95K
| 1CY3F5N3NybxR359WnaawS4/jcwaUZSfhEgnYsOudbTHeXU+Pc8uxfFggQIDAQAB
| oyQwIjATBgNVHSUEDDAKBggrBgEFBQcDATALBgNVHQ8EBAMCBDAwDQYJKoZIhvcN
| AQELBQADggEBABQMAy35YfWKCBMICYnzyalM8/gd56Y7yjlxrxbgccTHPLLLsiKE
| jSCk/ztzINQ4q9zadVmO6yb1Nu8jznHpCt8QJOusklZ2sOXdcxHRh8lakX8zDmO+
| dfe7wyK0CkJ0fH+YhSvEsXdrZP+5k0tpdGpSKBXcO9fFkqHMyDMx0Z1oDxPgntqy
| lrAhG1OheZvQcgGSLGMopQneUliE6AFPK7TR5/31d5gSs6vqo9AtafZJhwvjiZmp
| GbHRltdcfkYsS01y0/Weaw+th9/mgWKGVcuPyNeho3sYtO3eaHVRPPw4uxPLKGBL
| pOR6cEqRxz0zOUCyNT3dV09mrg1O4Xwra8E=
|_-----END CERTIFICATE-----
| rdp-ntlm-info: 
|   Target_Name: WINDCORP
|   NetBIOS_Domain_Name: WINDCORP
|   NetBIOS_Computer_Name: FIRE
|   DNS_Domain_Name: windcorp.thm
|   DNS_Computer_Name: Fire.windcorp.thm
|   DNS_Tree_Name: windcorp.thm
|   Product_Version: 10.0.17763
|_  System_Time: 2024-05-30T14:35:01+00:00
|_ssl-date: 2024-05-30T14:35:38+00:00; 0s from scanner time.
5222/tcp  open  jabber              syn-ack ttl 127 Ignite Realtime Openfire Jabber server 3.10.0 or later
|_ssl-date: 2024-05-30T14:35:40+00:00; 0s from scanner time.
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     unknown: 
|     errors: 
|       invalid-namespace
|       (timeout)
|     auth_mechanisms: 
|     xmpp: 
|       version: 1.0
|     compression_methods: 
|     stream_id: 7wmd6w2fj5
|     capabilities: 
|_    features: 
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
5223/tcp  open  ssl/jabber          syn-ack ttl 127
|_ssl-date: 2024-05-30T14:35:39+00:00; +1s from scanner time.
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     errors: 
|       (timeout)
|     auth_mechanisms: 
|     xmpp: 
|     unknown: 
|     compression_methods: 
|     capabilities: 
|_    features: 
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
5229/tcp  open  jaxflow?            syn-ack ttl 127
5262/tcp  open  jabber              syn-ack ttl 127 Ignite Realtime Openfire Jabber server 3.10.0 or later
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     unknown: 
|     errors: 
|       invalid-namespace
|       (timeout)
|     auth_mechanisms: 
|     xmpp: 
|       version: 1.0
|     compression_methods: 
|     stream_id: twbs9qj01
|     capabilities: 
|_    features: 
5263/tcp  open  ssl/jabber          syn-ack ttl 127
|_ssl-date: 2024-05-30T14:35:38+00:00; 0s from scanner time.
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     errors: 
|       (timeout)
|     auth_mechanisms: 
|     xmpp: 
|     unknown: 
|     compression_methods: 
|     capabilities: 
|_    features: 
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
5269/tcp  open  xmpp                syn-ack ttl 127 Wildfire XMPP Client
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     errors: 
|       (timeout)
|     auth_mechanisms: 
|     xmpp: 
|     unknown: 
|     compression_methods: 
|     capabilities: 
|_    features: 
5270/tcp  open  ssl/xmpp            syn-ack ttl 127 Wildfire XMPP Client
|_ssl-date: 2024-05-30T14:35:39+00:00; +1s from scanner time.
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
5275/tcp  open  jabber              syn-ack ttl 127
| xmpp-info: 
|   STARTTLS Failed
|   info: 
|     unknown: 
|     errors: 
|       invalid-namespace
|       (timeout)
|     auth_mechanisms: 
|     xmpp: 
|       version: 1.0
|     compression_methods: 
|     stream_id: 1l7oz3wf7z
|     capabilities: 
|_    features: 
| fingerprint-strings: 
|   RPCCheck: 
|_    <stream:error xmlns:stream="http://etherx.jabber.org/streams"><not-well-formed xmlns="urn:ietf:params:xml:ns:xmpp-streams"/></stream:error></stream:stream>
5276/tcp  open  ssl/jabber          syn-ack ttl 127
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
|     errors: 
|       (timeout)
|     auth_mechanisms: 
|     xmpp: 
|     unknown: 
|     compression_methods: 
|     capabilities: 
|_    features: 
|_ssl-date: 2024-05-30T14:35:38+00:00; 0s from scanner time.
| fingerprint-strings: 
|   RPCCheck: 
|_    <stream:error xmlns:stream="http://etherx.jabber.org/streams"><not-well-formed xmlns="urn:ietf:params:xml:ns:xmpp-streams"/></stream:error></stream:stream>
5985/tcp  open  http                syn-ack ttl 127 Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
7070/tcp  open  http                syn-ack ttl 127 Jetty 9.4.18.v20190429
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Jetty(9.4.18.v20190429)
|_http-title: Openfire HTTP Binding Service
7443/tcp  open  ssl/http            syn-ack ttl 127 Jetty 9.4.18.v20190429
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
|_http-server-header: Jetty(9.4.18.v20190429)
|_http-title: Openfire HTTP Binding Service
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
7777/tcp  open  socks5              syn-ack ttl 127 (No authentication; connection failed)
| socks-auth-info: 
|_  No authentication
9090/tcp  open  zeus-admin?         syn-ack ttl 127
| fingerprint-strings: 
|   GetRequest: 
|     HTTP/1.1 200 OK
|     Date: Thu, 30 May 2024 14:33:51 GMT
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
|     Date: Thu, 30 May 2024 14:33:58 GMT
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
|   DNSStatusRequestTCP, DNSVersionBindReqTCP: 
|     HTTP/1.1 400 Illegal character CNTL=0x0
|     Content-Type: text/html;charset=iso-8859-1
|     Content-Length: 69
|     Connection: close
|     <h1>Bad Message 400</h1><pre>reason: Illegal character CNTL=0x0</pre>
|   GetRequest: 
|     HTTP/1.1 200 OK
|     Date: Thu, 30 May 2024 14:34:11 GMT
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
|     Date: Thu, 30 May 2024 14:34:11 GMT
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
9389/tcp  open  mc-nmf              syn-ack ttl 127 .NET Message Framing
49670/tcp open  msrpc               syn-ack ttl 127 Microsoft Windows RPC
49674/tcp open  ncacn_http          syn-ack ttl 127 Microsoft Windows RPC over HTTP 1.0
49675/tcp open  msrpc               syn-ack ttl 127 Microsoft Windows RPC
49676/tcp open  msrpc               syn-ack ttl 127 Microsoft Windows RPC
49697/tcp open  msrpc               syn-ack ttl 127 Microsoft Windows RPC
49920/tcp open  msrpc               syn-ack ttl 127 Microsoft Windows RPC
6 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port5223-TCP:V=7.94SVN%T=SSL%I=7%D=5/30%Time=66588E73%P=x86_64-pc-linux
SF:-gnu%r(RPCCheck,9B,"<stream:error\x20xmlns:stream=\"http://etherx\.jabb
SF:er\.org/streams\"><not-well-formed\x20xmlns=\"urn:ietf:params:xml:ns:xm
SF:pp-streams\"/></stream:error></stream:stream>");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port5263-TCP:V=7.94SVN%T=SSL%I=7%D=5/30%Time=66588E73%P=x86_64-pc-linux
SF:-gnu%r(RPCCheck,9B,"<stream:error\x20xmlns:stream=\"http://etherx\.jabb
SF:er\.org/streams\"><not-well-formed\x20xmlns=\"urn:ietf:params:xml:ns:xm
SF:pp-streams\"/></stream:error></stream:stream>");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port5275-TCP:V=7.94SVN%I=7%D=5/30%Time=66588E63%P=x86_64-pc-linux-gnu%r
SF:(RPCCheck,9B,"<stream:error\x20xmlns:stream=\"http://etherx\.jabber\.or
SF:g/streams\"><not-well-formed\x20xmlns=\"urn:ietf:params:xml:ns:xmpp-str
SF:eams\"/></stream:error></stream:stream>");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port5276-TCP:V=7.94SVN%T=SSL%I=7%D=5/30%Time=66588E76%P=x86_64-pc-linux
SF:-gnu%r(RPCCheck,9B,"<stream:error\x20xmlns:stream=\"http://etherx\.jabb
SF:er\.org/streams\"><not-well-formed\x20xmlns=\"urn:ietf:params:xml:ns:xm
SF:pp-streams\"/></stream:error></stream:stream>");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port9090-TCP:V=7.94SVN%I=7%D=5/30%Time=66588E4E%P=x86_64-pc-linux-gnu%r
SF:(GetRequest,11D,"HTTP/1\.1\x20200\x20OK\r\nDate:\x20Thu,\x2030\x20May\x
SF:202024\x2014:33:51\x20GMT\r\nLast-Modified:\x20Fri,\x2031\x20Jan\x20202
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
SF:TPOptions,56,"HTTP/1\.1\x20200\x20OK\r\nDate:\x20Thu,\x2030\x20May\x202
SF:024\x2014:33:58\x20GMT\r\nAllow:\x20GET,HEAD,POST,OPTIONS\r\n\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port9091-TCP:V=7.94SVN%T=SSL%I=7%D=5/30%Time=66588E62%P=x86_64-pc-linux
SF:-gnu%r(GetRequest,11D,"HTTP/1\.1\x20200\x20OK\r\nDate:\x20Thu,\x2030\x2
SF:0May\x202024\x2014:34:11\x20GMT\r\nLast-Modified:\x20Fri,\x2031\x20Jan\
SF:x202020\x2017:54:10\x20GMT\r\nContent-Type:\x20text/html\r\nAccept-Rang
SF:es:\x20bytes\r\nContent-Length:\x20115\r\n\r\n<html>\n<head><title></ti
SF:tle>\n<meta\x20http-equiv=\"refresh\"\x20content=\"0;URL=index\.jsp\">\
SF:n</head>\n<body>\n</body>\n</html>\n\n")%r(HTTPOptions,56,"HTTP/1\.1\x2
SF:0200\x20OK\r\nDate:\x20Thu,\x2030\x20May\x202024\x2014:34:11\x20GMT\r\n
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
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2024-05-30T14:34:59
|_  start_date: N/A
|_clock-skew: mean: 0s, deviation: 0s, median: 0s
| p2p-conficker: 
|   Checking for Conficker.C or higher...
|   Check 1 (port 19187/tcp): CLEAN (Timeout)
|   Check 2 (port 62603/tcp): CLEAN (Timeout)
|   Check 3 (port 57219/udp): CLEAN (Timeout)
|   Check 4 (port 15486/udp): CLEAN (Timeout)
|_  0/4 checks are positive: Host is CLEAN or ports are blocked

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Thu May 30 15:35:48 2024 -- 1 IP address (1 host up) scanned in 372.16 seconds
```

```shell
nmap -sCV -p- --min-rate=1000 -T4 IP -oN scan -vv
```

Add the domain name to the /etc/hosts file

![[attachments/Pasted image 20240530153913.png]]
# SMB Enumeration

![[attachments/Pasted image 20240530154249.png]]

No guest access

# Web Enumeration

Taking a look at the website, we have a couple things to look at

- List of IT staff with their names with their emails in the links, this could be used for enumeration later on.

	![[attachments/Pasted image 20240530155230.png]]

- 3 other employees
	 
	![[attachments/Pasted image 20240530155325.png]]

- A password reset functionality

	![[attachments/Pasted image 20240530155421.png]]

There is a question about a pets name and we can see the user Lily has a pet so if we can get the name we could be able to reset their password

# Kerberos Enumeration

Extract only the names from the emails

```
organicfish718
organicwolf509
tinywolf424
angrybird253
buse
Edeltraut
Edward
Emile
tinygoose102
brownostrich284
sadswan869
goldencat416
whiteleopard529
happymeercat399
orangegorilla428
```

Using kerbrute

![[attachments/Pasted image 20240530160442.png]]

```shell
./kerbrute userenum --dc windcorp.thm -d windcorp.thm user.txt
```

