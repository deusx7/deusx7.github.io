<h3> HeroCTF '23 </h3>

Here are the challenges I was able to solve:

```
P.S:- The scoreboard was dynamic
```

# Challenges Solved

## Prog
-      Math Trap (50 points)

## System
-     Chm0d (50 points)
-     IMF#0 (50 points)
-     SUDOkLu (50 points)
-     IMF#1: Bug Hunting (500 points)
-     IMF#2: A woman's weapon (500 points)
-     IMF#3: admin:admin (500 points)
-     IMF#4: Put the past behind (500 points)

# Prog

#### Math Trap
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c95cf4e2-bb75-4f89-8ef0-4cd610d630d6)

Since we're given a remote service to connect to let us see what it does

Connecting to it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8e1ad6a9-5129-4f1d-b4fe-effcfb7ce99c)

We're asked a calculation 

I used gave it the answer and got this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/17a26531-73a2-4f90-9c0e-57421c8b6c48)

I got *Too Slow* so basically we need to solve each math it gives

And doing this manually is not possible cause it also checks the answer received with time

The way forward is by scripting it and that's what I did

Here's my solve [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/heroctf/prog/Math%20Trap/solve_2.py) it's not really well scripted but it does the job 😄

Running it gives the flag 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/818ff725-48f2-4ec3-b982-13f4829581dd)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c3d3907c-31d6-42a6-b92c-37023db686a8)

```
Flag: Hero{E4sy_ch4ll3ng3_bu7_tr4pp3d}
```

# System

#### Chm0d 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0b569148-b584-4fa0-901c-c64d4919d4fc)

I had to first deploy an instance
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ce755e31-79e2-418f-ac2b-477f906be97f)

Now I logged in using the cred given
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0d5c3534-b8ed-4296-bb6a-a2fc9323c8fe)

Checking the */* directory shows that the flag is there
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2686b438-5520-41cb-ba3d-af84ee28cad7)

And noticing the permission set on it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6f9b086f-cbeb-414a-b78b-7ab8b0706a9a)

At the moment we don't have any read/write/execute permission over the file

But since the file is owned by us so, we can change the permission set on it using *chmod*

Trying it gives permission denied
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/126f0bca-845b-4fac-806d-ccd92a1b35f8)

Hmmmmm let us see what permission is set on the chmod binary
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3c49ca86-48cb-4ac0-a6af-85f8ab2b1678)

Dang it's permission is the same as the flag.txt file and since the binary is owned by root we can't change it

At this point I taught I had to do privilege escalation so using *scp* I transferred *linpeas.sh* to the box
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c5419c36-de68-4d58-93ae-1cb369259264)

I immediately noticed that the linpeas i transferred has execute permission set on it 

So maybe any file that is transferred to the box will automatically have execute perm set on it

This is good cause now I can upload my own machine *chmod* binary to the box then run it

Doing that works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f3235ee6-2bb5-44c1-89d0-73a102aa99e3)

Now that we have chmod binary on it which has execute permission we can then change the permission on the flag file then read it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a23b27b2-5821-46a9-ba72-bc414feac8ba)

```
Flag: Hero{chmod_1337_would_have_been_easier}
```

#### IMF#0: Your mission, should you choose to accept it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b4531861-09dc-4f2f-bb2b-0d9bc5b2dae1)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a4d13a67-eeba-4c9b-8b77-ebf99bbe65d4)

This is just the message asking if we accept the upcoming mission

And the flag is just right there

```
Flag: Hero{I_4cc3pt_th3_m1ss10n}
```

#### SUDOkLu
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/edad7b26-fcc7-47d9-b996-f56b28f259ba)

First I started an instance
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cc8d7191-157c-4594-b590-f9af3aaf750b)

Then i logged in to ssh
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2ea098a6-d122-4d88-9dcc-7e31c98c903d)

We know that the goal is to read the file at `/home/privilegeduser/flag.txt`

But we are currently user `user` so we will be doing some privilege escalation

Checking for sudo permission shows that we can run */usr/bin/socket* as user *privilegeduser*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5f442fee-cf1c-4ae7-95c2-f3fde4f9abb6)

Moving over to [gtfobins](https://gtfobins.github.io/gtfobins/socket/) shows that we can get a reverse shell via the socket binary
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/61d8167d-4d94-4ca4-bd5d-6b9a90754dd3)

