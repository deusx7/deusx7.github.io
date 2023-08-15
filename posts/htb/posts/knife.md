# Knife

![Uploading image.png…]()

## Difficulty = Easy
---
Running our `Nmap` scan gives us this :

```sh
# Nmap 7.94 scan initiated Tue Aug 15 15:14:43 2023 as: nmap -p- -sCV -v --min-rate=1000 -T4 -oN nmap.txt 10.10.10.242
Warning: 10.10.10.242 giving up on port because retransmission cap hit (6).
Nmap scan report for 10.10.10.242
Host is up (0.38s latency).
Not shown: 43005 filtered tcp ports (no-response), 22528 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 be:54:9c:a3:67:c3:15:c3:64:71:7f:6a:53:4a:4c:21 (RSA)
|   256 bf:8a:3f:d4:06:e9:2e:87:4e:c9:7e:ab:22:0e:c0:ee (ECDSA)
|_  256 1a:de:a1:cc:37:ce:53:bb:1b:fb:2b:0b:ad:b3:f6:84 (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-title:  Emergent Medical Idea
|_http-server-header: Apache/2.4.41 (Ubuntu)
| http-methods: 
|_  Supported Methods: GET HEAD POST
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Tue Aug 15 15:22:17 2023 -- 1 IP address (1 host up) scanned in 453.52 seconds
```

Since Port 80/HTTP is opened, i decided to run a dir/file scan with `ffuf` first :

![](https://i.imgur.com/9zNGc3s.png)

`ffuf` doesn't seems to be giving me what i want, so let us check the website :

![](https://i.imgur.com/V6RCP5d.png)

- [ ] The website doesn't seems to be responsive.
- [ ]  `robots.txt` isn't available.
- [ ] No directories ❌ No files ❌.

Checking the Technologies gives us little Impression, i mean i hardly see websites with `PHP` versions

![](https://i.imgur.com/zT3Uh9q.png)

Enumerating the PHP version, looks like it is vulnerable to RCE in the `user-agent` :

![](https://i.imgur.com/Gm8liXg.png)

This [exploit](https://github.com/flast101/php-8.1.0-dev-backdoor-rce/blob/main/revshell_php_8.1.0-dev.py) works best, Now let run it

![exploit](https://i.imgur.com/bLI58ng.png)

Which definitely should give you a shell back :

![shell](https://i.imgur.com/DLz4zzI.png)

---
#### Privilege Escalation

- Running `sudo -l` tells us we can run `/usr/bin/knife` with sudo permissions

![](https://i.imgur.com/DGEScpU.png)

- Checking `GTFOBINS` we have a payload to escalate privileges using `knife` :

![](https://i.imgur.com/RGophOu.png)

- Then using the payload gives us root, you can tweak the payload to this `sudo knife exec -E 'exec "/bin/bash"'` :

![](https://i.imgur.com/jutXDrm.png)

Bankaii 🧘‍♀️

