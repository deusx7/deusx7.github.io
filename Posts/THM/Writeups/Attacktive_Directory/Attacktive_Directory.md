# Attacktive Directory

99% of Corporate networks run off of AD. But can you exploit a vulnerable Domain Controller?

# Task 1 <span style="color:#00b050">Intro</span> Deploy The Machine

Deploy Machine
# Task 2: <span style="color:#00b050">Intro</span> Setup

Install Impacket, Bloodhound and Neo4j

# Task 3: <span style="color:#0070c0">Enumeration</span> Welcome to Attacktive Directory

**Welcome to Attacktive Directory**

Welcome Dear User!

Thank you for doing my first room. I originally created this room for my final project in my Cyber Security degree program back in 2019. Since then, I've gone on to make several other rooms, even a Network for THM. In May 2021, I made the decision to renovate this room and make it more guided and less challenge based so there are more learning opportunities for others. I hope you enjoy it.

Love,

[Spooks](https://twitter.com/NekoS3c)

  

Enumeration  

Basic enumeration starts out with an **nmap scan**. Nmap is a relatively complex utility that has been refined over the years to detect what ports are open on a device, what services are running, and even detect what operating system is running. It's important to note that not all services may be deteted correctly and not enumerated to it's fullest potential. Despite nmap being an overly complex utility, it cannot enumerate everything. Therefore after an initial nmap scan we'll be using other utilities to help us enumerate the services running on the device.

For more information on nmap, check out the [nmap room](https://tryhackme.com/room/furthernmap).

  

**Notes_:_** Flags for each user account are available for submission. You can retrieve the flags for user accounts via RDP (Note: the login format is spookysec.local\User at the Window's login prompt) and Administrator via Evil-WinRM.

What tool will allow us to enumerate port 139/445? enum4linux

*enum4linux is a Linux-based tool designed for network enumeration and information gathering. It's commonly used in penetration testing and vulnerability assessments*

Let's perform a scan using this tool.

What is the NetBIOS-Domain Name of the machine?

Using enum4linux:

![[attachments/Pasted image 20240117101209.png]]

Using Nmap:

![[attachments/Pasted image 20240117102238.png]]

What invalid TLD do people commonly use for their Active Directory Domain?

![[attachments/Pasted image 20240117101359.png]]

# Task 4: <span style="color:#0070c0">Enumeration</span> Enumerating Users via Kerberos

**Introduction:**

A whole host of other services are running, including **Kerberos**. Kerberos is a key authentication service within Active Directory. With this port open, we can use a tool called [Kerbrute](https://github.com/ropnop/kerbrute/releases) (by Ronnie Flathers [@ropnop](https://twitter.com/ropnop)) to brute force discovery of users, passwords and even password spray!

**Note:** Several users have informed me that the latest version of Kerbrute does not contain the UserEnum flag in Kerbrute, if that is the case with the version you have selected, try a older version!

**Enumeration:**

For this box, a modified [User List](https://raw.githubusercontent.com/Sq00ky/attacktive-directory-tools/master/userlist.txt) and [Password List](https://raw.githubusercontent.com/Sq00ky/attacktive-directory-tools/master/passwordlist.txt) will be used to cut down on time of enumeration of users and password hash cracking. It is **NOT** recommended to brute force credentials due to account lockout policies that we cannot enumerate on the domain controller.

To install kebrute:
- go to this [link](https://github.com/ropnop/kerbrute/releases/tag/v1.0.2) and download this file:
![[attachments/Pasted image 20240117103534.png]]

- Open your terminal and navigate to the directory where you downloaded to.
- Run the command `mv kerbrute_linux_amd64 kerbrute`
- Next command `chmod +x kerbrute` to make it an executable
- Now you can run it with `./kerbrute`

What command within Kerbrute will allow us to enumerate valid usernames? 

![[attachments/Pasted image 20240117103842.png]]

What notable account is discovered? (These should jump out at you)

Make sure to edit your /etc/hosts file to add the entry for the AD domain "spookysec.local"

`sudo nano /etc/hosts`
enter your machine's IP and the domain
![[attachments/Pasted image 20240117105253.png]]

Next up make sure to download the [user list](https://raw.githubusercontent.com/Sq00ky/attacktive-directory-tools/master/userlist.txt) and the [password list](https://raw.githubusercontent.com/Sq00ky/attacktive-directory-tools/master/passwordlist.txt)

Now to start our user enumeration using kerbrute: