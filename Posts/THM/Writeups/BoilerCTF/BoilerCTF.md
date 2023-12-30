# BoilerCTF
Difficulty: Medium
![](attachments/4a800c6513239dbdfaf74ce869a88add.jpeg)

# Introduction
Description: Intermediate level CTF. Just enumerate, you'll get there.

# Initial Access
First up as usual we kick off our reconnaissance with an Nmap scan to discover open ports and services on our target machine.

![[attachments/20231230181738.png]]

From our scan, we can see 4 open ports on the machine and 2 of them are running http service on port 80 and 10000. We can start by visiting the site on port 80.

![[attachments/20231230182113.png]]

Here we have an Apache2 default page, nothing useful here. Heading back to TryHackMe.

Question 1:
"File extension after anon login", this indicates there is anonymous login enabled on the FTP server as seen in the nmap scan results.
![[attachments/20231230182533.png]]
Since Anonymous login is enabled it means we can login to this ftp server with the username "Anonymous" and no password and then list the contents to get the answer for the first question.

![[attachments/20231230182901.png]]
As we can see there is  a hidden .txt file ".info.txt". we can download the file to our machine using the command `get .info.txt` which will download the file to our current directory and we can cat it to see the contents.

![[attachments/413.png]]
The file contains some kind of cipher text which we can analyze and decipher using [this](https://www.dcode.fr/cipher-identifier) online tool.

![[attachments/20231230183725.png]]
paste your code into the white box and click on "analyze", as we can see it's most likely ROT-13. Click on the ROT-13 to take you to a page to decipher it.

![[attachments/20231230183917.png]]

Unfortunately, this is a dead end as seen from the result, Remember: ENUMERATION IS THE KEY!!!. Let's continue.

Question 2:
What is on the highest port? 
That will be "ssh" which is on port 55007 if you refer back to the nmap scan.

Question 3:
What's running on port 10000? 
From the nmap scan, it's webmin.

![[attachments/20231230184539.png]]

Question 4:
Can you exploit the service running on that port? (yay/nay answer)
From a quick Google research or by guessing lol "nay" 

Question 5:
What's CMS can you access?
Here we need to perform more enumeration. Earlier from our nmap scan we found a http apache web server running on port 80 and a robots.txt file. Let's take a look at that.

*Note: It's also good practice to check page source code because it's very common for some  CTFs to hide flags in the Apache default webpage so take note of that in future CTFs.*

![[attachments/20231230190620.png]]

![[attachments/20231230191215.png]]

Here we have some directories that are are not allowed to be accessed and it reads "not a rabbit hole or is it" this is most probably another rabbit hole too, seems the creator of this CTF had a lot of fun creating it 😅.

We can also see some code at the bottom which we can try to identify and decode using the same tool as earlier.

![[attachments/20231230190849.png]]
Seems to be ASCII Code
![[attachments/20231230190914.png]]
which when decoded give a Base64 code when identified.
![[attachments/20231230191720.png]]

![[attachments/20231230191747.png]]
Decoding it gives an MD5 Hash function when identified
![[attachments/20231230191835.png]]
which finally leads to yet another rabbit hole........

Since we couldn't find any valuable info from the robots.txt directory, We can further enumerate by performing a directory brute-force to try and find hidden webpages.  I am going to  be using disearch, tools like gobuster, dirb,feroxbuster etc. can also be used as long as the correct wordlist is also used.

Dirseach result:
![[attachments/20231230190413.png]]
we have a couple directories but one that stands out is the /joomla directory. A qucik google search reveals that joomla is a free and open-source content management system for publishing web content on websites. This is our answer for question 5. Visiting the directory we are met with the CMS homepage.

![[attachments/20231230192336.png]]

Question 6:
Keep enumerating, you'll know when you find it.
This means we are to dig deeper and next step is to perform another directory brute-force but this time we are looking for sub directories under /joomla/. 

*Note: Remember, it's also good practice to check every page source code for vital info.*

![[attachments/20231230193500.png]]

From our result we can see a lot of directories have been found. Only the `_file `directory contains yet another rabbit hole. 

When visited we are met with a base64 code which when decoded give another base64 code, decoding it reveals it's just a rabbit hole...

![[attachments/20231230193228.png]]

![[attachments/20231230193211.png]]

While the `_test` directory is where we are met with the real deal. So i'll go straight to the point here.

![[attachments/20231230193928.png]]

A quick google search for "sar2html exploit" will give a Remote Command Execution [exploit](https://www.exploit-db.com/exploits/47204). 
The instructions are very straight forward:
![[attachments/20231230194309.png]]

First click on "New"
![[attachments/20231230194347.png]]

Now we can edit the URL like in the instructions indicate to pass commands like `ls, cd, cat`

`http://IP/joomla/_test/index.php?plot=;ls`

![[attachments/20231230194652.png]]

clicking on "Select Host" will display the contents of the current directory 
`/var/html/www/joomla/_test`. 

Question 7:
The interesting file name in the folder?
Using the command `ls` we get the file "log.txt"

If we cat the file we get some an ssh username and password which can be used to login to the  web server.  
`http://IP/joomla/_test/index.php?plot=;cat log.txt`
![[attachments/20231230195559.png]]
Note: Remember ssh is running on port 55007 and not 22 so be sure to indicate it.
`ssh basterd@IP -p 55007`

Question 8:
Where was the other users pass stored(no extension, just the name)?
checking the contents of the script "backup.sh" we get our answer:

![[attachments/20231230195854.png]]

Now we can login as the user.
`ssh stoner@IP -p 55007`

*Note: you can exit the current user first the login or login in another terminal*

Question 9:
user.txt

![[attachments/20231230200347.png]]

The file ".secret" is hidden which is why you use `ls -al` to see it and not `ls` and we get our first flag.

# Privilege Escalation

Question 10:
What did you exploit to get the privileged user?
Now for privilege escalation. 
We  can first try `sudo -l` to list all commands we can run with sudo.

![[attachments/20231230200724.png]]
Dead End.

Next is to find files with SUID bit set using the command:
`find /-perm -u=s 2>/dev/null`

![[attachments/20231230200950.png]]

`/usr/bin/find` binary stands out the most and is most likely to be our privilege escalation vector. This answers question 10.
Navigation to [GTFObins](https://gtfobins.github.io/) we can search for "find" and select SUID and copy and paste the command in our terminal to get root!.

![[attachments/20231230201217.png]]

![[attachments/20231230201231.png]]

![[attachments/20231230201307.png]]
*Note: Remember to change `.find` to `/usr/bin/find`. Because you have to specify the path to the binary for it to work*
Just like that we are root! and have successfully escalated our privileges

Question 11:
root.txt
![[attachments/20231230201539.png]]

Navigate to the root directory and cat the file. GGs 🤝