We were given the internal IP for the machine and luckily there's netcat on the machine
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f885fb67-8a96-4cd2-b9fd-0b3a723cee35)

So we'll be using nc to catch the reverse shell

I ssh to another session where my reverse shell will be caught
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c8984fb1-a0b7-4732-a34a-bfe3b137788a)

And we get the flag

```
Flag: Hero{ch3ck_f0r_m1sc0nf1gur4t1on5}
```

#### IMF#1: Bug Hunting
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/807bd6ce-c01a-4539-b5c3-424c9f467f78)

I started an instance as usual first
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/afb3e9b9-71fc-4316-9651-7f6a52584c91)

Remember initially we were given the cred to ssh which is `bob:password`

We're given two boxes attempting to login to ssh with the first host fails
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1dfc0235-e19e-4e13-9ae4-191eb5e73c31)

But for the second one it works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ac79ec0c-6fd7-4a02-824f-111bb4b65ccc)

There's a *welcome.txt* in the user's home directory

Checking it's content gives this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3172d0a2-7167-4710-825d-822e15a1ba21)

```
Hi Bob!

Welcome to our firm. I'm Dave, the tech lead here. We are going to be working together on our app.

Unfortunately, I will be on leave when you arrive. So take the first few days to get familiar with our infrastructure, and tools.

We are using YouTrack as our main issue tracker. The app runs on this machine (port 8080). We are both going to use the "dev" account at first, but I will create a separate account for you later. There is also an admin account, but that's for our boss. The credentials are: "dev:aff6d5527753386eaf09".

The development server with the codebase is offline for a few days due to a hardware failure on our hosting provider's side, but don't worry about that for now.

We also have a backup server, that is supposed to backup the main app's code (but it doesn't at the time) and also the YouTrack configuration and data.

Only I have an account to access it, but you won't need it. If you really have to see if everything is running fine, I made a little utility that run's on a web server.

The command to check the logs is:
curl backup

The first backups might be messed up a bit, a lot bigger than the rest, they occured while I was setting up YouTrack with it's administration account.
Hope you find everything to you liking, and welcome again!

Dave
```

After reading it here's what I understood from it:
- There's a web server which is running YouTrack hosted on port 8080
- We are already given the dev credential 
- There is also a backup server and to access it is by using curl which just checks the log 
- Hint pointing at the which backup file the YouTrack administrator password is stored

Since there's a web server hosted locally and it is running YouTrack, I used ssh portforward to make it accessible to my host
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/47e5388d-bee5-4251-8de8-c8352823d58f)

```
Command: ssh -L 8000:127.0.0.1:8080 bob@dyn-05.heroctf.fr -p13654
```

We can confirmed it worked by scanning our host
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/547f4d55-b183-4ea6-a0ea-51acec450635)

Dave gave us the dev user credential to be `dev:aff6d5527753386eaf09`

Moving over to my web browser shows a login page
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8095f857-5bca-46ba-adba-79447d8dc5f7)

Using the credential works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6d09fe46-c1e5-411b-a4d5-997e4a04a938)

Next thing I noticed is the verson of the web app which is:

```
YouTrack 2020.5.2579 
```

Searching for exploits leads [here](https://www.synacktiv.com/publications/exploiting-cve-2021-25770-a-server-side-template-injection-in-youtrack.html)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e4439eb3-6d6e-4754-ac09-28189c9d483b)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d1318468-5d1a-45d6-b192-91dc929493e1)

But after reading the exploit which is basically exploiting Server Side Template Injection (SSTI) it requires a privileged admin user account and our account isn't an admin account so let us put this aside for now

Looking through the web app shows this issue page
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fb350698-c2a2-458e-9876-acac539e8f8d)

Clicking on the first issue gives the flag
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e6a04139-2589-426c-97d8-979439fadaa3)

```
Flag: Hero{1_tr4ck_y0u_tr4ck_h3_tr4ck5}
```

#### IMF#2: A woman's weapon
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/20cd5a36-475f-4b17-966f-6279b21e9a8e)

I got third blood in this challenge hahaha 🩸
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5d5faa8e-c98f-4827-862d-134d196f2234)

