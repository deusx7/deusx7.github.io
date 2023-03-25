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

So i asked chatgpt and got the answer
![image](https://user-images.githubusercontent.com/127159644/227715278-9ee180a5-8746-494e-ac21-72b053213df1.png)

Trying that works
![image](https://user-images.githubusercontent.com/127159644/227715327-c72c1305-3955-422e-8e98-8728ed152669.png)

```
Username: matthew
Password: IcingaWebPassword2023
```

Using that to login works
![image](https://user-images.githubusercontent.com/127159644/227715398-130e54c1-1494-497b-8c22-f55e8dae793f.png)

From here we can get RCE using the same resource that exploited the path transversal

#### Exploitation: Remote Code Execution (CVE-2022-24715)

The exploitation goes this way

```
Create ssh key with PEM as its type
```

Using ssh-keygen works fine
![image](https://user-images.githubusercontent.com/127159644/227715586-e284bc22-a976-4cee-854d-681dc8e7cde5.png)

Now we need to create a new SSH resource in icingaweb.

It can be done here:

```
Configuration -> Resources -> Create a New Resource
```

![image](https://user-images.githubusercontent.com/127159644/227716048-237d1f3a-7535-4739-8037-a86ef582bab4.png)
![image](https://user-images.githubusercontent.com/127159644/227717046-d866a18b-3ac6-404e-b7ad-048713edf872.png)
![image](https://user-images.githubusercontent.com/127159644/227717230-121e62d8-e49e-476b-8205-82085a9a035f.png)

Now to get rce we need to create another resource

```
Resource Type: SSH Identity
Resource Name: shell.php
User: ../../../../../../dev/shm/shell.php
Private Key: file:///etc/icingaweb2/ssh/haxor
```

So we intercept the request in burp and manipulate the private key value
![image](https://user-images.githubusercontent.com/127159644/227717380-c2cfb981-b3e9-443b-9360-a87b85eefc82.png)

After forwarding the request it works
![image](https://user-images.githubusercontent.com/127159644/227717395-c1fff159-ffbb-4c9c-88b9-fd84546ad1c3.png)




