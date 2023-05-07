<h3> CyberStarters CTF '23 Final </h3>

Here are the challenges I was able to solve in the ctf which took place on the 6th May, 2023 at lasted from 9A.M - 3P.M

```
P.S:- The scoreboard was dynamic
```

# Challenges Solved
![image](https://user-images.githubusercontent.com/127159644/236645351-37ec660a-aee5-4680-acc2-04515e337dfc.png)

## Cryptography
-     Frequency (100 points)
-     Idan (200 points)

## Forensics
-     Logger (100 points)
-     Insanity (150 points)

## Web
-      Slash (150 points)
-      Cynic (150 points)


# Cryptography

#### Frequency 
![image](https://user-images.githubusercontent.com/127159644/236645603-b48f18c4-0689-4d43-898a-8545935226fd.png)

After downloading the flag.txt file checking its content shows this
![image](https://user-images.githubusercontent.com/127159644/236645648-854a654b-169f-40a2-838b-cc0f21792e42.png)

Using [DcodeFr](https://www.dcode.fr/cipher-identifier) I identified the cipher as *DTMF Code* 
![image](https://user-images.githubusercontent.com/127159644/236645684-fd99503b-f0b7-4cef-bd93-d73a0439e5f9.png)

Then using its [decoder](https://www.dcode.fr/dtmf-code) I decoded it
![image](https://user-images.githubusercontent.com/127159644/236645722-1f447a62-22b9-4167-a145-3b29eb9a6449.png)

On decoding it gives *681117267847012311910497116951001119511610410195110117109981011141159510910197110125*

I then used [DcodeFr](https://www.dcode.fr/cipher-identifier) to identify it as *ASCII Code* 
![image](https://user-images.githubusercontent.com/127159644/236645875-28c2a21a-5496-4d6a-8c9f-3cc24ebd1e19.png)

Then using its [decoder](https://www.dcode.fr/ascii-code) I decoded it to get the flag
![image](https://user-images.githubusercontent.com/127159644/236645888-ab5e1c6b-2b76-4eec-abce-8bebd5cda5a4.png)

```
Flag: DoHCTF{what_do_the_numbers_mean}
```

#### Idan
![image](https://user-images.githubusercontent.com/127159644/236645955-c0e9d353-35ac-4e56-8c9d-fa6dc3059a5b.png)

After downloading the python file and it's output.txt I checked it out

Looking at the python code shows this
![image](https://user-images.githubusercontent.com/127159644/236646004-83121247-3f3e-4d30-8bfe-95af76b2b772.png)

While it's output shows this
![image](https://user-images.githubusercontent.com/127159644/236646017-e7a65f6e-e5b7-4b9c-8b90-96573cc604ee.png)

Using cyberchef I got this
![image](https://user-images.githubusercontent.com/127159644/236646298-358bff7f-4863-45e3-a7bf-6fe2979a4a6c.png)

```
Encoded Flag: GrKFWI{LGDQ_WKH_GHFUBSWRRU}
```

Then using dcodefr i got the encoded text to be affine cipher
![image](https://user-images.githubusercontent.com/127159644/236681059-c6ef40d2-462f-4129-bf3e-348ac4b7f13b.png)

Decoding it forms this
![image](https://user-images.githubusercontent.com/127159644/236681093-fc523dcf-56a1-460d-a731-f3a49549d08a.png)

```
Flag: DoHCTF{IDAN_THE_DECRYPTOOR}
```

# Forensics

#### Logger 
![image](https://user-images.githubusercontent.com/127159644/236646519-10d4eaf4-f64c-4015-bbbe-49716773b850.png)

After downloading the file keylog.txt and viewing its content it shows this
![image](https://user-images.githubusercontent.com/127159644/236646526-4dfbccf9-2fd7-432d-93f2-f2dbc9c27aa2.png)

At first this looks weird lol but after arranging it well i got this

Here's how i arranged it 
![image](https://user-images.githubusercontent.com/127159644/236646963-c26ea430-f1ee-4950-a38d-fab4b97e023b.png)
```bash
Command: cat keylog.txt | cut -d ':' -f 2 | tr '\n' ' ' 
```

Now we can manually remove the spaces to form this 

```
844339666777555555 344277777777 6666888337 33 366666
```

Then using dcodefr you know the drill I got the cipher it is which turns out to be *Multi-tap Phone (SMS)*
![image](https://user-images.githubusercontent.com/127159644/236647162-5f4d3d31-8e4e-4d09-bd2f-44160e9b0b3a.png)

Decoding it forms this
![image](https://user-images.githubusercontent.com/127159644/236647203-c0326cb1-8016-41be-a582-c624375eda28.png)

```
THEWORLL DHASS OMVEP E DON
```

At this point it looks like readable English but somehow after a while of nobody solving it they gave this hint
![image](https://user-images.githubusercontent.com/127159644/236647244-02223cec-0f6c-4331-b081-d789c3b3fef6.png)

From the hint we know that how the word should be arranged. I was able to arrange the first three words but the remaining last two were hard 😭

Then I told my team mate @cyberhajibi and immediately she got it 💀

It turned out to be: *(Note the flag isn't sensitive)*

```
TheWorldHasMovedOn
```

#### Insanity
![image](https://user-images.githubusercontent.com/127159644/236647487-d741ed97-62ec-4908-82a7-ca5b952dcbae.png)

Initially I didn't solve this during the CTF but i knew it just that i was having a really hard time with copying the UNICODE values

So lets get to it :D

Looking at the file given shows this
![image](https://user-images.githubusercontent.com/127159644/236647623-ad44c550-a535-4369-8b2c-667b997e2c4f.png)

Looks normal but checking the file size shows this
![image](https://user-images.githubusercontent.com/127159644/236647635-7b77d5f0-a267-496d-9f7b-78bb58b7e7ab.png)

From the file size we can tell that there's something more in it 

Using *xxd* to check its hexdump shows this
![image](https://user-images.githubusercontent.com/127159644/236647663-2c7844a5-e5af-4358-a378-6a2b7d7a53a7.png)
![image](https://user-images.githubusercontent.com/127159644/236647672-3b5e0c77-0c8b-4b78-9b27-4e9fd34c2385.png)

From the hex dump we can see that there are some values more of like *.* in it 

Using vim to view the file shows this
![image](https://user-images.githubusercontent.com/127159644/236647698-5926b866-e154-4fef-ad8b-9f7e73d0a16f.png)

We can see some unicode characters in it and this kind of steg (more of steg than forensics) is called *Zero Width Joiner* 

How do i know that 🤔 (Well from reading previous ctf writeups)

We can use tool like [this](https://330k.github.io/misc_tools/unicode_steganography.html) to decode it

But here was where my problem was 😂

How to copy the whole file 💀

*VIM 101* to the rescue


# Web

#### 

Unfortunately the challs are not more up
![image](https://user-images.githubusercontent.com/127159644/236681326-cc285653-e294-4209-b2f7-0c85203fb6f8.png)

But *TD;LR*: The challenge involves a login and a register page. When we register we get directed to our account and the flag isn't there. And the page was saying something about we are not admin then looking at the login page source code *(CTRL + U)* discloses the admin email address and what we will notice is that the login submit button is disabled. Trying to register another account using the admin email shows *user already exists* trying *SQL Truncation* works now we have access over the admin account. So we can login using it but we will need to inspect element and change the disabled field to enabled then after loggin in, we get the flag 

For the second web challenge: We're given a page and only one end point in it and that endpoint involves purchasing the flag. But we are only currently having about 18000 If i can remember. Now we are not actually given a specfic amount on how much the flag worths and trying to like buy the flag shows fails 🤔

Looking at the logic of the web app we can tell that it does something like this:

```python
amount = 180000
price = 20000
buy_flag = price - amount
if buy_flag > $some_amount:
   print('Purchased')
 else:
   print('Failed')
```

Another thing we should note is that the cookie is a jwt token which when decoded gives a json array of something like:

```json
{
   "username": "guest123321",
   "flag": "0"
}
```

And it's algorithm is *HS256* . Since we don't currently have the flag the flag variable of our cookie is just zero. But if we purchase the flag it should return the flag. But now how do we achieve purchasing the flag 🤔

From the logic proposed earlier if no form of sanitation is done to check the usage of a negative number what happens :

```python
amount = -18000
price = 20000
buy_flag = price - amount
if buy_flag > $some_amount:
   print('Purchased')
 else:
   print('Failed')
```

We can see that the *buy_flag* variable will return a huge number sweeeet 😅

After I tried that it showed purchased then on viewing the jwt decoded token gives the flag

