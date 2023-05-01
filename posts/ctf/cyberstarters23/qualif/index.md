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

## Cryptography
-     di_sease (100 points)
-     Hensel's Mystery (400 points)

## Osint
-      Rogue Agent (200 points)

## Web
-     None Shall Pass (100 points)
-     ^_^ (200 points)


## Blockchain
-      Ask The Block (100 points)
-      Blockr (150 points)

# Sanity Check

#### Discord

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
