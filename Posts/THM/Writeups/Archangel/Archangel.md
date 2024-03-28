Boot2root, Web exploitation, Privilege escalation, LFI

# Task 1

A well known security solutions company seems to be doing some testing on their live machine. Best time to exploit it.

Start machine and connect to VPN
# Task 2

Enumerate the machine

Nmap scan:

![[attachments/Pasted image 20240328124008.png]]

```shell
nmap -sCV -A -p- -T4 --min-rate=1000 IP -oN scan
```

Wesite running on port 80:
![[attachments/Pasted image 20240328124101.png]]

## Question 1: Find a different hostname

![[attachments/Pasted image 20240328124142.png]]

Hostname found `mafialive.thm`

## Question 2: Find flag 1

Insert Hostname and IP into `/etc/hosts` file

![[attachments/Pasted image 20240328124337.png]]

Navigate to the site using the hostname:

![[attachments/Pasted image 20240328124427.png]]

First flag found ✅

## Question 3: Look for a page under development

Directory Brute force using dirsearch:

![[attachments/Pasted image 20240328124731.png]]

![[attachments/Pasted image 20240328124750.png]]

Navigate to `/test.php`:

![[attachments/Pasted image 20240328124818.png]]

## Question 4: Find flag 2

![[attachments/Pasted image 20240328124935.png]]

Clicking the button seems to display the contents of the file `mrrobot.php` which is stored on the system. This should indicate possible LFI (local file inclusion) vulnerability.


Attempting to view contents of `/etc/passwd` isn't working with this payload, this indicates that there is a possible filter preventing us from viewing any other file apart from `mrrobot.php`:

![[attachments/Pasted image 20240328125112.png]]

Since the site is running on PHP we can look for LFI PHP filter payloads to use. You can find some good payloads [here](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/File%20Inclusion/README.md)

Navigating to the site we can look for PHP filters:

![[attachments/Pasted image 20240328125435.png]]

After testing various payloads, this was the one that worked for me:

![[attachments/Pasted image 20240328130639.png]]

```
php://filter/convert.base64-encode/resource=
```

Inserting the filter works and gives out a base64 output of the contents of `mrrobot.php`

![[attachments/Pasted image 20240328130746.png]]

Full URL:

```
http://mafialive.thm/test.php?view=php://filter/convert.base64-encode/resource=/var/www/html/development_testing/mrrobot.php
```

What this payload is doing basically is taking whatever we supply as the input and then encodes it in base64 which enables us to bypass the filter. This base64 code can then easily decoded back to plaintext:

![[attachments/Pasted image 20240328130822.png]]

We can now try to read the page (test.php) source code to try and understand what filter is in place and how to bypass it:


![[attachments/Pasted image 20240328131043.png]]

Decode it:

![[attachments/Pasted image 20240328131543.png]]

We now have the page source code. 

NOTE: If you are using your terminal to decode the base64 code like me, then remember to remove the space after the first quote and before the last quote to prevent an error.

Now to analyze the code, we can redirect the output inside of a file rather than to the terminal to get a clearer view:

![[attachments/Pasted image 20240328131410.png]]

![[attachments/Pasted image 20240328131611.png]]

Second flag obtained ✅

What the filter is basically doing is that if it detects no presence of `../..` and the string `/var/www/html/development_testing` then it gives an output, or else it prints out `Sorry, Thats not allowed` .

So basically instead of using `../..` for directory traversal, we can use something like `..//..`  to bypass this filter and also we should always include `/var/www/html/development_testing` in our payload. With that knowledge, a payload like:

```
/var/www/html/development_testing/..//..//..//..//..//etc/passwd
```

should allow us to view the contents of `/etc/passwd`. Let's try it:

![[attachments/Pasted image 20240328132221.png]]

And it works. For a better formatting, we can view the page source:

![[attachments/Pasted image 20240328132254.png]]

## Question 5: Get a shell and find the user flag

Now to try and gain a shell with LFI.

A common method of gaining RCE using LFI is via Log poisoning.

First up, since this server runs on apache, we can view the apache log file located at `/var/log/apache2/access.log`. This will probably cause the page to load very slow because a log file tends to have lots of output since it logs literally everything you do on the site since you started the machine. So to prevent this you can just reset the machine and everything will load faster and this is what i am going to do. Remember to insert the new IP address in your `/etc/hosts` file after resetting


![[attachments/Pasted image 20240328133354.png]]

We can now view the log file easier.

As seen from the output, the log actually takes not of the user-agent. This means it probably execur
![[attachments/Pasted image 20240328133633.png]]

