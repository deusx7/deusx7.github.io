Difficulty: Medium

![[attachments/Pasted image 20240102104014.png]]

# Introduction

This room will be a guided challenge to hack the James Bond styled box and get root.

Credit to [creosote](https://www.vulnhub.com/author/creosote,584/) for creating this VM. This machine is used here with the explicit permission of the creator <3

So.. Lets get started!

# Enumeration
 
 First up we kick off our enumeration with an nmap scan on the target to discover open ports and services running.

Nmap scan result:

![[attachments/Pasted image 20240102104540.png]]

**Question 1**: 
Use nmap to scan the network for all ports. How many ports are open? 4

Next up is to take a look at the http website which is being served on port 80.

Question 2:
Take a look on the website, take a dive into the source code too and remember to inspect all scripts!

![[attachments/Pasted image 20240102104922.png]]

It gives us a directory to navigate to for login.
Viewing the source code, there is a javascript code we can inspect like the question advises

![[attachments/Pasted image 20240102105043.png]]

![[attachments/Pasted image 20240102105146.png]]

We seem to have a comment giving us a username and  an encoded password. Using my favorite tool we can identify and decode this easily.

![[attachments/Pasted image 20240102105303.png]]

It's identified to be "HTML Escape". Now to decode it:

![[attachments/Pasted image 20240102105428.png]]

We now have a password. Let's now navigate to the login page. InvincibleHack3r

![[attachments/Pasted image 20240102105755.png]]
Here we have a webpage talking about GoldenEye and some nice action in the background. It also states that pop3 has been configured to run on a high non-default port which is 55007 from our nmap scan.

![[attachments/Pasted image 20240102105746.png]]

Taking a look at the page's source code we have a new name now, Natalya. It might be useful later on.

Onto the next steps..

**Question 7**:
Take a look at some of the other services you found using your nmap scan. Are the credentials you have re-usable?

Using netcat to try and login to the pop3 service using the credentials we got earlier doesn't work:
![[attachments/Pasted image 20240102113319.png]]

**Question 8**:
If those creds don't seem to work, can you use another program to find other users and passwords? Maybe Hydra?Whats their new password?

As the question suggest we can try to use hydra to brute-force for the password with the usernames at hand. Remember we now have 2 usernames boris and natalya.

I tried using this syntax ` hydra -l boris -P /usr/share/wordlists/rockyou.txt pop3://<IP>:<PORT>`  with the wordlist "rockyou.txt" but it wasn't working for some reason until i used a different syntax with the wordlist "fasttrack.txt"

![[attachments/Pasted image 20240102122445.png]]

Now we have 2 sets of credentials for login to the pop3 service.

**Question 9:** 
If those creds don't seem to work, can you use another program to find other users and passwords? Maybe Hydra?Whats their new password? ........

**Question 10**:
Inspect port 55007, what services is configured to use this port? telnet

A list of telnet commands can be found [here](https://www.shellhacks.com/retrieve-email-pop3-server-command-line/) 

Now with the credentials we can login to pop3 email system using telnet

![[attachments/Pasted image 20240102123649.png]]

After logging in and listing the contents, we have 2 messages which we can display the contents of using the command `RETR <number>`. We can also copy and save all the messages to our local machine in a text file for later reference.

![[attachments/Pasted image 20240102124217.png]]

**Question 12**:
What can you find on this service? emails

**Question 13**: 
What user can break Boris' codes? The answer is in the 2nd email

**Question 14**:
Using the users you found on this service, find other users passwords
We have already found a username and password for another user earlier. We can now try to login as this user.

**Question 15**:
Keep enumerating users using this service and keep attempting to obtain their passwords via dictionary attacks.

After logging in as the second user we can find some credentials for yet another user to login as.

![[attachments/Pasted image 20240102125044.png]]

# Task 3 GoldenEye Operators Training

Enumeration really is key. Making notes and referring back to them can be lifesaving. We shall now go onto getting a user shell.

## Instructions 

If you remembered in some of the emails you discovered, there is the severnaya-station.com website. To get this working, you need up update your DNS records to reveal it.

If you're on Linux edit your "/etc/hosts" file and add:

`<machines ip> severnaya-station.com`

If you're on Windows do the same but in the "c:\Windows\System32\Drivers\etc\hosts" file

Just as instructed edit the /etc/hosts file using any text edit of your choice eg nano, vim, make sure to use "sudo" if you're not the root user.

![[attachments/Pasted image 20240102125450.png]]

Once you have done that, in your browser navigate to: http://severnaya-station.com/gnocertdir

Try using the credentials you found earlier. Which user can you login as? We enter the credentials we found earlier and login.

![[attachments/Pasted image 20240102125941.png]]

Have a poke around the site. What other user can you find?

![[attachments/Pasted image 20240102130042.png]]

Navigating to the "messages" section we can find a user named "Doak".

What was this users password?
We can try to brute-force for his pop3 password using hydra.

![[attachments/Pasted image 20240102131057.png]]

**Question 21**:
Use this users credentials to go through all the services you have found to reveal more emails.

![[attachments/Pasted image 20240102131424.png]]

yet another set of credentials after logging in to the pop3 service.

**Question 24**:
Take a look at their files on the moodle (severnaya-station.com)

**Question 25**:
Download the attachments and see if there are any hidden messages inside them?

![[attachments/Pasted image 20240102131816.png]]


![[attachments/Pasted image 20240102132052.png]]
The message reveals a secret directory which we can navigate to.

![[attachments/Pasted image 20240102132140.png]]

Here we have a .jpg image. Since the question asks us to find hidden messages inside of them we can try a few tools like "strings".

![[attachments/Pasted image 20240102132407.png]]

![[attachments/Pasted image 20240102132353.png]]

here we have  a username and  a base64 code which can be decoded to give a possible password.

![[attachments/Pasted image 20240102132517.png]]

We now have YET ANOTHER SET OF CREDENTIALS!!!!! AHHHHHHH!!!!!!
