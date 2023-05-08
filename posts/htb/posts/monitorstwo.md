<h3> Monitors Two HackTheBox </h3>

Difficulty = Easy

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/236706924-2c717963-1502-478f-88fa-3c3fc732acc8.png)

Checking the web server on port 80 shows an instance of *Cacti Version 1.2.22 * 
![image](https://user-images.githubusercontent.com/127159644/236707001-64ac9a50-c482-406d-b0f4-206aae36da70.png)

Searching google for default credentials show that it's *guest:guest*

After attempting to loggin in with it doesn't works

Then since we know the version i searched up google for [exploit](https://www.rapid7.com/db/modules/exploit/linux/http/cacti_unauthenticated_cmd_injection/) and found this
![image](https://user-images.githubusercontent.com/127159644/236707146-b716274a-a25a-4adf-a120-65f8f4c63b8a.png)

Well I tried using metasploit for it 👀. But for some reason the exploit isn't available on my own version of metasploit I guess i have to save the ruby exploit manually

So I used a github [exploit](https://github.com/FredBrave/CVE-2022-46169-CACTI-1.2.22)

Trying it works
![image](https://user-images.githubusercontent.com/127159644/236707633-bf884d37-b00b-4c81-ae56-6d53f79619c6.png)

We can tell that this is a docker container
![image](https://user-images.githubusercontent.com/127159644/236707820-bdafe220-4b66-406d-a222-1e8c14048263.png)

We can stabilize our shell using:

```bash
/usr/bin/script -qc /bin/bash /dev/null
export TERM=xterm
CTRL +Z
stty raw -echo;fg
```

I uploaded linpeas.sh to the box for further enumeration
![image](https://user-images.githubusercontent.com/127159644/236707872-ca91d3c8-d9b4-47b7-be45-cc2171a2e209.png)

After runnng the script *bash linpeas.sh* I found this interesting
![image](https://user-images.githubusercontent.com/127159644/236708089-753e8acd-e56f-45b7-98c6-d1c91d9018f0.png)
![image](https://user-images.githubusercontent.com/127159644/236708228-6fea0537-d908-4bfd-b11e-7ef7cbac1aa2.png)

Using [gtfobins](https://gtfobins.github.io/gtfobins/capsh/#suid) shows a way we can escalate priv to root

Trying it gives us root user on the docker container
![image](https://user-images.githubusercontent.com/127159644/236708149-7ec67b1b-2c27-4b5f-ac4c-210044f764ff.png)

Remember that there's mysql running on this docker container and we currently only know the password to the db and not the user checking /entrypoint.sh discloses some information
![image](https://user-images.githubusercontent.com/127159644/236708367-aaf63af1-430a-41c9-8286-8924264b2689.png)

Loggin in as *root:root* on host *db* works
![image](https://user-images.githubusercontent.com/127159644/236708399-8e12cab0-6f27-474e-a2ed-21514457bd90.png)

Dumping the *user_auth* table shows some accounts
![image](https://user-images.githubusercontent.com/127159644/236708430-59b305a8-7cba-4a8a-9cee-a893ecfcfe6a.png)

Cracking the hash of user *marcus* gives *funkymonkey*
![image](https://user-images.githubusercontent.com/127159644/236708632-b208f355-c80f-4a27-8384-6b8f2a52dfd6.png)

Now using it over *ssh* works
![image](https://user-images.githubusercontent.com/127159644/236708569-11dcec17-5cfd-4bcb-b5cf-cdb0e4cb458b.png)

I uploaded *linpeas.sh* and after running it i get this
![image](https://user-images.githubusercontent.com/127159644/236708708-9af6f847-5849-4b6e-a511-889b2b194559.png)
![image](https://user-images.githubusercontent.com/127159644/236708872-b3fa83ac-e8e9-4414-9740-686bba310be3.png)

Reading the mail shows this
![image](https://user-images.githubusercontent.com/127159644/236708895-1f346c69-0529-41d8-a331-d4c0c8fc96d4.png)

We can see that the mail talks about various exploits and the one that looks particularly interesting to us is:

```
CVE-2021-41091: This vulnerability affects Moby, an open-source project created by Docker for software containerization. Attackers could exploit this vulnerability by traversing directory contents and executing programs on the data directory with insufficiently restricted permissions. The bug has been fixed in Moby (Docker Engine) version 20.10.9, and users should update to this version as soon as possible. Please note that running containers should be stopped and restarted for the permissions to be fixed.
```

I searched for the [exploit](https://github.com/UncleJ4ck/CVE-2021-41091) then uploaded *exp.sh* to the target
![image](https://user-images.githubusercontent.com/127159644/236709065-a3dec63c-0879-4e0a-88a7-c26d9ef8618c.png)

Running the exploit shows this
![image](https://user-images.githubusercontent.com/127159644/236709082-b470ae96-45b3-4ade-aff4-eaff3eeb7086.png)

So I had to set */bin/bash* perm to *suid* on the docker container
![image](https://user-images.githubusercontent.com/127159644/236709291-346c93c4-cb0d-4375-8228-a30bb02a7b1c.png)

Then i ran the exploit again but the shell doesn't seem to last it just cuts off
![image](https://user-images.githubusercontent.com/127159644/236709483-50b77b0f-b09d-4a59-a15b-c60b45f523dc.png)

I then did it manually by calling */bash -p* from the docker container
![image](https://user-images.githubusercontent.com/127159644/236709528-9ee589a8-04cf-4c43-858a-15f5b4fdd35a.png)

And we're done 👻

![hackerman](https://user-images.githubusercontent.com/127159644/236709940-c9b72732-379e-4791-a3fd-7d13e75ca470.gif)
