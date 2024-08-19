
**Prepared for**: Mr. Thomas Wreath

**Prepared By**: deusx

**Start Date**: August 12, 2024

# Summary

# Scope

# Webserver: Enumeration

We first start with an nmap scan to discover open ports on our target

```shell
# Nmap 7.94SVN scan initiated Fri Aug 16 09:37:34 2024 as: nmap -sCV -p- --min-rate=1000 -T4 -oN scan -vv 10.201.149.200
Nmap scan report for 10.201.149.200
Host is up, received syn-ack (0.18s latency).
Scanned at 2024-08-16 09:37:34 WAT for 251s
Not shown: 65413 filtered tcp ports (no-response), 117 filtered tcp ports (host-unreach)
PORT      STATE  SERVICE    REASON       VERSION
22/tcp    open   ssh        syn-ack      OpenSSH 8.0 (protocol 2.0)
| ssh-hostkey: 
|   3072 9c:1b:d4:b4:05:4d:88:99:ce:09:1f:c1:15:6a:d4:7e (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfKbbFLiRV9dqsrYQifAghp85qmXpYEHf2g4JJqDKUL316TcAoGj62aamfhx5isIJHtQsA0hVmzD+4pVH4r8ANkuIIRs6j9cnBrLGpjk8xz9+BE1Vvd8lmORGxCqTv+9LgrpB7tcfoEkIOSG7zeY182kOR72igUERpy0JkzxJm2gIGb7Caz1s5/ScHEOhGX8VhNT4clOhDc9dLePRQvRooicIsENqQsLckE0eJB7rTSxemWduL+twySqtwN80a7pRzS7dzR4f6fkhVBAhYflJBW3iZ46zOItZcwT2u0wReCrFzxvDxEOewH7YHFpvOvb+Exuf3W6OuSjCHF64S7iU6z92aINNf+dSROACXbmGnBhTlGaV57brOXzujsWDylivWZ7CVVj1gB6mrNfEpBNE983qZskyVk4eTNT5cUD+3I/IPOz1bOtOWiraZCevFYaQR5AxNmx8sDIgo1z4VcxOMhrczc7RC/s3KWcoIkI2cI5+KUnDtaOfUClXPBCgYE50=
|   256 93:55:b4:d9:8b:70:ae:8e:95:0d:c2:b6:d2:03:89:a4 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFccvYHwpGWYUsw9mTk/mEvzyrY4ghhX2D6o3n/upTLFXbhJPV6ls4C8O0wH6TyGq7ClV3XpVa7zevngNoqlwzM=
|   256 f0:61:5a:55:34:9b:b7:b8:3a:46:ca:7d:9f:dc:fa:12 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLfVtZHSGvCy3JP5GX0Dgzcxz+Y9In0TcQc3vhvMXCP
80/tcp    open   http       syn-ack      Apache httpd 2.4.37 ((centos) OpenSSL/1.1.1c)
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: Did not follow redirect to https://thomaswreath.thm
443/tcp   open   ssl/http   syn-ack      Apache httpd 2.4.37 ((centos) OpenSSL/1.1.1c)
| tls-alpn: 
|_  http/1.1
| ssl-cert: Subject: commonName=thomaswreath.thm/organizationName=Thomas Wreath Development/stateOrProvinceName=East Riding Yorkshire/countryName=GB/localityName=Easingwold/emailAddress=me@thomaswreath.thm
| Issuer: commonName=thomaswreath.thm/organizationName=Thomas Wreath Development/stateOrProvinceName=East Riding Yorkshire/countryName=GB/localityName=Easingwold/emailAddress=me@thomaswreath.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2024-08-16T07:54:48
| Not valid after:  2025-08-16T07:54:48
| MD5:   f5ea:624c:3ee8:eb29:ec8d:cd40:4efb:4146
| SHA-1: 040e:203a:4623:cad5:f5f3:5a33:1aa1:a4a7:6a8b:b61c
| -----BEGIN CERTIFICATE-----
| MIIELTCCAxWgAwIBAgIUTPcF5PLulINDlIZ9JLtztMz7pw0wDQYJKoZIhvcNAQEL
| BQAwgaUxCzAJBgNVBAYTAkdCMR4wHAYDVQQIDBVFYXN0IFJpZGluZyBZb3Jrc2hp
| cmUxEzARBgNVBAcMCkVhc2luZ3dvbGQxIjAgBgNVBAoMGVRob21hcyBXcmVhdGgg
| RGV2ZWxvcG1lbnQxGTAXBgNVBAMMEHRob21hc3dyZWF0aC50aG0xIjAgBgkqhkiG
| 9w0BCQEWE21lQHRob21hc3dyZWF0aC50aG0wHhcNMjQwODE2MDc1NDQ4WhcNMjUw
| ODE2MDc1NDQ4WjCBpTELMAkGA1UEBhMCR0IxHjAcBgNVBAgMFUVhc3QgUmlkaW5n
| IFlvcmtzaGlyZTETMBEGA1UEBwwKRWFzaW5nd29sZDEiMCAGA1UECgwZVGhvbWFz
| IFdyZWF0aCBEZXZlbG9wbWVudDEZMBcGA1UEAwwQdGhvbWFzd3JlYXRoLnRobTEi
| MCAGCSqGSIb3DQEJARYTbWVAdGhvbWFzd3JlYXRoLnRobTCCASIwDQYJKoZIhvcN
| AQEBBQADggEPADCCAQoCggEBAMBtU7jxitGS41os/Hc1QP7yurdRyXUS75MqwwCE
| JB4OM4VrRhAksxbd+f+KGBdtF4GKyOO7r1GAdo4ebv3/9f6nBi9tRacZTTmLUYlo
| 1XHW/MQnZK7KCWmAZlMka56hk1R3+TCrkZL/l7lTwyDSA0xDsJHr2VhXY42kVMFU
| jncCpgGnKcw2EQcJubODasT187LrGk92rasYyefRe/rd4tkTrP2CmpLdPtzkPDHx
| HWzoalxIZtUTZg93HwWwC798+NsBfJGYJyy4qUIoqe10rSKOlpy2rlGr6nebwkOR
| duZbMvLQlT3I7HDKAq34oib0FqMSWfW6hTO5/SXLRtBdCuECAwEAAaNTMFEwHQYD
| VR0OBBYEFLCUOpUZ/lPzjF5ISXF4F0oGhgIRMB8GA1UdIwQYMBaAFLCUOpUZ/lPz
| jF5ISXF4F0oGhgIRMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEB
| AAXtfBkrLPVi5uAHPxcEhflsppPkOcdES3GyOGe5G5DzSWw20GUj1svSKzrv30K0
| JnXtNMy5spPSCd9kxoH9df+Wde+8vlDI8W+IPttpyvVNPzYUVg4KQy/Baz4ulRR2
| 2Rl/0FlJ0PX/ls0wTe1kwYT/5AnQTeEhKUPG+wd2IOpthqTAa7cgvx2T/mi7kfFs
| 8c1YJlASeNXwJs/IuNEUWVC6M8lsfVgZ748HlXSN5LgDfyEx1iNJdP0GMQlseWFG
| YtPiaL6RblnsO9a/0tltddKDGSh/M1oUbZvY72mIP2RWdfsRFf4bxLuiPIhVgJke
| F7A+B5cGfD1+i87Z8t8upj4=
|_-----END CERTIFICATE-----
|_http-server-header: Apache/2.4.37 (centos) OpenSSL/1.1.1c
|_ssl-date: TLS randomness does not represent time
|_http-title: 400 Bad Request
| http-methods: 
|_  Supported Methods: GET POST OPTIONS
9090/tcp  closed zeus-admin conn-refused
10000/tcp open   http       syn-ack      MiniServ 1.890 (Webmin httpd)
| http-methods: 
|_  Supported Methods: GET HEAD
|_http-title: Login to Webmin
|_http-server-header: MiniServ/1.890
|_http-trane-info: Problem with XML parsing of /evox/about
|_http-favicon: Unknown favicon MD5: 44B470A00E02390F1D26DCCF7273F203

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Aug 16 09:41:45 2024 -- 1 IP address (1 host up) scanned in 251.27 seconds

```

