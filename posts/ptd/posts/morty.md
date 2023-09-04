# Morty

***
## Difficulty = Medium
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/15a53e34-7085-4916-b0b7-7d1814091ce7)

***

First of all, let run our nmap scan

```shell
# Nmap 7.94 scan initiated Sun Sep  3 15:37:00 2023 as: nmap -p- -sVC -v --min-rate=1000 -T4 -oN nmap.txt 10.150.150.57
Increasing send delay for 10.150.150.57 from 0 to 5 due to 109 out of 272 dropped probes since last increase.
Increasing send delay for 10.150.150.57 from 5 to 10 due to 11 out of 11 dropped probes since last increase.
Nmap scan report for 10.150.150.57
Host is up (0.21s latency).
Not shown: 65131 filtered tcp ports (no-response), 401 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 e8:60:09:66:aa:1f:e8:76:d8:84:16:18:1c:e4:ee:32 (RSA)
|   256 92:09:d3:0e:f9:47:48:03:9f:32:9f:0f:17:87:c2:a4 (ECDSA)
|_  256 1d:d1:b3:2b:24:dc:c2:8a:d7:ca:44:39:24:c3:af:3d (ED25519)
53/tcp open  domain  ISC BIND 9.16.1 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.16.1-Ubuntu
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-title: Index of /
| http-ls: Volume /
| SIZE  TIME              FILENAME
| 147   2020-06-10 11:25  note.html
|_
|_http-server-header: Apache/2.4.41 (Ubuntu)
| http-methods: 
|_  Supported Methods: GET POST OPTIONS HEAD
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sun Sep  3 15:42:50 2023 -- 1 IP address (1 host up) scanned in 350.36 seconds
```

Checking Port `80/HTTP` we have a note.html file, that says

```
Morty,  
if you read this: I've already configured your domain 'mortysserver.com' on this server, don't bother me with it anymore!!  
-Rick
```

![](https://i.imgur.com/f8atRIZ.png)

Since we have been referred to **mortysserver.com** , we will add it to our `/etc/hosts` file , Navigating to **mortysserver.com** we have another website that seems like a password clue , `Fl4sk#!`

![](https://i.imgur.com/nsok2MH.png)


Viewing `Page-Source` we have a `screen.jpeg` file, we can download and analyze it to see if we can extract information from it

![](https://i.imgur.com/XdgAhmQ.png)

At first it doesn't seem like there is any embedded data, but using the password we got earlier to decrypt hidden information in the **screen.jpeg** file, we found a `TXT` file

![](https://i.imgur.com/kxDYKHf.png)

```shell
sec-fortress@Pwn-F0rk-3X3C:~/PTD/morty$ cat keytotheuniverse.txt 
rick:WubbaLubbaDubDub1!
```

The content of the file looks like a credential, Tried it for `SSH` but didn't work, We have port `53/DNS` opened, so we can do a zone transfer

![](https://i.imgur.com/mg6a8hd.png)

Nice we have **rickscontrolpanel.mortysserver.com** subdomain, add it to your `/etc/hosts` file and Navigate to the website, In which we have a **PhpMyAdmin** page

![](https://i.imgur.com/QKIlf9M.png)

Trying out the credentials we found earlier , which is `rick:WubbaLubbaDubDub1!` , we got a successfully login 🤟 , Also we found **FLAG2.txt** and we now know that the website uses **PhpMyAdmin Version - 4.8.1**

![](https://i.imgur.com/cxJOvWE.png)

Enumerating that version, we find an exploit, you can get it from [here](https://www.exploit-db.com/exploits/50457) , Note that there is also a manual method to get shell

![](https://i.imgur.com/yfx4iDf.png)

![](https://i.imgur.com/23sR0vL.png)

Since we can execute commands {RCE}, then definitely, we can send a `PHP` reverse shell to the target then load it up on our browser

![](https://i.imgur.com/OcxCIIT.png)

Now we can navigate to **/fuck.php** on the website, but first of all make sure you start your Netcat listener with the right IP Address and Port (Note: If you are not getting back a shell, Use Pentest Monkey payload, You can get it from [here](https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php))

![](https://i.imgur.com/tZ7SSuB.png)

![](https://i.imgur.com/QFrTa40.png)

I tried to perform Privilege Escalation, But i don't think it is possible because we have found **FLAG3.txt** , which is located under the User **morty** home's directory

Big shout out to [wizlynxgroup](https://www.wizlynxgroup.com/) and [Pwntilldawn](https://online.pwntilldawn.com/)


