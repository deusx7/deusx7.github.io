<h3> Raz0rblack TryHackMe </h3>

Difficulty = Medium

Nmap Scan:

```
# Nmap 7.92 scan initiated Wed May  3 01:24:35 2023 as: nmap -sCV -p53,88,111,139,389,464,445,593,636,2049,3249,3268,3389,5985,9389 -oN nmapsan 10.10.84.28
Nmap scan report for 10.10.84.28
Host is up (0.43s latency).

PORT     STATE  SERVICE       VERSION
53/tcp   open   domain        Simple DNS Plus
88/tcp   open   kerberos-sec  Microsoft Windows Kerberos (server time: 2023-05-03 00:24:45Z)
111/tcp  open   rpcbind       2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/tcp6  rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  2,3,4        111/udp6  rpcbind
|   100003  2,3         2049/udp   nfs
|   100003  2,3         2049/udp6  nfs
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/tcp6  nfs
|   100005  1,2,3       2049/tcp   mountd
|   100005  1,2,3       2049/tcp6  mountd
|   100005  1,2,3       2049/udp   mountd
|   100005  1,2,3       2049/udp6  mountd
|   100021  1,2,3,4     2049/tcp   nlockmgr
|   100021  1,2,3,4     2049/tcp6  nlockmgr
|   100021  1,2,3,4     2049/udp   nlockmgr
|   100021  1,2,3,4     2049/udp6  nlockmgr
|   100024  1           2049/tcp   status
|   100024  1           2049/tcp6  status
|   100024  1           2049/udp   status
|_  100024  1           2049/udp6  status
139/tcp  open   netbios-ssn   Microsoft Windows netbios-ssn
389/tcp  open   ldap          Microsoft Windows Active Directory LDAP (Domain: raz0rblack.thm, Site: Default-First-Site-Name)
445/tcp  open   microsoft-ds?
464/tcp  open   kpasswd5?
593/tcp  open   ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp  open   tcpwrapped
2049/tcp open   mountd        1-3 (RPC #100005)
3249/tcp closed ssp
3268/tcp open   ldap          Microsoft Windows Active Directory LDAP (Domain: raz0rblack.thm, Site: Default-First-Site-Name)
3389/tcp open   ms-wbt-server Microsoft Terminal Services
| rdp-ntlm-info: 
|   Target_Name: RAZ0RBLACK
|   NetBIOS_Domain_Name: RAZ0RBLACK
|   NetBIOS_Computer_Name: HAVEN-DC
|   DNS_Domain_Name: raz0rblack.thm
|   DNS_Computer_Name: HAVEN-DC.raz0rblack.thm
|   Product_Version: 10.0.17763
|_  System_Time: 2023-05-03T00:25:46+00:00
|_ssl-date: 2023-05-03T00:25:56+00:00; 0s from scanner time.
| ssl-cert: Subject: commonName=HAVEN-DC.raz0rblack.thm
| Not valid before: 2023-05-02T00:23:23
|_Not valid after:  2023-11-01T00:23:23
5985/tcp open   http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
9389/tcp open   mc-nmf        .NET Message Framing
Service Info: Host: HAVEN-DC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time: 
|   date: 2023-05-03T00:25:48
|_  start_date: N/A
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled and required

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed May  3 01:26:42 2023 -- 1 IP address (1 host up) scanned in 127.55 seconds
```

That's a lot of ports classic windows 😹

We can see the domain name as *raz0rblack.thm* so i added it to my */etc/hosts* file

First lets start from port 2049 which is usually nfs

I'll check what mount is available there

```
➜  pwn showmount -e raz0rblack.thm
Export list for raz0rblack.thm:
/users (everyone)
➜  pwn
```

Cool we can mount the *users* share over to our host
![image](https://user-images.githubusercontent.com/127159644/235819021-aaced37f-eb85-452a-86f1-cbf365cf512c.png)

The *sbradley.txt* file contains a flag 

But checking the .xlsx file shows a list of usernames
![image](https://user-images.githubusercontent.com/127159644/235819299-2f9af96d-05af-4974-b445-eec2c89d3365.png)

So i can compiled the names to a file then used a [script](https://github.com/PinkDraconian/CTF-bash-tools/blob/master/scripts/ctf-wordlist-names.sh) to convert them to the way AD does its naming
![image](https://user-images.githubusercontent.com/127159644/235819517-3f661c9a-e1fa-4c42-aca7-8009b41c3e7e.png)

From here I can try validating some of the users in the list using kerbrute then I can proceed by doing ASREP roasting
![image](https://user-images.githubusercontent.com/127159644/235819632-33e33f23-2f02-49f9-a631-80a4927e3deb.png)

Now we have three valid users. Saving it in a list and performing ASREP roasting gives the hash of the user *twilliams*
![image](https://user-images.githubusercontent.com/127159644/235819820-c8aaf949-984e-4183-824b-a57853e5ae51.png)

Using *John The Ripper* I'll brute force the password hash
![image](https://user-images.githubusercontent.com/127159644/235819889-c1878002-88a3-41f8-85ee-0eedc8744f57.png)

Nice we have the cred for user *twilliams* as *roastpotatoes*

At this point lets check out smb
![image](https://user-images.githubusercontent.com/127159644/235820151-adc3014a-d538-451c-9344-5346da3ec970.png)

We can see that the user *twilliams* has read access over the *IPC$* share. With this we can brute force RID's and get other users on the box

Using crackmapexec it can be achieved 
![image](https://user-images.githubusercontent.com/127159644/235820397-31a98f54-3022-485c-9dae-78cdf7925697.png)

Cool we have new users that we can add to our list and perharps try doing password spray on them

```
[Users]

lvetrova
twilliams
sbradley
xyan1d3
```

Performing password spray shows that user *sbradley* password has expired
![image](https://user-images.githubusercontent.com/127159644/235820922-6ccec17d-abf7-40b6-acf0-acf5afa20fa1.png)

We can reset the password to anything new 
pwnerhaxor@123

