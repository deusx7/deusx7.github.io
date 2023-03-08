<h3> LACTF '23 </h3>

### Description: LA CTF is an annual cybersecurity competition hosted by ACM Cyber at UCLA. During the CTF I was only able to solve few pwn challenges

#### One Time Pad

This is a cryptography challenge i don't know crytpography but i gave this a shot and did it cause its more of a simple python code

Here's the script
![image](https://user-images.githubusercontent.com/127159644/223719532-1c230b84-9ce2-4610-8bf0-517caec3b1f3.png)

```
from itertools import cycle
pt = b"Long ago, the four nations lived together in harmony ..."

key = cycle(b"lactf{??????????????}")

ct = ""

for i in range(len(pt)):
    b = (pt[i] ^ next(key))
    ct += f'{b:02x}'
print("ct =", ct)

#ct = 200e0d13461a055b4e592b0054543902462d1000042b045f1c407f18581b56194c150c13030f0a5110593606111c3e1f5e305e174571431e
```

We can see what the code does which is:

```
1. it assigns some value in variable pt
2. Then does the some a for loop on the length of the value stored in pt
3. It then xors each character of pt with the next value of key 
4. Then it makes the value stored in ct a two-digit hexadecimal string with a leading zero if necessary.
```

We're already given a cipher text to use 

So the idea is to reverse the operation done 

Here's my solve script
![image](https://user-images.githubusercontent.com/127159644/223724230-9db44f30-abd0-4f97-a1f7-40975c0451cd.png)

```
pt = b"Long ago, the four nations lived together in harmony ..."

ct = '200e0d13461a055b4e592b0054543902462d1000042b045f1c407f18581b56194c150c13030f0a5110593606111c3e1f5e305e174571431e'

# pair the ct in 2
val = []
flag = []

for i in range(0, len(ct), 2):
    pair = ct[i:i+2]
    val.append(pair)

for i in range(len(pt)):
    decoded = (pt[i] ^ int(val[i], 16))
    flag.append(chr(decoded))

print("".join(flag))
```

Running it gives us the flag
![image](https://user-images.githubusercontent.com/127159644/223724505-69c39d6c-4e9b-4e07-ac52-21cfea9fdd62.png)

```
Flag: lactf{b4by_h1t_m3_0ne_m0r3_t1m3}
```
























Basic File Checks
![image](https://user-images.githubusercontent.com/127159644/223547243-312b4a38-1031-4316-9090-a87808bac4fc.png)

Cool we're working with a x64 binary and from the protections enabled are:

```
1. Partial Relro
2. NX Disabled
```

The source code for the binary is given 

```
#include <stdio.h>

int main_called = 0;

int main(void) {
    if (main_called) {
        puts("nice try");
        return 1;
    }
    main_called = 1;
    setbuf(stdout, NULL);
    printf("Lyrics: ");
    char buf[256];
    fgets(buf, 256, stdin);
    printf("Never gonna give you up, never gonna let you down\nNever gonna run around and ");
    printf(buf);
    printf("Never gonna make you cry, never gonna say goodbye\nNever gonna tell a lie and hurt you\n");
    return 0;
}
```

The program is a simple C program and here's what it does:

```
1. It assigns the value 0 to variable main_called
2. It checks if main is called then it puts nice try
3. Else if main is not called is prints out Lyrics: then receives 256 bytes of our input and stores in the buffer which can hold up to 256 bytes
4. Then it prints out the rickroll song lyrics 
5. Our input is then printed out without using a format specifier
6. Printf is called again and this time prints out rickroll lyrics
```

Looking at the code doesn't show any form of buffer overflow but instead a format string vulnerability

Since its a format string vulnerability we can perform a GOT overwrite but the problem is that we want to first leak a libc address then perform another GOT overwrite on printf to call system on buf. But since printf is already there if we overwrite the printf we can't actually perform another GOT overwrite

At this point i almost gave up cause there's no way around this 🤔

So i decided to take a look at the decompiled code

And unfortunately the creator just rick rolled me 😹

Why i say that is cause from the decompiled code the last call isn't printf but puts
![image](https://user-images.githubusercontent.com/127159644/223620898-13ead469-d89a-4b39-a948-5e1b6b965c31.png)

So this is ok for our GOT overwrite and ROP chain

Here's what i'll do:

```
1. Calculate libc base address
2. Overwrite the GOT of puts to main+<a_value> # to bypass the check that's done to know if main is called
2. Overwrite the GOT of printf to system
```

A docker file is given so i'll get the libc the server uses
![image](https://user-images.githubusercontent.com/127159644/223630850-a91af85c-f1f1-4c2e-af7c-aed63e8ddc33.png)



