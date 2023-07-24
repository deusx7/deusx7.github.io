hey, it been a while 

let run our nmap scan

```sh
┌──(sec-fortress㉿kali)-[~/PTD/10.150.150.146]                                                     
└─$ nmap --open 10.150.150.146

Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-22 19:20 EDT
Nmap scan report for 10.150.150.146
Host is up (0.15s latency).
Not shown: 717 closed tcp ports (conn-refused), 278 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
21/tcp   open  ftp
22/tcp   open  ssh
80/tcp   open  http
443/tcp  open  https
3306/tcp open  mysql   

Nmap done: 1 IP address (1 host up) scanned in 9.84 seconds      

┌──(sec-fortress㉿kali)-[~/PTD/10.150.150.146]                                                     
└─$ nmap -p21,22,80,443,3306 -sCV 10.150.150.146

Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-22 19:27 EDT
Nmap scan report for 10.150.150.146
Host is up (0.24s latency).                  
PORT     STATE SERVICE  VERSION
21/tcp   open  ftp?                          
| fingerprint-strings:                                                                        
|   GenericLines: 
|     220 ProFTPD Server (ProFTPD) [::ffff:10.150.150.146]                                    
|     Invalid command: try being more creative                                                
|_    Invalid command: try being more creative
22/tcp   open  ssh      OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:                         
|   3072 0f:e0:e4:6d:4b:ec:81:f2:e3:53:7f:eb:f0:8b:d1:c6 (RSA)                                
|   256 2c:20:a9:e1:ca:41:7c:a0:b7:81:77:ad:6b:ba:65:8c (ECDSA)                               
|_  256 70:81:8f:ef:2f:82:cf:52:7c:fb:7e:be:32:93:22:26 (ED25519)
80/tcp   open  http     Apache httpd 2.4.46 ((Unix) OpenSSL/1.1.1i PHP/7.4.14 mod_perl/2.0.11 Perl/v5.32.0)                                                                                  
|_http-server-header: Apache/2.4.46 (Unix) OpenSSL/1.1.1i PHP/7.4.14 mod_perl/2.0.11 Perl/v5.32.0
| http-title: FBC Engineering Reviewer System                                                 
|_Requested resource was http://10.150.150.146/reviewer/                  
443/tcp  open  ssl/http Apache httpd 2.4.46 ((Unix) OpenSSL/1.1.1i PHP/7.4.14 mod_perl/2.0.11 Perl/v5.32.0)                                                                                  
| http-title: FBC Engineering Reviewer System                                                 
|_Requested resource was https://10.150.150.146/reviewer/                                     
| tls-alpn:
|_  http/1.1                                                                                  
|_ssl-date: TLS randomness does not represent time                                            
|_http-server-header: Apache/2.4.46 (Unix) OpenSSL/1.1.1i PHP/7.4.14 mod_perl/2.0.11 Perl/v5.32.0
| ssl-cert: Subject: commonName=localhost/organizationName=Apache Friends/stateOrProvinceName=Berlin/countryName=DE
| Not valid before: 2004-10-01T09:10:30
|_Not valid after:  2010-09-30T09:10:30
3306/tcp open  mysql?
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port21-TCP:V=7.94%I=7%D=7/22%Time=64BC6600%P=x86_64-pc-linux-gnu%r(Gene
SF:ricLines,92,"220\x20ProFTPD\x20Server\x20\(ProFTPD\)\x20\[::ffff:10\.15
SF:0\.150\.146\]\r\n500\x20Invalid\x20command:\x20try\x20being\x20more\x20
SF:creative\r\n500\x20Invalid\x20command:\x20try\x20being\x20more\x20creat
SF:ive\r\n");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ . 
Nmap done: 1 IP address (1 host up) scanned in 257.47 seconds
```

Let start enumeration, starting with FTP

```bash
┌──(sec-fortress㉿kali)-[~/PTD/10.150.150.146]
└─$ ftp 10.150.150.146   
Connected to 10.150.150.146.
220 ProFTPD Server (ProFTPD) [::ffff:10.150.150.146]
Name (10.150.150.146:sec-fortress): anonymous
331 Password required for anonymous
Password: 
530 Login incorrect.
ftp: Login failed
ftp> 
```

well never expected less, nmap told us so

---

We also found out that `port 80` is open which is HTTP, navigating to the website, we get this:

