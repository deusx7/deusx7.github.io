
# Reset

![](attachments/20240528132945.png)
Step into the shoes of a red teamer in our simulated hack challenge!   
Navigate a realistic organizational environment with up-to-date defenses. 

Test your penetration skills, bypass security measures, and infiltrate into the system. Will you emerge victorious as you simulate the ultimate organization APT?

Find all the flags!

The VM may take about 5 minutes to completely boot.

# Nmap Scan


```shell
# Nmap 7.94SVN scan initiated Tue May 28 13:31:29 2024 as: nmap -sCV -p- --min-rate=1000 -T4 -oN scan -vv 10.10.201.127
Nmap scan report for 10.10.201.127
Host is up, received echo-reply ttl 127 (0.17s latency).
Scanned at 2024-05-28 13:31:29 WAT for 238s
Not shown: 65514 filtered tcp ports (no-response)
PORT      STATE SERVICE       REASON          VERSION
53/tcp    open  domain        syn-ack ttl 127 Simple DNS Plus
88/tcp    open  kerberos-sec  syn-ack ttl 127 Microsoft Windows Kerberos (server time: 2024-05-28 12:33:47Z)
135/tcp   open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
139/tcp   open  netbios-ssn   syn-ack ttl 127 Microsoft Windows netbios-ssn
389/tcp   open  ldap          syn-ack ttl 127 Microsoft Windows Active Directory LDAP (Domain: thm.corp0., Site: Default-First-Site-Name)
445/tcp   open  microsoft-ds? syn-ack ttl 127
464/tcp   open  kpasswd5?     syn-ack ttl 127
593/tcp   open  ncacn_http    syn-ack ttl 127 Microsoft Windows RPC over HTTP 1.0
636/tcp   open  tcpwrapped    syn-ack ttl 127
3268/tcp  open  ldap          syn-ack ttl 127 Microsoft Windows Active Directory LDAP (Domain: thm.corp0., Site: Default-First-Site-Name)
3269/tcp  open  tcpwrapped    syn-ack ttl 127
3389/tcp  open  ms-wbt-server syn-ack ttl 127 Microsoft Terminal Services
| ssl-cert: Subject: commonName=HayStack.thm.corp
| Issuer: commonName=HayStack.thm.corp
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2024-01-25T21:01:31
| Not valid after:  2024-07-26T21:01:31
| MD5:   1593:b46f:8770:a73a:9649:f3ec:e9ad:c968
| SHA-1: 9d45:4568:8ee5:2758:e3cc:26ff:e0ca:23db:5ae6:017e
| -----BEGIN CERTIFICATE-----
| MIIC5jCCAc6gAwIBAgIQYX4tgCrderNB4R+8ZsmEBTANBgkqhkiG9w0BAQsFADAc
| MRowGAYDVQQDExFIYXlTdGFjay50aG0uY29ycDAeFw0yNDAxMjUyMTAxMzFaFw0y
| NDA3MjYyMTAxMzFaMBwxGjAYBgNVBAMTEUhheVN0YWNrLnRobS5jb3JwMIIBIjAN
| BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApK21ITU7iV1Yu2/DdUVw5vAc/DyD
| SF9w27iyDoRL85CgxAkLCE9XBxyT3qNbNUqeRBefM9MmBbJ/jYu29zrDOyA8CrP5
| IfwjLJrHcM8SzyABPGudOdRFf1zKbR0coVhfEZtgIy81+412CFDTYf3nuXwJR3sV
| 1R+DJLUmj9yfvvXpSzzZLj3t2mAiyAPZHCuALOyw3bmh7zKe0+//hcnvrm8f2Hkj
| ucqukdj9Dbq+cqfjTIbwitvkyB9OOoII0HwQWZ026f39ZkB03296If7QMnRexyEg
| udOOK57aMUMfNmDkLmVFJrN/txa+7ghoSRnhpZCQuUFwXlkAO6o3LZwECQIDAQAB
| oyQwIjATBgNVHSUEDDAKBggrBgEFBQcDATALBgNVHQ8EBAMCBDAwDQYJKoZIhvcN
| AQELBQADggEBACVA2CvbsLEtSlT+tpousDWKBzfJQ4BpagvEJ0JO5Fd2GnMfXR9Z
| Oh4V4pMmb+b/NeBfrJ/7RoU/pSLxGhnd8kha1mv4UouY97H5WlORLO15r1H7gfvh
| ++C4MU+XKAeuiCHGSfecy1DZITt9jpuNf3eddYb65pSAUWU7QkJv9V6KvKNgzDfV
| nQogWNc7sdbHYlxHgBMs5CS0CivROnlcO9gLpKZlWOZTi+4gERTfLNz2ZeVSW9e+
| HxXgn7sOWLvybZ+1vTSCUguD+Ym4CLTor8N8ud+4FE8qews+EBBm5XNmn8yDJCU9
| Ct+iYlQVJMreg70HXzvODmD+sqzu7ijcVFo=
|_-----END CERTIFICATE-----
|_ssl-date: 2024-05-28T12:35:19+00:00; 0s from scanner time.
| rdp-ntlm-info: 
|   Target_Name: THM
|   NetBIOS_Domain_Name: THM
|   NetBIOS_Computer_Name: HAYSTACK
|   DNS_Domain_Name: thm.corp
|   DNS_Computer_Name: HayStack.thm.corp
|   DNS_Tree_Name: thm.corp
|   Product_Version: 10.0.17763
|_  System_Time: 2024-05-28T12:34:40+00:00
5985/tcp  open  http          syn-ack ttl 127 Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-title: Not Found
|_http-server-header: Microsoft-HTTPAPI/2.0
7680/tcp  open  pando-pub?    syn-ack ttl 127
9389/tcp  open  mc-nmf        syn-ack ttl 127 .NET Message Framing
49669/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49670/tcp open  ncacn_http    syn-ack ttl 127 Microsoft Windows RPC over HTTP 1.0
49671/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49674/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49675/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49699/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
Service Info: Host: HAYSTACK; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled and required
|_clock-skew: mean: 0s, deviation: 0s, median: 0s
| p2p-conficker: 
|   Checking for Conficker.C or higher...
|   Check 1 (port 20039/tcp): CLEAN (Timeout)
|   Check 2 (port 28889/tcp): CLEAN (Timeout)
|   Check 3 (port 64010/udp): CLEAN (Timeout)
|   Check 4 (port 40298/udp): CLEAN (Timeout)
|_  0/4 checks are positive: Host is CLEAN or ports are blocked
| smb2-time: 
|   date: 2024-05-28T12:34:40
|_  start_date: N/A

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Tue May 28 13:35:27 2024 -- 1 IP address (1 host up) scanned in 237.79 seconds
```

