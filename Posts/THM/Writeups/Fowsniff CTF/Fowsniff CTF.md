# Fowsniff CTF

Difficulty: Easy

![](https://tryhackme-images.s3.amazonaws.com/room-icons/97b218eed9688e9a5cbe136714b86288.jpeg)


# Introduction

This boot2root machine is brilliant for new starters. You will have to enumerate this machine by finding open ports, do some online research (its amazing how much information Google can find for you), decoding hashes, brute forcing a pop3 login and much more!

This will be structured to go through what you need to do, step by step. Make sure you are [connected to our network](http://tryhackme.com/access)

Credit to [berzerk0](https://twitter.com/berzerk0) for creating this machine. This machine is used here with the explicit permission of the creator <3

# Enumeration
First off we kick off our recon with an nmap scan to discover open ports and services running on the target machine.

Nmap scan result:

![[attachments/Pasted image 20240108155706.png]]

Here we can see there are a number of ports discovered and we have some open ports. First up let's checkout the website on port 80.

![[attachments/Pasted image 20240108155841.png]]

reading through the webpage we can see the company has suffered a data breach and some credentials have been exposed. We also have some vital info on the webpage.

![[attachments/Pasted image 20240108160134.png]]

Let's take a look at their twitter/X page:

![[attachments/Pasted image 20240108160344.png]]

We have a username and what seems to be a password hash for the sysadmin which can later be cracked. We also have a pastebin link, let's take a look.

![[attachments/Pasted image 20240108160531.png]]

We have a backup for password dump. Navigating to the link:

![[attachments/Pasted image 20240108160713.png]]

We have the MD5 password hashes and their respective usernames.

Time to crack these hashes with JohntheRipper:

![[attachments/Pasted image 20240108161007.png]]

we now have the passwords for the users.

Going back to tryhackme, Question 6 asks:

Using the usernames and passwords you captured, can you use metasploit to brute force the pop3 login?
