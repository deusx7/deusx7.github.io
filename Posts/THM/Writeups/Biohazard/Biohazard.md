# Biohazard

Difficulty: Medium

# Info

A CTF room based on the old-time survival horror game, Resident Evil. Can you survive until the end?

![](https://tryhackme-images.s3.amazonaws.com/room-icons/72aca9d285c3156a05b34b7f6cc67ae6.png)

# Task 1: Introduction

Welcome to Biohazard room, a puzzle-style CTF. Collecting the item, solving the puzzle and escaping the nightmare is your top priority. Can you survive until the end?

If you have any question, do not hesitate to DM me on the discord channel.

**How many open ports?** 

First off we start our enumeration with an Nmap scan to discover open ports and services running on our target machine.

Nmap scan result:

![[attachments/Pasted image 20240115140905.png]]

we can see we have 3 ports open. Let's first take a look at the website running on port 80.

**What is the team name in operation**

![[attachments/Pasted image 20240115141008.png]]

# Task 2: The Mansion

Collect all necessary items and advanced to the next level. The format of the Item flag:

**Item_name{32 character}**

Some of the doors are locked. Use the item flag to unlock the door.

Tips: It is better to record down all the information inside a notepad

**What is the emblem flag**

Taking a look at the page's source code we can't find any info there, so we click on the "mansion" link and it takes us to another page

![[attachments/Pasted image 20240115141653.png]]

Taking a look at the source code for this page we have some information on another directory named "/diningRoom/"

![[attachments/Pasted image 20240115141841.png]]

Navigating to that directory:

![[attachments/Pasted image 20240115142244.png]]

Here we have another link, but before clicking on it we can take at this page's source code for any info:

![[attachments/Pasted image 20240115142457.png]]

Yes we do. It's a base64 code which we can easily decode in our terminal

![[attachments/Pasted image 20240115142559.png]]

Taking a look at the site:

![[attachments/Pasted image 20240115144233.png]]


we can see another directory "/artRoom/" and  a link.

Clicking the link takes us to the first Flag:

![[attachments/Pasted image 20240115144428.png]]

Now to click on the link in /dinningRoom/ dir:
![[attachments/Pasted image 20240115151743.png]]

navigating to the /artRoom/ directory takes us to this page:

![[attachments/Pasted image 20240115144712.png]]

following the link takes us to a page filled with list of directories:

![[attachments/Pasted image 20240115145328.png]]

first directory to check is the /barRoom/ since we have already checked the rest

![[attachments/Pasted image 20240115145530.png]]

we can submit the flag we got earlier

![[attachments/Pasted image 20240115150427.png]]

click on the link:

![[attachments/Pasted image 20240115150602.png]]

Identify the code using [this](https://www.dcode.fr/cipher-identifier)
![[attachments/Pasted image 20240115150633.png]]

![[attachments/Pasted image 20240115150641.png]]

now we can submit the flag and it'll take us to another page

![[attachments/Pasted image 20240115150744.png]]

![[attachments/Pasted image 20240115150757.png]]

so we are told to refresh  the previous page 

![[attachments/Pasted image 20240115150826.png]]

They are requesting for the emblem so we submit it:
![[attachments/Pasted image 20240115151919.png]]
it just says "rebecca" nothing else. Maybe it'll be usefull later on. Let's continue.

Navigating to the directory 'dinningRoom2F':

![[attachments/Pasted image 20240115151124.png]]

Check the source code:

![[attachments/Pasted image 20240115151136.png]]

Identify the code using the tool used earlier:

![[attachments/Pasted image 20240115151236.png]]

![[attachments/Pasted image 20240115151244.png]]

*You get the blue gem by pushing the status to the lower floor. The gem is on the diningRoom first floor. Visit sapphire.html*

![[attachments/Pasted image 20240115151344.png]]

Next up visiting the /galleryRoom/ dir:

![[attachments/Pasted image 20240115151453.png]]

click the link:
![[attachments/Pasted image 20240115151524.png]]

```
crest 2:
GVFWK5KHK5WTGTCILE4DKY3DNN4GQQRTM5AVCTKE
Hint 1: Crest 2 has been encoded twice
Hint 2: Crest 2 contanis 18 letters
Note: You need to collect all 4 crests, combine and decode to reavel another path
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it
```

Going back to the /diningRoom/ dir and entering the gold emblem key, it takes us to another page with a code:

![[attachments/Pasted image 20240115153534.png]]

Identify and decode it:

![[attachments/Pasted image 20240115153603.png]]

![[attachments/Pasted image 20240115153611.png]]

*there is a shield key inside the dining room. The html page is called the_great_shield_key*

![[attachments/Pasted image 20240115153645.png]]

Navigating to the /armourRoom/:

![[attachments/Pasted image 20240115153740.png]]

Submit the shield key

![[attachments/Pasted image 20240115153807.png]]

nothing in source code so lets visit the link:

![[attachments/Pasted image 20240115153902.png]]
we now have the 3rd and 2nd crest. Remains the first and fourth.

```
crest 3:
MDAxMTAxMTAgMDAxMTAwMTEgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAwMTEgMDAxMDAwMDAgMDAxMTAxMDAgMDExMDAxMDAgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAxMTAgMDAxMDAwMDAgMDAxMTAxMDAgMDAxMTEwMDEgMDAxMDAwMDAgMDAxMTAxMDAgMDAxMTEwMDAgMDAxMDAwMDAgMDAxMTAxMTAgMDExMDAwMTEgMDAxMDAwMDAgMDAxMTAxMTEgMDAxMTAxMTAgMDAxMDAwMDAgMDAxMTAxMTAgMDAxMTAxMDAgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTAxMTAgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTEwMDEgMDAxMDAwMDAgMDAxMTAxMTAgMDExMDAwMDEgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTEwMDEgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTAxMTEgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAxMDEgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAwMDAgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTEwMDAgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAwMTAgMDAxMDAwMDAgMDAxMTAxMTAgMDAxMTEwMDA=
Hint 1: Crest 3 has been encoded three times
Hint 2: Crest 3 contanis 19 letters
Note: You need to collect all 4 crests, combine and decode to reavel another path
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it
```

Let's find the 1st  and 4th crest and  decode them all and combine them.

Going to the /attic/ dir and submitting the shield key:

![[attachments/Pasted image 20240115154119.png]]

![[attachments/Pasted image 20240115154131.png]]

Nothing in the source code so lets click the link.

![[attachments/Pasted image 20240115154223.png]]

```
crest 4:
gSUERauVpvKzRpyPpuYz66JDmRTbJubaoArM6CAQsnVwte6zF9J4GGYyun3k5qM9ma4s
Hint 1: Crest 2 has been encoded twice
Hint 2: Crest 2 contanis 17 characters
Note: You need to collect all 4 crests, combine and decode to reavel another path
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it
```

we have the 4th crest, remaining the 1st!!!

Going to the /tigerStatusRoom/ and submitting the blue_jewel we get the final crest:
![[attachments/Pasted image 20240115155740.png]]

![[attachments/Pasted image 20240115155816.png]]

```
crest 1:  
S0pXRkVVS0pKQkxIVVdTWUpFM0VTUlk9  
Hint 1: Crest 1 has been encoded twice  
Hint 2: Crest 1 contanis 14 letters  
Note: You need to collect all 4 crests, combine and decode to reavel another path  
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it
```

Now to decode them and combine

Crest 1:
base64 > base32 > final
`RlRQIHVzZXI6IG`

Crest 2:
base32 > base58 > final
`h1bnRlciwgRlRQIHBh`

Crest 3:
base64 > binary > HEX > final
`c3M6IHlvdV9jYW50X2h`

Crest 4:
base58 > HEX > final
`pZGVfZm9yZXZlcg==`

use dcode for identification and cyberchef for decoding, especially for HEX

Final code: 
`RlRQIHVzZXI6IGh1bnRlciwgRlRQIHBhc3M6IHlvdV9jYW50X2hpZGVfZm9yZXZlcg==` (base64)

Decode:
`FTP user: hunter, FTP pass: you_cant_hide_forever`

Now we can login!!!!

# Task 3: The guard house

After gaining access to the FTP server, you need to solve another puzzle.

Where is the hidden directory mentioned by Barry
![[attachments/Pasted image 20240115163404.png]]

![[attachments/Pasted image 20240115162649.png]]

After logging in we can see some file we can download to our local machine to work on. use the command `get <filename>` to download files

we have 3 images, 1 text file and an encrypted file.

For the images we can extract info from them

First image: 
![[attachments/Pasted image 20240115162924.png]]
`steghide extract -sf <image_name>`

Second image:
![[attachments/Pasted image 20240115163011.png]]

`strings <image_name>`

Third image:
![[attachments/Pasted image 20240115163042.png]]
`binwalk -e <image_name>`
`unzip <image_name>`

combine all 3 codes together:
`cGxhbnQ0Ml9jYW5fYmVfZGVzdHJveV93aXRoX3Zqb2x0` (base64)

Decode:
![[attachments/Pasted image 20240115163207.png]]
`plant42_can_be_destroy_with_vjolt`

Now we can decrypt the gpg file.
![[attachments/Pasted image 20240115163606.png]]

Navigating to the /hidden_closet/ dir we can submit the flag:

![[attachments/Pasted image 20240115163628.png]]

# Task 4: The Revisit

Done with the puzzle? There are places you have explored before but yet to access.

![[attachments/Pasted image 20240115163803.png]]

Nothing in the source code but we have 2 links. Let's check each.

![[attachments/Pasted image 20240115163852.png]]
Lets identify and decode:
![[attachments/Pasted image 20240115164008.png]]

![[attachments/Pasted image 20240115163952.png]]

`weasker login password, stars_members_are_my_guinea_pig`

Second link:
![[attachments/Pasted image 20240115164128.png]]

