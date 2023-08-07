# Difficulty = Easy

Hey, Welcome back

Let run our Nmap scan:

```sh
sec-fortress@Pwn-F0rk-3X3C:~/HTB/irked$ nmap --open 10.10.10.117 -Pn
Starting Nmap 7.94 ( https://nmap.org ) at 2023-08-07 06:06 EDT
Nmap scan report for 10.10.10.117
Host is up (0.25s latency).
Not shown: 915 closed tcp ports (conn-refused), 82 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT    STATE SERVICE
22/tcp  open  ssh
80/tcp  open  http
111/tcp open  rpcbind

Nmap done: 1 IP address (1 host up) scanned in 11.79 seconds

sec-fortress@Pwn-F0rk-3X3C:~/HTB/irked$ nmap -p22,80,111 -sCV --min-rate=1000 10.10.10.117 -Pn
Starting Nmap 7.94 ( https://nmap.org ) at 2023-08-07 06:08 EDT
Nmap scan report for 10.10.10.117
Host is up (0.27s latency).

PORT    STATE SERVICE VERSION
22/tcp  open  ssh     OpenSSH 6.7p1 Debian 5+deb8u4 (protocol 2.0)
| ssh-hostkey: 
|   1024 6a:5d:f5:bd:cf:83:78:b6:75:31:9b:dc:79:c5:fd:ad (DSA)
|   2048 75:2e:66:bf:b9:3c:cc:f7:7e:84:8a:8b:f0:81:02:33 (RSA)
|   256 c8:a3:a2:5e:34:9a:c4:9b:90:53:f7:50:bf:ea:25:3b (ECDSA)
|_  256 8d:1b:43:c7:d0:1a:4c:05:cf:82:ed:c1:01:63:a2:0c (ED25519)
80/tcp  open  http    Apache httpd 2.4.10 ((Debian))
|_http-title: Site doesn't have a title (text/html).
|_http-server-header: Apache/2.4.10 (Debian)
111/tcp open  rpcbind 2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|   100000  3,4          111/udp6  rpcbind
|   100024  1          34317/tcp6  status
|   100024  1          40806/udp6  status
|   100024  1          51297/udp   status
|_  100024  1          55742/tcp   status
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 36.17 seconds

```

Navigating to the website:

![](https://i.imgur.com/cc7PpNZ.png)

Let check if IRC port is opened on our target, you can use this nmap syntax:

`nmap -sV --script irc-botnet-channels,irc-info,irc-unrealircd-backdoor -p 194,6660-7000 10.10.10.177`

*Output:*

```sh
sec-fortress@Pwn-F0rk-3X3C:~/HTB/irked$ nmap -sV --script irc-botnet-channels,irc-info,irc-unrealircd-backdoor -p 194,6660-7000 10.10.10.117
Starting Nmap 7.94 ( https://nmap.org ) at 2023-08-07 06:13 EDT
Nmap scan report for irked.htb (10.10.10.117)
Host is up (0.29s latency).
Not shown: 341 closed tcp ports (conn-refused)
PORT     STATE SERVICE VERSION
6697/tcp open  irc     UnrealIRCd
| irc-botnet-channels: 
|_  ERROR: Closing Link: [10.10.14.12] (Throttled: Reconnecting too fast) -Email djmardov@irked.htb for more information.

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 43.63 seconds
```

### After Much enumeration we finally got an exploit

works  --> [Exploit 1](https://github.com/geek-repo/UnrealIRCd-3.2.8.1/blob/master/poc.py)

doesn't work --> [Exploit 2](https://www.exploit-db.com/exploits/13853)

![](https://i.imgur.com/hTtogtO.png)

- We then stabilize the shell and goot shell as **ircd** 
- After much enumeration we got a backup file with a steg password in it

![](https://i.imgur.com/FEQGnG5.png)

Remember we had a picture on the website, let use the password for it

![](https://i.imgur.com/LBAygqu.png)

Worked, finally escalated to djmardov

![](https://i.imgur.com/DMyZLz8.png)

Now we need root 🚫

- Over here we can see that we have an unusual SUID which is **viewuser**

![](https://i.imgur.com/2yCbSrO.png)

- Right here we can see that after running the **viewuser** command, it is reading stuffs from /tmp/listusers.
- Now we will add a file with the `echo "id" > /tmp/listusers` command and still permission denied

![](https://i.imgur.com/4L9t5ju.png)

- Definitely we will have to give **/tmp/listusers** executable permissions

![](https://i.imgur.com/XFV4Slg.png)

- It ran the command `id` as root, let get shell through this 😀

![](https://i.imgur.com/ypP1TA2.png)

**Baaaankaiiii 👨‍💻**

