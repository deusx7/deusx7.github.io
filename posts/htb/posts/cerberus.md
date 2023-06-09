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

Using this exploit scrpit [Exploit](https://github.com/JacobEbben/CVE-2022-24715/blob/main/exploit.py)

I got shell
![image](https://user-images.githubusercontent.com/127159644/227747439-4c75a59c-8f97-4b7c-a2c7-59662defba6b.png)

Now this is weird cause cerberus is a windows box and not a linux box 

That means we're in some sort of container 🤔

Next thing is to get root and checking for suid binary shows this
![image](https://user-images.githubusercontent.com/127159644/227747986-0d824e24-6530-4251-8c57-05c5c6750d8a.png)

```
/usr/bin/firejail
```

So i searched for exploit and found this [Resource](https://www.openwall.com/lists/oss-security/2022/06/08/10)

There's an exploit script for (CVE-2022-31214) [Exploit](https://seclists.org/oss-sec/2022/q2/att-188/firejoin_py)

I transferred it to the target and run it, my privilege was escalated to root
![image](https://user-images.githubusercontent.com/127159644/227748283-8094b1ee-e287-4a56-8070-63a9f633fe1d.png)

After getting root i decided to find a way to escape this container

THen on running linpeas.sh i got this
![image](https://user-images.githubusercontent.com/127159644/227748494-a022052d-65dd-4081-81e6-570bb807c7a2.png)

Cache Cred is True in this joined domain host

So i asked chatgpt again and it says the path where the cred and information of a windows joined domain host is located at `/var/lib/sss/db`

After checking i saw that `cache_cerberus.local.ldb` has an hash

Then i cracked it and it belongs to user `matthew`
![image](https://user-images.githubusercontent.com/127159644/227749264-b16beab8-9eeb-4d54-9a6a-422541ee7a30.png)

But where do we login from?

Now i want to scan the whole host to know what ports are hosts are up

Using nmap compiled binary i scanned the host and figured that winrm is open
![image](https://user-images.githubusercontent.com/127159644/227749590-c14b2e92-50ec-4997-8dd2-333d727ff508.png)

With this i can now port forward using chisel to my host then login to the winrm as user matthew
![image](https://user-images.githubusercontent.com/127159644/227749695-19a8d29d-d16b-4dbf-b6f1-6f8597764201.png)

So i logged in as user matthew to the winrm service
![image](https://user-images.githubusercontent.com/127159644/227749766-ab9d6c82-c92d-4910-bdef-5d51215b3388.png)

#### Privilege Escalation

Checking `Program Files (x86)` I got `ManageEngine\ADSelfService Plus` 
![image](https://user-images.githubusercontent.com/127159644/227749914-b740b10e-0ff3-4909-86fe-8b5cbd576056.png)

Searching for exploit leads here [Resource](https://www.manageengine.com/security/advisory/CVE/cve-2022-47966.html)

I'll port forward again using chisel in order to exploit the service running internally
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/19f54578-066a-4a1e-bb04-3fd856b7eb1b)
```
Attacker: chisel server -p 8080
Target: .\chisel.exe client 10.10.14.175:8080 R:9000:socks
```

Since the service runs on port 9251 I port forwarded it to my host

From scanning my host I can tell that it indeed runs on port 9251
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/76525791-733e-4d6c-92c0-4cd562d6d6b2)

Back to exploitation

Loading up metasploit shows the it requires some values
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f9efec2b-27e1-4066-9eec-52bc1f5a49c0)

Moving over to the web service shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/aeec12c6-618c-4266-b966-f9a7bd55fc90)

Since it's trying to resolve to that let's add it to our `/etc/hosts` file `dc.cerberus.local`

It wasn't able to resolve so i was stucked here too bad 😞
