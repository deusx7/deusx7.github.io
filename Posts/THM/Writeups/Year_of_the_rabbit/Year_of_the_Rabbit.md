# Year of the Rabbit
Difficulty: Easy

![[attachments/c062ef0e0b4f70e51a2dafc5fc2bca0e.jpeg]]

# Introduction

![](https://i.imgur.com/LmK6uGc.png)  

Let's have a nice gentle start to the New Year!  
Can you hack into the Year of the Rabbit box without falling down a hole?

**_(Please ensure your volume is turned up!)_**

# Enumeration
First up, We perform an Nmap scan to discover open port and services running on the target machine.

Nmap scan result:

![[attachments/Pasted image 20240101190522.png]]
Here we have 3 open ports. An ftp port but no anonymous login enabled, An ssh port for remote access to the machine, and a http website running on port 80. Navigating to the website, we are met with an Apache2 default page with no vital info.

![[attachments/Pasted image 20240101190918.png]]

