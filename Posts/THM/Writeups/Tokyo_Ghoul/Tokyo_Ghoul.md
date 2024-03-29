# Tokyo Ghoul

Help kaneki escape jason room

# Task 1: About the room

![](https://i.imgur.com/tuzTqo4.gif)   

wzebi dyalmn????

This room took a lot of inspiration from [psychobreak](https://tryhackme.com/room/psychobreak) , and it is based on Tokyo Ghoul anime.

Alert: This room can contain some spoilers 'only s1 and s2 ' so if you are interested to watch the anime, wait till you finish the anime and come back to do the room 

The machine will take some time, just go grab some water or make a coffee.

**This room contains some non-pg13 elements in the form of narrative descriptions. Please proceed only at your own comfort level.**

# Task 2: Where am i?

## Use nmap to scan all ports

Nmap scan:

![](attachments/20240329101137.png)

```shelll
nmap -sCV -A -p- -T4 --min-rate=1000 IP -oN scan
```

## How many ports are open ?

![](attachments/20240329102628.png)

##  What is the OS used ?

![](attachments/20240329102840.png)

# Task 3: Planning to escape

  

![](https://pm1.narvii.com/5731/bc5df8c79950e46f820fad03bcb98e056b03adc8_hq.jpg)

Try to look around any thing would be useful .

## Did you find the note that the others ghouls gave you? where did you find it ?

Navigate to the website running on port 80:

![](attachments/20240329101954.png)

Checking the page source, we have a comment telling us to login as anonymous via ftp.

![](attachments/20240329102146.png)

```
<!-- look don't tell jason but we will help you escape we will give you the key to open those chains and here is some clothes to look like us and a mask to look anonymous and go to the ftp room right there -->
```

We can take a loot at the link on the website:

![](attachments/20240329102252.png)

It takes us to a webpage `jasonroom.html`

Checking the source, we find a similar comment like before:

```
<!-- look don't tell jason but we will help you escape , here is some clothes to look like us and a mask to look anonymous and go to the ftp room right there you will find a freind who will help you -->
```

**Answer**: `jasonroom.html`

Anonymous login allowed on the FTP server, which means we can login with the username `anonymous` and no password.

![](attachments/20240329101224.png)

Login and download all files in all directories:

![](attachments/20240329101626.png)

We have a note, a linux executable and a jpeg file. 

![](attachments/20240329101834.png)

## What is the key for Rize executable?

Next up is to give the executable file executable permission so we can run it.

![](attachments/20240329105645.png)

```
chmod +x file (add executable permission)
./file (run the file)
```

As we can see it is requesting for a passphrase which we don't know yet. At the end of the message it says to "look inside of me", so let's cat the file:

![](attachments/20240329105840.png)

We can see a word `kamishiro` which could be the potential passphrase because when we run the executable it starts with "Hey Kaneki" and not "KamishiroHey Kaneki". So the word "kamishiro" is probably the passphrase, let's try it.

![](attachments/20240329110043.png)

It works and we got a passphrase `You_found_1t`

## Use a tool to get the other note from Rize .

We also obtained a picture, we can try checking for any hidden information in it using stenography tools like Steghide.

```
steghide extract -sf file
```

![](attachments/20240329110254.png)

Enter the passphrase `You_found_1t` when prompted and we get a note.

# Task 4: What Rize is trying to say?

![](https://fc08.deviantart.net/fs70/f/2014/347/d/5/jason_torturing_kaneki_by_otakubishounen-d89o67a.gif)

  

You should help me , i can't support pain aghhhhhhh

##  What the message mean did you understand it ? what it says?

Checking the contents of the file, we have what looks like Morse code. We can decode it using [dcode](https://gchq.github.io/CyberChef/)

![](attachments/20240329110453.png)

From Morse code to Hex:

![](attachments/20240329111201.png)

Morse - Hex:

![](attachments/20240329111322.png)

Hex - Base64:

![](attachments/20240329111343.png)

Base64 to Plaintext:

![](attachments/20240329111425.png)


## Can you see the weakness in the dark ? no ? just search

Navigate to the directory `d1r3c70ry_center` on the website

![](attachments/20240329111533.png)

Performing a directory bruteforce SCAN, we can find a directory `/claim` 

![](attachments/20240329113203.png)


![](attachments/20240329113231.png)

![](attachments/20240329113346.png)

Selecting YES or NO takes us to a blank page but looking at the url we have `index.php?view=flower.gif`
This seems to be getting the file `flower.gif`. We could for possible LFI (local file inclusion).

Trying to view the `/etc/passwd` file as a common test for LFI, we get this message:

![](attachments/20240329113639.png)

It seems there is some sort of filter in place, therefore we can try using a PHP LFI filter bypass. Tried using some payloads from this [site](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/File%20Inclusion/README.md) but none worked until i modified a payload to only encode the dots and slashes and it worked. 

![](attachments/20240329115039.png)

We are able to read contents of `/etc/passwd`.

## What did you find something ? crack it

We are also able to obtain a username `kamishiro` and a password hash:

![](attachments/20240329120515.png)

We can try to crack the hash. Place the entire thing in a file

![](attachments/20240329120638.png)

I will use hashcat to crack it.

Checking this [site](https://hashcat.net/wiki/doku.php?id=example_hashes), we can get the hashcat mode for the hash:

![](attachments/20240329120856.png)

## what is rize password ?

Now to crack it:

![](attachments/20240329120944.png)

```
hashcat -m 1800 hash.txt /usr/share/wordlists/rockyou.txt
```

# Task 5: Fight Jason

![](https://33.media.tumblr.com/cd0d4d963a4ef3564d7ca4621d3346f0/tumblr_nj23o9WFXq1u9f7vko1_500.gif)  

Finnaly i got Rize kagune help me fight Jason and get root .

Now with a username and password, we can login as the user `kamishiro` via ssh

![](attachments/20240329121246.png)
## user.txt

![](attachments/20240329121323.png)

## root.txt

Checking sudo privileges:

![](attachments/20240329121402.png)

The owner of the `jail.py` script is root and wr can run it with sudo.

![](attachments/20240329121828.png)

 with sudo. Let's see the contents of the script.

![](attachments/20240329121846.png)

This script accepts user input and if the input contains any of those keywords it won't execute.

So we have to find a way to spawn a shell without using any of those keywords.

Searching on google on "how to escape python jail" took me to this [blog post](https://anee.me/escaping-python-jails-849c65cf306e) and i was able to read the root.txt file to get the flag.

![](attachments/20240329123159.png)

```python
__builtins__.__dict__['__IMPORT__'.lower()]('OS'.lower()).__dict__['SYSTEM'.lower()]('cat file.txt')
```

![](attachments/20240329123322.png)

OR

We can spawn a bash shell `/bin/bash` as root:

![](attachments/20240329174343.png)

```python
__builtins__.__dict__['__IMPORT__'.lower()]('OS'.lower()).__dict__['SYSTEM'.lower()]('/bin/bash') 
```

The End.

![](https://giffiles.alphacoders.com/132/13246.gif)