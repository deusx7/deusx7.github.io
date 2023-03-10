<h3> Here's A Libc PicoCTF </h3>

### Binary Exploitation

We're given a binary and a remote libc library
![image](https://user-images.githubusercontent.com/127159644/224201272-73e17443-0210-4593-9223-3b3f2b1ee1a2.png)

Firstly i'll use pwninit to patch the binary 
![image](https://user-images.githubusercontent.com/127159644/224201374-db88cb70-f851-4a7a-8819-e9c9912c4a90.png)

You can neglect the solve.py file pwninit automatically creates it to use as the pwn script

Anyways the reason i patched the binary is so that it uses the libc file given 

#### Basic File Checks
![image](https://user-images.githubusercontent.com/127159644/224202146-24175a4d-6c97-4fc2-a836-f0b7a1be9837.png)

We're working with a x64 binary and no protection is enabled except NX (No Execute)

I'll run the binary to know what it does
![image](https://user-images.githubusercontent.com/127159644/224201561-d5ddb124-5197-4518-9bb7-70a19e200d56.png)

It just goes in a loop and echo our input back

Using ghidra i'll decompile the binary

Here's the decompiled main function
![image](https://user-images.githubusercontent.com/127159644/224201691-3bcbc07d-f90f-4995-89cf-151a82467e1f.png)

We see that it calls function do_stuff()

Here's the decompiled do_stuff() function
![image](https://user-images.githubusercontent.com/127159644/224201892-5d18f8c2-eee3-4a08-8507-4935023a726c.png)

From the high lighted section of the image we see that it uses scanf without specifying the amount of bytes to read causing a buffer overflow

Lets confirm it
![image](https://user-images.githubusercontent.com/127159644/224202051-4ef70250-3bb8-4e3a-825d-6ba26359d9c8.png)

So the best way to pwn this binary is by performing ROP ret2libc 

During the program execution we see that the GOT of puts is already populated
![image](https://user-images.githubusercontent.com/127159644/224202371-64b0fa14-b0af-47b3-a7d4-a8b19c2c1315.png)
![image](https://user-images.githubusercontent.com/127159644/224202487-f7c59ae2-ec3c-462f-af4c-1b3eeddcc36d.png)

Now lets get the offset
![image](https://user-images.githubusercontent.com/127159644/224202610-79f4c063-4449-4479-b6b8-e4aeef8d3b2e.png)
![image](https://user-images.githubusercontent.com/127159644/224202644-ad1ffa24-81cf-41cf-af35-5c61ee235522.png)

The offset is `136`

To get a `pop rdi & ret` gadget i'll use `ropper`
![image](https://user-images.githubusercontent.com/127159644/224202730-2187c2e1-a373-41bb-9275-e6e7fc8b5da3.png)

The reason am getting a ret gadget is not to encounter movaps stack allignment

So the idea of my exploit (ret2libc) is to use `puts@plt` to write the `puts@got` to `rdi` which will basically print the got puts address to the screen

From there i'll calculate the libc base address then get the `/bin/sh` & `system` address and get a shell 🤓

Here's my solve script [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/picoctf/here's%20a%20libc/exploit.py)

Running it locally works
![image](https://user-images.githubusercontent.com/127159644/224203394-508f96d6-194a-41f2-8e44-4134a7b62326.png)

Also it works remotely
![image](https://user-images.githubusercontent.com/127159644/224203615-e62499d5-ce76-4ee3-9102-3c69ba1f8a7e.png)

And we're done 👻

<br>
[Back To Home](../index.md)
