<h3> Cerberus HackTheBox </h3>

### Difficulty = Hard

### IP Address = 10.10.11.205

#### This is my first hard rated hackthebox machine and its a windows box xD

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/227714366-b69f0657-52ca-4fc5-b305-2f3da790d02d.png)

I added the domain name to my `/etc/hosts` file

```
➜  ~ cat /etc/hosts | grep cer
10.10.11.205    icinga.cerberus.local cerberus.local
➜  ~ 
```

After navigating to the web server I got this login page
![image](https://user-images.githubusercontent.com/127159644/227714514-c5dd3dc0-be36-4dc9-b8dc-03615a144e83.png)

Since weak cred doesn't work (lets face it this is an hard htb box 😂) I decided to check for exploits

And i found a path transversal exploit

Here's the resource [Exploit](https://www.sonarsource.com/blog/path-traversal-vulnerabilities-in-icinga-web/)

To get the `/etc/passwd` file according to the exploit you goto

```
Vuln: http://icinga.cerberus.local:8080/icingaweb2/lib/icinga/icinga-php-thirdparty/etc/passwd
```

Trying that works
![image](https://user-images.githubusercontent.com/127159644/227714671-da582c0f-4cab-4f48-abeb-5e79c1b2839a.png)

And now if you read the resource you will see that authenticated user can then gain RCE via ssh key

First on the normal login page looking at the source code shows this
![image](https://user-images.githubusercontent.com/127159644/227714915-e0a99cbb-6f70-4034-a54a-df36067011a4.png)

```
file:///etc/icingaweb2/ssh/nima
```

It shows us the path to the `Icinga Web 2` 

That is useful cause we want to enumerate creds