5 ports discovered and 4 ports open 22,80,443,10000

```shell
nmap -sCV -p- --min-rate=1000 -T4 10.201.149.200 -oN scan -vv
```

OS detection

```shell
# Nmap 7.94SVN scan initiated Fri Aug 16 09:46:24 2024 as: nmap -O -oN osscan.txt 10.201.149.200
Nmap scan report for 10.201.149.200
Host is up (0.16s latency).
Not shown: 976 filtered tcp ports (no-response), 19 filtered tcp ports (admin-prohibited)
PORT      STATE  SERVICE
22/tcp    open   ssh
80/tcp    open   http
443/tcp   open   https
9090/tcp  closed zeus-admin
10000/tcp open   snet-sensor-mgmt
Device type: storage-misc|general purpose
Running (JUST GUESSING): HP embedded (89%), Linux 3.X (85%)
OS CPE: cpe:/h:hp:p2000_g3 cpe:/o:linux:linux_kernel:3.1
Aggressive OS guesses: HP P2000 G3 NAS device (89%), Linux 3.1 (85%), Linux 3.2 (85%)
No exact OS matches for host (test conditions non-ideal).

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Aug 16 09:46:59 2024 -- 1 IP address (1 host up) scanned in 35.56 seconds

```

![[attachments/Pasted image 20240816094954.png]]

We get the operating system to be centos linux distribution

We also have a domain name of `thomaswreath.thm`

Include this in our `/etc/hosts` file

![[attachments/Pasted image 20240816095245.png]]

Now we can access the website

![[attachments/Pasted image 20240816095433.png]]

Directory and subdomain scan reveals nothing.

From our nmap scan we can see port 10000 running the service MiniServ 1.890 (Webmin httpd)

![[attachments/Pasted image 20240816102401.png]]

ssl error, so we change the protocol to https

![[attachments/Pasted image 20240816103449.png]]

# Webserver: Exploitation

searching for this specific version on google reveals it is vulnerable

![[attachments/Pasted image 20240816100932.png]]

using this exploit https://github.com/n0obit4/Webmin_1.890-POC


we have remote code execution

![[attachments/Pasted image 20240816103912.png]]

and we have rce as the root user

![[attachments/Pasted image 20240816104044.png]]

This exploit takes advantage of the vulnerable 'old' and 'expired' parameters of password_change.cgi.

we can easily get shell access by transferring a revshell script forcing the target to connect back to our netcat listener 

![[attachments/Pasted image 20240816105238.png]]

Now we have access as the root user, we don't need to perform any privilege escalation.

Although we can find a way to maintain persistence on this machine incase we eventually lose access.

One way is to obtain the private key of the root user. This can be found here `/root/.ssh/id_rsa` 

![[attachments/Pasted image 20240816105830.png]]

copy and paste the key onto your attack machine

we can attempt to crack it using ssh2john

![[attachments/Pasted image 20240816105943.png]]

Turns out there is no password so no need for cracking. We can just login as the root user via ssh.

Change the permissions and login

![[attachments/Pasted image 20240816110125.png]]

# Pivoting: Enumeration