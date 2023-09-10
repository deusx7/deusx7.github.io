# Kiba

***
## Difficulty = Easy 

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/21098158-abca-49c1-a339-c52d93a2e670)

***

Running our Nmap scan we have :

```shell
# Nmap 7.94 scan initiated Sun Sep 10 08:46:49 2023 as: nmap -p- -sVC -v --min-rate=1000 -T4 -oN nmap.txt 10.10.117.138
Warning: 10.10.117.138 giving up on port because retransmission cap hit (6).
Nmap scan report for 10.10.117.138
Host is up (0.29s latency).
Not shown: 65428 closed tcp ports (conn-refused), 103 filtered tcp ports (no-response)
PORT     STATE SERVICE      VERSION
22/tcp   open  ssh          OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 9d:f8:d1:57:13:24:81:b6:18:5d:04:8e:d2:38:4f:90 (RSA)
|   256 e1:e6:7a:a1:a1:1c:be:03:d2:4e:27:1b:0d:0a:ec:b1 (ECDSA)
|_  256 2a:ba:e5:c5:fb:51:38:17:45:e7:b1:54:ca:a1:a3:fc (ED25519)
80/tcp   open  http         Apache httpd 2.4.18 ((Ubuntu))
|_http-title: Site doesn't have a title (text/html).
|_http-server-header: Apache/2.4.18 (Ubuntu)
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
5044/tcp open  lxi-evntsvc?
5601/tcp open  esmagent?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, Help, Kerberos, LDAPBindReq, LDAPSearchReq, LPDString, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe: 
|     HTTP/1.1 400 Bad Request
|   FourOhFourRequest: 
|     HTTP/1.1 404 Not Found
|     kbn-name: kibana
|     kbn-xpack-sig: c4d007a8c4d04923283ef48ab54e3e6c
|     content-type: application/json; charset=utf-8
|     cache-control: no-cache
|     content-length: 60
|     connection: close
|     Date: Sun, 10 Sep 2023 12:48:35 GMT
|     {"statusCode":404,"error":"Not Found","message":"Not Found"}
|   GetRequest: 
|     HTTP/1.1 302 Found
|     location: /app/kibana
|     kbn-name: kibana
|     kbn-xpack-sig: c4d007a8c4d04923283ef48ab54e3e6c
|     cache-control: no-cache
|     content-length: 0
|     connection: close
|     Date: Sun, 10 Sep 2023 12:48:26 GMT
|   HTTPOptions: 
|     HTTP/1.1 404 Not Found
|     kbn-name: kibana
|     kbn-xpack-sig: c4d007a8c4d04923283ef48ab54e3e6c
|     content-type: application/json; charset=utf-8
|     cache-control: no-cache
|     content-length: 38
|     connection: close
|     Date: Sun, 10 Sep 2023 12:48:27 GMT
|_    {"statusCode":404,"error":"Not Found"}

---SNIP---

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sun Sep 10 08:48:57 2023 -- 1 IP address (1 host up) scanned in 128.36 seconds
```

Port `80/HTTP` doesn't seem to give me what i want, even while performing **directory bruteforcing**, No directory/files where discovered 

![](https://i.imgur.com/PF4IzEG.png)

Port `5044` isn't loading up, but port `5601` gives us a **Kibana** Dashboard page

![](https://i.imgur.com/iDyTi8X.png)

Nice, we can navigate to the **Management** menu to see which version of kibana we are using, these will give us the chance to enumerate more:

![](https://i.imgur.com/7on4p0j.png)

>Cool, we have a **Prototype Pollution** vulnerability that allows attackers to exploit the rules of the JavaScript programming language, by injecting properties into existing JavaScript language construct prototypes, such as Objects to compromise applications in various ways. This could literally lead to **RCE**

Navigate to the **Timelion** menu and follow this [guide](https://github.com/mpgn/CVE-2019-7609) to know more about how the **RCE** took place 

![](https://i.imgur.com/IuZMTZK.png)
![](https://i.imgur.com/YfAX3WQ.png)

### Privilege Escalation

Running `getcap -r / 2>/dev/null` in other to check for files with Capabilities we can see that a python binary has been stored on the user **Kiba's** home directory, we can use this to get `root`

![](https://i.imgur.com/D6eCjOA.png)

Using this payload we can get elevated privileges as `root` 🐉

```shell
/home/kiba/.hackmeplease/python3 -c 'import os; os.setuid(0); os.system("/bin/bash")'
```

![](https://i.imgur.com/zcmWUci.png)

Happy weekend and Have fun 

![](https://media.giphy.com/media/3o7527WMiaRJmrWMTe/giphy-downsized-large.gif)
