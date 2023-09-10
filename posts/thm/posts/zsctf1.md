# ZSCTF1

***
## Difficulty = Easy 

![httptryhackme comjrzsecurityctf1](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/644b686a-46d2-44ca-a6ec-73c35985e4ce)

***

Running our nmap scan we have a long list of open ports {I have a feeling this gonna be fun 😅🤟}

```shell
# Nmap 7.94 scan initiated Thu Sep  7 04:50:02 2023 as: nmap -p- -sVC -v --min-rate=1000 -T4 -oN nmap.txt 10.10.199.105
Warning: 10.10.199.105 giving up on port because retransmission cap hit (6).
Nmap scan report for 10.10.199.105
Host is up (0.28s latency).
Not shown: 65368 closed tcp ports (conn-refused), 149 filtered tcp ports (no-response)
PORT      STATE SERVICE     VERSION
25/tcp    open  ftp         vsftpd 3.0.2
|_smtp-commands: SMTP: EHLO 530 Please login with USER and PASS.\x0D
80/tcp    open  http        Apache httpd 2.4.7 ((Ubuntu))
|_http-server-header: Apache/2.4.7 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
111/tcp   open  rpcbind     2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|   100000  3,4          111/udp6  rpcbind
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/tcp6  nfs
|   100003  2,3,4       2049/udp   nfs
|   100003  2,3,4       2049/udp6  nfs
|   100005  1,2,3      37409/udp6  mountd
|   100005  1,2,3      44504/udp   mountd
|   100005  1,2,3      48875/tcp   mountd
|   100005  1,2,3      57998/tcp6  mountd
|   100021  1,3,4      40916/tcp   nlockmgr
|   100021  1,3,4      41317/udp   nlockmgr
|   100021  1,3,4      47649/tcp6  nlockmgr
|   100021  1,3,4      53219/udp6  nlockmgr
|   100024  1          35905/udp   status
|   100024  1          44875/tcp6  status
|   100024  1          48654/tcp   status
|   100024  1          54728/udp6  status
|   100227  2,3         2049/tcp   nfs_acl
|   100227  2,3         2049/tcp6  nfs_acl
|   100227  2,3         2049/udp   nfs_acl
|_  100227  2,3         2049/udp6  nfs_acl
139/tcp   open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp   open  netbios-   Samba smbd 4.1.6-Ubuntu (workgroup: WORKGROUP)
1322/tcp  open  ssh         OpenSSH 6.6.1p1 Ubuntu 2ubuntu2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   1024 17:32:b4:85:06:20:b6:90:5b:75:1c:6e:fe:0f:f8:e2 (DSA)
|   2048 53:49:03:32:86:0b:15:b8:a5:f1:2b:8e:75:1b:5a:06 (RSA)
|   256 3b:03:cd:29:7b:5e:9f:3b:62:79:ed:dc:82:c7:48:8a (ECDSA)
|_  256 11:99:87:52:15:c8:ae:96:64:73:d6:49:8c:d7:d7:9f (ED25519)
2049/tcp  open  nfs         2-4 (RPC #100003)
6379/tcp  open  redis       Redis key-value store 3.0.7
8080/tcp  open  http        Apache Tomcat/Coyote JSP engine 1.1
|_http-server-header: Apache-Coyote/1.1
| http-methods: 
|   Supported Methods: GET HEAD POST PUT DELETE OPTIONS
|_  Potentially risky methods: PUT DELETE
|_http-title: Apache Tomcat
8081/tcp  open  http        Apache httpd 2.4.7 ((Ubuntu))
| http-robots.txt: 14 disallowed entries 
| /administrator/ /cache/ /components/ /images/ 
| /includes/ /installation/ /language/ /libraries/ /media/ 
|_/modules/ /plugins/ /templates/ /tmp/ /xmlrpc/
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: Welcome to the Frontpage
|_http-generator: Joomla! 1.5 - Open Source Content Management
9000/tcp  open  http        Jetty winstone-2.9
| http-robots.txt: 1 disallowed entry 
|_/
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: Dashboard [Jenkins]
|_http-favicon: Unknown favicon MD5: 23E8C7BD78E8CD826C5A6073B15068B1
38914/tcp open  mountd      1-3 (RPC #100005)
40916/tcp open  nlockmgr    1-4 (RPC #100021)
48654/tcp open  status      1 (RPC #100024)
48875/tcp open  mountd      1-3 (RPC #100005)
49733/tcp open  mountd      1-3 (RPC #100005)
52376/tcp open  unknown
| fingerprint-strings: 
|   DNSStatusRequestTCP: 
|     Unrecognized protocol:
|   DNSVersionBindReqTCP: 
|     Unrecognized protocol: 
|     version
|_    bind
52505/tcp open  ssh         Apache Mina sshd 0.8.0 (protocol 2.0)
| ssh-hostkey: 
|_  2048 97:bb:2c:13:54:2f:88:0d:00:c6:80:24:30:d6:29:54 (RSA)
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port52376-TCP:V=7.94%I=7%D=9/7%Time=64F98F35%P=x86_64-pc-linux-gnu%r(DN
SF:SVersionBindReqTCP,36,"Unrecognized\x20protocol:\x20\0\x06\x01\0\0\x01\
SF:0\0\0\0\0\0\x07version\x04bind\0\0\x10\0\x03\n")%r(DNSStatusRequestTCP,
SF:24,"Unrecognized\x20protocol:\x20\0\0\x10\0\0\0\0\0\0\0\0\0\n");
Service Info: Host: CTF; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-time: 
|   date: 2023-09-07T08:53:59
|_  start_date: N/A
|_clock-skew: mean: -59m59s, deviation: 1h43m53s, median: -1s
| nbstat: NetBIOS name: CTF, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| Names:
|   CTF<00>              Flags: <unique><active>
|   CTF<03>              Flags: <unique><active>
|   CTF<20>              Flags: <unique><active>
|   \x01\x02__MSBROWSE__\x02<01>  Flags: <group><active>
|   WORKGROUP<00>        Flags: <group><active>
|   WORKGROUP<1d>        Flags: <unique><active>
|_  WORKGROUP<1e>        Flags: <group><active>
| smb2-security-mode: 
|   3:0:0: 
|_    Message signing enabled but not required
| smb-os-discovery: 
|   OS: Unix (Samba 4.1.6-Ubuntu)
|   NetBIOS computer name: CTF\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2023-09-07T11:53:56+03:00

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Thu Sep  7 04:54:20 2023 -- 1 IP address (1 host up) scanned in 257.91 seconds
```

