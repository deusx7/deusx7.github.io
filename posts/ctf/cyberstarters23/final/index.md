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


# Forensics

#### Logger 
![image](https://user-images.githubusercontent.com/127159644/236646519-10d4eaf4-f64c-4015-bbbe-49716773b850.png)

After downloading the file keylog.txt and viewing its content it shows this
![image](https://user-images.githubusercontent.com/127159644/236646520-c8df40f5-8b7d-45e7-820c-9daf9587f884.png)
![image](https://user-images.githubusercontent.com/127159644/236646526-4dfbccf9-2fd7-432d-93f2-f2dbc9c27aa2.png)

At first this looks weird lol but after arranging it well i got this

Here's how i arranged it 

```bash
Command: cat keylog.txt | cut -d ':' -f 2 | tr '\n' ',' 
```