Syntax

```shell
nmap -sCV -p- --min-rate=1000 -T4 <IP> -oN scan -vv
```

First up from the scan output we can see the domain name is thm.corp so we add this to the `/etc/hosts` file

![](attachments/20240528133844.png)

Next we have some notable ports open

- 88
- 135
- 389
- 445
- 3389???
# SMB Enumeration

Using smbclient 

![](attachments/20240528134141.png)

We have some shares. The one that stands out is `Data` so let's check it out

![](attachments/20240528134350.png)

Download all files found in the onboarding directory. For some reason i can't download the last pdf.

In the txt file we can get a password

![](attachments/20240528134522.png)

The PDF has no useful information.

Using smbmap for better info, it shows we have read and write access to the `Data` Share

![](attachments/20240528134918.png)

And we have read access to the `IPC$` share that contains a lot of files.

No Access for the rest

![](attachments/20240528135003.png)

User enumeration using `netexec`

![](attachments/20240528140246.png)

Extract only the names and put in a text file so we can have a username wordlist for brute forcing

Since we have kerberos running on the target we can use a tool like kerbrute to enumerate 

![](attachments/20240528140527.png)

All users are valid

#  # AS-REP Roasting

With these valid names we can try to retrieve kerberos tickets using a tool `GetNPUsers`. This _will allow us to query ASReproastable accounts from the Key Distribution Center. The only thing that’s necessary to query accounts is a valid set of usernames which we enumerated previously via Kerbrute._

Impacket Syntax:

```shell
impacket-GetNPUsers DOMAIN/user -no-pass
```

![](attachments/20240528141055.png)

copy these hashes and paste in a file so we can crack them

copy the hash into a file and crack using hashcat. The hashcat mode is `18200`