![](https://i.imgur.com/qwXXjHN.png)

Nothing much even after `viewing-source`, Let perform a directory bruteforce with `gobuster`

```bash
┌──(sec-fortress㉿kali)-[~/PTD/10.150.150.146]
└─$ gobuster dir -u http://10.150.150.146/ -w ~/SecLists-master/Discovery/Web-Content/common.txt -b 401,400,400,501,402,404,403 -x bak,zip,php,PHP,txt,html -t 40 2>/dev/null 
===============================================================
Gobuster v3.4
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.150.150.146/
[+] Method:                  GET
[+] Threads:                 40
[+] Wordlist:                /home/sec-fortress/SecLists-master/Discovery/Web-Content/common.txt
[+] Negative Status codes:   402,404,403,401,400,501
[+] User Agent:              gobuster/3.4
[+] Extensions:              txt,html,bak,zip,php,PHP
[+] Timeout:                 10s
===============================================================
2023/07/23 19:05:55 Starting gobuster in directory enumeration mode
===============================================================
/applications.html    (Status: 200) [Size: 3607]
/dashboard            (Status: 301) [Size: 240] [--> http://10.150.150.146/dashboard/]
/favicon.ico          (Status: 200) [Size: 30894]
/img                  (Status: 301) [Size: 234] [--> http://10.150.150.146/img/]
/index.php            (Status: 302) [Size: 0] [--> http://10.150.150.146/reviewer/]
/webalizer            (Status: 301) [Size: 240] [--> http://10.150.150.146/webalizer/]

===============================================================
2023/07/23 19:11:59 Finished
===============================================================
```

- Navigating to /applications.html we have a random page//

![](https://i.imgur.com/1AFmzoA.png)

- Navigating to /dashboard, we get a 301 to /phpinfo.php giving us valuable able information about the web server, we are not meant to be able to view this page, you can know more form [here](https://serverfault.com/questions/194440/security-risks-of-having-public-phpinfo-page)

![](https://i.imgur.com/vlG9zp7.png)

- /Favicon.ico point to an image, nothing much there
- /img gives us an image directory with literally nothing

![](https://i.imgur.com/0jDS1or.png)

- /index.php leads us back to the default home page of the website
- /webalizer leads to a directory with nothing to

![](https://i.imgur.com/4yrCCRn.png)

---
## Change of Plan

Going back to the website i clicked **`Get started`** and was referred to a /login page:

![](https://i.imgur.com/iKANPC7.png)

Nice 😊😇

- [+] Tried default Credentials `admin:admin, admin:password` but none worked.
- [x] Going back to our nmap scan we found a suspicious service `3306/tcp open  mysql?`, then decided to try out SQL injection/
- [x] It worked with the query **`admin' OR 1'='1'--`** and we where presented with a dashboard 

![](https://i.imgur.com/KWTSVS9.png)

- Navigating to the `test bank`, we get FLAG3 and notice that the page is vulnerable to LFU (Local File Upload)

![](https://i.imgur.com/nFS4yao.png)


- We uploaded our shell and fuzz for where the file was stored using gobuster

```bash
┌──(sec-fortress㉿kali)-[~/PTD/10.150.150.146]
└─$ gobuster dir -u http://10.150.150.146/reviewer/system/system/admins/assessments/databank/ -w ~/SecLists-master/Discovery/Web-Content/common.txt -b 401,400,400,501,402,404,403 -x bak,zip,php,PHP,txt,html -t 40 2>/dev/null
===============================================================
Gobuster v3.4
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.150.150.146/reviewer/system/system/admins/assessments/databank/
[+] Method:                  GET
[+] Threads:                 40
[+] Wordlist:                /home/sec-fortress/SecLists-master/Discovery/Web-Content/common.txt
[+] Negative Status codes:   401,400,501,402,404,403
[+] User Agent:              gobuster/3.4
[+] Extensions:              zip,php,PHP,txt,html,bak
[+] Timeout:                 10s
===============================================================
2023/07/23 19:47:47 Starting gobuster in directory enumeration mode
===============================================================
/files                (Status: 301) [Size: 287] [--> http://10.150.150.146/reviewer/system/system/admins/assessments/databank/files/]

===============================================================
2023/07/23 19:11:59 Finished
===============================================================
```

- Nice, now we have our web shell

![](https://i.imgur.com/0T2EudA.png)

- Time to get a reverse shell

![](https://i.imgur.com/79uXKlU.png)

Now that we have our reverse shell, it is time to escalate priviledges and gain root

***checklist:**

- [ ] Any Kernel exploit 
- [ ] PATH Abuse
- [x] SUID
	- Below is how the exploit took place


![](https://i.imgur.com/yfaxvFB.gif)

Have Fun😊


