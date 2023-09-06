# Stuntman Mike

***
## Difficulty = Easy

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/13cff441-8c21-4bbd-ba6a-7bde2c3f640e)

***

We decided to run our nmap scan

```shell
# Nmap 7.94 scan initiated Wed Sep  6 06:48:00 2023 as: nmap -p- -sVC -v --min-rate=1000 -T4 -oN nmap.txt 10.150.150.166
Warning: 10.150.150.166 giving up on port because retransmission cap hit (6).
Nmap scan report for 10.150.150.166
Host is up (0.16s latency).
Not shown: 65390 closed tcp ports (conn-refused), 143 filtered tcp ports (no-response)
PORT     STATE SERVICE  VERSION
22/tcp   open  ssh      OpenSSH 7.6p1 (protocol 2.0)
| ssh-hostkey: 
|   2048 b7:9e:99:ed:7e:e0:d5:83:ad:c9:ba:7c:f1:bc:44:06 (RSA)
|   256 7e:53:59:7b:2d:6c:3b:d7:21:28:cb:cb:78:af:99:78 (ECDSA)
|_  256 c5:d2:2d:04:f9:69:40:4c:15:34:36:fe:83:1f:f3:44 (ED25519)
8089/tcp open  ssl/http Splunkd httpd
| http-methods: 
|_  Supported Methods: GET HEAD OPTIONS
|_http-title: splunkd
| ssl-cert: Subject: commonName=SplunkServerDefaultCert/organizationName=SplunkUser
| Issuer: commonName=SplunkCommonCA/organizationName=Splunk/stateOrProvinceName=CA/countryName=US
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2019-10-25T09:15:13
| Not valid after:  2022-10-24T09:15:13
| MD5:   a81b:a4c7:ea97:ebc8:7f73:310f:e279:3eb2
|_SHA-1: 6bd8:1aeb:bb06:78e8:33ff:3419:27c9:6b03:4d72:44c1
| http-robots.txt: 1 disallowed entry 
|_/
|_http-server-header: Splunkd

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed Sep  6 06:50:17 2023 -- 1 IP address (1 host up) scanned in 137.41 seconds
```

Decided to enumerate port 8089/**Splunkd**, but we did not have any leads, enumerating Port 22/**SSH**, we have a username enumeration vulnerability, I tried several exploits but still no leads, But trying to connect to SSH without password gives us this banner :

![](https://i.imgur.com/GgLPpZB.png)

Definitely we know `Mike` is the username, we can bruteforce the password using this [script](https://github.com/pwnesia/ssb) (I decided not to use **hydra** because it is too slow)

_Syntax :_

```shell
sec-fortress@Pwn-F0rk-3X3C:~/PTD/10.150.150.166$ sudo ssb -p 22 -w /usr/share/wordlists/rockyou.txt -t 15s -c 100 mike@10.150.150.166
```

_Output :_

![](https://i.imgur.com/WDcfF9j.png)

Great!!!, Now we can login with the credentials `mike:babygirl` 

![](https://i.imgur.com/i6wDrwT.png)
### Privilege Escalation

Running `sudo -l` we have permissions to run all commands with sudo {This means we can do sudo followed by any other programs or binary with the password "**babygirl**" and it should give us user as "**root**"}.

![](https://i.imgur.com/EUOdZic.png)

This privilege escalation vector is as simple as running the command `sudo su` which means to switch user, since we don't have any user specified, it will automatically switch to the user **root** for us.

![](https://i.imgur.com/K9XVlp3.png)

We got root!! bankai 😂

<button onclick="window.location.href='https://sec-fortress.github.io';">Back To Home螥</button>

