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


The other issues are not of importance except this one
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/40255124-e74f-4280-ad9d-ed50b0cf8df1)

