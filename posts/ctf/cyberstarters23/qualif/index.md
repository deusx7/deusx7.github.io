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

If you use palmpay/opay well you should know that when a number is provided, It will bring out the person full names

So its worth a shot 💀

After trying it on palmpay i attempted to make cash transfer to the person then i saw his name 🤤
![WhatsApp Image 2023-05-01 at 2 22 41 PM](https://user-images.githubusercontent.com/127159644/235458323-1c3a1b35-2634-468e-8a83-8402515741b2.jpeg)

Which was `Adebayo Mustapha Ekeh` !!

Searching it on linkedln gave this 
![image](https://user-images.githubusercontent.com/127159644/235383731-b4a92241-92c5-49ce-a79a-fbc0db8bfd95.png)

We can see the encoded text in the profile description

So I scripted a program to decoded it [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/Cyberstarters23/Qualif/Osint/Rogue%20Agent/solve.py)

Running it gives the flag
![image](https://user-images.githubusercontent.com/127159644/235449707-da5a000b-84f5-44f1-b01e-0a9a83882194.png)


# Cryptography

#### di_sease

We're given an image file and here's it metadata
![image](https://user-images.githubusercontent.com/127159644/235450202-899a7476-2cd5-44be-868b-fbb228266ef6.png)

Checking it shows various flag in it
![image](https://user-images.githubusercontent.com/127159644/235450309-0d6c6ef0-0516-4bac-a6ce-3c1e31bc7f19.png)

At first I didn't know what it is. So I checked [Dcodefr](https://www.dcode.fr/symbols-ciphers) for various image ciphers

And while looking through it I saw something similar to the image given
![image](https://user-images.githubusercontent.com/127159644/235450500-5fa056c1-a94f-4c96-a1e1-c55cac42b806.png)

Navy Signal Code looks promising xD

After using it and selecting the various flags from the image it decryped to this
![image](https://user-images.githubusercontent.com/127159644/235451011-c1375fa4-4dae-4e49-b221-f80b6b000669.png)

```
Flag: DoHCTF{The_flags_revealed_009}
```

#### Hensel's Mystery

We're given a python file (ring.py) and its output (output.txt)

First we get the parameters from `ring.py` and the polynomial from `output.txt`. With sagemath imported we can do the following.

```
from sage.all import *

# from ring.py
p = 35671
k = 100
N = p**k

# the polynomial from output.txt and its derivative
var('x')
with open('output.txt') as file:
    f = eval(file.read().replace('^', '**'))
df = f.derivative()
````

As can be seen from `ring.py`, the flag is a root of the polynomial:

```
assert poly(flag) == 0
```

However, calculating the roots of this polynomial in `Z/NZ` is too hard, so we cannot do that. After lots of Googling, I found the Hensel's lifting lemma, which can be used to 'lift' the roots that were calculated in `Z/pZ` to `Z/p^kZ = Z/NZ`.

Calculating the roots in `Z/pZ` is easy and can even be bruteforced since `p` is small, lets calculate the roots as follows.

```
roots = []
for i in range(p):
    if Mod(f(x = i), p) == 0:
        roots.append(i)
```

There should be maximum of 4 roots now.

Now let's implement the Hensel's lifting lemma, and let's lift the roots to `k=100`.

```
# https://www.geeksforgeeks.org/hensels-lemma/
# a_{k+1} = a_k-f(a_k)*f'(a_1)^(-1) mod p^{k+1}

# f'(a_1) for all roots
derivs = [df(x = r) for r in roots]

roots_old = roots
for n in range(1, k):
    roots = []
    for r_old,deriv in zip(roots_old, derivs):
        # f'(a_1)^(-1) mod p^{k+1}
        dinv = int(Mod(deriv,p**(n+1))**(-1))
        roots.append(int(Mod(r_old-int(f(x = r_old))*dinv, p**(n+1)))
    roots_old = roots
```

Now we should have the lifted roots, and the flag is one of them.

```
import string
for root in roots:
    flag = int.to_bytes(root, 500, 'big').lstrip(b"\x00")
    if set(flag).issubset(string.printable.encode()):
        print(flag)
```

Here's the flag

```
Flag: DoHCTF{univariate_polynomial_ring_go_brrr}
```

I also made a solve [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/Cyberstarters23/Qualif/Crypto/Hensel's%20Mystery/solve.py) for it 

Runing it on sagecell sagemath also gives the flag
![image](https://user-images.githubusercontent.com/127159644/235452077-17251018-d7a3-4a6c-8638-4217fd111591.png)

# Web

#### None Shall Pass

