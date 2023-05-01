<h3> CyberStarters CTF '23 Qualification </h3>

Here are the challenges I was able to solve in the ctf which lasted from 28th April 2023 - 30th April 2023

```
P.S:- The scoreboard was dynamic
```

# Challenges Solved

## Sanity Check
-      Discord (10 points)
-      DoHCTF{_colwSPs:(} (10 points)
-      Twitter (10 points)

## Steg
-     OK (100 points)

## Osint
-      Rogue Agent (200 points)

## Cryptography
-     di_sease (100 points)
-     Hensel's Mystery (400 points)

## Web
-     None Shall Pass (100 points)
-     ^_^ (200 points)


## Blockchain
-      Ask The Block (100 points)
-      Blockr (150 points)

# Sanity Check

#### Discord

After joining their discord channel I got this 
![image](https://user-images.githubusercontent.com/127159644/235383084-70651a7e-9de9-45b0-8148-d7a244b56e74.png)

We can tell its base64 so i scripted it in python in order to decoded it

Here's my [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/Cyberstarters23/Qualif/Sanity_Check/Discord/solve.py) 

Running it gives the flag
![image](https://user-images.githubusercontent.com/127159644/235383309-7644273f-c623-4a16-9473-dcbb6e0a8b98.png)

```
Flag: DoHCTF{try_to_be_hacktive_on_discord_hehehehehehe}
```

#### DoHCTF{_colwSPs:(}

Looking at it we can tell its the flag already :D

```
Flag: DoHCTF{_colwSPs:(}
```

#### Twitter 

After clicking on the [link](https://twitter.com/DiaryOfHackers) it redirects me to their twitter page
![image](https://user-images.githubusercontent.com/127159644/235383452-5e4eab09-ce6e-4b8f-8609-ec6c2f0ef83d.png)

So i just clicked follow and then back on the ctf I inputted `Yes`
 
```
Flag: Yes
```

# Steg

#### 0K 

We're given a text file to download:
![image](https://user-images.githubusercontent.com/127159644/235382393-fce7923a-cbfb-479a-8010-7038dccfb9c6.png)

Looking at it we can tell that there's lot of space in the file 

Also using `xxd` we can verify that
![image](https://user-images.githubusercontent.com/127159644/235382424-8333155d-dd09-4d5c-aa8b-615fd255c2bc.png)

Based on this we can tell its SnowSteg that's used

Using `stegsnow` I got the values of those white spaces decoded
![image](https://user-images.githubusercontent.com/127159644/235382806-d3bcfd71-4d38-42b0-a323-44641b84a953.png)

```
Flag: DoHCTF{another_quite_simple_one}
```

# OSINT

#### Rogue Agent

This was quite a very fun one i would say (i'm not really an osint person)

We are given this number `+2348109439442` and a third name `Mustapha` 

The task is to find his real linkedln account 

This was nearly almost impossible cause there wasn't any avaialble open source tool on the internet that gets a linkedln user account based on phone number

And attempting to search it manually was futile

Then after a while i remembered that a phone number was given! So the question is what can I do with it 🤔
