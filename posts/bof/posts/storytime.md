<h3> StoryTime HS'19 CTF </h3>

Basic File Check:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/61303808-89e0-482e-8244-d39ce4fc614f)

```
➜  Storytime file storytime 
storytime: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=3f716e7aa7e236824c52ed0410c1f14739919822, not stripped
➜  Storytime checksec --file=storytime --format=json | jq .storytime
{
  "relro": "partial",
  "canary": "no",
  "nx": "yes",
  "pie": "no",
  "rpath": "no",
  "runpath": "no",
  "symbols": "yes",
  "fortify_source": "no",
  "fortified": "0",
  "fortify-able": "1"
}
```

From the check we can see that we're working with a x64 binary and the only protection enabled is NX (No-Execute) which basically prevents us from writing shellcode to the stack and executing it

I'll run the binary to get an overview of what it does
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7935b3c5-b78b-4581-80fb-b8c655cb1ee5)

Interesing...... Just receives our input and exits

Time to decompile to get the pseudo code using ghidra

Here's the main function
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/458832d3-4e23-4162-8680-9c671578dd4d)

```c
int main(void)

{
  char buffer [48];
  
  setvbuf(stdout,(char *)0,2,0);
  write(1,"HSCTF PWNNNNNNNNNNNNNNNNNNNN\n",0x1d);
  write(1,"Tell me a story: \n",0x12);
  read(0,buffer,400);
  return 0;
}
```

Looking at it just shows a buffer variable which can only hold up to 48 bytes of data then the program writes out some text to standard output and then uses read to receive our input but it is giving us the ability to read up to 400 bytes of data into a 48 buffer variable and we have a buffer overflow here

There are other functions in the program here are the decompiled code

Function climax():
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/297f722b-c40e-41e4-b19e-66b6077a0063)

```c

void climax(void)

{
  char buffer [48];
  
  read(0,buffer,4000);
  return;
}
```

From there we see another buffer overflow which is letting us read up to 4000 bytes of data in a buffer that can only hold up to 48 bytes

Function beginning():
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c97b86b9-327c-4559-b367-0f39d21e2f6a)

```c

void beginning(void)

{
  write(1,"Once upon a time...\n",0x28);
  return;
}
```

This just writes some text to stdout

Function middle():
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/65b8deb6-3a23-4361-a005-80cf7e5a0db5)

```c

void middle(void)

{
  write(1,"Middle of story is the best! :D\n",0x28);
  return;
}
```

This just writes some text to stdout

Function end():
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e966c22f-f021-4914-bf4c-31cbc3650cec)

```c

void end(void)

{
  write(1,"The End!\n",0x28);
  return;
}
```

This just writes some text to stdout

Now we see the other functions just writes some text to standard output and just one out of the others has a buffer overflow vuln in it

Let us get the offset required to take control execution over the binary
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e4fcde4d-2bb8-4e6a-aa2b-919a2aa1420c)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/43974d1c-17b9-44d8-af02-e49bf62cf872)

Cool the offset is *56*

But how do we exploit this binary now that we've gotten the offset

Best attack scenerio to use is *Ret2Libc*

Reason why I want to use this is cause write@plt is used during the program execution
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9f418b07-7d3c-44f4-ab70-1f0687c618fa)

Uhmmm we need to know the value of what the registers need to be for us to leak write

Going over to linux [syscalls](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#x86_64-64_bit) shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f887703e-a3a0-44c2-8699-3f93c51ed7e3)

From there we can see the usage of how [write](https://man7.org/linux/man-pages/man2/write.2.html) syscall can be used
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/445acc46-433a-4d0d-81f0-e90d5773187f)

In this case it should be:

```
write(1, elf.got['write'], 8)
```

The reason i used `8` as size of what is to be read is because if we're able to leak the got of write it is going to be 8 bytes long but basically it should be >= *size(elf.got['write'])*

So let us get the gadget needed

For pop rdi, pop rsi, pop rdx:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/bb542566-be6f-47df-9db5-bda113af2b90)

From the result we can see that no pop rdx gadget oops

Let us look at the assembly code of the binary of the functions

Also note that for us to use a linux syscall we need to fill in the registers from the last before the first i.e

```
Fill in rdx,
Fill in rsi,
Fill in rdi
syscall
```

Checking main shows this:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a42041a8-a5a8-4939-9fd2-6b2cbf23bb24)

The value of *edx* register is already going to be filled with *0x190* so that already fills in our *size(buf)* check

No need to fill in the *rdx* register

So after i checked other functions i found the other functions interesting to use cause it is moves the value of 1 to the rdi and also the write@plt address is after it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c3fd18a9-6583-4076-bfb5-62c6f1627fde)

But what we should note there is that after the write@plt is called it does *pop rbp* and we will need to pad it with 8 bytes since i'll be using that address 😜

With this the idea of our exploit will be:
- Overflow the binary to leak write libc then jump to the other function that has a buffer overflow
- Calculate libc base address
- Get the address of bin_sh & system
- ROP to system

Here's my exploit [script]()