Now back to the web app

The other issues are not of importance except this one
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/40255124-e74f-4280-ad9d-ed50b0cf8df1)

It's talking about the *Backup Log checking utility* and remember that *Dave* said there's a backup server

I downloaded the script to my host and here's the content
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a96ecdae-a0dd-4d3b-8c7e-ee100884a30a)

```php
<?php
    $file = $_GET['file'];
    if(isset($file))
    {
        include("$file");
    }
    else
    {
        include("/var/log/backup.log");
    }
?>
```

Now if you remember that *Dave* said the command to check the log is *curl backup* so this means that backup is a web server running on port 80

Pinging it from the host we currently have access to shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f07694be-5451-4f19-866a-e15c630b34ea)

So basically this is the second host as we can tell from it's ip *i.e the box that when we tried loggin to ssh didn't work*

For us to access the host we need to port forward it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/bab12814-abe4-4a4d-a15e-ede1423c80ca)

Now we can access it from our host
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/52ba9d8d-a502-4484-9e5b-b5887ab2ceb1)

But it returns the backup log file and this is intended cause no file parameter was passed in the url

Back to the script we can see it uses *include* to get the content of the file passed in the *$file* parameter and this vulnerable to Local File Inclusion (LFI) due to the usage of *include*

Let us confirm it first
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b0f18a22-6a71-40d3-a1b8-22a92042f7c2)

Cool it works. At this point let's further exploit this vulnerability to get Remote Code Execution (RCE)

There are various ways or achieving this but in this case i'll go with Log Poisoning

First lets determine what web server this web app is built on

Using wappalyser extension i achieved that though you can use nmap,curl,http-header to fingerprint that
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8ce3e9ed-c1d4-49a8-9dee-f096f76ebaab)

The web server is *Nginx*. This is needed cause for log poisoning, we need to know where the log files are placed

And from Nginx it's default is:

```
/var/log/nginx/access.log
```

Including the log file works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a7c8a7ac-c8fd-4fb1-bd83-a147989d6e99)

So let us go ahead with the attack

I used burp to work with the header manipulation
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/57536df4-7003-4847-ba10-bd0bdf2122b6)

First thing to do is to inject this php code in the user-agent header
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7fe60d2d-16ee-4567-815b-0c64978536b3)

```php
<?php system($_GET['cmd']); ?>
```

Also forward the request at least three times for it to appear in the log file

From here we can get code execution
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a5cb8e0b-7a05-4220-a71d-1013a20c3a46)

Looking at the result we see that we are user `www-data`

Let us get a reverse shell. 

Since there's already nc on the other host, I just used it to host a python web server which contains a file *lol.sh* and the file content is that of a bash reverse shell
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/606d2b8e-2eea-477f-b187-f6e703339f7c)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cc38bd4e-ca42-4521-ab19-25de8e2c1722)

Now i will make the file at */tmp/lol.sh* executable then run it and hope to catch my reverse shell in my listener
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2bbf4f95-ff77-4609-a0db-493fb0ffc063)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d202a735-7e13-4d33-b4f0-bc91b2e0ff3d)

Back on our listener for our shell fingers crossed 🤞
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d8226940-56ef-49c0-a450-8c29883276ec)

Let us now stabilize it using python
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f67e2b1e-738a-4fe5-b332-f3781fa0d9c4)

User www-data is less privileged so lets see how we can escalate privilege

Running *sudo -l* shows that user *www-data* can run */usr/bin/rsync* as user *backup*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b7db3689-03c3-499d-8dbc-c9fd6e3b5d3d)

Moving over to [gtfobins](https://gtfobins.github.io/gtfobins/rsync/#sudo) shows a way we can abuse the permission to get shell
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0795b827-5180-4101-aed2-6fb2f906fc00)

Trying it works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/29f8c5e2-de28-47bb-ae96-4be32a9fa325)

Now that we are user *backup* lets see what we have access to
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0407c34a-f8bd-416a-8cb3-400b35f0a076)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1e5bfa5f-0857-4562-8f75-b41c06e0fdf4)

Nice let's see what's in /backup
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f9e44c85-c543-4d01-865e-c67f3afa0794)

Our flag is in there also
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b8857b7c-db15-4182-856d-1bcf602e7bcc)
