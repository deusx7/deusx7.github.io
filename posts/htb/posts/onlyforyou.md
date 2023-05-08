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