![](https://deusx7.github.io/Posts/THM/Writeups/VulnNet_Roasted/attachments/20240524114731.png)

```shell
hashcat -m 18200 hash.txt /usr/share/wordlists/rockyou.txt
```

Only one was cracked

![](attachments/20240528142848.png)

# Kerberoasting

With these we can then perform kerberoasting using the impacket tool `GetUserSPNs`

![](attachments/20240528143128.png)

We have a couple of accounts

Add the `-request` switch to get the hashes for the accounts

![](attachments/20240528143251.png)

That's a lot of hashes

copy all and crack the hashes using hashcat. The mode is `13100`

![](https://deusx7.github.io/Posts/THM/Writeups/VulnNet_Roasted/attachments/20240524122934.png)

The hashes won't crack 

![](attachments/20240528144030.png)

At this point i was stuck and didn't know where else to check so i decided to try downloading that one pdf that refused to download earlier and for some reason it worked this time.

In the content of this pdf we can find a user and a the same password we got earlier.

![](attachments/20240529134612.png)

Still nothing so after much research i decided to try and steal NTLM hashes with responder.

# Stealing NTLM Hash

I read this blog as a guide: https://www.hackingarticles.in/multiple-files-to-capture-ntlm-hashes-ntlm-theft/

Follow the steps

![](attachments/20240529143945.png)

![](attachments/20240529144034.png)

![](attachments/20240529144320.png)

It didn't work so i uploaded the `.lnk` file instead

![](attachments/20240529144515.png)

and i got the hash

![](attachments/20240529144549.png)

place the hash inside a file and crack, the mode is `5600`

![](attachments/20240529145112.png)

so now we have the password for the user `AUTOMATE`

Using evil-winrm, we can login

![](attachments/20240529145237.png)

Look for user flag and submit.

# Privilege Escalation

Running `whoami /all` to check the user privileges doesn't reveal anything useful

![](attachments/20240529150100.png)

Next is to transfer sharphound and use bloodhound to get a better view

![](attachments/20240529150343.png)

The file keeps getting deleted, looks like there is antivirus enabled

![](attachments/20240529150613.png)

No need for running sharphound on the machine though, since there is LDAP protocol.

we can just run

```shell
bloodhound-python -ns TARGET IP --dns-tcp -d thm.corp -u AUTOMATE -p PASSWORD -d thm.corp -c all --zip
```

![](attachments/20240529155209.png)

Unzip it

![](attachments/20240529155230.png)

Import the json files

Drag and drop

![](attachments/20240529155516.png)

We are able to get list of AS-REP Roastable users who don't require preauthentication

![](attachments/20240529160531.png)

We can see the user `TABATHA_BRIT` whose password we have already obtained earlier via AS-REP Roasting

Now we can check the shortest path to domain through the user

![](attachments/20240529161553.png)

But this route doesn't work

Quick tip is to first of all mark TABATHA as owned

![](attachments/20240529165531.png)

Then search for domain computers and select shortest path from owned

![](attachments/20240529165918.png)

![](attachments/20240529170013.png)

This shows 

- Tabatha has `GenericAll` access to Shawna
- Shawna has `ForgetChangePassword` to Cruz
- Cruz has `GenericWrite` to Darla
- and Darla is a `MemberOf` Domain Computers

Since we have `GenericAll` access we can just change the password 

![](attachments/20240529170714.png)

Now login as the user

![](attachments/20240529170950.png)

Next up `ForgotChangePassword` to Cruz

I ran the `runas.exe` to spawn a cmd shell as the user shawna and then tried using net command to change the password of cruz but it didn't workout

![](attachments/20240529172108.png)

![](attachments/20240529172122.png)

To exploit this, bloodhound already has suggestions for you.

Just right click on what you need and select help

![](attachments/20240529172900.png)

Select linux abuse and you'll  see the command to run

![](attachments/20240529172941.png)


![](attachments/20240529172825.png)

Now rdp as the user cruz with the new password

![](attachments/20240529173034.png)

![](attachments/20240529173016.png)


Next up, cruz has `GenericWrite` to Darla

Checking bloodhound on how to exploit this

![](attachments/20240529173242.png)

The tool can be cloned from this repo: https://github.com/ShutdownRepo/targetedKerberoast.git

Run it with the creds for the cruz user

![](attachments/20240529174450.png)

Then copy the hash for darla and crack it.

The hash didn't crack but even better, we can just reset the password using `net rpc` like we did earlier

![](attachments/20240529194536.png)

Infact we could have just done this to all the account right from the beginning

![](attachments/20240529194607.png)

Now we have access to the user darla

Checking back on bloodhound we can see the user is allowed to delegate to haystack.thm.corp

![](attachments/20240529195540.png)

Bloodhound gives a detailed explanation about this 

![](attachments/20240529195700.png)

Checking the suggestion shw
Taking a look at this blog gives an idea on how to perform this attack https://www.alteredsecurity.com/post/resource-based-constrained-delegation-rbcd (start from step 3)

Bloodhound gives a suggestion to use `getst` which is part of the impacket toolkit. This will request a service ticket and save it as a ccahe. Then since we have constrained delegation privileges, we will be able to impersonate the admin user.

- Export the file name which it was saved to
- **Remember to add `haystack.thm.corp` to your /etc/hosts file**

 Then using wmiexec we can login as the admin user. wmiexec is able to read the `KRB5CCNAME` variable which is what allows us to login successfully.

Get a shell as the admin user and find the flag.
 
![](attachments/20240529201640.png)

GGs 🤝