### PORT 25/SMTP

+ Looking at our nmap scan, nmap was successful on connecting to the **target** , but we still need to confirm these which is true

![](https://i.imgur.com/wGEjEZM.png)

**VERSION ENUMERATION**

![](https://i.imgur.com/hL7RCEw.png)

### PORT 80/HTTP

- We don't seem to be getting any leads here too, It looks like some wget to the file `main2.html` is done outside of our VPN network, so we don't have access to this

![](https://i.imgur.com/xAgxnxR.png)

- Running **FFUF** {Directory Bruteforce} we have 3 good entries which is cool 

![](https://i.imgur.com/6WF13sj.png)

- `/javascript` and `/test` doesn't to give alot of information, so we are typically interested in `phpmyadmin` whereas we need a password and username 😭
### PORT 2049/NFS

- Running `showmount -e 10.10.199.105` shows us that we can mount **/backup**

```shell
sec-fortress@Pwn-F0rk-3X3C:~/THM/ZSCTF1$ showmount -e 10.10.199.105       
Export list for 10.10.199.105:
/backup *
```

We can then mount this **/backup** by doing :

- `mkdir /tmp/bankai`
- `sudo mount -t nfs 10.10.199.105:/backup /tmp/bankai -nolock`
- `cd /tmp/bankai`

Once all this is done, doing `ls` we can see we have a **backup.tar.bz2.zip** file, which when trying to unzip asks us for a password 😆

![](https://i.imgur.com/LHeBT16.png)

Using a tool called **fcrackzip** , i was able to bruteforce the password, You can install it with `sudo apt install fcrackzip` , Then bruteforce the file with the exact same syntax used in the JPEG below

![](https://i.imgur.com/wmM1Byf.png)

Trying to unzip the file it looks like we can't at first cos' it is read-only, but unzipping it to my **/tmp** directory works 😁

![](https://i.imgur.com/Qw3KpnC.png)

Great !!!, so we can go ahead and decompress this archive till we finally get a file or folder {I just don't want to agree this is a rabbit hole 😿}

![](https://i.imgur.com/n04yWb2.png)

We knew it this are config files of web applications, I can literally see the famous **DVWA** , urrhhhh 🤣 (Well am pretty happy i was able to see the end of this archive, so let move on)

![](https://i.imgur.com/F48vb6D.png)

Also you might want to run `grep --color=auto -rnw '/home/sec-fortress/THM/ZSCTF1/html' -ie "Pass" --color=always 2>/dev/null` to check for any file containing passwords, Just saying we might need it later
### PORT 139/445/SMB

We don't seem to have any luck here too, we have 2 shares `IPC$` and `print$` , On successful connection to `IPC$` we can't run commands Neither can we even connect to `print$` 

![](https://i.imgur.com/wpxrTjw.png)

### PORT 8081/Joomla
 
**I DECIDED TO JUMP TO THESE COS' THIS IS THE ONLY PROTOCOL NMAP GAVE ME ALOT OF INFORMATION ABOUT, INCLUDING DIRECTORIES**

Navigating to the `/administrator` page, we have a login page, saying "Can You Pwn me" 😂, Literally i tried out several default credentials, brute-forced and even enumerated the previous `backup.tar.bz2.zip` file we found on the **NFS** share.

![](https://i.imgur.com/75Pk0lv.png)

Nevertheless !! We have a tool called `joomscan` , it can be installed and used with the following command syntax below 

```shell
1337>$ sudo apt install joomscan
1337>$ joomscan --url http://10.10.214.35:8081/  
```

Running this tool gave us exactly what we wanted, a way to bypass that page or something and we got a **Remote Admin Change Password** Exploit.

![](https://i.imgur.com/aOGPPBD.png)

_Steps to Produce :_

- Navigate to `/index.php?option=com_user&view=reset&layout=confirm` on the website and you should see a **Confirm your account** page asking for a particular token sent to some kind of email

![](https://i.imgur.com/XTKU0sE.png)

- Don't Panic!! 😂, we don't need these mail as we could just input `'` in the Token field and we are fine, The token query would be like: {**"SELECT id FROM jos_users WHERE block = 0 AND activation = ' ' "**}

![](https://i.imgur.com/iqYodMy.png)

- You should now see a password reset page, you can change the password to whatever you feel like and have fun (Just make sure you remember what it is )

![](https://i.imgur.com/uIPxzqY.png)

- Now we can navigate to the `/administrator` page and use that password for the **Admin** user

![](https://i.imgur.com/shORhcp.png)

### Getting Shell

- Navigate to this specific URL `/administrator/index.php?option=com_templates` ( Can't share screenshots here for some reasons) and you should see the **Template Manager** page

![](https://i.imgur.com/a3oVLzH.png)

- I will be editing **beez** , so we can click on **beez** and then the **Edit HTML** button on the Tools bar

![](https://i.imgur.com/AcaDITn.png)

- Next you should be able to see an **index.php** writable page, (Yeah just like wp-plugins 👾), we can paste our PHP reverse shell here and hit **Apply** on the tools bar

![](https://i.imgur.com/kWdY5Dq.png)

-  Start up your netcat listener and navigate to the URL `http://10.10.171.169:8081/templates/beez/index.php` , This should give us back a reverse shell

![](https://i.imgur.com/kvVnu1W.png)

### Privilege Escalation

Yeepiii 😁, we have the `cp` command (copy) with SUID bit set, this means that we can copy any file on this box, including the **/etc/shadow** file (This is where password hashes for Users are stored including the root user, if we can steal these file, edit it to our own password, then replace this file then we can get root) , Let roll 🤟

![](https://i.imgur.com/XZju64q.png)

_How to Produce :_

- First of all change directory to `/tmp`
- Then copy the `/etc/shadow` file to the `/tmp` folder

![](https://i.imgur.com/Tx1kMOr.png)

- Now send the file to our attacking machine using a **python2 server** and **wget**

![](https://i.imgur.com/qFm09MR.jpg)

- Grant writable permission to the shadow file on our attacker system
- Generate a password hash with **openssl** on the target system
- Replace it with the `root` password **hash** inside the **shadow** on our attacker machine

![](https://i.imgur.com/qhqqLJJ.jpg)

- Now send the file back to our Target system

![](https://i.imgur.com/39dzdB5.jpg)

- You should have `shadow.1` and `shadow` , just do `/bin/cp shadow.1 shadow` {This is necessary to make sure our own changes was made, cos' we have 2 shadow files in the same directory with different contents, do these keep both **shadow.1** and **shadow** file the same}
- Then send the `/tmp/shadow` file to `/etc/shadow` by using the same `cp`, do `cp ./shadow /etc/shadow`

![](https://i.imgur.com/3n24IWG.png)

Now we can `su` to root with the password we used for the password hash, Mine is **bankai**

![](https://i.imgur.com/xfh1K7O.png)

**Note that you have to convert the root flag to "base64" then "base32" then "rot13", Have fun 🥳**

![](https://i.imgur.com/xFtJ1Ln.png)

Bankaiii 🧘‍♀️

![](https://media.giphy.com/media/Juk9FJzaFa4c5yjBLM/giphy.gif)


<button onclick="window.location.href='https://sec-fortress.github.io';">Back To Home螥</button>

