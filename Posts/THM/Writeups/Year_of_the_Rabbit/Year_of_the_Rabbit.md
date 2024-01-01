# Year of the Rabbit
Difficulty: Easy

![](attachments/c062ef0e0b4f70e51a2dafc5fc2bca0e.jpeg)

# Introduction

![](https://i.imgur.com/LmK6uGc.png)  

Let's have a nice gentle start to the New Year!  
Can you hack into the Year of the Rabbit box without falling down a hole?

**_(Please ensure your volume is turned up!)_**

# Enumeration
First up, We perform an Nmap scan to discover open port and services running on the target machine.

Nmap scan result:

![](attachments/20240101190522.png)
Here we have 3 open ports. An ftp port but no anonymous login enabled, An ssh port for remote access to the machine, and a http website running on port 80. Navigating to the website, we are met with an Apache2 default page with no vital info.

![](attachments/20240101190918.png)

Next up is to perform a directory brute-force to discover hidden webpages.

Using the tool "dirsearch":
![](attachments/20240101224227.png)
only the directory "/assets" was discoverd.

![](attachments/20240101224257.png)

There are only 2 files here, a video named "RickRolled" lol, and a css document. 

![](attachments/20240101224508.png)

carefully looking through the css document, there is a hidden directory given to us there. 

![](attachments/20240101224605.png)

navigating to it, there is a popup that advises us to turn off javascript in our browser. To do that in firefox:

![](attachments/20240101224719.png)

type in `about:config` in the URL bar, accept warning and then disable javascript.

For chrome:

![](attachments/20240101224855.png)

type in the following into the URL bar: `chrome://settings/content/javascript?search=javasc` and disable it.

![](attachments/20240101225008.png)

successfully doing that and navigating to the directory, we have some saying there is a hint in the video but after watching the video, at the :56 second mark a voice speaks and tells us we are looking in the wrong place, which means there's something else we have to look for. 

After much searching i discovered in the Network tab that there was a request being sent to  a hidden directory which retrieves the video and then redirects us to the current page:
![](attachments/20240101225757.png)

Navigating to this discovered directory:
![](attachments/20240101225935.png)

We have a .png image file here. Downloading the image, we have a picture of a "Hot Babe" but no vital information for us. Next up is to try and extract possible hidden information using some steganography. Using the command `strings <filename>` we might get some valuable information hidden in the image.

![](attachments/20240101230648.png)

scrolling to the bottom of the line we get the username for FTP and a list of possible passwords. we can use this list to create a wordlist and then use hydra to brute-force for the password of the FTP service. So we can just copy and paste everything from line 6282 to the end and create a new file called 'wordlist.txt' and use hydra to brute-force using the syntax: 
`hydra -l <username> -P wordlist.txt ftp://IP`

![](attachments/20240101231232.png)

we have a password and can login to the FTP server using `ftp <IP>`

![](attachments/20240101231412.png)
after logging in, there is a file which most probably contains some useful credentials. Download it to your local machine using `get <filename>`, then you can exit out of ftp using `exit` command.

![](attachments/20240101231611.png)
It seems to contain some kind of code. we can identify and decode it using my favorite [tool](https://www.dcode.fr/cipher-identifier) 

![](attachments/20240101231728.png)

The most likely code result is "Brainfuck", totally agree.
Clicking on it takes us to a page to decode it, paste it in and execute.

![](attachments/20240101231908.png)

we now have actual credentials. Possibly ssh login creds. Lets test them.
# Initial Access

![](attachments/20240101232055.png)
After logging in we are greeted with a message from the  root user talking about a hidden message. Let's first try and find the flag. After searching around the system the first flag can be located in Gwendoline's home directory but we have no read access which means we have to look for a way to login as the user.
Note: commands like `clear` might not work for you, to fix just enter the following `export TERM=xterm`

![](attachments/20240101232426.png)

Going back to the message we were greeted with after logging in via ssh it says a hidden message is in a leet s3cr3t hiding place. After searching around the system for a while i decided to use the locate command to find the file or folder "s3cr3t" using `locate s3cr3t`

![](attachments/20240101232736.png)
the first result happened to be the be the one.

![](attachments/20240101233201.png)

navigating to the folder, there is a hidden file which contains Gwendoline's password.

With that we are able to obtain the first flag:
![](attachments/20240101233109.png)

# Privilege Escalation

Now time to escalate to root to get the final flag.

First up entering the command `sudo -l`:
![](attachments/20240101233430.png)

it reveals the user can run the following but not as root. Checking [GTFObins](https://gtfobins.github.io/gtfobins/vi/#sudo)
![](attachments/20240101233632.png)

entering the command didn't work after trying multiple ways. After a long exhausting research i found out the sudo version is vulnerable to [CVE-2019-14287](https://www.exploit-db.com/exploits/47502)

![](attachments/20240101234020.png)

there is a detailed explanation on how the exploit works but all we need is to edit this line from `sudo -u#-1 /bin/bash` to `sudo -u#-1 /usr/bin/vi /home/gwendoline/user.txt` which opens up vi, the we  enter the following and press enter to spawn a bash shell as root:

![](attachments/20240101234308.png)

![](attachments/20240101234348.png)
And we are root and can cat the final flag in /root.

GGs 🤝 Happy Hacking!

