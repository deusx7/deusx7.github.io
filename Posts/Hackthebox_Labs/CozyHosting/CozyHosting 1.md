# CozyHosting 

DIFFICULTY: EASY 

![](attachments/20231021011123.png)
# Introduction 

This is an easy rated linux machine from hackthebox. It contains Directory Enumeration, Session Hijacking, PostgreSQL, Privilege Escalation, Hash Cracking, and Command Injection. 
# Initial Access 

To kick off our reconnaissance, I initiated an Nmap scan to discover open ports and services on the target machine. 

![](attachments/20231021011234.png)

From the nmap scan we can see there are multiple services running on the machine including a http server. I attempted to access the web server on port 80 and it was resolving to a domain cozyhosting.htb and the page wasn't loading so i decided to add the ip address of our target to the /etc/hosts file in order the page to load properly. 

![](attachments/20231021011402.png) 

after that we are able to access the site. 

![](attachments/20231021011455.png) 

Going through the website and checking all links i landed at a login page requesting a username and password which i haven't yet obtained so i needed to find a way to login. 
![](attachments/20231021011548.png)

 While i was checking through the page source code and making some research to see if i can find any known exploits for the version of technologies in use on the website, i ran a directory enumeration scan in the background to see if i can find any hidden directory using dirsearch. 
 
![](attachments/20231021011626.png)

 I discovered a directory that contained session cookies which could be used to login as an authorized user. 
 
![](attachments/20231021011732.png) 

so the next step is to copy the cookie, launch developer tools (ctrl + shift + i), navigate to storage and replace the cookie there with the aurhtorized one. 

![](attachments/20231021011852.png)

 Now all that's left to do is refresh the page and we gain access. 
 ![](attachments/20231021011946.png)
 
 Scrolling down the page there is a request to enter a hostname and username, looks like it's for ssh connection. As i don't have any credentials i start to look around the webpage and find any clues or hints. I end up discovering anything passed into the fields were being executed as ssh command. So i started up burpsuite to intercept the request in order to use repeater to test various arbitrary commands. 
 ![](attachments/20231021012447.png)
 
 since i knew it could execute shell commands i decided to try and get a reverse shell by creating a shell.sh script containing simple bash reverse shell onliner from https://www.revshells.com/, starting a python server in the same directory as my script in order to host it so i can download it on the target machine using curl. After that change the permission to make sure it can be executed and lastly starting a netcat listener and running the script. Since we can't have space between the commands burpsuite won't interpret the request properly, we add ${IFS} which basically equates to nothing so it can serve as a space. 
 
![](attachments/20231021012629.png) !

![](attachments/20231021012731.png)

 ![](attachments/20231021012854.png)
# Privilege Escalation 

Now that we have access to the machine, time to find flags and escalate our privilege to possibly root! After thoroughly examining the machine and finding no flag and i decided to transfer a linpeas script to the target machine to help in the enumeration for privilege escalation vectors. After linpeas finished running i decided to download a jar file i saw in the initial directory i was spawned in when i gain access. Downloaded the file from target to my host machine and unzipped it. It extracted multiple folders containing lots of files so i just grepped for the word "password" using then command `egrep "passowrd" iR .` and ended up finding a password. 

 ![](attachments/20231021012947.png)
 
 With this password i decided to use it to login to the postgresql database that i discovered from reading the linpeas result and it can also be guessed that it is a database password by the "spring.datasource" in the above image. 
 ![](attachments/20231021013113.png)

 **NOTE**: If you're reading this for a guide remember to stabilize your shell or else you won't be able to login. After logging into the database i discovered a database called cozyhosting and a table named users which contained password hashes which can be cracked. So i copied and pasted them to my attack machine to start cracking it using hashcat `hashcat -a 0 -m 3200 hash.txt /usr/share/wordlists/rockyou.txt` . 
 
![](attachments/20231021013324.png) 

with this password i can try to ssh as josh and get the first flag `ssh josh@10.10.11.230`. 
 
![](attachments/20231021013846.png)

Now to escalate to root. User josh has sudo permission for the /usr/bin/ssh binary. Quick search on https://gtfobins.github.io/ gives info on how to spawn a root shell `sudo ssh -o ProxyCommand=';sh 0<&2 1>&2' x` 

![](attachments/20231021013957.png) 
GGs 🤝